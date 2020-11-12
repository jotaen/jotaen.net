+++
title = "The Design of Everyday Code"
subtitle = "Three golden principles for building great APIs"
date = "2222-02-02"
tags = ["thoughts", "coding"]
image = "/posts/2222-02-02-api-design/design-of-everyday-things.jpg"
image_colouring = "190"
id = "eYPPs"
url = "eYPPs/3-golden-principles-of-api-design"
aliases = ["eYPPs"]
+++

I had a “Don Norman”-moment just the other day: I went to visit a friend who lives in an apartment downtown. The building is fairly new and its main entrance is equipped with a digital intercom system. Unlike the old days, where doorbells used to be lined up individually, this building has one small panel that only consists of a display and three buttons (two arrow buttons and a ring button). When you want to visit someone, you have to activate the display (by clicking a random button), then scroll through the list of all residents’ names (sorted alphabetically, appearing one at a time), and finally hit the ring button. As far as my friend is concerned that’s a swift and delightful 12-step procedure.

These and other kinds of usability nuisances are subject of Don Norman’s legendary book “The Design of Everyday Things”. It’s about the interactive objects that we deal with on a daily basis: door handles, tools, light switches, control panels, children’s toys, or an absurd (but fictional) coffeepot, which you see on [the cover](/posts/2222-02-02-api-design/design-of-everyday-things.jpg). The book revolves around the usage patterns and design traits that make for comprehensible and pleasant user interfaces. Originally published in 1988, the current edition also contains some examples from the digital era.

You might wonder how the topic of user interface design is relevant for software developers, especially when they are not engaged with building frontends. But in fact, software developers are routinely involved with user interfaces every day – and that both as their creators and as their consumers. (The “I” in API stands for *interface* after all.) When it comes to usability, how are classes and methods that are exposed by a programming library different from the physical tools in your toolbox? Isn’t using a CLI application conceptually the same as operating your washing machine at home? And I bet you know that kind of situation, where you are about to setup some system, and you go by the book and configure it to the best of your knowledge, but it would just fail to run, over and over again, presenting you a vague error message, which leaves you clueless, puzzled, and – most of all – raging in furious anger.

The answer to all this is downright simple: there is no difference between the interfaces in real-life (the “everyday things”) and the interfaces whose nature is merely programmatic. In other words: it doesn’t matter whether you are putting together knobs and handles or symbols and characters – in the end, another human being is using what you designed in order to accomplish something.[^1] And hence, there is a lot of insight to be derived from the usability aspects of “things”, because a great deal of its mechanics can be applied when we design our code. With that in mind, I recommend you have a look at your “goto” programming libraries or your all-time favourite CLI tools and ask yourself: what is it that makes you love using them? My take on that question is the following three principles.

## 1. Put yourself into the service of your consumers

The basic definition of an API is that it offers access to a certain set of functionalities and allows them to be (re-)used in different contexts. A *great* API, however, does not content itself with satisfying merely functional requirements. It attributes the same amount of importance to the software developer, who needs to understand, integrate and debug it.

- Structure/organisation: discoverability
- Transparency of functionality
- Sufficient documentation
- Thoughtful naming
- Descriptive failure states
- Account for standard use cases

One could say that a great API is *convenient*, in the physical sense of feeling practical, ergonomic or handy to the software developer who uses it.

## 2. Leverage the constraints of the language to represent the constraints of your models
- Congruent constraints
- Make illegal states unrepresentable (as good as the language constructs allows for)
- Allow for fine-granular / independent failure

## 3. Create abstractions that make sense on their own
- Meaningful but most of all self-contained mental models
- Be general-purpose enough in order to allow reusage


# Practical considerations

Note that we haven’t talked about the actual libraries, services and tools themselves here but only about their surface structure.[^2] I have presumed that the API works in the sense that the underlying functionality is correct, reliable and somewhat efficient. That is the baseline anyway – similarly, it wouldn’t make much sense to muse about the asthetics of a building when its fundamental structure is in acute danger of collapsing.

One criterion commonly associated with usability is *ease of use*. That is certainly appropriate in the way that things shouldn’t be more complicated than they need to be. Ease of use, however, is not an end in itself. In some cases complexity is inherent and cannot be simplified down to a seemingly tidy facade. Trying to do that anyway results in a so-called “leaky abstraction”, which means that the underlying complexity shines through and that the promises of the exposed models are subject to implicit conditions. Albeit undesired, leaky abstractions are hard (and sometimes impossible) to avoid and a careful balancing act is required to make a good tradeoff between convenience and correctness.

Great APIs do not just contribute to making software developers feel more happy or productive. Viewing it from a higher-level perspective, one could say that they also have an overall economic impact. This stems from the fact that the number of API consumers can be orders of magnitude larger than the number of its creators. I want to call this the “1:n” effect: say, 100 developers stumbled across the same issue and it took them 5 minutes to fix on average, then this would justify 8 hours worth of time for the creator to sit down and sort out that headache. This is of course a highly philosophical consideration – but it demonstrates what impact it can have when designing “things” and putting them out into the world.


[^1]: In tech, this idea has also become known as “developer experience” (or short: “DX”)

[^2]: Functional aspects of software like correctness or maintainability are promoted through separate principles
