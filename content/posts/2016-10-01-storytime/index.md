+++
title = "Storytime"
subtitle = "Learning from challenges"
date = "2016-10-01"
tags = ["meta", "thoughts"]
image = "/posts/2016-10-01-storytime/bookshelf.jpg"
id = "V4ZPG"
url = "V4ZPG/storytime"
aliases = ["V4ZPG"]
+++

I recently got asked to write up a challenging software project that I was involved into and what I have learned from it. The following story is not the hardest coding problem I ever worked on, but is nonetheless an exciting project and — apart from coding — gives you a good insight into my understanding of an agile and iterative approach to solving problems.

One sentence of context upfront: the company where I worked here is the biggest german platform for physicians (160k users) and is both an expert network where colleagues can ask for help and also a resource for medical knowledge and pharma information.

The community management of my company wanted to launch a regular newsletter, that would keep users informed about the most recent activities on the platform (new articles, questions, news, …). The clue was that the newsletter content should be individual for each user based on the areas of interest they had picked in their settings.

In order to gather early feedback on this product idea, we strived for a simple yet sufficiently viable solution: we built an endpoint on top of our main database and made use of existing algorithms to grab the user specific content. A worker app on our messaging system  requested this endpoint to assemble each newsletter and another worker handed the emails over to our mail service provider.

The MVP was a great success: We processed a huge amount of newsletters per day that yielded a lot of user traffic. But we were facing two major problems:

1. We wanted to split off all the editorial content from the user generated content in order to migrate it to a separate CMS. That way, the content didn’t live in a single database anymore, but we had two distinct sources of data; additional content sources were planned.
2. We wanted to improve the recommendation algorithms, but our main (relational) database didn’t do well in this specific purpose.

In order to solve the first problem, we decoupled the recommendation system from the main application and duplicated all content items to a standalone microservice. Whenever content was published or edited anywhere on the platform, an event got emitted to the messaging layer; a worker transformed the data and pushed it into this recommendation service. That approach was far more resilient and we also saw a huge performance boost. In terms of technology, we chose to start with a document based datastore and reimplemented the data processing logic on the new server.

Next, we worked on the recommendation algorithms: Together with product owners and stakeholders, we thought of more sophisticated ways to tag the content. As upcoming requirements, the system should be capable of promoting particular content items or should take tracking data into account (e.g. popularity of an item). It became clear that our content structure could be best modeled as graph, so we decided to exchange the document store with a graph database, which allowed us to link each item to all kinds of metadata. We had little hands-on experience with this database type, but we considered it to be the right choice and we were given the chance to learn about it.

Although both software and product are still work-in-progress, this is a good point to conclude the story. There is no finish; my description is a window in time of something that is ever changing and continuously transforming. The moral is not the solution — it is the approach.

Having told you this story lets me point out three things that I take away and got clear about. These are my learnings:

- **Sustainable software architecture is driven by requirements.** No master plans. Keep it cheap and flexible in the early stages, where ideas are clear but questions still many in number. Then steadily evolve along with maturing demands. When it comes to making decisions, I find the concept of shearing layers[^1] to be a helpful guideline to identify and handle different grades of change.
- **Pick the right tool for the job.** This oftenly repeated truism is easier said than done, because figuring out the meaning of “*right*” can be the most difficult challenge. In fact, the implications of technological choices can be far reaching and are not the sole responsibility of developers: Software should be owned by the entire product team, where everyone shares the same understanding and is equally commited.
- **Teams and products over tools and technology.** This is a personal one: I love to code and am passionate about my craft, but my true motivation is an exciting product that is grown collaboratively. I am a software developer in the first place, but my work becomes meaningful only when I am involved in the context.


[^1]: Read here about [shearing layers](https://en.wikipedia.org/wiki/Shearing_layers) and see this [video](https://www.youtube.com/watch?v=HTSbtM12IZw)

*[MVP]: Minimum Viable Product
