---
layout:        blogpost
title:         The job interview
subtitle:      Asking questions as a candidate
date:          2016-12-04
tags:          [hiring, job]
redirect_from: /abcdef/
permalink:     abcdef/the-job-interview
image:         /assets/2016/interview-table.jpg
---

Most software companies put a lot of thought into the elaboration of an interview process for applicants. This is not for nothing: Even though software developers are a dime a dozen, it is hard to find good people who are not just smart and fit into the company culture, but also have a solid track record in what they do.

There are tons of articles that give advice for HR on how to measure the skillset of a candidate, get insight into their motivation and find out how they think about their work. On the other hand though, there is very little to find[^1] about the other side of interview process: Finding the right company as applicant.

At the time of this writing I was looking for a new job and had spent much thought on how to find a place I would really love to work. I tried to establish a methodological procedure on how to approach my search and came up with three criteria that I attempt to evaluate when meeting a potential company:

1. **Team** – I attribute a lot of importance to a transparent, progressive and diverse environment. I want to collaborate with people who are self-aware and enthusiastic (but not obsessed) with what they do. Being part of a supportive and respectful team is in my eyes one of the most substantial aspects of employee hapiness.
2. **Product** – Although I see writing code and mastering tools as a craft I continuously am about to get better in, my true motivation comes from the product that I am contributing to. Being part of that is what makes my work meaningful eventually and I need to feel a strong idenfication so that I can bring in my own ideas.
3. **Technology** – I want to constantly move myself forward and learn new things, but I do not give excessive weight to particular technologies. An ambitious and self-critical team culture is much more important here than working with certain programming languages or the latest libraries. In regards to the product, I like to see technology as an enabler of productivity.


# General process

A few thoughts upfront: Although it is called a job “interview”, I consider this term to be too one-sided. The purpose of the whole process is to get to know each other and to find out if both sides see a way in working together. In fact, I think the interview is a conversation, where I meet the people who I actually gonna work with and look whether it “feels right”.

As different companies and positions have different demands and expectations, the procedure described in this blogpost is highly opinionated: The questions must be seen as examples and are eventually just an entry point for a conversation. Also, there is no right/wrong and either no scorecard that gives a measurable answer in the end. (However, there might be red cards, of course.) The topics that I raise here should yield a good picture and serve as a basis for me to make a reasonale decision.


# Architecture, Technology

### What does your current tech stack look like?
These questions should give a good overview over the basic setup:

- Which programming languages do you use?
- What databases and major frameworks did you choose?
- How does your architecture look like? (e.g. microservices vs. monolith)
- What tools do you use for build, CI, monitoring, deployment, etc.
- On which infrastructure is your application running?

Apart from the factual aspect of these questions, it’s more interesting to look behind the curtain: *why* did they decide on certain tools, how do these technologies breathe life into the product and how are the current choices reflected upon. The actual situation is less important to me than to understand the reasons behind it. I like to see a considerate contention of the pros & cons and how current hindrances are being addressed.

### Who makes decisions on technologies? How does the architecture evolve?
I think there is no golden trail for establishing architectures as this highly depends on team setup and product demands. I generally prefer an agile approach, where architecture is driven by actual requirements and not by big master plans that where elaborated upfront.

In my experience, it is important that everyone is encouraged to make his voice heard in technical discussions and shares a common understanding in which direction the development is heading to. However, there are different flight levels that must be well calibrated between the single developer, the team, CTO and product management (think e.g. of the “Make vs. Buy” question).


# Team

### How do you know what to do each day?
This again is a very basic question to understand the work processes. The daily workflow is a good starting point, but it is admittedly the least important. I’m more interested to get a feeling for the points of intersection with the product management and with other teams. I have made the best experience with cross-functional teams, where developers, PMs, design, UX,… collaborate hand in hand from the very beginning. Although methodologies like Kanban came from the industry originally, it’s neither effective nor efficient to think of software development like a production line, where ideas traverse the departments from construction to assembly. A good indicator is to scan the boundaries of some roles in the team: What does the UX guy know about FE development? Who (apart from operating) is involved in maintaining the build processes? What do the backend developer know about upcoming style and layout changes?

### What is the current team performance?
There are various ways of measuring the performance and throughput of a team. When working in sprints, most teams practise some sort of estimates, which helps planning the upcoming workload. It’s also common to review the outcome of a sprint and see whether the estimates were accurate. For me, it doesn’t matter which method is being used, as long as there is a functioning cycle of planning and evaluation. The team should show awareness for this topic and foster a culture of perseverant improvement.

### How do you deal with impediments?
Each team faces impediments and hindrances that prevent it from delivering the highest possible performance. But just because a team executes weekly retrospectives doesn’t mean they systematically tackle one barrier after the other. Continuous improvement (Kaizen) is matter of culture, not processes.

If possible, I try to get an insight into the recent retrospectives and speak about a few of the major impediments that were discussed there. It can be interesting to double check these in a follow-up interview with the CTO in order to see, whether team and management share the same picture of what’s going on. Misalignment might be an indicator for cultural problems or lack of communication.

### What do you do to get better?
The first response to this question is often about educational budgets, which I’m not primarily interested in. It’s of course a big plus when a company pays my tickets, but in the end people don’t get better just because they attend a conference or a workshop once in a while. It’s worth diving a bit deeper into that topic, e.g. by asking these questions:

- Do you think your company/team is innovative? What does innovation mean to you?
- How do you share knowledge within teams and across teams?
- When was the last time you introduced a technology that nobody had experience with?
- Do you engage in open source?
- Do you have a tech blog? If so, who writes for it?


# Code

### How do you ensure quality?
- Code metrics?
- Code reviews, merge policies?
- Consistency (standards, policies and conventions)

### What is your overall code coverage?
I prefer to ask this question exactly that way, even though scarcely anybody will know the overall figure for this. Test coverage is an excellent example to see how people deal with metrics and how they think that these numbers reflect the actual quality. My personal opinion is that coverage is one of the most important developer metrics and everyone should roughly know about it. However, the goal is to have a useful and well-conceived testing approach in the end, not to aim for 100% by all means.

### How do you find, track, analyse and fix bugs?


# Build, Deployment, Production

### What steps have to happen when I want to change production code?
In my experience, the maturity of a team can be better assessed by looking at  tooling and processing rather than what trendy frontend library they use. A  fully automated, stable continuous deployment setup for example requires a significant amount of work, and this is not just a matter of developer convenience – seing a constant investment here shows that the company understands how these processes pay off on a business level. Moreover, they might even be an indicator for the overall productivity. 

This question also gives a good insight into the responsibility for releases: Do they have fixed release dates that are demanded by the product manager or is it the developers themselves who push on with getting their stuff out.

### Do you release on friday evenings?
This is a bit of a trick question and I don’t know whether I would ask it literally. The idea behind it is to see how confident they feel with their infrastructure and whether they trust their monitoring to make a reliable assertion about the healthiness of the application. It’s can be also interesting to ask for the latest major incident, how it was resolved and what they did afterwards to prevent it from happening again.


# Product process

### How do you plan features?
- How do ideas become features?
- How are developers involved into the feature/product process?

### With whom do I collaborate? And with whom not?
- How does collaboration look like?
- Who is involved in the product development process? (PO/PM, UX, FE, BE, QA, …)
- How do these people communicate/collaborate with each other?


[^1]: [“A developer’s guide to interviewing”](https://medium.com/@djsmith42/how-to-interview-as-a-developer-candidate-b666734f12dd#.8ytpeoyjb) by Dave Smith was a huge inspiration; with this blogpost I tried to establish my own version of it.
