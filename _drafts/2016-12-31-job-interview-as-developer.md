---
layout:        blogpost
title:         The job interview
subtitle:      Asking questions as a candidate
date:          2016-10-24
tags:          [hiring, job]
redirect_from: /abcdef/
permalink:     abcdef/the-job-interview
image:         /assets/2016/interview-table.jpg
---

Most software companies put a lot of thought into the elaboration of an interview process for applicants. This is not for nothing: Even though software developers are a dime a dozen, it is hard to find good people who are not just smart and fit into the company culture, but also have a solid track record in what they do.

There are tons of articles that give advice for HR on how to measure the skillset of a candidate, get a realistic insight into their motivation and find out how they think about their work. On the other hand though, there is very little to find[^1] about the other side of interview process: Finding the right company as applicant.

At the time of this writing, I am about to relocate to another city, which is the reason why I am looking for a new job. I have spent much thought in the last weeks on how to find a place I really want to work and I tried to establish a methodological procedure on how to approach my search. In general, I came up with three criteria that I attempt to evaluate when meeting a potential company:

1. **Team** – I attribute a lot of importance to a respectful, progressive and diverse environment, since I spend a considerable amount of time with my colleagues. I want to collaborate with people who are self-aware and enthusiastic (but not obsessed) about what they do.
2. **Product** – Although I see writing code and mastering tools as a craft I continuously am about to get better in, my true motivation comes from the product that I am contributing to. Being part of that is what makes my work meaningful eventually and therefore I need to feel a strong idenfication so that I can bring in my own ideas.
3. **Technology** – I do not give excessive weight to particular technologies, so it’s not important to me to work with certain libraries or programming languages in the first place. In regards to the product, I like to see technology as an enabler of productivity. On a personal level, I want to steadily learn and move myself forward.


# General process

A few thoughts upfront: Although it is called a job “interview”, I consider this term to be too one-sided. The purpose of the whole process is to get to know each other and to find out if both sides can imagine to work together. In fact, I see the interview more to be a conversation, where I meet the people that I actually gonna work with and get a feeling whether it just fits.

As different companies and positions have different demands and expectations, the procedure described in this blogpost is highly opinionated: The questions must be seen as examples and are eventually just an entry point for a discussion. Also, there is no right/wrong and either no scorecard that gives a countable answer in the end. (However, there might be red cards, of course.) The topics that I raise here should yield a good picture and serve as a basis to make a reasonale decision.


# Architecture, Technology

### What does your tech stack currently look like?
- Programming languages, runtimes
- Frameworks, libraries
- Build and deployment

### Who makes decisions on technologies? How does the architecture evolve?
- How are the flight levels calibrated between team, teamleads, CTO and upper management?
- Are there dedicated architects, that specify/predetermine an architecture?
- How do you review your architectural choices?
- Make vs. buy?


# Build, Deployment, Production

### What steps have to happen when I want to change production code?

- Technology: version control; CI; tests; deploy setup
- Process: code review; business approval; deploy process
- Responsibility for releases: Developer vs. release manager vs. entire team (incl. PO/PM)?

### Do you release on friday evenings?
- Follow up: How often do you usually release? Who does that?
- How do you know, that your software is healthy right now?


# Team

### How do you know, what you do on each day?
- Sprint planning; work-day planning?

### What is the current team performance?
- Are there measurements on team performance/throughput?
- Who takes care of addressing impediments? (Retro?)
- What are the biggest impediments at the moment? (How do you identify them? What do you do to solve them?)

### What do you do to get better?
- How do productivity and team work get improved?
- What does innovation mean to you?
- On individual, team and company level


# Code

### How do you ensure quality?
- Code metrics?
- Code reviews, merge policies?
- Consistency (standards, policies and conventions)

## What is your overall code coverage?
- Testing concept

### How do you find, track, analyse and fix bugs?


# Product process

### How do you plan features?
- How do ideas become features?
- How are developers involved into the feature/product process?

### With whom do I collaborate? And with whom not?
- How does collaboration look like?
- Who is involved in the product development process? (PO/PM, UX, FE, BE, QA, …)
- How do these people communicate/collaborate with each other?


[^1]: [This blogpost](https://medium.com/@djsmith42/how-to-interview-as-a-developer-candidate-b666734f12dd#.8ytpeoyjb) by Dave Smith was a huge inspiration for me.
