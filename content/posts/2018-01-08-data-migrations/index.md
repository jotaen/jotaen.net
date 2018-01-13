+++
draft = true
title = "Open heart surgery"
subtitle = "Successful data migrations during full operation"
date = "2018-01-08"
tags = ["database"]
image = "/posts/2018-01-08-data-migrations/engine.jpg"
id = "c5PaA"
url = "c5PaA/successful-data-migration"
aliases = ["c5PaA"]
+++

Modern web applications are expected to run 24/7 without noticeable downtime. While code changes can be pushed out almost instantaneously thanks to modern continuous delivery pipelines, database migrations are a delicate and rather expensive process.

Freezing the database (and therefore the application as a whole) is not viable due to business requirements, even though it would make the lives of software developers a lot simpler. Minor database migrations also don’t justify to disrupt the development activity – instead, they should be conducted seamlessly and with minimal risk.

# Breaking new ground

This blog post outlines a procedure that should be applicable for the smaller kinds of migrations that developers are facing during their daily work. (Varying situations and circumstances of course may demand respective adjustments.)

I want to guide you through the procedure by means of an example. One word about technology upfront: the sample code is written in NodeJS and we are using MongoDB as database (which is a document store). In the end, it shouldn’t really matter though what kind of database you are using and whether you employ a dynamically or statically typed language. The underlying ideas would still remain valid.

## Initial situation

Let’s say we have a module that manages employees in an application. All employee data is stored in a MongoDB, which the module has full ownership of. (This means there exists no other piece of code that has direct access to the database and thus no other place we need to worry about.)

The documents which represent the employees look like this in the database collection:

```json
{
    _id: ObjectId("507f191e810c19729de860ea"),
    name: "John Doe",
    employedSince: 2004,
    workplace: "Buenos Aires"
}
```

Now, requirements change and the application shall also support employees who work from multiple locations:

```json
{
    _id: ObjectId("507f191e810c19729de860ea"),
    name: "John Doe",
    employedSince: 2004,
    locations: ["Buenos Aires", "Singapore", "Berlin"]
}
```

So, effectively we want two things here: rename the field and convert the value to the new format.

## 1. Support symmetric writes and reads

We introduce the new field in the database layer of the application. For **read operations** we derive the migration status from the presence of the new field. The new field is favoured but the code falls back to the old one:

```js
employees.getById = (id) => {
    return mongodb.findOne({
        _id: id
    }).then((doc) => {
        const isMigrated = Array.isArray(doc.locations);
        return {
            id: doc._id.toHexString(),
            name: doc.name,
            employedSince: doc.employedSince,
            workplace: isMigrated ? doc.locations[0] : doc.workplace,
            locations: isMigrated ? doc.locations || [doc.workplace]
        };
    });
};
```

For **write operations** (for instance creation) we introduce an explicit parameter that the migrated client code would set to `true`. We again fall back to `workplace`.

```js
employees.create = (employee, isMigrated) => {
    if (isMigrated && employee.locations.length > 1) {
        throw new Error("There can only be 1 location currently.");
    }
    return mongodb.insertOne({
        name: employee.name,
        employedSince: employee.employedSince,
        workplace: isMigrated ? employee.locations[0] : employee.workplace,
        locations: isMigrated ? employee.locations : [employee.workplace]
    }).then(doc => {
        return doc.insertedId.toHexString()
    });
};
```

Note that `locations` is introduced with a constraint that makes it fully backwards compatible. We also do not omit the old field right away, we rather keep it up to date and consistent. This not only reduces complexity while the migration is in progress, it is also crucial in the event of a deployment rollback, which means that a previous application version would come into effect again. The problem is here that documents with the new field could have already been written in the meantime, which the old code version is unable to gracefully deal with. Be it likely or not, but by ignoring this you literally slam the door behind you upon your next deployment.

## 2. Migrate all client code

With the first step the new property has become available to the application and the old one is deprecated. We can take all the necessary time to refactor the places where employee objects are used to the new format. Bear in mind though: the constraint that only one value is supported in the array still applies.

If it is possible to safely refactor the entire client code in one atomic transition along with the changes to the database layer, you can simplify the implementation by omitting the migration flag in the database service API.

## 3. Stop persisting the deprecated property

Once the period of grace for a potential rollback has elapsed we can discontinue to write the old property into the database. In this example, we are effectively only removing a single line of code.

```js
// ...
    return mongodb.insertOne({
        name: employee.name,
        employedSince: employee.employedSince,
        locations: employee.locations || [employee.workplace]
    })
// ...
```

## 4. Migrate the data

With the previous step, the values of the old properties are effectively frozen. That allows us to run over all the user documents in the collection and persist the conversion that we previously did on the fly in our database module above:

[^1]
```js
db.find().forEach((doc) => {
    const isMigrated = Array.isArray(doc.locations);
    mongodb.updateOne({ _id: doc._id }, {
        $set: {
            locations: isMigrated ? doc.locations : [doc.workplace]
        },
        $unset: { workplace: "" }
    });
});
```

Generally you should keep in mind to write your migration algorithm in an idempotent way, so that you can safely run it multiple times. (Imagine the database connection failed halfway in between and you’d need to start over.)

If you want to have an extra safety net, you don’t have to drop the old field. Keep in mind though, that especially in document stores the latter has a potential pitfall: if someone else reinvents the old fields in the future without knowing or checking that it had already existed at some point in the past, they might find themselves badly surprised to retrieve “random” values for their “new” field. Possible workarounds are to rename the field to something obvious like `ARCHIVED_workplace` (and then perhaps drop it later) or to export it to a separate archive collection.

## 5. Drop all support for the deprecated property

Now that the data has been fully migrated we can drop the support of the deprecated property to the outside world.

```js
employees.getById = (id) => {
    return mongodb.findOne({
        _id: id
    }).then((doc) => {
        return {
            id: doc._id.toHexString(),
            name: doc.name,
            employedSince: doc.employedSince,
            locations: doc.locations
        };
    });
};

employees.create = (employee) => {
    return mongodb.insertOne({
        name: employee.name,
        employedSince: employee.employedSince,
        locations: employee.locations
    }).then(doc => {
        return doc.insertedId.toHexString()
    });
};
```

Once this has happened the constraint for the new property is obsolete and the consumers can take full advantage of the new field supporting a superset of values. The migration is thereby successfully completed.

# Basic recipe

Essentially, this is the basic recipe for a migration from `old` to `new`:

1. Introduce `new`:
  - Make it fully compatible through constraints.
  - Always write both the old and new field.
  - For read operations fall back to `old` if `new` isn’t set yet.
2. Deprecate `old` and migrate all consumers of the API.
3. Shift sole write sovereignty to `new`. Read operations continue to fall back to `old`.
4. Run a migration to copy all values from `old` to `new`.
5. Remove `old` altogether from the code.

In practice the migration plan can vary. Depending on the circumstances you may take shortcuts, but it is also very well possible that a migration cannot be accomplished within one single round. Slight technical differences in the kind of database that is being used may call for further adjustments.

In the end, the important thing is to come up with a plan upfront that describes all steps as concise and explicit as possible. The procedure can be intimidating, especially for developers who are not so experienced with it, which makes it crucial for everyone to know about the current status and the next step at all times.

# Asymmetric migration

The example above showed a symmetric migration. During the transition period we enforced a constraint that allowed us to compute the new property from the old one and vice versa. This, however, is not always the case.

- Migrations can be destructive, if you shift over to a format that only allows for a subset of the previously available value range.
- On the other hand, even if you migrated to a format that supports a superset of possible values, it can still happen that the new data format makes additional information mandatory that was just not existing previously.

In order to illustrate both cases, let’s say we wanted to migrate the date of employment from only the year (stored as integer value) to a fully qualified date object. In addition to that you want to migrate from multiple `locations` backwards to only a singular `workplace`. The desired end result would look like this:

```json
{
    _id: ObjectId("507f191e810c19729de860ea"),
    name: "John Doe",
    employmentDate: Date("2004-08-15"),
    workplace: "Singapore"
}
```

These kinds of migrations are non-trivial and cannot be handled by the database layer alone. While it’s obvious that we can do *something* about the location information, there is no reasonable way to compute the full date out of nothing. This leaves us with basically three options.

## Start fresh

If the property is optional for the application and not critical for the business, we introduce the new fields additionally and initialise them with `null`:

```json
{
    _id: ObjectId("507f191e810c19729de860ea"),
    name: "John Doe",
    employmentDate: null,
    employedSince: 2004,
    workplace: null,
    locations: ["Buenos Aires", "Singapore", "Berlin"]
}
```

The application would stop providing write support for the old fields and encourage its users to enter the new information. At some point the deprecated fields will eventually be dropped or made read-only in the database layer, in order to keep them around for historical reference.

## Best guess

We could try to compute a best guess for the new data format:

- For the employment date we would have to assume an arbitrary month and day, e.g. `Date("2004-01-01")`. This is not really a feasible option here, because the resulting data is just not correct.
- For `locations` there are two ways. We can either choose one of the values from the array or we can join the array together to one, comma-separated string. Both are not immaculate though: the first means losing data, whereas the second wouldn’t be a singular value in the logical sense.

## Remove or lock

As the very last resort, if backwards compatibility is terminated and the data can neither be guessed nor made optional, the document must be made inaccessible. In a schema based database this would mean removing these datasets; in a schemaless database we could also consider to “lock” the document.

```js
employees.getById = (id) => {
    return mongodb.findOne({
        _id: id
    }).then((doc) => {
        if (!(doc.employmentDate instanceof Date)) {
            throw new Error("Field `employmentDate` invalid.")
        }
        if (!doc.workplace) {
            throw new Error("Filed `workplace` missing.")
        }
        return {
            id: _id.toHexString(),
            name: doc.name,
            employmentDate: doc.employmentDate,
            workplace: doc.workplace
        };
    });
};
```



[^1]: <br>The object that we are passing to `updateOne` is a MongoDB specific change description, where `$set` and `$unset` are so-called [update operators](https://docs.mongodb.com/manual/reference/operator/update/).