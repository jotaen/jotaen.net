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

Even though HTTP APIs are often concerned with CRUD operations at their core, there are a lot of things that need to be taken care of *before* the actual request gets put into action: is the data that we received in a valid format? Is the desired operation applicable? Does the user have proper permission to do so? Is the user even who he claims to be?

Depending on the application requirements, the complexity of these kinds of checks can increase considerably and thus call for a thought-through structure that is robust to maintain and easy to reason about.

In this blog post I’d like to develop such a concept in an exemplaric way with aid of a fictional online book shop API that illustrates my explanations.

## Exemplaric requirements

In order to register a new product item in the shop, a staff user must make a call to the products API and send along the following dataset that describes the new product:

```JSON
{
    "title": "Japan Travel Guide",
    "summary": "<p>The top 23 places in Japan (Number 14 is the best!)</p>",
    "isActive": false,
    "price": 29.95,
    "featuredDate": "2018-06-15"
}
```

There are a few things to take into consideration here:

- `title` must be a non-empty string.
- `summary` must be a string containing valid HTML.
- `isActive` must be a boolean. It decides whether the product is listed publicly or stored as a draft. In order to publish something the user must have admin priviledges though. Otherwise he is only allowed to create a draft product that then must be published later by someone with higher permissions.
- `price` must be a non-negative float with 2 decimal places. Depending on the individual user settings, the maximum assignable price might be capped. (The shop owner had problems with abuse in the past and introduced this mechanism as a safety measure.)
- `featuredDate` can (optionally) be an ISO-formatted date string. It means that the product shall be featured during that day in the sidebar of the web shop. Important constraint: the shop can only display one featured product per day.

As authentication mechanism the shop system uses Basic Auth[^1], where the credentials (username + password) are attached as header fields in the request.

# Conceptual setup

For a simple case like the above there is nothing wrong with just implementing the rules one after the other and not worrying too much about the code architecture. However, such a naive approach can quickly become cumbersome as the application grows. (A shop API that only allows product creation is a bit pointless after all.) And, nevertheless, it is good to be at least aware of the fundamental concepts in order to restructure the setup when it becomes necessary.

Our upfront checks can basically be divided into 4 different categories:

1. **Authentication**: The matter of authentication is to verify that someone actually is who he claims to be. The most obvious way to do this is via user name and password: by her name (or ID, email address, etc.) the user declares who she is; with her password she proves it.
2. **Request validation**: By means of request validation we make sure that our application deals with a valid request object. Typical examples for validation are to see whether required request parameters are present or whether given data complies to certain restrictions. Validation is relatively dumb though, because it only ensures the correctness of request data on a formal level. While not forbidden, it would be rather unusual for a validation task to consult the database.
3. **Authorisation**: During an authorisation check we assess whether a user is allowed to perform the inquired operation. These checks are often tied to universal roles, but they can also stem from individual settings or be dependent on other extrinsic factors.
4. **Business integrity**: Finally, we need to ensure that an operation is legal in the sense of our domain model and wouldn’t lead to corrupt state. Integrity checks can also be defined implicitly, e.g. by means of database constraints.

The difference between the last two may not always be obvious. The subject-matter of an integrity check is whether the requested operation is generally possible (*conceivable*), regardless of what the user is allowed to do. Authorisation, however, can only be granted within these boundaries and – in doubt – will be trumped by the former.

# Application in practice

Let’s apply the concept that I outlined above to a web application now. Notice, the following samples are written in pseudo-code.

We’ll have a look at the implementation of the different check stages first; then we’ll assemble things together in the webserver.

### Authentication check

The authentication check retrieves the principal[^2] from the database and ensures that the credentials match.

```php
function retrievePrincipalOrThrow(credentials) {
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

During request validation we are checking the types and value ranges of properties, without yet considering the principal or any other rules. The only goal is to make sure that the given data and parameters are formed in accordance to the API specification.

```php
function isValidProduct(body) {
    // These functions would be all static, pure predicates
    return isNonEmptyString(body.title) &&
        isHtmlString(body.summary) &&
        isBoolean(body.isActive) &&
        isNonNegativeFloatWithTwoDecimalPlaces(body.price) &&
        (isEmpty(body.featuredDate) || isIsoDate(body.featuredDate))
}
```

### Authorisation check

The authorisation check contains the rules that determine whether a particular user (principal) has sufficient permission to execute a request.

```php
function isAuthorisedForCreation(principal, product) {
    publishRule := (product.isActive && principal.isAdmin)
    priceLimitRule := (product.price <= principal.maxPriceAllowance)
    return (publishRule && priceLimitRule)
}
```

### Integrity check

The data integrity check needs to happen in a way that prevents any potential  concurrent write request to interfer in the meantime. (Here: by means of a database transaction.)[^3]

```php
function createOrThrow(product) {
    return productDB.transaction(function() {
        potentialConflict := productDB.findByFeaturedDate(product.featuredDate)
        if (potentialConflict != null) {
            throw DuplicateFeaturedDateError()
        }
        return productDB.insert(product)
    })
}
```

# Bringing it all together

With the above modules we can compose a well-guarded HTTP server consisting of a controller that is flanked by several middlewares. Any request that gets directed to the endpoint must pass all middlewares one after the other. Consequently, an invalid request would never make it to the controller.

```php
function authenticationMiddleware(request, response, next) {
    principal := retrievePrincipalOrThrow(request.getCredentials())
    request.principal = principal
    next()
}

function validationMiddleware(request, response, next) {
    body := request.getBodyAsJson()
    if (isValidProduct(body)) {
        request.product = body
        next()
    }
    throw InvalidRequestError()
}

function authorisationMiddleware(request, response, next) {
    if (isAuthorisedForCreation(request.principal, request.product)) {
        next()
    }
    throw NotAuthorisedError()
}

function createProductController(request, response) {
    newProduct := createOrThrow(request.product)
    return response(serialiseAsJson(newProduct))
}
```

With this in place we can eventually configure our HTTP endpoint:

```
httpServer.registerEndpoint("POST", "/api/products")
    .withMiddleware(authenticationMiddleware)
    .withMiddleware(validationMiddleware)
    .withMiddleware(authorisationMiddleware)
    .withController(creationController)
```

While it’s strictly not necessary to separate our algorithms into distinct modules, it promotes reusability and – more importantly – allows for writing cheap and isolated tests.


[^1]: In a real application it probably would be more common to use server sessions or [JWT tokens](/C3K4N/jwt-json-web-tokens). 
[^2]: A principal is an authenticatable entity. In our case: the API user
[^3]: An alternative way would be to define a uniqueness constraint on the `featuredDate` column in the database.
