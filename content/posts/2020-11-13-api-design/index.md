+++
title = "The Design of Everyday Code"
subtitle = "Two golden principles for building great APIs"
date = "2020-11-13"
tags = ["thoughts", "coding"]
image = "/posts/2020-11-13-api-design/design-of-everyday-things.jpg"
image_colouring = "190"
id = "eYPPs"
url = "eYPPs/two-golden-principles-of-great-api-design"
aliases = ["eYPPs"]
+++

I had a “Don Norman”-moment just the other day: I went to visit a friend who lives in an apartment building downtown. The building is fairly new and its main entrance is equipped with a digital intercom system. Unlike the old days, where doorbells used to be lined up individually, this building has one small panel that only consists of a display and three buttons (two arrow buttons and a ring button). When you want to visit someone, you have to activate the display (by clicking a random button), then scroll through the list of all residents’ names (sorted alphabetically, appearing one at a time), and finally hit the ring button. As far as my friend is concerned that’s a swift and delightful 12-step procedure.

These and other kinds of usability nuisances are subject of Don Norman’s legendary book “The Design of Everyday Things”. It’s about the interactive objects that we deal with on a daily basis: door handles, tools, light switches, control panels, children’s toys, or an absurd (but fictional) coffeepot which you see on [the cover](/posts/2020-11-13-api-design/design-of-everyday-things.jpg). The book revolves around the usage patterns and design traits that make for comprehensible and pleasant user interfaces. Originally published in 1988, the current edition also contains some examples from the digital era.

You might wonder how the topic of user interface design is relevant for software developers, especially when they are not engaged with building frontends. But in fact, software developers are routinely involved with user interfaces every day – and that both as their creators and as their consumers. (The “I” in API stands for *interface* after all.) When it comes to usability, how are classes and methods that are exposed by a programming module different from the physical tools in your toolbox? Isn’t using a CLI application conceptually the same as operating your washing machine at home? And I bet you know that kind of situation, where you setup some system, and you go by the book and configure it to the best of your knowledge, but it would just fail to run, over and over again, only presenting you a vague error message, that leaves you clueless, puzzled, and – most of all – raging in furious anger.

The answer to all this is downright simple: there is no difference between the interfaces in real-life (the “everyday things”) and the interfaces whose nature is merely programmatic. In other words: it doesn’t matter whether you are putting together buttons and handles or symbols and characters – in the end, another human being is using what you designed in order to accomplish something.[^1] And hence, a lot of insight can be derived from the usability aspects of “things”, because a great deal of its mechanics can be applied when we design our code. With that in mind, I recommend you have a look at your go-to libraries or your all-time favourite CLI tools and ask yourself: what is it that makes you love using them?


# Two golden rules for building great APIs

Before I reason about my take on this question, I want to make two upfront remarks. The first is about terminology, just so we are aligned on language: an *API* can be any programmatic interface, for example that of a code library or web service. The *creator* is the developer who is in charge of designing and building the API, whereas the *consumer* is the developer who utilises it within a specific context. Secondly, the target audience of this blog post is not exclusively the creators of standalone APIs, such as external libraries or commercial services. On the contrary: most APIs get written for internal purpose throughout the development process of an application and never get to live a life on their own.

## 1. Put yourself at the service of the consumers

The basic definition of an API is that it offers access to a certain bundle of functionalities and allows it to be (re-)used in different contexts. For an API to be *great* it’s not enough to only satisfy functional requirements though. An equal amount of care should be devoted to the human needs of the consumers who eventually have to understand and integrate against it. The means to achieve that are probably not much of a novel revelation, yet all the harder they sometimes are to put into practice.

- A sensible structure, especially on the high level, is a vital factor for discoverability. In the best case a consumer finds their way around without even having to consult the documentation.
- Thoughtful and consistent naming gives meaning to functionalities and makes domain concepts easier to grasp. The practice of domain-driven design provides a good basic approach in that respect.
- Failure states are sufficiently descriptive in order to ease the process of debugging. A prominent example is the compiler of the Elm programming language that came to attention for its extremely sophisticated error messages.
- While there should be one canonical way of doing things “right”, standard use cases should nevertheless be taken into account for practical reasons. For instance, an API can offer a separate set of utilities that build on top of its core to make common procedures more convenient.
- The structure of the documentation takes the needs of different target groups into consideration. Someone unfamiliar might be interested in learning the fundamentals or how to get started, whereas a power user might want to read up on the specification of a certain parameter.

All in all, one could describe a great API to be convenient in the physical sense of feeling practical, ergonomic or handy. The consuming developers intuitively perceive that the API was build with the aim of being useful and providing service to them. (And that is to the developers, not to their application.)

## 2. Leverage the constraints of the language to represent the constraints of your models

Good design goes beyond merely making something happen. The most tricky challenge is to construct the outward structure in a way that only those pieces can be combined which are actually meant to fit together. Ideally, the design only allows valid states and legal operations to be represented. In more abstract terms one could say that the goal is to maximise the congruence of constraints (namely those of the models with those of the language).

- Model data structures and control flows in a way that intrinsic rules of the program is reflected and enforced by technical patterns[^2] or language constructs.
- Favour custom data structures over general-purpose types in order to incorporate constraints directly. (Most likely, the former will use the latter internally, but that can remain an implementation detail.)
- Consider immutable data structures to be the default rather than the exception.
- Enforce constraints on creation instead of on usage. That allows constraint violation to be uncovered early on.

Total congruence of constraints is not achievable in most cases, especially not when using general-purpose programming languages. A careful design, however, can come quite close and makes a significant difference in practice. It contributes to making a program safer and is also an important factor for the subjective level of confidence for consumers.


# The API mindset

One criterion commonly associated with user experience is *ease of use*. That is certainly appropriate in the sense that things shouldn’t be more complicated than they need to be. Ease of use, however, is not an end in itself. In some cases complexity is inherent and cannot be simplified down to a seemingly tidy facade. Trying to do that anyway results in a so-called “leaky abstraction”, which means that the underlying complexity shines through and that the promises of the exposed models are subject to implicit conditions. Albeit undesired, leaky abstractions are hard (and sometimes impossible) to avoid and a careful balancing act is required to make a good trade-off between convenience and correctness.

Great APIs do not just contribute to making software developers feel more happy, confident or productive. Viewing it from a higher-level perspective, one could say that they also have an overall economic impact. In extreme cases the number of consumers might be orders of magnitude larger than the number of its creators. I want to call this the “1:n”-effect. Say, 50 developers stumbled across the same point of friction and it took them 5 minutes to deal with it on average, then this would justify 4 hours worth of time for the creator to sit down and sort out that rough edge. This is a highly philosophical consideration of course, but it demonstrates how disproportional the value of time on both respective sides is.

In the end, I think that the key to building great APIs is largely a matter of awareness and habit. Even if you are working on internal APIs most of the time it pays off to be thorough about their design and structure. This ethos is not at all special for the field of software development by the way: craftsmen for instance routinely consider non-functional aspects like labour efficiency, safety and workplace ergonomics when building their own tools and appliances. You don’t have to go overboard with your efforts. Try to put yourself into the shoes of the consumers when you create an API – regardless of whether it’s for the public, your colleagues or just for your future self.


[^1]: In tech, this idea is sometimes referred to as “developer experience” (or short: “DX”)

[^2]: An inspiration for various code patterns can be drawn from the Gang-of-Four book, for example
