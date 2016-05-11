---
layout:        blogpost
title:         What is a REST service?
subtitle:      From the series “Let’s build a REST service”
date:          2016-03-19
tags:          [rest, microservice, api, project]
redirect_from: /fXts2/
permalink:     fXts2/what-is-a-rest-service
image:         /assets/2016/hammock.jpg
---

> This blogpost is part of the series [“Let’s build a REST service”](/Toqw4/lets-build-a-rest-service), in which I build my own shortlink webservice. The source code of the project is [on Github](https://github.com/jotaen/j4n.io).

# What is a RESTful webservice?

A webservice is basically an ordinary webserver, that manages a specific resource.[^1] The interaction with this resource happens via HTTP requests and responses. However, instead of serving complete webpages (with markup and layout and all that), there is only pure data being exchanged. The service is agnostic in regards of specific technologies, so the client (i.e. the “user” of the service) does for instance not know, what kind of database is being used or in which programming language the service is implemented in.

In order to be RESTful, the service should meet the following requirements:

- It offers a **uniform interface**. In the context of most web applications this is standard HTTP as basic communication protocol and JSON as exchange format for data. Both directions must comply strictly to a respective **specification**.
- The API allows to **perform all CRUD operations** on its resources (on the single ones anyway, better yet on entire collections).
- The service **has sole sovereignty** over the resources it manages. For the sake of integrity and consistency it is good practice to neither share the resource nor to offer a bypass to manipulate it.
- The service should **fulfill a single responsibility**. It must neither be hyper generic on the one hand nor be tailored for specific use cases on the other: The truth lies somewhere in between.
- The **requests are stateless** and fully self-contained; the server does not store client context between subsequent requests.
- Responses should contain **links to related or embedded resources**. (This aspect is a should-have though, because it doesn’t make sense in every use case.)

# Best practices

## Endpoints

- collection & single item
- POST, PUT, DELETE, GET

## Responses

- JSON (also for errors)
- Always response

## Versioning

Every (public) API should be versioned. This is a rare exception of the YAGNI principle, because *perhaps* you will not need versioning, but *when* you need it and you don’t have it, you get into deep trouble: You either risk to break all existing clients or you place a lifelong burden of workarounds on yourself. Therefore it’s crucial to have this problem covered from the very beginning.

API versioning is a wildly discussed question[^2], where there ain’t (and won’t be) a definite answer. For the sake of simplicity I usually prefer APIs to be versioned by prefixing the URL path (`/v1/my/resource`). However, this doesn’t make much sense in the case of j4n.io, since shortness of the URLs is a business requirement which I am subjected to.

I decided to go with the second most simple solution: Versioning my API via a query parameter (`?version=1`). For both laziness and convenience, I let this parameter default to the latest available version.

[^1]: The term “REST” goes originally back to [the dissertation of Roy Fielding](https://www.ics.uci.edu/~fielding/pubs/dissertation/fielding_dissertation.pdf) from 2000.
[^2]: [Here](http://www.lexicalscope.com/blog/2012/03/12/how-are-rest-apis-versioned/) is an outdated, but nonetheless helpful overview.

*[CRUD]: Create, Read, Update, Delete
*[YAGNI]: You ain’t gonna need it
