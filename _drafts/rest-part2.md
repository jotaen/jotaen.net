---
layout:     blogpost
title:      What is a REST service?
subtitle:   From the series “Let’s build a REST service”
date:       2016-03-19
tags:       [rest, microservice, api, project]
permalink:  0baE3/what-is-a-rest-service
image:      /assets/2016/hammock.jpg
---

# Definition of REST

In my opinion, REST does not stand for a strict definition in the first place. Instead, I consider it to be a generic term containing living standards and practices. I don’t abuse this point of view as an excuse for inaccuracy or laziness. It’s just works well and is totally sufficient in practice. (Unless you prefer to get lost in sententious elaborations.)

A good REST service meets the following minimal requirements:

- It must offer a **uniform interface**. In the context of most web applications this is standard HTTP for the request and JSON for the response. Both directions must comply strictly to a respective **specification**.
- The API allows to **perform all CRUD operations** on its resources (on the single ones anyway, better yet on entire collections).
- It **has sole sovereignty** over the resources it manages. The resource (e.g. in the form of a database) is neither shared nor is there any bypass to access it.
- The **requests are stateless** and fully self-contained; the server does not store client context between subsequent requests.
- Responses should contain **links to related or embedded resources**. (This aspect is a should-have though, because it doesn’t make sense for all use cases.)

# Designing the j4n.io API

## Endpoints

- extent of a microservice
- collection & single item
- POST, PUT, DELETE, GET

## Responses

- JSON (also for errors)
- Always response

## Versioning

Every (public) API should be versioned. This is a rare exception of the YAGNI principle, because *perhaps* you will not need versioning, but *when* you need it and you don’t have it, you get into deep trouble: You either risk to break all existing clients or you place a lifelong burden of workarounds on yourself. Therefore it’s crucial to have this problem covered from the very beginning.

API versioning is a wildly discussed question[^1], where there ain’t (and won’t be) no definite answer. For the sake of simplicity I usually prefer APIs to be versioned by prefixing the URL path (`/v1/my/resource`). However, this doesn’t make much sense in the case of j4n.io, since shortness of the URLs is a business requirement which I am subjected to.

I decided to go with the second most simple solution: Versioning my API via a query parameter (`?version=1`). For both laziness and convenience, I let this parameter default to the latest available version.

[^1]: [Here](http://www.lexicalscope.com/blog/2012/03/12/how-are-rest-apis-versioned/) is an outdated, but nonetheless helpful overview.

*[CRUD]: Create Read Update Delete
*[YAGNI]: You ain’t gonna need it
