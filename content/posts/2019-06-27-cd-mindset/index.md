+++
draft = true
title = "The continuous delivery mindset"
subtitle = "What software developers can contribute to making CD successful"
date = "2019-06-27"
tags = ["worklife", "devops"]
image = "/posts/2019-06-27-cd-mindset/assembly-line.jpg"
image_info = "Image by Land Rover MENA [CC BY 2.0](http://creativecommons.org/licenses/by/2.0) with colour modifications"
id = "uhb19"
url = "uhb19/continuous-delivery-mindset"
aliases = ["uhb19"]
+++

“Continuous delivery” (CD) is the practice of applying changes to software on an ongoing basis and delivering value to customers frequently. The underlying goals are to shorten the feedback loop in product development, to be able to respond to changing requirements quickly and to minimise the exposure time of defects. It comes as no surprise that CD is particularly popular with web applications, where release processes are entirely controlled by vendors and new software versions are typically rolled out “on the fly”.

Books can be filled about technical aspects of continuous delivery (and more so about its sibling “continuous deployment”), but its success is neither a matter of tooling alone, nor is developer convenience the main driving force behind it. Instead, CD is primarily a business incentive and its direct, incremental nature is the ultimate enabler for iterative and customer-centric product development. In order to take full advantage of that, CD has to be exercised at organisational level and not just in the development department.

Apart from strong leadership and a mature team culture, effective CD depends on the human factor to a large degree. All individual contributors – be they in product, design, marketing or development – need to know their place, adopt the right mindset and bring their work processes in line. In this blog post I focus on the perspective of software developers and outline the behavioural qualities that I consider most important for them to take active part in such a setup. (I leave out all other aspects deliberately in order to keep the post in scope.)

# Continuous delivery for developers

## Involve yourself

Software developers should include themselves into projects right from the beginning, once initial ideas are tangible or first user stories are written down. The common goal is to start simple and gradually deliver working pieces of software, be it either for internal evaluation or to actual end-users.

A proficient developer has various “hats on their rack” that suit different stages of a project. Being able to rapidly cobble together a fake click-prototype is an equally valuable skill than to claw one’s way through the convoluted mess of a tricky optimisation problem. (Better yet, when the latter can be significantly alleviated by working out a clever compromise.) During planning phases, developers actively help to find opportunities (win-win-situations), for instance by suggesting a modification to a feature that leads to a drastic reduction of implementation cost.

There are numerous ways for developers to make themselves useful early on. But all pioneering spirit aside, it is important that they are mindful about the reliability of their work and stay “on top of things” at all times.

## Embrace iterative work

Continuously delivering small pieces of software has a practical benefit as opposed to big releases: the risk of changes is reduced by making them more manageable. Changes are split into chunks, which can be gradually discussed, reviewed, tested, integrated, verified and re-evaluated as they are taken over into the main code base. It requires a certain level of seniority though to structure work ahead in a smart way and to only make decisions that are necessary for the time being.

Working iteratively also has some challenges when it comes to software architecture. When working in an agile manner, product designers wouldn’t come around with elaborated specifications to kick off a project. But software developers also wouldn’t ask for them upfront in order to get started. Even though the final requirements are yet obscure, they know the paths that eventually will lead to a solid and sustainable software architecture.

Ideally, feature design and software design evolve side by side. That can only work out, however, if software architecture is considered to be an equally serious concern for the success of a project as feature design is. Only if crucial technical considerations are taken into account the same way as other high-leveled input (like user feedback), the end result can become a well-rounded symbiosis of all different stakes.

## Take ownership and responsibility

“You build it, you run it”[^1] – this quote is from an interview with Werner Vogels, CTO at Amazon. The point is that the people who create software are also responsible for running it in production. In the old days, a developer’s job was done when their changes passed QA and were integrated into the main code base. Chances were that programmers didn’t really know what the infrastructure looked like. With continuous delivery, however, every developer has advanced knowledge about the environments, is routinely involved in system and capacity planning, and proactively responds to operational issues.

That is easier said than done, though. It is not just a matter of making some monitoring tools available to everyone or rotating the on-call duty in the teams. Instead, developers are supposed to habitually take on the responsibility for their work throughout the entire lifecycle. That includes to chaperon changes when they go live and to actively watch out for defects. It means to share relevant details with other teams and to proactively inform the right people about potential risks. And: it implies to be self-critical and seek for help if things start to feel hairy.

## Communicate proactively

With multiple releases happening throughout a week (or even throughout a day), a product can feel very volatile, even for the people who directly work on it. Software is rarely self-contained in regards to changes: customer documentation needs to be kept up to date, social media campaigns want to be rolled out in time, or data analytics algorithms call for change and adjustment. All those interests need to be aligned and scheduled, which often requires a tricky balance to be found between the desire of a low time-to-market and the avoidance of sheer chaos.

In the end, software developers are making most of the actual changes happen and are usually controlling the release mechanism too. They are well aware of the latest state that each task is in and therefore especially urged to keep the right people in the loop at the right times. Having a dedicated QA stage or a formal approval procedure may feel safer in that respect, however, these kind of processes tend to be protracted and disproportionally costly – they are often more of a hindrance than a help.

## Be a disciplined professional

As pointed out earlier, the implementation is often evolving in the same agile and iterative way than the feature itself. It is not uncommon for code of very different maturity levels to coexist while work is in progress; refactorings rock up unaskedly and need to be performed spontaneously or painfully deferred; API or database migrations must be executed during full operation.

In such a vibrant setup, it is all too easy to lose sight of software quality and overall consistency. Technical debt is easily raised (“we can still refactor that later…”) and shortcuts are quickly taken (“we don’t have enough time to write proper tests now!”). On top of that, the feedback loop for feature delivery is fullfillingly short-termed, while the ramifications of technical carelessness are much harder to grasp. The latter ones can pile up to substantial impediments down the line though and strike back nastily.

The best way to avoid fragmentation and the “rot of bad code” is two-sided: on the one hand there need to be common quality standards across the development team (or department) that members can be held accountable for. Developers must bring enough professional discipline, so that these standards are actually lived up to. Writing tests, refactoring “bad code” or following common patterns shouldn’t be seen as curse, but rather welcomed as a necessity that allows the software to sustain in the long run. In addition to that, leadership needs to keep an eye on the overall state of affairs and foster a culture where the otherwise rather abstract technical work is appropriately rewarded. This helps the team to find a healthy balance.

## Adopt specific techniques

Not every developer feels immediately comfortable knowing that their code contributions will automatically be deployed and released into production. This degree of automatism is not mandatory of course, but it serves as one good example for the technical environment that is common for continuous delivery. But even if releases are driven manually, for them to be happening robustly a rock-solid test suite is as needful as thorough real-time monitoring.

Continuous delivery is often associated to (and sometimes confused with) the DevOps movement. (“DevOps” is a portmanteau word made of the two parts “development” and “operations”.) There is no distinct definition of the term – simply put, I understand it to be a set of attitudes and techniques that facilitate modern, agile software development. As far as the mindset is concerned, there certainly is a significant intersection between DevOps and CD. Apart from that, DevOps toolchains happen to contain a lot of applicable technology[^2] that support continuous delivery from the practical point of view.

All those principles and tools need to be learned by every developer, at least to a level that they can routinely work with them. It doesn’t mean that everyone is expected to become a tooling and infrastructure expert, but the aim is clearly missed when most of the operational responsibilities are carried out by that “one DevOps guy” on the team.

## Perpetuate the culture

It’s crucial for everyone to internalise that processes and work setups are not set in stone, but that they rather demand constant reflection and adjustment from all involved parties. When new hires come in, they must be trained sufficiently so that they can familiarise themselves with the general concept of continuous delivery (in case they aren’t already) and learn about company-specific best practices that have evolved over time.

Phases of friction can cause an (undesired) return to traditional waterfall approaches. These must be identified by the mentors and addressed together with the participating teams. The development department might be particularly prone to this pitfall, since people in it tend to be used to tackling problems in an analytic manner. It might then seem more obvious to formalise processes rather than to let oneself in for a dynamic environment where occasional uncertainty and constant negotiation are a natural part of the game.


[^1]: See [ACM Queue (2006)](https://queue.acm.org/detail.cfm?id=1142065) for the full interview

[^2]: For the technical side, “[Continuous Delivery (Addison Wesley)](https://www.amazon.com/dp/0321601912)” provides a comprehensive overview.
