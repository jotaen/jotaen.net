+++
draft = true
title = "Open heart surgery"
subtitle = "Successful data migration during full operation"
date = "2018-01-08"
tags = ["logging", "operating"]
image = "/posts/2018-01-08-data-migration/asdf9.jpg"
id = "asdf9"
url = "asdf9/data-migration"
aliases = ["asdf9"]
+++

- Compare to code-freeze migrations

# Example

Let’s say we have a module that manages employees in an application. All user data is stored in a MongoDB, which the module has full ownership of. (This means there is no other client.)

The database documents which represent the articles look like this in the MongoDB collection:

```json
{
    _id: ObjectId("7abe787zabce78a12"),
    name: "John Doe",
    birthyear: 1979,
    workplace: "Buenos Aires"
}
```

The application should now also support employees who work in multiple locations. They should be allowed to enter all the locations that they work from:

```json
{
    _id: ObjectId("7abe787zabce78a12"),
    name: "John Doe",
    birthyear: 1979,
    locations: ["Buenos Aires", "Singapoore", "Berlin"]
}
```

So, effectively we want two things here: rename the field and convert the value to the new format.

### 1. Support symmetric writes and reads

We introduce the new field in the database layer of the application:

```js
db.create = (employee) => {
    if (employee.locations) {
        if (employee.locations.length > 1) {
            throw new Error("There can be 1 location max.");
        }
        if (employee.workplace && employee.workplace !== employee.locations[0]) {
            throw new Error("Old and new location value must be equal.")
        }
    }
    return employeeCollection.insert({
        name: employee.name,
        birthyear: employee.birthyear,
        workplace: employee.locations ? employee.locations[0] : employee.workplace,
        locations: employee.locations || [employee.workplace]
    });
};

db.read = (employeeId) => {
    const employee = employeeCollection.findById({
        _id: ObjectId(employeeId)
    });
    return employee ? {
        name: employee.name,
        birthyear: employee.birthyear,
        location: employee.locations ? employee.locations[0] : employee.location,
        locations: employee.locations || [employee.location]
    } : null;
};
```

The code supports both fields now. It derives the migration status from the presence of the new value: the new field is favoured but it falls back to the old one. A mismatch of the two fields can be intercepted to be on the safe side with consitency.

If it is possible to refactor the entire client code at once in one atomic operation, you can simplify this implementation a bit.

Note that this field is introduced with a constraint that makes it fully backwards compatible. We also do not omit the old property right away, we rather keep it updated and consistent. This can be crucial in case you need to rollback your deployment, which means that the previous code version would come into effect again. Documents with the new field could have already been written in the meantime, which the old code version might not be able to gracefully deal with.

### 2. Migrate all client code

With the first step the new property has become available to the application and the old one is deprecated. We can take all the necessary time to refactor the places where user objects are used to the new format. However, there is still the constraint that only one value is supported in the array!

### 3. Stop persisting the deprecated property

Once the period of grace for a potential rollback has elapsed we can stop to write the old property to the database. In this example, we are effectively only removing a single line of code:

```js
// ...
    return userCollection.insert({
        name: user.name,
        birthyear: user.birthyear,
        locations: user.locations || [user.workplace]
    });
// ...
```

### 4. Migrate the data

With the previous step, the values of all old properties are effectively frozen. That allows us to run over all the user documents in the collection and persist the conversion that we did on the fly in our db module above:

```js
migrateUsers = () => {
    db.find({}).forEach((user) => {
        db.update({ _id: user._id }, {
            name: user.name,
            birthyear: user.birthyear,
            locations: user.locations || [user.workplace]
        });
    });
};
```

Generally you should keep in mind to write your migration algorithm in an idempotent way, so that you can safely run it multiple times. (For example because the database connection failed halfway in between.)

### 5. Drop all support for the deprecated property

Now that the data has been fully migrated we can drop the support of the deprecated property to the outside world. At the same time the constraint for the new property can be omitted and the consumers can take full advantage of the new field supporting manifold values.

```js
db.create = (user) => {
    return userCollection.insert({
        name: user.name,
        birthyear: user.birthyear,
        locations: user.locations || [user.workplace]
    });
}

db.read = (userId) => {
    const user = userCollection.findById({
        _id: ObjectId(userId)
    });
    return user ? {
        name: user.name,
        birthyear: user.birthyear,
        locations: user.locations
    } : null;
}
```

The migration is thereby completed.

# Basic recipe

Essentially, this is the basic recipe for a migration from `oldField` to `newField`:

1. Introduce `newField`:
  - Make it fully compatible through constraints.
  - Always write in both fields.
  - For read operations fall back to `oldField` if the new one isn’t set yet.
2. Deprecate `oldField` and migrate all consumers of the API.
3. Shift sole write sovereignity to `newField`. Read operations continue to fall back to `oldField`.
4. Run a migration to copy all values from `oldField` to `newField`.
5. Remove `oldField` altogether

# Asymmetric migration

The first example showed a symmetric migration – during the transition period we enforced a constraint that allowed us to compute the new property from the old one and vice versa. This, however, is not always possible.

- Migrations can be destructive: you migrate to a format that only allows for a subset of the previously available value range.
- On the other hand, even if you migrate to a format that supports a superset of possible values, it can still happen that the new format mandates information that was not existing previously.

In order to illustrate both cases, let’s say we wanted to migrate the birth information from only the year (stored as integer value) to a full date. In addition to that you want to migrate backwards from multiple `locations` to a singular `workplace`.

```json
{
    _id: ObjectId("7abe787zabce78a12"),
    name: "John Doe",
    birthdate: Date("1979-08-15"),
    workplace: "Singapoore"
}
```

These kinds of migrations are non-trivial and cannot be handled by the database layer alone. While it’s obvious that we can do *something* about the date, there is no way we can calculate the full date on the fly. This leaves us with basically three options:

### Remove the data

If the value is optional for the application and not critical for the business, we introduce the new fields additionally and initialise them with `null`:

```json
{
    _id: ObjectId("7abe787zabce78a12"),
    name: "John Doe",
    birthdate: null,
    birthyear: 1979,
    locations: null
}
```

The application would stop providing write support for the old fields and encourage its users to enter the new information. At some point the deprecated fields will eventually be frozen and made read-only in the database layer. They can then either be dropped or kept around for historical reasons.

### Best guess

We could try to calculate a best guess for the new data format. In this case we would have to assume an arbitrary month and day (e.g. `Date("1979-01-01")`) but that isn’t really a feasable option here.

For `locations` there are two ways. We can either choose one of them or we can join the array together to one string. Both are not immaculate though: the first means losing data, whereas the second wouldn’t be a singular value in the logical sense.

### Flag the document

If the data can neither be guessed nor made optional, the document must be flagged somehow and treated by the client in a special way. It depends on the application requirements how strict this will be. As the very last resort – when backwards compatibility is terminated – the document must eventually be locked or even erased:

```js
db.read = (userId) => {
    const user = userCollection.findById({
        _id: ObjectId(userId)
    });
    if (!user.birthdate) {
        throw new Error("Document invalid: birthdate missing.")
    }
    if (!user.workplace) {
        throw new Error("Document invalid: workplace missing.")
    }
    return user ? {
        name: user.name,
        birthyear: user.birthyear,
        locations: user.locations
    } : null;
}
```
