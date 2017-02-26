+++
title = "Testing and QA of J4N.IO"
subtitle = "From the series “Let’s build a REST service”"
date = "2016-04-12"
tags = ["testing", "ci", "microservice", "project"]
image = "/posts/2016-04-12-rest-test/swing-in-dawn.jpg"
id = "v24iU"
url = "v24iU/testing-and-qa-of-j4nio"
aliases = ["v24iU"]
+++

> This blogpost is part of the series [“Let’s build a REST service”](/Toqw4/lets-build-a-rest-service), in which I build my own shortlink webservice. The source code of the project is [on Github](https://github.com/jotaen/j4n.io).

Back in the days when I started programming, I didn’t write tests at all. After applying changes I only performed some checks by hand to confirm that the application was still working. This procedure sufficed for me and I felt good with it back then. However, as my programming skills evolved over the years, so did my point of view in regards of testing: Today I can barely imagine writing a piece of code without writing tests for it.

If I would be able to travel back in time to tell myself why testing is so important, I probably would have asserted this:

- **Good tests prevent you or someone else to break something by accident.** The essential precondition for this is, that the entire behavior of the program is under test.[^1] In other words: Any modification of behavior must result in failing tests.
- **Writing tests before writing implementation** help you to give fair thought to software design: You are enforced to make deliberate decisions about segregation and responsibilities, which results in an overall clearer structure and better interfaces of your components.
- **Good tests can be better than verbose documentation**. A good structured test suite reads like a requirement specification. In addition, modern test frameworks offer the possibility to add meaningful descriptions right on the spot. This must be taken advantage of.
- A strong test suite (complemented by a rock solid deploy chain and thorough monitoring) **is worth its weight in gold, when it comes to deployment**. Imagine: It’s Friday afternoon and you just finished the implementation of a new feature. You deploy it to production and knock off without having glanced for even a second over the freshly released system. How does that sound to you?

The actual j4n.io codebase has about 350 lines of code, which is a good measure for a microservice of that size. However, the tests for the application contain thrice as much code. I wrote about 70 test cases[^2], that verify the functionality on various technical and logical levels.

### System Tests
These tests consist of HTTP requests, that are sent to the app; the assertions then solely rely on the HTTP responses. I don’t care about anything that happens within the application during the call. Since these tests are performed on the most outward level, they can be also called “end-to-end” tests for this reason.

System level tests are the most important ones, because they ensure the integrity of the application as a whole. If I would rewrite my application from scratch in a different programming language, these tests would still remain valid. This is a major difference to the other test categories. However, system tests alone are not sufficient, as they are too roughly-grained and do not allow to test the various logical layers of the program code in isolation. Moreover, the test cases are bound to the HTTP protocol and would become useless, if I would want to write a CLI interface.

### Unit Tests
A unit is the smallest cohesive piece of code, that is self-contained and has deterministic behavior. In most cases a unit is a pure function or an object (with multiple methods). Unit tests are cheap and easy to write. In the case of j4n.io there are a few units for data pre-processing and validation. These are typical use cases for unit tests. You just throw something into the unit and check the output. (This principle is called black-box testing.)

The ability to write these kinds of tests can be a strong reason to segregate code into distinct modules. For example the j4n.io middlewares contain some logic, that could have been extracted and therefore separately tested (if I had implemented it within an isolated unit). However, this must be decided on a by-case basis.

### Integration Tests
The primary concern of j4n.io is to manage shortlinks, which are stored in and read from a MongoDB. For that reason it makes sense to test the integration between code and database. Integration tests are not as trivial as unit tests. There are a few things to considerate:

- One cannot simply checkout the project and run the tests, because the tests will not work without a running Mongo-DB instance. The supply and setup of this external dependency must be as straightforward and simple as possible. (As for j4n.io, you just need to pass the DB hostname via an environment variable.)
- You must ensure, that subsequent test-runs don’t get in each others way. You could clear (drop) the database before every test or you could create a fresh collection every time. I decided to go with the latter.
- The external entity must be available in your build environment. My builds for j4n.io are executed on [Travis CI](https://travis-ci.org), who provide MongoDB support out of the box.

To avoid the hassle with integration tests, some people prefer to write mock tests instead. As far as I am concerned, I barely make use of them, because I see little value in mocking dependencies just in order to reduce testing boilerplate. A mock test only tells me whether my application works with some dummy module, that I myself had written. When I want to make a meaningful assertion about the interaction between my code and an external entity, I see most value in testing just that.

However, a valuable use case for mock tests would be to test specific behavior of an external component, that would be otherwise difficult to provoke (such as a particular exception or a fragmentary data transmission).

# Read on

> [**Part 5: Deploying and operating**](/Tt7Yh/deployment-and-operating) The best code is worth little, if it doesn’t run anywhere. In order to preserve a healthy ratio between application size and maintenance expenses, we will go into the cloud.


[^1]: By the way, this quality also becomes handy when you apply a refactoring to the innards: Without even having to touch them, the tests remain valid and tell you when you are done.
[^2]: For my taste, the code-to-test ratio for j4n.io is adequate, but resides at the lower bounds though.
