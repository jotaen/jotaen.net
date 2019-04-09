+++
draft = true
expiryDate = "2017-01-01"
title = "Testing terminology"
subtitle = ""
date = "2018-10-21"
tags = ["testing"]
image = "/drafts/2018-10-21-testing/puzzle.jpg"
image_info = "Original photo by Hans-Peter Gauster"
id = "asdf6"
url = "asdf6/testing-concepts"
aliases = ["asdf6"]
+++

You sometimes hear statements such as that a unit should only be an atomic piece of code. Or that unit tests and integration tests differ in execution speed. Or that you can turn an integration test into a unit test by mocking away its collaborators.

I personally find these kinds of definitions a bit academic and of little practical use. 

In order to come up with a good test setup I rather let myself guide by these aspects:

- What is the subject matter of my test?
- What aspect are my assertions targeted at?
- Where is the value of a test?

From my experience there is no such thing like an ideal test setup.

Goals:

- Confidence
- Avoid regressions (worriless refactoring)
- Compliance

## Subject matter

I don’t find it helpful at all to formally distinguish between unit and integration tests.

### Unit test
- Subject matter: outward behaviour of a unit
- May or may not have internal collaborators (as long as they are an implementation detail)

### Integration test

- Subject matter: collaboration of unit with external entity
- Examples: ORM library; specific edge-cases, e.g. IO-exceptions

## Collaborators

- Induce specific behaviour
- Bypass dependency on 3rd party
- Cut off undesired code path
- Ensure specific way of interaction

## Setup

- Configurability
- Execution time
- Ease of use

