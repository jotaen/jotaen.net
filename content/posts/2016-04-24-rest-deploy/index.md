+++
title = "J4N.IO – Deployment and operating"
subtitle = "From the series “Let’s build a REST service”"
date = "2016-04-24"
tags = ["project", "devops"]
image = "beachchair-ocean.jpg"
id = "Tt7Yh"
url = "Tt7Yh/deployment-and-operating"
aliases = ["Tt7Yh"]
+++

> This blogpost is part of the series [“Let’s build a REST service”](/Toqw4/lets-build-a-rest-service), in which I build my own shortlink webservice. The source code of the project is [on Github](https://github.com/jotaen/j4n.io).

The best code isn’t worth anything when it doesn’t run somewhere. Thankfully, operating did become simple as it can be nowadays. Gone are the times where you needed to spend hours to setup servers, configure firewalls and watch out for security updates. The whole process of building, shipping and serving a web application is boiled down to a minimal setup and configuration effort: The “as-a-service” suffix is the keyword to watch out for.

The build and deploy process for j4n.io is a continuous deployment setup. That means, that all changes, that pass the quality gates, get released into production instantaneously. That’s cool from a dev perspective: your work adds value to the product instantly and it saves time and effort (releases can be a time consuming issue). But there are two sides of this coin: Continuous deployment requires a different, farseeing mindset from software developers and the only technical thing, that prevents a buggy or defect commit from going live, are tests and quality checks.

# Getting the code out there

## Build and tests
I use [Travis CI](https://travis-ci.org/jotaen/j4n.io) as a build service for j4n.io. The entire configuration for the build is stored in a plain YAML file, which is part of the project. Each push on the [j4n.io Github repository](https://github.com/jotaen/j4n.io) triggers a build, in which the dependencies are installed and the tests get executed. Every build is executed in a fresh environment, so it is ensured that all dependencies are well-defined and the project contains everything it needs to run. The process does not rely on a particular machine and no state is needed to be shared among subsequent builds.

## Code analysis
When the tests did pass, the codebase undergoes a code analysis:

- [Coveralls](https://coveralls.io/github/jotaen/j4n.io?branch=master) keeps track of the test coverage. This is extremely helpful when working with pull requests, because you are able to track down coverage changes in advance.
- [Bithound](https://www.bithound.io/github/jotaen/j4n.io) monitors the project dependencies (e.g. if they are outdated) and generates simple metrics, that disclose unnecessary duplications or complexity.

## Deployment and operating
After the actual build has completed, the application gets deployed automatically. I run my app on [Modulus.io](https://modulus.io), which offer platform-as-a-service (PAAS) hosting for NodeJS/MongoDB and a few other environments. They currently use AWS, Joyent or DigitalOcean as underlying infrastructure, but this is a mere technical detail you don’t need to bother with. The only thing you need to do is upload your code and let them worry about all the rest in order make it run. That’s pretty convenient![^1]

The integration between Modulus and Travis is seamless: The deploys are executed from the Travis platform, which has the great advantage, that no unwanted local files can make it into the deploy. The entire setup is settled by a three-liner in the Travis configuration file.

## Monitoring

Despite tests and other quality gates there are always things that can go wrong during deployment. For that reason, I have some post-deploy checks for j4n.io, which make certain, that the app is healthy and stable.

- A **smoke test** is executed directly after the deployment. It performs five key transactions that affect the main responsibilities of the application, thus making sure that everything made it unscathed to production and the server got restarted properly.
- The application constantly gets **monitored** via [StatusCake](https://www.statuscake.com). They perform simple requests all the time from all over the world and send instant notifications once the server is not available. (Modulus also provides an alerting feature, which sends Mails or text messages, if the application crashes.)

## Notifications

Although the test suite needs about 10 seconds to pass, the entire build and deploy process from scratch takes a few minutes. Since I don’t want to sit and wait for it to be completed, I created a Slack channel, where all information get pushed, as soon as it become available:

![A slack message notifying about a successful deployment](/assets/2016/slack-j4nio.png)

The second notification is the smoke test, which I explained above. When it appears, I know that the deployment passed through and everything is working fine. As a future improvement I plan a failing health check to result in an automated rollback to the latest stable version of the app.


[^1]: Modulus.io is the only service involved here, which charge something. All the other services are free for open-source projects

<!-- *[PAAS]: Platform as a service -->
