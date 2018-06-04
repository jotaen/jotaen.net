+++
draft = true
title = "Web guards"
subtitle = "Strategies to check and validate HTTP requests"
date = "2018-06-03"
tags = ["coding", "backend"]
image = "/posts/2018-06-03-guards/tokyo-palace.jpg"
id = "13ozc"
url = "13ozc/checking-validating-http-requests"
aliases = ["13ozc"]
+++



```JSON
{
    "title": "Japan Travel Guide",
    "summary": "<p>The top 30 places in all of Japan!</p>",
    "isPublished": false,
    "price": 29.95,
    "featuredDate": "2018-06-15"
}
```

- `title` must be a string.
- `summary` must be a string containing valid HTML.
- `isPublished` is a boolean and decides whether the product is listed publicly or stored as a draft. In order to publish something the user must have admin priviledges. Otherwise they are only allowed to create draft (unpublished) products.
- `price` must be a non-negative float with 2 decimal places. Depending on the individual user settings, the maximum assignable price might be capped.
- `featuredDate` must be an ISO-formatted date string, meaning that the product shall be featured during that day in the sidebar of the web shop. Important constraint: there can only be one featured product per day in the shop.

As an authentication mechanism the shop system uses Basic Auth, where the credentials (username + password) are attached as header fields in the request.

# Concept

1. **Authentication**: The matter of authentication is to verify that someone is who he claims to be. In the most obvious way to do this is via user name and password. By name (or ID, or email address) the user declares who he is; with the password he proves it.
2. **Request validation**: By means of request validation we make sure that our application deals with a valid request object. Validation is relatively dumb though, because it only ensures the integrity of the request on a formal level. Typical examples for validation are to see whether required request parameters are present or to perform checks on certain fields. (E.g. that a string is formatted the right way or that a number is within a particular range.) While not forbidden, it would be rather unusual for a validation task to consult the database.
3. **Authorisation**: During an authorisation check we see whether a user is actually allowed to perform the inquired operation. These checks are often tied to universal roles, but they can also be dependend on individual circumstances at the time of the request.
4. **Business integrity**: Finally, we need to ensure that an operation is legal in the sense of our domain model and wouldn’t lead to corrupt state. Integrity checks can also be implicitly defined, e.g. by means of constraints in the database. In our example it is only allowed for one product to be featured per day.

The difference between a the last two may not always be obvious. The subject-matter of an integrity check is whether the requested operation is generally legal, regardless of what the user is allowed to do. Authorisation, however, can only be granted within these boundaries and – in doubt – will be trumped by the former.

# The product creation request

The concept that I outlined above can be applied in the following way[^1] to a web application. Let’s have a look at the implementation of the different check stages first; then we’ll assemble things together to a webserver.

### Authentication check

The authentication check retrieves the principal from the database and ensures that the credentials match.

```php
export function retrievePrincipalOrThrow(credentials) {
    principal := userDB.findUserByName(credentials.name)
    if (principal == null) {
        throw PrincipalNotFoundError()
    }
    if (!principal.canBeAuthenticatedWith(credentials.password)) {
        throw InvalidCredentialsError()
    }
    return principal
}
```

### Request validation

During request validation we are checking the types and value ranges of properties, without yet considering the principal or any other rules. The only goal is to make sure that the body object is formed according to the specification.

```php
export function isValid(body) {
    // These functions would be all static, pure predicates
    return isNonEmptyString(body.title) &&
        isHtmlString(body.summary) &&
        isBoolean(body.published) &&
        isNonNegativeFloatWithTwoDecimalPlaces(body.price) &&
        (isEmpty(body.featuredDate) || isIsoDate(body.featuredDate))
}
```

### Authorisation check



```php
export function isAuthorised(principal, product) {
    publishRule := (product.isPublished && principal.isAdmin)
    priceLimitRule := (product.price <= principal.maxPriceAllowance)
    return (publishRule && priceLimitRule)
}
```

### Integrity check

The data integrity check needs to happen in a way that prevents any potential  concurrent write request to interfer in the meantime. (Here: by means of a database transaction.)

```php
export function createOrThrow(product) {
    return productDB.transaction(function() {
        conflict := productDB.findByFeaturedDate(product.featuredDate)
        if (conflict) {
            throw DuplicateFeaturedDateError()
        }
        return productDB.insert(product)
    })
}
```

## Bringing it all together

With the above modules we can compose a well-guarded HTTP server. Any request that gets directed to the resource must pass all middlewares one after the other. Therefore, an invalid request would never make it to the controller.

While it’s strictly not necessary to separate our algorithms into distinct modules, it promotes reusability and – more importantly – allows for writing cheap and isolated tests.

```php
function authenticationMiddleware(request, response, next) {
    principal := retrievePrincipalOrThrow(request.getCredentials())
    request.principal = principal
    next()
}

function validationMiddleware(request, response, next) {
    body := request.getBodyAsJson()
    if (isValid(body)) {
        request.product = body
        next()
    }
    throw InvalidRequestError()
}

function authorisationMiddleware(request, response, next) {
    if (isAuthorised(request.principal, request.product)) {
        next()
    }
    throw NotAuthorisedError()
}

function createProductController(request, response) {
    newProduct := createOrThrow(request.product)
    return response(serialise(newProduct))
}


httpServer.registerResource("POST", "/api/products")
    .withMiddleware(authenticationMiddleware)
    .withMiddleware(validationMiddleware)
    .withMiddleware(authorisationMiddleware)
    .withController(creationController)
```


[^1]: Notice, all samples are written in pseudo-code.
