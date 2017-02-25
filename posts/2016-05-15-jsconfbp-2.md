---
layout:        blogpost
title:         JavaScript city tour (2/2)
subtitle:      Second day of the JSConf Budapest, May 2016
date:          2016-05-15
tags:          [conference, javascript]
redirect_from: /lxrmc/
permalink:     lxrmc/jsconf-budapest-2016-part2
image:         /assets/2016/budapest-skyline.jpg
---

These are my notes on the second day of the [JSConf in Budapest](http://jsconfbp.com/)[^1], which  took place at May 12th and 13th in the Akvarium Klub in the heart of city.

By the way: I took the image above at Friday afternoon after the conference. If you like it, you can [download it in full resolution](/assets/2016/budapest-skyline-full.jpg). It’s public domain! (Sorry for low quality though, I took it with my phone.)

## “Building an Offline Page for theguardian.com”

Oliver Joseph Ash pointed out how important it is to provide a good offline experience for a website. It can not be taken as prerequisite, that everyone has a Wifi connection – and even if so, it may be instable and slow. For the website of the newspaper The Guardian he uses Service Workers, which are hooked into requests and can for example cache results. It is not the goal to achieve a perfect clone of the online version of the webpage, instead it would be just a good start to offer an offline version *at all*.

## “High Performance in the Critical Rendering Path”

Performance is not a mere nice-to-have – we already learned this lesson yesterday. Nicolás Bevacqua encouraged us to measure web performance fast and often and provided the following suitable techniques to us:

- Minify, compress and concatenate assets
- Make use of the `Expires` header (you can achieve long TTLs by tokenizing the assets)
- Deliver the things above the fold fast, and the things below the fold async
- Render most of the things server-side and cache the results, whereever possible

## “Offensive and Defensive Strategie for Client-Side JavaScript”

Anand Vemuri showed how the security of web applications and public services can be improved:

- CSRF tokens ensure, that requests come from “official” clients. However, they are not that trivial as they look like, so they have to be implemented thoroughly.
- The `Access-Control-Allow-Origin` headers also counteract CSRF attacks.
- It’s a good advice to use GET requests for read requests only. Offering a `X-HTTP-Method-Override` header (or a query parameter `method`) for GET can be a security hole.

## “Science in the Browser: Orchestrating and Visualising Neural Networks”

Interesting project by Rob Kerr, who is neuro-biologist and uses web technologies in his dissertation. Since data visualisation and manipulation is cheap and easy, JavaScript and CSS play a more and more important role in science.

## “Down the Rabbit Hole: JS in Wonderland”

Fun talk by Claudia Hernández, who demonstrated the traps of the JavaScript language design. Here are some of them:

- `NaN === NaN` results `false`, since `NaN` doesn’t equal anything (be specification). The `isNaN()` function comes to the rescue.
- There is a way of writing JavaScript [without using any alphanumeric characters](http://patriciopalladino.com/blog/2012/08/09/non-alphanumeric-javascript.html). This is not only unreadable, but it can be also used for security exploits.

## “Works On My Machine; or: the Problem is between Keyboard and Chair”

Outstanding keynote by Lena Reinhardt, although (or because) the word JavaScript wasn’t mentioned a single time. It cannot be overseen, that we have a diversity problem in the tech industry: Most of the people, which work as software engineers, are white, able, cis and priviledged men. They earn good money and have enough spare time to work on side project or attend conferences for instances. However, this doesn’t mirror the average of the population, since many other groups are underrepresented.

Lena Reinhardt looked for a good way to deal with this situation: But there is no masterplan to follow and no adjusting screw to turn. Although most of us are not “hit” by the lack of diversity (since most of us are white, priviledged males), we all have to face up to this problem and to do our bit to create a collective consciousness for this topic.


[^1]: Disclaimer: This summary is far away from complete and reflect a highly opinionated perception.
