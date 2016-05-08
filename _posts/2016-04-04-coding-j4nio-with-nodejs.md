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

Enough of the talking – let’s roll up the sleeves. I want to point out though, that this is not a hands-on tutorial that goes into detail about specific technologies. There are hundreds of thousands of guides on how to setup an ExpressJS project and dozens on blogposts on which NPM module is the best choice with MongoDB.

I rather like to concentrate on the general setup and the basic ideas behind the project, since these thoughts remain valid beyond particular (and frequently changing) implementation details.

# Technologies

Everyone is talking about JavaScript and NodeJS these days; packages spring up like mushrooms on npmjs.org (but also drown en masse, by the way); and an outsider could be left with the impression, that the MEAN stack is the real deal nowadays for writing web applications.

Of course, that is not true. Every technology has strengths and weaknesses and it is left to the software developer to make a considerate decision on which tool to select. Just picking en-vogue technologies that everyone goes with is a mistake that can viciously come back to roost.

However, for the j4n.io project it indeed suggested itself to pick NodeJS with MongoDB – for the following reasons:

- MongoDB is a non-relational document store. Since the shortlink datasets aren’t connected with each other and do not need to be poured into a strong schema, this database type seems to be an appropriate choice.
- I selected ExpressJS as HTTP framework, because it lives up to its name: Setting up a microservice is straightforward and free of unnecessary overhead. Handling JSON data structures is built-in. And hosting and deployment is cheap and easy.

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


*[NPM]: NodeJS Package Manager
