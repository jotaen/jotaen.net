+++
draft = true
title = "The CI mindset"
subtitle = "Living up to continuous integration"
date = "2020-01-01"
tags = ["devops"]
image = "/posts/XXXX-XX-XX-ci-mindset/assembly-line.jpg"
image_info = "Image by Land Rover MENA [CC BY 2.0](http://creativecommons.org/licenses/by/2.0) with slight colour modifications"
id = "asdf5"
url = "asdf5/continuous-integration-mindset"
aliases = ["asdf5"]
+++

Today’s times of agile software development are all about continuity: continuous integration, continuous deployment, continuous releases. While these are slightly different categories, they all aim at the same goals – being able to respond to changing requirements quicker, minimise the exposure time of bugs and shorten the feedback loop of feature development.

The concept of building and shipping right away sounds simple and intriguing, but getting there actually deserves a lot of effort to be put into tooling and processes. Ideally, every commit that gets pushed to the master code branch will automatically be deployed and released to production. But even if releases are driven manually, for them to be happening frequently a rock-solid test suite is as needful as thorough real-time monitoring. Reliability is what makes the difference.

While books[^1] can be filled about technical setups and concepts, this blog post touches a less obvious aspect that, however, is no less important: the human factor. Practicing successful continuous delivery is not just a matter of having the right tools in place, it’s a mindset question in great part. This especially should not be underestimated if the endeavour is to introduce continuous delivery to a team that is used to scheduled, dedicated releases.

## Plan in increments

This aspect alone could easily make one blog post – it’s probably the most crucial one, not just for a development team but also on the organisational level.

- Baby steps; small increments that are continuously released
- Feature/dev flags
- Requires certain level of seniority

## Take responsibility

- Verify that your changes are successful
- Keep an eye on logs and monitoring

## Communicate proactively

- Keep everyone in the loop
- Inform about risks proactively

## Know the tools

- Always think forward, but mind the retreat
- Two-pronged data migrations

## Invest into the foundations

- Constantly invest in tests, etc.
- Continuously dedicate time for refactorings


[^1]: For a comprehensive technical overview I recommend “[Continuous Delivery](https://www.amazon.com/dp/0321601912)” by Humble/Farley.
