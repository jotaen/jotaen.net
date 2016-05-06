---
layout:        blogpost
title:         J4N.IO – Deployment and operating
subtitle:      From the series “Let’s build a REST service”
date:          2016-04-24
tags:          [rest, microservice, api, project]
redirect_from: /0baE6/
permalink:     0baE6/deployment-and-operating
image:         /assets/2016/beachchair-ocean.jpg
---

The best code isn’t worth anything when it doesn’t run somewhere. Thankfully, operating did become simple as it can be nowadays. Gone are the times where you needed to spend hours to setup servers, configure firewalls and watch out for security updates. The whole process of building, shipping and serving a web application is boiled down to a minimal setup and configuration effort: The “as-a-service” suffix is the keyword to watch out for.


# Build chain

I use [Travis CI](https://travis-ci.com) as a build service for j4n.io. The entire configuration for the build is stored in a plain file, which is part of the project. There are several things happening on every push the repo:

## Build and tests
The dependencies are installed and then the tests get executed. Since travis execute every build in a fresh environment, it is ensured that all dependencies are well-defined and the project contains everything it needs to run. Also the process does not rely upon the state of one particular machine or on previous builds.

## Code analysis
When the tests did pass, the codebase undergoes a code analysis:

- [Coderwall](https://) keeps track of the code coverage and generates simple metrics.

## Operating
- Platform as a service


## Deployment and monitoring
- Post-deploy checks
- statuscake
