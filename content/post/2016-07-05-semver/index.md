+++
type = "post"
title = "Semantic versioning"
subtitle = "Communicate compatibility to API consumers"
date = "2016-07-05"
tags = ["semver", "release management"]
image = "/assets/2016/banksy-girl-with-balloon.jpg"
id = "s0SRs"
url = "s0SRs/semantic-versioning"
aliases = ["s0SRs"]
+++

A common approach to versioning APIs[^1] is to indicate the progression of an API via the version number: A significant improvement or an effortful rewrite of the code would result in a new major version (e.g. from 1.3 to 2.0), whereas small changes or minor fixes only would entail the incrementation of a decimal place. The advantage of this is that the version number reflects the generation of an API. (Of course, this must be handled consistently across all releases.) On the downside, this kind of version management is a bit arbitrary, since everybody will treat it differently.

Semantic versioning (short: SemVer) was born out of a different motivation. Its focus lies on handling and managing project dependencies. That said, SemVer is not a measurement for the size or the significance of a changeset. It makes an assertion about the compatibility of the public interface:

> [^2]The way in which the version number is incremented after this release is dependent on this public API and how it changes. This API could be declared in the code itself or exist strictly in documentation.

When a programmer implements an external API into his own application, then there is an intersection between application code and API code. This is what SemVer focuses on: version numbers are nothing else than a way of communicating how an API transforms and what that means for API consumers.

## Structure

A SemVer version number is made up of several parts. It must start with three numbers, which are separated by dots. These three parts are called MAJOR, MINOR and PATCH. A typical version number could look like this: `4.1.0` or `9.13.4`[^3]. The principal part may be followed by two optional suffixes for additional information.

### MAJOR

You must increment the MAJOR version when you make incompatible API changes. From the viewpoint of an API consumer, when she sees a MAJOR upgrade, she must learn about the changes in order to know whether her own code needs to be modified.

### MINOR

You must bump the MINOR version when you add functionality in a backwards-compatible manner, without affecting the behaviour of the previously existing API. From the viewpoint of an API consumer, he must be able to accept a MINOR update without any concerns regarding his own code. He may have a look at the changelog to learn about new features.

### PATCH

You must increment the PATCH version when you make backwards-compatible bug fixes. Although the SemVer specification only refers to bug fixes, it makes sence to stretch the definition so it also covers internal modifications that do not affect the external behaviour of the API. (Otherwise you would have to bump the MINOR or MAJOR version after an internal refactoring, which wouldn’t make much sense.) From the viewpoint of an API consumer, she must be able to fetch a PATCH update unworriedly and only needs to check the changelog when she had stumbled across bugs.

### Pre-release

A pre-release version may optionally be denoted by appending a hyphen and a series of dot separated identifiers, like: `3.4.1-alpha.2.3`

### Build metadata

Build metadata may optionally be denoted by appending a plus sign and a series of dot separated identifiers `19.14.0+a7c8270001f7ce` or `1.2.19-beta+2016.09.01`

## Examples

Here are some examples of how SemVer works in practice:

- You fix a bug in the input validation of your API, which was specified to only accept valid email addresses as parameter. However, the validation mechanism turned out to be faulty, because it didn’t reject some invalid addresses. You apply a fix and file a **PATCH** release (e.g. from `2.5.4` to `2.5.5`)
- You apply a refactoring to a recursion, so that its performance or memory consumption gets slightly improved. This is just an internal modification and doesn’t change the behaviour of the API, so it is a **PATCH**. If your old API was `1.0.0`, your new release would have to be versioned `1.0.1`
- Your API is in version `2.14.3` and you add 20 new functions without touching anything existing. You need to bump the **MINOR** version so your API is `2.15.0` hereafter.
- You introduce a new exception type in one function. Although this seems like an addition at first glance, it actually is a breaking change, because all consumers need to change their code in order to catch this new exception. If your API was `6.5.1` before, you must bump **MAJOR** to `7.0.0`

# Best practices

## Clearly define your API

> Software using Semantic Versioning MUST declare a public API.
>
> This API could be declared in the code itself or exist strictly in documentation. However it is done, it should be precise and comprehensive.
>
> *(SemVer 2.0.0, section 1)*

Chances are that most people do not even look in the source code of your library for a single time. Most people rather like to read the specification when using your API, since it is better to understand and easier to work with.

Without the API being specified, you can get into trouble when handling bugs. A bug is a defect that results in undesired behaviour. However, if you do not clearly specify what users can expect from the API, it can be difficult to determine the actual behaviour as correct or incorrect. In doubt, you would need to release a new MAJOR version, because maybe there are clients which rely on the faulty behaviour unknowingly.

If you provide an API specification as the single source of truth for your API, a bug is just behaviour that is not in accordance.

## Provide a CHANGELOG

The users of your API are humans. It is pointless to indicate a breaking change or the introduction of a new feature without providing understandable information on it. The best solution is to maintain[^4] a CHANGELOG file, in which all relevant changes are documented in a brief, informative and human readable way. If you omit this, you place a burden on all developers, who will have a hard time to track down the modifications in order to understand, whether or how they need to change their own source code.

## Start with 1.0.0 when you go public

A bad practice often observed are public libraries with 0.x.y versions. In SemVer, a 0.x.y version means that the API is under development and not intended to be used in production. Despite, there are tons of widely used packages out there that languish at version 0-point-something. This is absurd all the more in case the package is small in scope and well tested.

In SemVer you must liberate from the notion that a 1.0.0 release has to be perfect, impeccable and flawless. Instead, it just means you start to use SemVer. This is a sublime thing you should aim for, since only now you can turn all its benefits to advantage. Versions below 1.0.0 are purely arbitrary. Either, the maintainer of a package is unsure about the API and wants to leave all doors open, or she even decided to not be subject to SemVer at all.

## Never revert releases

Consider releases to be irrevertable. Even if you break SemVer (e.g. by introducing a breaking change with a PATCH release), you should not modify that faulty release. The SemVer spec offers some [further details on that question](http://semver.org/spec/v2.0.0.html#what-do-i-do-if-i-accidentally-release-a-backwards-incompatible-change-as-a-minor-version).

## Plan your releases ahead

Especially when you maintain an open source project as a sideline, you likely do not have the time to permanently work on it. Perhaps, you find some spare time on a Sunday afternoon, work through a bunch of issues and publish a release by the evening. It may be tempting to pack the entire changeset into a single release in order to file it away. However, your API consumers are graceful if you portion all the changes considerately into single releases. For you as the API maintainer there may be no difference between a MAJOR and PATCH release – in contrast to the consumers. As I explained above, different release categories have different meanings for them: A PATCH update can be fetched without needing to check the changelog, whereas a MAJOR release may result in additional work.

So, instead of bundling one big release e.g. from `9.7.8` to `10.0.0`, try to find a way to offer at least one intermediate release – e.g. you first release a bugfix (`9.7.9`), then you add new stuff (`9.8.0`) and finally you introduce some breaking changes (`10.0.0`).

## Make use of deprecation

Breaking changes are always difficult to handle. They must be clearly communicated and even if they are small in scope, they can result in a lot of (unscheduled) work on the client side. From the second you release a breaking change, affected consumers are forced to address this change in the near term, as they would be cut off from any further releases otherwise.

In order to avoid that, it is a good practice to announce upcoming breaking changes by making use of deprecation. A deprecation can be a fully self-contained MINOR release. That way, consumers have the chance to plan the migration ahead.

As a side benefit, you can avoid inflationary bumping of the MAJOR version when you “gather” deprecations over a period of time and eventually remove a whole bunch of functionality in one go.

## Consider additional labels to indicate generation

A common point of criticism is that SemVer doesn’t give any information about the generation of an API. If you add 120 new functions to your API, this would still be a MINOR release. However, a single extra line of breaking code would force the release to be MAJOR.

As I mentioned above, SemVer doesn’t want to convey this information by design. It’s sole purpose is to give indication about compatibility. There are several ideas on how to extend SemVer by this aspect, e.g. [by introducing a fourth number](https://github.com/mojombo/semver/issues/213). Personally, I don’t think that this proposal adds any value to the idea of SemVer. I would rather go with the [thoughts of Eric Elliot](https://medium.com/javascript-scene/software-versions-are-broken-3d2dc0da0783) and offer additional release names for marketing purpose.


[^1]: “API” denotes the public interface of an application: This can refer to a programming library/package just as to the specification of a RESTful microservice.
[^2]: Read the specification of [SemVer 2.0.0](http://semver.org/spec/v2.0.0.html)
[^3]: As you see, the numbers increase numerically, e.g. from 1.9.0 to 1.10.0
[^4]: It’s best to progressively add information to the CHANGELOG while developing (i.e. on each merge into the master branch)
