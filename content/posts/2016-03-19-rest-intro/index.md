+++
title = "What is a REST service?"
subtitle = "From the series “Let’s build a REST service”"
date = "2016-03-19"
tags = ["rest", "microservice", "api", "project"]
image = "/assets/2016/hammock.jpg"
id = "fXts2"
url = "fXts2/what-is-a-rest-service"
aliases = ["fXts2"]
+++

> This blogpost is part of the series [“Let’s build a REST service”](/Toqw4/lets-build-a-rest-service), in which I build my own shortlink webservice. The source code of the project is [on Github](https://github.com/jotaen/j4n.io).

A webservice is basically an ordinary webserver, that manages a specific resource.[^1] The interaction with this resource happens via HTTP requests and responses. However, instead of serving complete webpages (with markup and layout and all that), there is only pure data being exchanged. The service is agnostic in regards of specific technologies, so the client (i.e. the “user” of the service) does for instance not know, what kind of database is being used or in which programming language the service is implemented in.

In order to be RESTful, a service should meet the following requirements:

- It offers a **uniform interface**. In the context of most web applications this is standard HTTP as basic communication protocol and JSON as exchange format for data. Both directions must comply strictly to a respective **specification**.
- The API allows to **perform all CRUD operations** on its resources (on the single ones anyway, better yet on entire collections).
- The service **has sole sovereignty** over the resources it manages. For the sake of integrity and consistency it is good practice to neither share the resource nor to offer a bypass to manipulate it.
- The service should **fulfill a single responsibility**. It must neither be hyper generic on the one hand nor be tailored for specific use cases on the other: The truth lies somewhere in between.
- The **requests are stateless** and fully self-contained; the server does not store client context between subsequent requests.
- Responses should contain **links to related or embedded resources**. (This aspect is a should-have though, because it doesn’t make sense in every use case.)

# j4n.io API

The shortlinks can be viewed and managed via HTTP requests and the corresponding methods:

- **GET** for viewing single resources or listing all of them (that’s called “collection”)
- **PUT** for creating new resources, where the client specifies the URI
- **POST** either for creating new resources, where the server generates the URI; or for updating existing resources.
- **DELETE** for removing resources

The entire interface is defined in a [swagger specification](https://github.com/jotaen/j4n.io/blob/master/api.yml).[^2] This is a formal description of how an API request has to be setup and what the responses look like.

The exchange format for data input and output is JSON. This is the most common and practical format in the web. As for the requests, there is no need to encode the data as query or form parameters: it is just send as JSON in the body. The query parameters can be used for setting request options, such as the API version (see below) or for pagination of collections.

The API responses are also JSON. This is important to be consistent with: it applies not only to the regular responses, but also to errors or empty responses.

Here are the data structures for request and response of this particular blogpost. As you see, the response contains some additional meta-data, that cannot be manipulated via the request.

#### Request: PUT /fXts2
{% highlight json %}
{
  "url": "http://jotaen.net/fXts2/what-is-a-rest-service",
  "status_code": 302
}
{% endhighlight %}

#### Response: GET /fXts2
{% highlight json %}
{
  "token": "fXts2",
  "url": "http://jotaen.net/fXts2/what-is-a-rest-service",
  "status_code": 302,
  "created": "2016-03-19T15:02:09Z",
  "updated": "2016-03-19T15:02:09Z"
}
{% endhighlight %}

From the 70 HTTP predefined status codes, I chose the following ones for my API:

- **200 OK** Everything is fine (used for read, update and delete operations)
- **201 Created** A new resource had been created (used for create operations)
- **400 Bad request** The request is malformed and rejected for formal reasons. It doesn’t make sense for the client to retry that same request. I use this for validation errors.
- **401 Not authorized** The request requires valid authorization.
- **409 Conflict** The request (create operations only) cannot be processed, since there already is a resource existing under this URL.

# Further best practices

In the following section I’d like to share two topics, that I put some thought into while developing j4n.io. However, these are a bit selected at random, since there are dozens of other things, that need to be considered when developing a REST service.

## API design

The API of a microservice is to a programmer as a graphical user interface is to a user – the term “service” is by all means to be taken literally. Besides from fulfilling mandatory requirements like consistency and reliability, a good microservice API also follows the robustness principle. That says: “Be liberal in what you accept, be conservative in what you send.”

For example, the j4n.io API is tolerant regarding the type of the `status_code` property in the request. Even though the specification requires this value to be a number, the service also accepts a string (in case it is numeric), which then gets converted internally. Nevertheless, the response is always conform to the specification (and so is the data storage, by the way).

## Versioning

Every (public) API should be versioned. This is a rare exception of the YAGNI principle, because *perhaps* you will not need versioning, but *when* you need it and you don’t have it, you get into deep trouble: You either risk to break all existing clients or you place a lifelong burden of workarounds on yourself. Therefore it’s crucial to have this problem covered from the very beginning.

API versioning is a wildly discussed question[^3] – anyway, there ain’t (and won’t be) a definite answer to it. For the sake of simplicity I usually prefer APIs to be versioned by prefixing the URL path (`/v1/my/resource`). However, this doesn’t make much sense in the case of j4n.io, since shortness of the URLs is a business requirement which I am subjected to.

I decided to go with the second most simple solution: Versioning my API via a query parameter (`?api=v1`). For both laziness and convenience, I let this parameter default to the latest available version.

# Read on

> [**Part 3: Development with NodeJS**](/Q6eUW/coding-j4nio-with-nodejs) My service is implemented based on the ME(A)N-Stack (MongoDB, ExpressJS, NodeJS), which seems to be a pretty good choice for this particular project.


[^1]: The term “REST” goes originally back to [the dissertation of Roy Fielding](https://www.ics.uci.edu/~fielding/pubs/dissertation/fielding_dissertation.pdf) from 2000.
[^2]: [Swagger.io](http://swagger.io/) is a popular framework for describing APIs. There also is an editor on the swagger website for rendering the YAML files.
[^3]: [Here](http://www.lexicalscope.com/blog/2012/03/12/how-are-rest-apis-versioned/) is an outdated, but nonetheless helpful overview.

*[CRUD]: Create, Read, Update, Delete
*[YAGNI]: You ain’t gonna need it
