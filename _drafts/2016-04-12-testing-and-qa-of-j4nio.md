---
layout:        blogpost
title:         Testing and QA of J4N.IO
subtitle:      From the series “Let’s build a REST service”
date:          2016-04-12
tags:          [rest, microservice, api, project]
redirect_from: /0baE5/
permalink:     0baE5/testing-and-qa-of-j4nio
image:         /assets/2016/swing-in-dawn.jpg
---

Back in the days when I started programming, I didn’t write tests at all. After applying changes I only performed some checks by hand to confirm that the application was still working. This procedure sufficed for me and I felt good with it. However, while my programming skills evolved over the years, also my point of view in regards of testing shifted completely: Today I can barely imagine writing a piece of code without writing tests for it.

The actual j4n.io codebase has about 350 lines of code, which is a good measure for a microservice of that size. However, the tests for the application contain thrice as much code. There are about 70 test cases, that verify the functionality on various technical and logical levels and thus ensure the integrity of the application as a whole.

If I would be able to travel back in time and tell myself why testing is so important, I probably would have asserted this:

- **Good tests prevent you or someone else to break something by accident.** The essential precondition for this is, that the entire behavior of the program is under test. In other words: Any  modification of logic must result in failing tests.[^1]
- **Writing tests before writing implementation** help you to give fair thought to software design: You are enforced to make deliberate decisions about segregation and responsibilities, which results in an overall clearer structure and better interfaces of your components.
- **Good tests are better than verbose documentation**.
- A strong test suite (complemented by a rock solid deploy chain and a thorough monitoring) **is worth its weight in gold, when it comes to deployment**. Imagine: It’s Friday afternoon and you just finished the implementation of a new feature. You deploy it to production and knock off without having performed even a merest manual check on the freshly released system. How does that sound to you?

## Unit Tests

- Black box principle (input/output)

## Integration Tests

- How a unit behaves with an external entity (db, rest service)

## System Tests

- How the application/system behaves as an entirety



[^1]: 
