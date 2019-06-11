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

“Continuous delivery” (CD) is the practice of applying changes to software on an ongoing basis and delivering value to customers frequently. The underlying goals are to shorten the feedback loop in product development, to be able to respond to changing requirements quickly and to minimise the exposure time of defects. That being said, continuous delivery is primarily a business incentive and it makes for a central pillar of customer-centric, agile product development.

Effective continuous delivery has to be excercised at the organizational level, rather than just in one department or even a single team. Every collaborator – be it in product, design, marketing or development – needs to adopt the right mindset, understand the specific work processes and be willing to align to them.

In this blog post I want to focus on five specific behavioural qualities that I consider important for the role of an individual software developer who is part of such a setup. I assume that there already is a functioning CD culture present and don’t go into detail about the surrounding requirements that lead to it. (That would go way beyond scope here.) In any event, the key take-away is that effective CD is carried out by the people who are involved into it, so every team member has to understand what they can contribute to make it successful.

## Embracing incremental work

Continuously integrating and delivering small chunks of software has several benefits as opposed to big releases. The risk of changes is reduced by making them more manageable: changes are split into smaller chunks, which can be gradually discussed, reviewed, tested, integrated, verified and re-evaluated as they are integrated back into the main code base. Besides those technical aspects, however, the biggest advantage of developing software incrementally is actually a business one: it ultimately is the enabler for iterative product development.

This requires developers to be involved into projects from the very beginning, once initial ideas are concrete or the first user stories are written down. The aim is to start simple and then regularly deliver working pieces of software, be it either only for internal evaluation or to actual end-users. For this to work properly, developers have to mind the reliability of their work at all times and be confident with integrating changes into an established product, even if those are still “unfinished”. During planning phases they actively help to find opportunities (win-win-situations), for instance by suggesting a modification to a design that leads to a drastic reduction of implementation cost.

When it comes to software architecture, working iteratively has some challenges that require a certain level of seniority to deal with. Ideally, feature design and software design evolve side by side, where high-level user feedback is taken into account with same weight as low-leveled technical considerations – with the end result being a well-rounded consent of all the different perspectives (stakes). Product designers wouldn’t come around with elaborated specifications to kick off a project, but software developers also wouldn’t ask for them upfront in order to get started. Even though the final requirements are yet unknown, they know the paths that eventually lead to a solid and sustainable software architecture.

## Taking ownership and responsibility

“You build it, you run it”[^1] – this quote is from an interview with Werner Vogels, CTO at Amazon. The point is that the people who create software are also responsible for running it in production. In the old days, a developer’s job was done when their changes passed QA and were integrated into the main code base. Chances were that they didn’t really know what the infrastructure looked like. With continuous delivery, however, every developer has profound knowledge about the environments, is routinely involved in system and capacity planning, and proactively responds to operational problems.

That is easier said than done, though. It is not just a matter of making some monitoring tools available to everyone or rotating the on-call duty in the teams. Instead, developers are supposed to habitually take on the responsibility for their work throughout the entire lifecycle. That includes to chaperon changes when they go live or to actively watch out for defects. But it also means to share relevant details with other teams or to proactively inform the right people about potential risks.

## Communicating proactively

With multiple releases happening throughout a week (or even throughout a day), a product can feel very volatile, even for the people who directly work on it. On top of that, software is rarely self-contained in regards to changes: customer documentation needs to be kept up to date, social media campaigns want to be rolled out in time, and shifting data analysis can’t wait to be followed. All those schedules need to be aligned, which often requires a tricky balance to be found between the desire of a low time-to-market and the avoidance of sheer chaos.

Since software developers are ultimately applying most of the changes and also controlling the release mechanism, they are usually well aware of the latest state that each feature is in.

- Keep everyone in the loop
- Dedicated QA stages or formal approval processes are often more of a hindrance than a help

## Being disciplined

As pointed out earlier, the implementation is often evolving in the same agile and iterative way than the feature itself. During that time, code of different maturity levels coexists in the main code base. Refactorings rock up undesiredly – and need to be carried out spontaneously or painfully postponed. API or database migrations must be planned and executed during full operation.

- Constantly invest in tests, automation, configuration, etc.
- Continuously dedicate time for refactorings
- Keep an eye on software quality

## Adopting specific techniques

Not every developer feels immediately comfortable knowing that all their code contributions will automatically be deployed and released into production. This degree of automatism is not mandatory of course, but it serves as one good example for the technical environment that is common for continuous delivery. Even if releases are driven manually, for them to be happening reliably a rock-solid test suite is as needful as thorough real-time monitoring.

Continuous deliverly is often associated to (and sometimes confused with) the “DevOps” movement. (“DevOps” is a portmanteau word made of the two parts “development” and “operations”.) While there is no distinct definition of DevOps as a whole, I understand it to be a set of tools and techniques that facilitate modern, agile software development. As far as the mindset is concerned, there certainly is a significant intersection between DevOps and CD. Apart from that, DevOps toolchains[^2] happen to contain a lot of applicable technology that support continuous delivery from the practical point of view.

# Summary

Coming back to what I mentioned in the introduction: continuous delivery cannot work when individual contributors do not understand its philosophy and thus are not aware what role they are expected to play. Both a strong leadership and a mature work culture are pivotal for taking full advantage of CD. New hires must be trained, so that they can familiarise themselves with the general concept (in case they aren’t already) and learn about company-specific best practices that have manifested over time.

Phases of uncertainty and friction can cause an (undesired) return to traditional waterfall approaches. These must be identified by leadership and addressed together with the participating teams. The development department might be particularly prone to this effect, since people in it tend to be used to tackling problems in an analytic or systematic way. It might then seem obvious to formalise processes rather than to let oneself in for a more dynamic setup that requires constant negotiation to sustain.


[^1]: See [ACM, 2006](https://queue.acm.org/detail.cfm?id=1142065) for the full interview

[^2]: For the technical side, “[Continuous Delivery (Addison Wesley)](https://www.amazon.com/dp/0321601912)” provides a comprehensive overview.
