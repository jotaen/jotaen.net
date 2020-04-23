+++
title = "What are microservices anyway?"
subtitle = "Reasoning about application architecture"
date = "2020-02-18"
tags = ["thoughts"]
image = "/posts/2020-02-18-microservices/server-rack.jpg"
image_info = "Photo by Taylor Vick on Unsplash"
image_colouring = "40"
id = "ncP01"
url = "ncP01/distributed-application-architecture-microservices"
aliases = ["ncP01"]
+++

There are thousands of articles and countless talks about the question whether monoliths or microservices are the superior approach to building modern applications nowadays, and I’ve seen seasoned software engineers struggling to reason about this question. I can very much relate to that – not because I wouldn’t have anything to say about that topic, but more so because I don’t agree with the premise of that particular question in the first place. I firmly believe that a considerable source of uncertainty is 1) the fact that we are using misleading language and 2) that there often is too little focus on actual reasoning. Clearing up that fallacy is the subject of this essay.

So, what is *your* stance on the “monolith vs. microservice” question? What architectural approach would *you* choose for a greenfield project today? Would you go with (heads up: polemics!) old-fashioned monoliths or would you build modern microservices? The answer “it depends” is certainly legitimate, because these questions are indeed hard to answer in general. On the other hand, however, it’s also clear that they must eventually be decided at some point throughout a project, so we cannot evade this topic forever. As with everything in engineering, things should be there for a reason. We will come back to that realisation in a minute, but we need to straighten up some terminology beforehand.

# What are microservices anyway?

For the sake of this blog post, let’s define a *system* as a unit of directly connected components that are dependent on each other in order to fulfil a certain responsibility. For example, a web server that is wired to a database would be a system, because in the context of an application they only have value when acting together. An *application* is consequently the entirety of systems that is needed to solve the use case of a business.

That being said, it’s easy to agree on the definition of a monolithic application, where the entire functionality is bundled in one single system. Things start to get harder for the term “microservices”, though. While it’s obvious that a microservice architecture is the composition of multiple distinct systems, the prefix “micro” is anything but meaningful, because it lacks a precise definition. Is it lines of code that matter? Or the number of endpoints? And how would we call an architecture that consists of one bigger core service complemented by several smaller ones? Is that still microservices? Or a hybrid? A microservice-flavoured monolith?

It wouldn’t lead anywhere to lose ourselves in philosophical debates here or to try to come up with expressive names. This is for one major reason: because it is not important. All we need to agree on for now is that applications can be composed of systems of different cardinality and different size. Whether those are few and big, numerous and tiny, or have some other arbitrary peculiarity, is not of primary interest. The terms “monolith” and “microservices” represent two extremes in a wide range of possible configurations. It would be a misconception to limit our thinking to these two invariants only for the lack of other names.

# Don’t put the cart before the horse

Especially for greenfield projects it’s all too easy to fall for the alluring promises of microservices and setting up a wildly distributed application “just because everyone does that nowadays”. That might very well turn out to be immensly tricky and time-consuming to deal with. On the other hand, established applications must also be continuously adopted to ever changing circumstances. Stoically sticking with a veteran monolith in the naive hope to avoid “all those problems of going distributed” can turn into an equally burdensome nightmare after all.

The mistake is to settle on an architectural design without motivating it by actual demands. Neglecting that might not just cause some collateral damage, the impact can rather grow far beyond the scope of the engineering department and have severe effects on the business as a whole. It is the responsibility of software architects to be aware of that and to make careful and substantiated decisions.

While the number and size of systems are often at the forefront of our thinking, they are generally just parameters in the overall architecture. In the end, the application as a whole must meet functional, technical and collaborative requirements and that is where we should put our focus on. The key question therefore is what the *reasoning* behind the design of our system(s) is and how we suppose to reach our goals through it. Whether we end up having a monolith, microservices, or something in between, is nothing but a by-product of that rationale.

The following points outline various aspects to factor in and balance out when designing the system structure.

### Scalability
One system always scales as a whole. When different parts of the system have different performance demands, scaling can become tricky and inefficient. By splitting up responsibilities into distinct systems, each of them can be regulated independently. As an aside, the aspect of fine-granular scaling is often promoted disproportionally in the case of microservices.

### Contributors
The number of contributors to one system has natural bounds[^1]. The more people work on it, the harder it is to coordinate them and to ensure consistency and conceptual integrity. Dividing systems too early, on the other hand, can have the exact opposite effect and introduce a considerable amount of unnecessary friction. For large-scale companies, the collaborative aspect alone can be a major incentive in their architectural design.

### Cohesion
The effort to reconcile different responsibilities goes hand in hand with how close they are. It’s usually easy when components are accomodated in the same process, in contrast to them needing to be orchestrated across different data centers. Making the right cuts is a delicate endeavour, because every segregation automatically introduces systematic complexity. In the worst case, the interdependencies in a distributed system are still as high as in a monolithic application, while the additional complexity to integrate everything has grown beyond all proportion. (That is sometimes called a “distributed monolith”.)

### Technological diversity
Each system is based on a particular technological stack. A web server, for instance, is usually written in one particular programming language and data often resides in a single database. The motivations for wanting to diversify technologies can be manifold and distributed applications allow for implementing various systems in different technologies. (This is because communication is done via agnostic interfaces, e.g. protocols like HTTP or AMQP).

### Infrastructure
Every system needs to be maintained, deployed and monitored. The probably biggest investment that needs to be done when splitting up a monolithic application into a distributed one is to decouple operational concerns in order to keep the overhead low and to trade on synergy effects. That might, for example, be setting up a central logging facility, providing local environments for development, or building reusable deploy mechanisms.

# Restoring the reason

Considerations like the aforementioned are what should drive our architecture process. In order to assess the state and quality of an application and its systems we should ask questions like: Does it scale well and efficiently? How confident do collaborators feel when working on it? What effort does it take to roll out changes and how safe is that? Is the interplay of systems smooth and reliable? Have we picked the right technology for what we want to accomplish?

The reasoning behind these answers are much more important than the eventual number or size of systems that the application consists of. What does it help if it takes you a day to make a trivial change, only because you have an entangled armada of highly coupled microservices? Well, it’s not much better at least if you can’t effectively regulate your application’s performance, just because it is one gigantic and ponderous blob of code.

The merits of distributed applications are a hardly deniable reality, but the concrete implementation is still highly individual to the use case and the requirements of a particular application. But whatever the case may be, sustainable architecture is always based on well-founded reasoning and not on current trends, popular buzzwords or generic recommendations.


[^1]: According to [Conway’s Law](https://en.wikipedia.org/wiki/Conway%27s_law), there is at least a strong interdependency
