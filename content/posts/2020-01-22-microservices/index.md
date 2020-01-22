+++
draft = true
title = "What are microservices anyway?"
subtitle = "Sane ways to reason about applications architecture"
date = "2020-01-22"
tags = ["thoughts"]
image = "/posts/2020-01-22-microservices/server-rack.jpg"
image_info = "Photo by Taylor Vick on Unsplash"
image_colouring = "330"
id = "ncP01"
url = "ncP01/distributed-applications-microservices"
aliases = ["ncP01"]
+++

There are thousands of articles and countless talks about the question whether monoliths or microservices are the superior approach to building modern applications nowadays, and I’ve seen seasoned software engineers struggling to reason about this question. I can very much relate to that – not because I wouldn’t have anything to say about that topic, but more so because I don’t agree with the premise of that particular question in the first place. I firmly believe that a considerable source of uncertainty stems from the fact that we are using misleading terminology and that there often is too little focus on well-founded reasoning. Clearing up that fallacy is the subject of this essay.

So, what is *your* stance on the “monolith vs. microservice” question? What architectural approach would *you* choose for a greenfield project today? Would you go with old-fashioned monoliths or would you build modern microservices? The answer “it depends” is certainly legitimate, because these questions are indeed hard to answer in general. On the other hand, however, it’s also clear that they must eventually be decided at some point throughout a project, so we cannot evade this topic forever. As with everything in engineering, things should be there for a reason. We will come back to that thought in a minute, but we need to talk about some terminology beforehand.

# The traits of application architecture

For the sake of this blog post, let’s define a *system* as a unit of directly connected components that are dependent on each other in order to fulfil a certain responsibility. For example, a web server that is wired to a database would be a system, because in the context of an application they only have value when acting together. An *application* is consequently the entirety of systems that is needed to solve the use case of a business.

That being said, it’s easy to agree on the definition of a monolithic application, where the entire functionality is bundled in one single system. Things start to get harder for the term “microservices”, though. While it’s obvious that a microservice architecture is the composition of multiple distinct systems, the prefix “micro” is anything but meaningful, because it lacks a precise definition. Is it lines of code that matter? Or the number of endpoints? And how would we call an architecture that consists of multiple systems, a bigger core service and multiple additional smaller ones? Is that still microservices? Or a hybrid? A microservice-flavoured monolith?

It wouldn’t lead anywhere to lose ourselves in philosophical debates here or to try to come up with expressive names. This is for one simple reason: because it is not important. All we need to agree on for now is that applications can be composed of systems of different cardinality and different size. Whether those are few and large, numerous and small, or something arbitrary in between, is not of primary interest. The terms “monolith” and “microservices” only represent two extremes in a wide range of possible configurations. And there is no reason to limit our thinking to these two architectural invariants only for the lack of other names.

# Factors of distributed applications

It is a common misconception to put the cart before the horse and to settle on an architectural design without motivating it by actual demands. After all, the impact of underrating or neglecting that can grow far beyond the scope of the engineering department and might even have a sustainably drastic effect on the business as a whole.

Especially for greenfield projects it’s all too easy to fall for the alluring promises of microservices and setting up a wildly distributed application “just because everyone does that nowadays”. That, however, might turn out to be immensly tricky and time-consuming to deal with. On the other hand, established applications also must be continuously adopted to ever changing circumstances. Stoically sticking with a veteran monolith in the naive hope to avoid “all those problems of going distributed” can turn into an equally burdensome nightmare after all.

While the number and size of systems are often at the forefront of our thinking, they are generally just parameters in the overall architecture. In the end, the application as a whole must meet technical and functional requirements and that is where we should put our focus on. The key question consequently is what the *reasoning* is behind the design of our system(s). Whether we end up having a monolith, microservices, or something in between, is nothing but a by-product of that rationale.

The following points outline aspects we might need to factor in and balance out when designing the system structure in regards to size and number.

### Scalability
One system always scales as a whole. When different parts of the system have different performance demands, scaling can become tricky and inefficient. By splitting up responsibilities into distinct systems, each of them can be regulated independently.

### Contributors
The number of contributors to one system has natural bounds[^1]. The more people work on it, the harder it is to coordinate them and to ensure consistency and conceptual integrity. Dividing systems too early, on the other hand, can have the exact opposite effect and introduce a considerable amount of unnecessary friction.

### Cohesion
...
Only because an application is split up into multiple systems (e.g. microservices) doesn’t necessarily mean that the individual systems are truly independent. In the worst case the interdependencies are as high as in a monolithic application. (That is sometimes called a “distributed monolith”.)

### Technological diversity
One system is based on a particular technological stack. A web server, for instance, is usually written in one particular programming language and data normally resides in one database. The motivations for wanting to diversify technologies can be manifold and multi-system applications allow for that, because its systems communicate via agnostic interfaces (e.g. protocols like HTTP or AMQP).

### Infrastructure
Every system needs to be maintained, deployed and monitored. The probably biggest investment that needs to be done when splitting up a monolithic application into a distributed one is to decouple operational concerns in order to keep the overhead low and trade on synergy effects. That might, for example, be setting up a central logging facility or providing reusable deploy mechanisms.

# Conclusion

The aforementioned considerations are what should drive our application architecture. In order to assess the state and quality of its systems we should ask questions like: Do they scale well and efficiently? How confident do collaborators feel when working on them? What effort does it take to roll out changes and how safe is that? Is the interplay of systems smooth and reliable? The reasoning behind these answers are much more important than the eventual number of systems that an application consists of. What does it help if it takes you a day to make a trivial change, only because you have an entangled armada of highly coupled microservices? Well, it’s not much better at least if you can’t effectively regulate your applications’s performance, just because it is one gigantic and intractable blob of code.

To sum it up: the merits of distributed applications are a hardly deniable reality, but the concrete implementation is still highly individual to the use case and the requirements of a particular application. But whatever the case may be, good architecture is always based on well-founded reasoning and not on current trends or generic recommendations.


[^1]: According to [Conway’s Law](https://en.wikipedia.org/wiki/Conway%27s_law), there is at least a strong interdependency
