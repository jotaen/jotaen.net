+++
draft = true
title = "What are microservices anyway?"
subtitle = "Or how to reason about distributed applications"
date = "2025-01-01"
tags = ["thoughts"]
image = "/posts/2025-01-01-microservices/circuit-board.jpg"
image_info = "Photo by Alexandre Debiève on Unsplash"
image_colouring = "210"
id = "ncP01"
url = "ncP01/distributed-applications-microservices"
aliases = ["ncP01"]
+++

There are thousands of articles and countless talks about the question whether monoliths or microservices are the superior approach to building modern applications nowadays, and I’ve seen seasoned software engineers struggling to reason about this question. I can very much relate to that, not because I wouldn’t have anything to say about that topic, but more so because I don’t agree with the premise of that question in the first place. I firmly believe that a considerable source of uncertainty stems from the fact that we are often using inaccurate terminology in our discussions and that our picture gets distorted by the misleading expectations that our language creates. Dispelling that fallacy and setting a more well-reasoned basis are the subjects of this essay.

So, what is *your* stance on the “monolith vs. microservice” question? What architectural approach would *you* choose for a greenfield project today? Would you go monoliths, like in the old days, or would you be modern and build microservices? The answer “it depends” is certainly legitimate, because these questions are indeed hard to answer in general. On the other hand, however, it’s also clear that they must eventually be decided at some point throughout a project, so we cannot evade this topic forever. As with everything in engineering, things should be there for a reason. We will come back to that thought in a minute, but we need to talk about some terminology beforehand.

# The traits of application architecture

For the sake of this blog post, let’s define a *system* as a unit of directly connected components that are dependend on each other in order to fulfil a certain responsibility. For example, a web server that is wired to a database would be a system, because they only have value for an application when acting together.

That being said, it’s easy to agree on the definition of a monolithic application, where the entire functionality is bundled in one single system. Things start to get harder for the term “microservices”, though. While it’s obvious that a microservice architecture is the composition of multiple independent systems, the prefix “micro” is anything but meaningful. In the picture below you see diagrams of three different application architectures: a monolith on the left, microservices in the middle – but how do we call the diagram on the right? A hybrid? A microservice-flavoured monolith?

![Three architecture diagrams: 1) a singular big system; 2) a multitude of small systems; 3) a mixture of differently sized systems]()

It wouldn’t lead anywhere to lose ourselves in philosophical debates here or to try to come up with expressive names for what we see. This is for a simple reason: because it is not important. The notable difference that these three diagrams show is that applications can consist of systems of different cardinality and different size. Whether those are few and large, numerous and small, or something arbitrary in between, is not of primary interest. The terms “monolith” and “microservices” only represent two extremes in a wide range of possible configurations. And there is no reason to limit our thinking to these two invariants only for the lack of additional names.


# Factors of distributed applications

Especially for greenfield projects it’s all too easy to fall for the alluring promises of microservices and setting up a wildly distributed application “just because everyone does that nowadays”. That, however, might turn out to be immensly tricky and time-consuming to deal with. On the other hand, established applications also must be continuously adopted to ever changing circumstances. Stoically sticking with a veteran monolith in the naive hope to avoid “all those problems of going distributed” can turn into an equally burdensome nightmare after all.

It is a common misconception to put the cart before the horse and to settle on an architectural design without having actual and well-founded reasoning. The impact of underrating or neglecting that can grow far beyond the scope of the engineering department and might even have a sustainably drastic effect on the business as a whole. Therefore it is important to make properly motivated and responsible decisions when it comes to application architecture.

While cardinality and the size of components are often at the forefront of our thinking, they are technically just specific parameters of distributed systems in general. In the end, the application as a whole must meet technical and functional requirements and that is where we should put our focus on. Whether we end up having a monolith, microservices, or something in between, is nothing but a mere by-product of that rationale. I want to outline some of the key influential factors for designing distributed applications hereafter.

### Scalability
A system can only scale as a whole.

### Contributors
The number of contributors of a service is naturally limited.

### Operations
Every service needs to be maintained, deployed and monitored.

### Cohesion

### Interdependency

### Technological diversity

### Overall Complexity


# Conclusion

The aforementioned aspects are what matters when assessing the architectural quality of an application, regardless of whether it’s distributed or not: Does it scale well and efficiently? How confident do collaborators feel when working on it? What effort does it take to roll out changes and how safe is that? Is the interplay of components smooth and reliable? The answers to these questions are much more important than the eventual number of services that an application consists of. What does it help if it takes you a day to make a trivial change, only because you have an entangled armada of highly coupled microservices? Well, it’s not much better anyway if you can’t effectively regulate your system’s performance, just because it is one gigantic and intractable blob of code.

The merits of distributed applications are a hardly deniable reality, but the concrete implementation is still highly individual to the use case and the requirements of a particular application. But whatever the case may be, good decisions are always based on well-founded reasoning and not on current trends or generic recommendations.
