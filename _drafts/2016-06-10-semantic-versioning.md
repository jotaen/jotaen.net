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

A common approach to versioning is to indicate the progression of an API by the version number: A significant improvement or an effortful rewrite of the code resulted in a new major version (e.g. from 1.3 to 2.0), whereas small changes or minor fixes only entailed the incrementation of the decimal place. There are some ups and downs with this method:

- When the handling of major releases is done consistently, the version number is a good reflection for the generation of the API
-

Semantic versioning was born out of a different motivation: SemVer is not a measurement for the size or the significance of a changeset – it just and only makes an assertion about compatibility. It is made up of 3 parts `MAJOR.MINOR.PATCH`:

### MAJOR

### MINOR

### PATCH

If you add 150 new functions to a library, SemVer tells you to increment the minor version. However, the modification of a single line of code can coerce you into incrementing the major version, if this change breaks the existing behaviour.

> The way in which the version number is incremented after this release is dependent on this public API and how it changes. This API could be declared in the code itself or exist strictly in documentation. [SemVer 2.0.0 Specification](http://semver.org/)

# Best practices

## Always offer a CHANGELOG

The users of your library, package or API are humans. It’s pointless to indicate a breaking change or the introduction of a new feature without providing understandable information on it. The best solution is to maintain a CHANGELOG file, in which all relevant changes are documented in a brief, informative and human readable way. If you omit this you place a burden on all developers, who will have a hard time to track down the modifications in order to understand, whether or how they need to change their own source code.

## Use 1.0.0 if you go public

A bad practice often observed are public libraries with 0.x.y versions. In SemVer, a 0.x.y version means that the API is under development and not intended to be used in production. Despite, there are tons of widely used packages out there that languish at version 0-point-something. This is absurd all the more in case the packages are small in scope and well tested.

In SemVer you must liberate from the notion that a 1.0.0 release has to be perfect, impeccable and flawless. Instead, it just means you start to use SemVer. This is a sublime thing you should aim for, since only now you can turn all its benefits to advantage. Versions below 1.0.0 are purely arbitrary and often indicate that the maintainer of a package wants to leave all doors open.

## Never revert a release

- Instead, make a new release

## Make use of deprecation

- Avoid inflationary bumping of the major version
- Give users a chance to change their code in advance

## Consider several smaller releases

- Just because you work on several things at once, there is no need to release them at once

## Never violate SemVer

## Offer an additional label to indicate generation
