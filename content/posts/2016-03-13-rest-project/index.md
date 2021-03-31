+++
title = "Let’s build a REST service"
subtitle = "Kickoff for a five part blogpost series"
date = "2016-03-13"
tags = ["project", "backend"]
image = "bench.jpg"
id = "Toqw4"
url = "Toqw4/lets-build-a-rest-service"
aliases = ["Toqw4"]
+++

This is the first blogpost of a small series about microservices. In my current side project, I am working on a tiny REST API, that acts as a weblink shortener. In this kickoff post I want to describe the basic idea behind the project and give a look-out on the topics I am going to cover.

The source code of the project is available [on Github](https://github.com/jotaen/j4n.io).

# Table of contents

This series is planned to contain five parts. (I will hand in the corresponding links as we go along.)

- **Part 1: Kickoff** (This is the blogpost you currently read.)
- [**Part 2: Basics of microservices**](/fXts2/what-is-a-rest-service) How the term REST is defined and how the concepts can be applicable to practice.
- [**Part 3: Development with NodeJS**](/Q6eUW/coding-j4nio-with-nodejs) My service is implemented based on the ME(A)N-Stack (MongoDB, ExpressJS, NodeJS), which seems to be a pretty good choice for this particular project.
- [**Part 4: Testing and QA**](/v24iU/testing-and-qa-of-j4nio) Since microservices are small in scope and pretty much well-defined, they are not so hard to test. However, there is a whole bunch of testing utility and quality assurance tools to choose from.
- [**Part 5: Deploying and operating**](/Tt7Yh/deployment-and-operating) The best code is worth little, if it doesn’t run anywhere. In order to preserve a healthy ratio between application size and maintenance expenses, we will go into the cloud.


# The idea

Basically, a shortlink service is just a webserver, which stores brief tokens and associates weblinks with them. The webserver itself is of course accessible through a likewise brief domain. That way, long URLs are reachable via short and uniform ones. That’s it. Even though I am aware of the fact, that this is a pretty much useless idea, I always have dreamed of possessing my own shortlink service. Now, I’m going to make this dream come true.

I ordered the domain `j4n.io`, which luckily was still available. It is a suitable domain for several reasons:

- It is short (small, but important detail)
- The name kills two birds with one stone: It is both leetspeak for “jan” and also the numeronym for “jotaen” (because the 4 mid-positioned characters “otae” are substituted by the digit “4”).
- The io-TLD is actually assigned to the British Indian Ocean Territory. However, it is widely used as generic top-level domain with the meaning “input/output”. This mirrors the idea of redirecting.
- It covers the whole thing into a geeky and modern dress.

In order to be useful for my blog, the goal is to store the IDs of my blogposts and have them redirected to the corresponding full URL, so that [j4n.io/Toqw4](http://j4n.io/Toqw4) resolves to the URL of this very blogpost. In addition to that, the service must also offer administration access to its resources.

In summary, these are the technical requirements for the j4n.io service:

- Storing new shortlinks both with custom defined and auto-generated hashes
- Updating and deleting existing shortlinks
- Handling the appropriate meta-data for each item (e.g.: date of creation, date of last update)
- Distinguishing between read access (which is allowed to anyone) and write access (which is restricted to me)

Once the service is ready for production, I will update the information block of my blogpost layout (which is positioned underneath the header image) and add a permalink entry, where the corresponding shortlink will be listed.

# Read on

> Go to [**Part 2: Basics of microservices**](/fXts2/what-is-a-rest-service), where I explain the term REST and share some practical tips.
