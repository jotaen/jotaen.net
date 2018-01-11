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

# Basic recipe

Rename `oldProperty` -> `newProperty`

1. Introduce `newProperty` as a proxy to `oldProperty`. All read and write operations are just passed through.
2. Deprecate `oldProperty` and migrate all clients of that API.
  - If `newProperty` is backwards compatible: proxy `oldProperty` to `newProperty`
  - If `newProperty` is not backwards compatible: drop write support for `oldProperty` altogether
3. Shift write sovereignity to `newProperty`: write and read operations go to `newProperty`, but read operations fall back to `oldProperty`.
4. Run a batch migration to copy all values from `oldProperty` to `newProperty`. That effectively makes `oldProperty` obsolete.
5. Remove `oldProperty` altogether


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

The code supports both fields now. It derives the migration status from the presence of the new value: the new field is favoured but we fall back to the old one. A mismatch of the two fields can be prevented just to be on the safe side.

If it is possible to refactor the entire client code at once in one atomic operation, you can simplify this implementation a bit.

Note that this field is introduced with a constraint that makes it fully backwards compatible. We also do not omit the old property right away, we rather keep it updated and consistent. This can be crucial in case you need to rollback your deployment, which means that the previous code version would come into effect again. However, documents with the new field might already have been written in the meantime, which the old code version might not be able to gracefully deal with.

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

The migration is completed.

# Asymmetric migration

The first example showed a symmetric migration, because during the transition period we enforced a constraint that allowed us to compute the new property from the old one and vice versa. This, however, is not always possible. Imagine, we wanted to migrate the birth information from only the year (stored as integer value) to a full date, like so:

```json
{
    _id: ObjectId("7abe787zabce78a12"),
    name: "John Doe",
    birthdate: Date("1979-08-15"),
    locations: ["Buenos Aires", "Singapoore", "Berlin"]
}
```

There is no way we can calculate the full date on the fly. Thus, the database layer alone is not able to drive this migration on its own. This leaves us with basically three options:

### Remove the data

If the value is optional for the application and not critical for the business, we introduce the `birthdate` field additionally and initialise it with `null`.

```json
{
    _id: ObjectId("7abe787zabce78a12"),
    name: "John Doe",
    birthdate: null,
    birthyear: 1979,
    locations: ["Buenos Aires", "Singapoore", "Berlin"]
}
```

The application would stop providing write support for that field and encourage its users to enter the new information. At some point the `birthyear` field will eventually be frozen and made read-only in the database layer. It then can either be dropped or kept around for historical reasons.

### Lock the document

If the value is business critical and must be migrated, the document would be locked altogether. It depends then on the application requirements how strict this will be treated. If it’s not possible to make the field optional the document must eventually be locked or even erased.

```js
db.read = (userId) => {
    const user = userCollection.findById({
        _id: ObjectId(userId)
    });
    if (!user.birthdate) {
        throw new Error("Document invalid: birthdate missing.")
    }
    return user ? {
        name: user.name,
        birthyear: user.birthyear,
        locations: user.locations
    } : null;
}
```

### Best guess

Last but not least we could try to calculate a best guess for the new data format. In this case we would have to assume an arbitrary month and day (e.g. `Date("1979-01-01")`) but that isn’t really a feasable option here.