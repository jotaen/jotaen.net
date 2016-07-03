---
layout:        blogpost
title:         Semantic versioning
subtitle:      
date:          2016-06-10
tags:          [semver]
redirect_from: /abcdef/
permalink:     abcdef/semantic-versioning
image:         /assets/2016/.jpg
---

A common approach to versioning APIs[^1] is to indicate the progression of an API via the version number: A significant improvement or an effortful rewrite of the code results in a new major version (e.g. from 1.3 to 2.0), whereas small changes or minor fixes only entail the incrementation of a decimal place. There are some ups and downs with this:

- The version number is a good reflection for the generation of an API. Key prerequisite is that this is handled consistently across all releases.
-

Semantic versioning (short: SemVer) was born out of a different motivation: SemVer is not a measurement for the size or the significance of a changeset. It makes an assertion about the compatibility of the public interface:

> [^2]The way in which the version number is incremented after this release is dependent on this public API and how it changes. This API could be declared in the code itself or exist strictly in documentation.

A SemVer version number is made up of 3 parts `MAJOR.MINOR.PATCH`:

### MAJOR

You must increment the MAJOR version when you make incompatible API changes. This is the case when clients of the API would need to modify their own source code.

### MINOR

You must bump the MINOR version when you add functionality in a backwards-compatible manner, without affecting the behaviour of the previously existing API.

### PATCH

You must increment the PATCH version when you make backwards-compatible bug fixes. Although the SemVer specification only refers to bug fixes, it makes sence to stretch the definition so it also covers internal modifications that do not affect the external behaviour of the API. (Otherwise you would have to bump the MINOR or MAJOR version after an internal refactoring, which wouldn’t make much sense.)

### Postfixes

There are two optional postfixes to a version number:

- A pre-release version may be denoted by appending a hyphen and a series of dot separated identifiers, like: `3.4.1-alpha.2.3`
- Build metadata MAY be denoted by appending a plus sign and a series of dot separated identifiers `19.14.0+a7c8270001f7ce` or `1.2.19-beta+2016.09.01`

## Examples

Here are some examples of how SemVer works in practice:

- You apply a refactoring to a recursion, so that its performance or memory consumption gets slightly improved. This is just an internal modification and doesn’t change the behaviour of the API, so it is a **PATCH**. If your old API was `1.0.0`, your new release would have to be `1.0.1`
- Your API is in version `2.14.3` and you add 20 new functions without touching anything existing. You would need to bump the **MINOR** version so your API is `2.15.0` hereafter.
- You introduce a new exception type in one function. Although this seems like an addition at first glance, it actually is a breaking change, because all clients need to change their code in order to catch this exception. If your API was `6.5.1` before, you must bump **MAJOR** to `7.0.0`

# Best practices

## Provide a specification

A specification is the single source of truth for an API. Most people only work with the specification when implementing your API in their application. Chances are that most people do not even look in the source code of your library a single time.

Without a specifiction it is difficult

## Always offer a CHANGELOG

The users of your API are humans. It is pointless to indicate a breaking change or the introduction of a new feature without providing understandable information on it. The best solution is to maintain[^3] a CHANGELOG file, in which all relevant changes are documented in a brief, informative and human readable way. If you omit this you place a burden on all developers, who will have a hard time to track down the modifications in order to understand, whether or how they need to change their own source code.

## Use 1.0.0 if you go public

A bad practice often observed are public libraries with 0.x.y versions. In SemVer, a 0.x.y version means that the API is under development and not intended to be used in production. Despite, there are tons of widely used packages out there that languish at version 0-point-something. This is absurd all the more in case the package is small in scope and well tested.

In SemVer you must liberate from the notion that a 1.0.0 release has to be perfect, impeccable and flawless. Instead, it just means you start to use SemVer. This is a sublime thing you should aim for, since only now you can turn all its benefits to advantage. Versions below 1.0.0 are purely arbitrary. Either, the maintainer of a package is unsure about the API and wants to leave all doors open, or she even decided to not be subject to SemVer at all.

## Never revert a release

- Instead, make a new release

## Make use of deprecation


- Avoid inflationary bumping of the major version
- Give users a chance to change their code in advance

## Plan your releases and make them small

- Just because you work on several things at once, there is no need to release them at once

## Offer an additional label to indicate generation

# Disclaimer



[^1]: “API” denotes the public interface of an application: This can refer to a programming library/package just as to the specification of a RESTful microservice.
[^2]: See the specification of [SemVer 2.0.0](http://semver.org/)
[^3]: It’s best to progressively add information to the CHANGELOG while developing (i.e. on each merge into the master branch)
