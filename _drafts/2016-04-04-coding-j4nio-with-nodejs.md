---
layout:        blogpost
title:         Coding J4N.IO with NodeJS
subtitle:      From the series “Let’s build a REST service”
date:          2016-04-04
tags:          [rest, microservice, api, project]
redirect_from: /0baE4/
permalink:     0baE4/coding-j4nio-with-nodejs
image:         /assets/2016/strandkorbs-at-beach.jpg
---

Enough of the talking – let’s roll up our sleeves.

# Technologies

- MongoDB as schemaless document store
- NodeJS / Express

# Project structure

The source files in the app directory can be grouped into three categories:

## Setup, bootstrapping
When you look into the `bootstrap` folder, you instantly smell the dust of side-effects. Here is the place for all the dirty stuff, like accessing the process environment, establishing a database connection or starting the actual app. Because of all the global state, bootstrapping is difficult to deal with and can barely be tackled by tests. For that reason, it is good to keep these things simple and manage them all in one single place.

## Business logic
The business logic of the shortlink service consists of data pre-processing and persistence. These modules have a generic API – they do not know anything about HTTP or the framework they are embedded in. If I would choose a different HTTP framework or decide to write a CLI interface for accessing the database, I could reuse these modules without having to modify a single line of code. However, portability is not the primary reason for this strict demarcation: It’s rather a matter of good and clear code structure, which is achieved by defining abstraction layers precisely and keeping them strictly separate from one another.

## HTTP logic
The shortlink data is modeled as resource.
- Onion principle:
  - Routing
  - Middleware (preprocessing the request)
  - Controller
