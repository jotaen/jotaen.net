+++
title = "JavaScript city tour (1/2)"
subtitle = "First day of the JSConf Budapest, May 2016"
date = "2016-05-12"
tags = ["conference", "javascript"]
image = "/posts/2016-05-12-jsconfbp-1/budapest.jpg"
id = "AyHtk"
url = "AyHtk/jsconf-budapest-2016-part1"
aliases = ["AyHtk"]
+++

These are my notes on the first day of the [JSConf in Budapest](http://jsconfbp.com/)[^1], which  took place at May 12th and 13th in the Akvarium Klub in the heart of city.

## “What everybody should know about npm”

Laurie Voss (from npm Inc.) highlighted, that npm is more than just a simple manager for JavaScript packages. For instance, you can enhance your productivity with these 3 weird old tricks:

- Store your configuration in the `config` section of `packages.json`. It will be available as environment variable in the process.
- Safely rerun `npm init` everytime and it will cleanup your packages.json. Speaking of which: Don’t edit your packages.json by hand; npm does a better job in doing so.
- Keep your npm dependencies up to date with [Greenkeeper](https://greenkeeper.io/). It fully automates the update process: the only thing you need to do is accepting the pull request.

## “The Hitchhiker’s Guide to All Things Memory in JS”

Safia Abdalla refreshed the basics concerning memory management and garbage collection in JavaScript. In practice, when you want to analyze and optimize the memory consumption of your JavaScript apps, you need to choose the right tools depending on the platform your are working on:

- Use the [heapdump package](https://www.npmjs.com/package/heapdump) for debugging in the V8
- Use the Chrome DevTools (available under “Profiles”) for browser applications

## “Encrypt the Web For $0”

The talk of Yan Zhu basically came down to these advices:

- Start using HTTP/2. Most current browsers support it and it offers major improvements over HTTP/1.x (e.g. it is fully multiplexed and can use one single connection for parallelism).
- Start using encryption: even big players like Netflix do so by this time. With [“Let’s encrypt”](https://letsencrypt.org/) it cannot be simpler to setup secure HTTP connections.

## “Why Performance matters”

When the performance of your website suck, so do your conversions. That’s no platitude, but it’s proven by several studies from big companies. However, it is important to understand that performance is not all about bare numbers and measurement parameters – instead, it has to do a lot with perception.[^2] Denys Mishunov shared the following tips:

- Show meaningful content to the user as quickly as possible
- Make smart assumptions about the userflow and try to preload resources

## “Event-Sourcing your React-Flux applications”

Maurice De Beijer carried over the ideas of Flux from the frontend into the backend. By using the Command Query Responsibility Segregation (CQRS) pattern, the backend architecture gets split up into two parts:

- an event container receives commands and holds the complete history of actions
- a queryable datastore stores the currently effective state of the data

That way, backend state gets replicable and therefore more robust. Also, this approach does complement pretty well with React and Redux in the frontend.

## “Internet of Cats”

Rachel White demonstrated how to bring back the fun into programming. Main ingredients: cluelessness, curiosity, self-conquest and a pathological obsession with cats. Main learning: Be nice to each other. That will make many things way more simple.

## “The Other Side of Empathy”

This talk was a suitable follow-up. Nick Hehr collects resources on understanding the importance of empathy in his blog [“The Other Side of Empathy”](http://more-empathy.online/). His theses from the talk:

- Developing technologies is about people, not about technology
- Only give feedback, when it is constructive
- Helpful feedback requires a time investment from the person who gives it

[^1]: Disclaimer: This summary is far away from complete and reflect a highly opinionated perception.
[^2]: The perception of performance is likely more important than the performance itself. Further reading on this [at the Apple developer documentation.](https://developer.apple.com/library/ios/documentation/Performance/Conceptual/PerformanceOverview/DevelopingForPerf/DevelopingForPerf.html)
