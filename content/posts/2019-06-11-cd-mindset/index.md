+++
draft = true
title = "The continuous delivery mindset"
subtitle = "What software developers can contribute to successful CD"
date = "2019-06-11"
tags = ["worklife", "devops"]
image = "/posts/2019-06-11-cd-mindset/assembly-line.jpg"
image_info = "Image by Land Rover MENA [CC BY 2.0](http://creativecommons.org/licenses/by/2.0) with colour modifications"
id = "uhb19"
url = "uhb19/continuous-delivery-mindset"
aliases = ["uhb19"]
+++

“Continuous delivery” (CD) is the practice of applying changes to software on an ongoing basis and delivering value to customers frequently. The underlying goals are to shorten the feedback loop in product development, to be able to respond to changing requirements quickly and to minimise the exposure time of defects. That being said, continuous delivery is primarily a business incentive, which makes for a central pillar of customer-centric, agile product development.

Effective continuous delivery has to be excercised at the organizational level, rather than just in one department or even a single team. Every collaborator – be it in product, design, marketing or development – needs to adopt the right mindset, understand the work processes and be willing to align to them. There are common principles that apply to all participants likewise, but some are also specific to the respective roles.

In this blog post I focus on the behavioural qualities that I consider important for individual software developers who are part of such a setup. For the scope of this post I assume that there already is a functioning CD culture present and don’t go into detail about the surrounding requirements that lead to it.

# The continuous delivery maxims

## Involve yourself

Software developers should include themselves into projects right from the beginning, once initial ideas are tangible or the first user stories are written down. The aim is to start simple and gradually deliver working pieces of software, be it either for internal evaluation or to actual end-users. During planning phases, developers actively help to find opportunities (win-win-situations), for instance by suggesting a modification to a feature that leads to a drastic reduction of implementation cost.

A proficient developer has various “hats on their rack” that suit different stages of a project. Being able to rapidly cobble together a fake click-prototype can be an equally valuable skill than to claw one’s way through the convoluted mess of a tricky optimisation problem. In any event, developers should mind the reliability of their work at all times and also know how to appropriately integrate changes into an established product, even if those are still “unfinished”.

## Embrace iterative work

Continuously integrating and delivering small chunks of software has a big practical benefit as opposed to big releases: the risk of changes is reduced by making them more manageable. Changes are split into smaller chunks, which can be gradually discussed, reviewed, tested, integrated, verified and re-evaluated as they are integrated back into the main code base. Besides those technical aspects, however, the biggest advantage of developing software incrementally is actually a business one: it is the ultimate enabler for iterative product development.

When it comes to software architecture, working iteratively has some challenges that require a certain level of seniority to deal with. When working in an agile manner, product designers wouldn’t come around with elaborated specifications to kick off a project. But software developers also wouldn’t ask for them upfront in order to get started. Even though the final requirements are yet unknown, they know the paths that eventually lead to a solid and sustainable software architecture.

Ideally, feature design and software design evolve side by side. That can only work out though if software architecture is considered to be an equally serious concern for the success of a project as feature design is. Only if crucial technical considerations are taken into account the same way as other high-leveled input (like user feedback), the end result can become a well-rounded symbiosis of all different stakes.

## Take ownership and responsibility

“You build it, you run it”[^1] – this quote is from an interview with Werner Vogels, CTO at Amazon. The point is that the people who create software are also responsible for running it in production. In the old days, a developer’s job was done when their changes passed QA and were integrated into the main code base. Chances were that programmers didn’t really know what the infrastructure looked like. With continuous delivery, however, every developer has advanced knowledge about the environments, is routinely involved in system and capacity planning, and proactively responds to operational issues.

That is easier said than done, though. It is not just a matter of making some monitoring tools available to everyone or rotating the on-call duty in the teams. Instead, developers are supposed to habitually take on the responsibility for their work throughout the entire lifecycle. That includes to chaperon changes when they go live and to actively watch out for defects. It means to share relevant details with other teams and to proactively inform the right people about potential risks. And: it also implies to be self-critical and seek for help if things start to feel hairy.

## Communicate proactively

With multiple releases happening throughout a week (or even throughout a day), a product can feel very volatile, even for the people who directly work on it. Software is rarely self-contained in regards to changes: customer documentation needs to be kept up to date, social media campaigns want to be rolled out in time, or data analytics algorithms call for change and adjustment. All those schedules need to be aligned, which often requires a tricky balance to be found between the desire of a low time-to-market and the avoidance of sheer chaos.

In the end, software developers are making most of the actual changes happen and they are usually also controlling the release mechanism. They are well aware of the latest state that each task is in and therefore especially urged to keep the right people in the loop at the right times. Having a dedicated QA stage or a formal approval procedure may feel safer in that respect, however, these kind of processes tend to be protracted and disproportionally costly – they are often more of a hindrance than a help.

## Be a disciplined professional

As pointed out earlier, the implementation is often evolving in the same agile and iterative way than the feature itself. It is not uncommon for code of very different maturity levels to coexist while work is in progress; then, refactorings rock up unaskedly – and need to be performed spontaneously or painfully deferred; lastly, API or database migrations must be executed during full operation.

In such a vibrant setup, it is all too easy to lose sight of software quality and overall consistency. Technical debt is easily raised (“we can still refactor that later…”) and shortcuts are quickly taken (“we don’t have enough time to write tests now!”). On top of that, the feedback loop for feature delivery is fullfillingly short-termed, while the ramifications of technical carelessness are much harder to grasp. The latter ones can pile up to substantial impediments down the line though and strike back nastily.

The best way to avoid fragmentation and the “rot of bad code” is two-sided: on the one hand there need to be common quality standards across the development team (or department) that members can be held accountable for. On the other hand, developers must bring enough professional discipline, so that these standards are actually lived up to. This calls for a leadership that fosters a culture where the otherwise rather abstract technical work is appropriately rewarded. That helps the team to find a healthy and balanced mentality.

## Adopt specific techniques

Not every developer feels immediately comfortable knowing that their code contributions will automatically be deployed and released into production. This degree of automatism is not mandatory of course, but it serves as one good example for the technical environment that is common for continuous delivery. But even if releases are driven manually, for them to be happening robustly a rock-solid test suite is as needful as thorough real-time monitoring.

Continuous delivery is often associated to (and sometimes confused with) the DevOps movement. (“DevOps” is a portmanteau word made of the two parts “development” and “operations”.) There is no distinct definition of the term – simply put, I understand it to be a set of attitudes and techniques[^2] that facilitate modern, agile software development. As far as the mindset is concerned, there certainly is a significant intersection between DevOps and CD. Apart from that, DevOps toolchains happen to contain a lot of applicable technology that support continuous delivery from the practical point of view.

All those principles and tools need to be learned by every developer, at least to a level that they can routinely work with them. It doesn’t mean that everyone is expected to become a tooling and infrastructure expert, but the aim is clearly missed when most of the operational responsibilities are carried out by that “one DevOps guy” on the team.

# Summary

Successful continuous delivery depends on the human factor to a large degree. Every collaborator must understand the philosophy and be aware of the role they are playing to make it work effectively. Both a strong leadership and a mature team culture are pivotal. New hires must be trained sufficiently, so that they can familiarise themselves with the general concept (in case they aren’t already) and learn about company-specific best practices that have manifested over time.

Phases of friction can cause an (undesired) return to traditional waterfall approaches. These must be identified by the mentors and addressed together with the participating teams. The development department might be particularly prone to this effect, since people in it tend to be used to tackling problems in an analytic manner. It might then seem more obvious to formalise processes rather than to let oneself in for a dynamic environment where occasional uncertainty and constant negotiation are part of the game.


[^1]: See [ACM Queue (2006)](https://queue.acm.org/detail.cfm?id=1142065) for the full interview

[^2]: For the technical side, “[Continuous Delivery (Addison Wesley)](https://www.amazon.com/dp/0321601912)” provides a comprehensive overview.
