+++
title = "JavaScript city tour"
subtitle = "Two days of JSConf in Budapest (May 2016)"
date = "2016-05-15"
tags = ["off-topic"]
image = "budapest-skyline.jpg"
id = "lxrmc"
url = "lxrmc/jsconf-budapest-2016"
aliases = ["lxrmc"]
+++

These are some notes from two days of the [JSConf in Budapest](http://jsconfbp.com/)[^1], which took place at May 12th and 13th in the Akvarium Klub in the heart of city.

By the way: I took the image above at Friday afternoon after the conference. If you like it, you can [download it in full resolution](/posts/2016-05-15-jsconfbp/budapest-skyline.original.jpg). It’s public domain! (Sorry for low quality though, I took it with my phone.)

## “What everybody should know about npm”

Laurie Voss (from npm Inc.) highlighted, that npm is more than just a simple manager for JavaScript packages. For instance, you can enhance your productivity with these 3 weird old tricks:

- Store your configuration in the `config` section of `packages.json`. It will be available as environment variable in the process.
- Safely rerun `npm init` everytime and it will cleanup your packages.json. Speaking of which: Don’t edit your packages.json by hand; npm does a better job in doing so.
- Keep your npm dependencies up to date with [Greenkeeper](https://greenkeeper.io/). It fully automates the update process: the only thing you need to do is accepting the pull request.

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

## “The Other Side of Empathy”

Nick Hehr collects resources on understanding the importance of empathy in his blog [“The Other Side of Empathy”](http://more-empathy.online/). His theses from the talk:

- Developing technologies is about people, not about technology
- Only give feedback, when it is constructive
- Helpful feedback requires a time investment from the person who gives it

## “Building an Offline Page for theguardian.com”

Oliver Joseph Ash pointed out how important it is to provide a good offline experience for a website. It can not be taken as prerequisite, that everyone has a Wifi connection – and even if so, it may be instable and slow. For the website of the newspaper The Guardian he uses Service Workers, which are hooked into requests and can for example cache results. It is not the goal to achieve a perfect clone of the online version of the webpage, instead it would be just a good start to offer a basic offline version *at all*.

## “High Performance in the Critical Rendering Path”

Performance is not a mere nice-to-have – we already learned this lesson yesterday. Nicolás Bevacqua encouraged us to measure web performance fast and often and provided the following suitable techniques to us:

- Minify, compress and concatenate assets
- Make use of the `Expires` header (you can achieve long TTLs by tokenizing the assets)
- Deliver the things above the fold fast, and the things below the fold async
- Render most of the things server-side and cache the results, whereever possible

## “Works On My Machine; or: the Problem is between Keyboard and Chair”

Outstanding keynote by Lena Reinhardt, although (or because) the word JavaScript wasn’t mentioned a single time. It cannot be overlooked that we have a diversity problem in the tech industry: Most of the people, which work as software engineers, are white, able, cis and priviledged men. They earn good money and have enough spare time to work on side project or attend conferences for instances. However, this doesn’t mirror the average of the population, since many other groups are underrepresented.

Lena Reinhardt looked for a good way to deal with this situation: But there is no masterplan to follow and no adjusting screw to turn. Although most of us might not be “hit” by the lack of diversity, we all have to face up to this problem and contribute our bit to create a collective consciousness for this topic.


[^1]: Disclaimer: This summary is far away from complete and reflect a highly opinionated perception.
[^2]: The perception of performance is likely more important than the performance itself. Further reading on this [at the Apple developer documentation.](https://developer.apple.com/library/ios/documentation/Performance/Conceptual/PerformanceOverview/DevelopingForPerf/DevelopingForPerf.html)
