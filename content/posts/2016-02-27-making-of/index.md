+++
title = "Behind the scenes"
subtitle = "The making-of of my blog"
date = "2016-02-27"
tags = ["meta"]
image = "electrical-supplies.jpg"
id = "cpQw4"
url = "cpQw4/behind-the-scenes"
aliases = ["cpQw4"]
+++

During christmas break I refactored (and also revived) this blog, which was motivated by my intend to blog on a regular basis. When I started it, I developed a tiny PHP website framework as a side project and my blog was its first use case. This was big fun and I learned a lot. But even though I still believe in its initial idea, my interest in PHP decreased in a great measure throughout the last year. I never managed to finish a single release of the framework and the only reason for me to catch up on that would be to properly file that project away.

Beyond the fact, that development and maintenance kept me off from actually writing and publishing stuff, my motivation to run this blog also has shifted. Way back when I started, I was primarily interested in building a blog engine, nowadays I rather like to concentrate on using the blog and writing posts for it. (By the way: I often found that I am not the only blogger, who transitioned through this particular process.)

## Blog engine

For all these reasons, I tried to get rid of the tools and decided to condense maintenance expenses to a bare minimum. My first consideration was to migrate to medium.com (or svtble or whatever). These blog services offer most likely the easiest way to bootstrap a blog with a least time-to-first-blogpost. Also they don’t just offer blogging, but you also become part of their community, which makes it much simpler to spread the word. However, there is one thing, which I really dislike about these kinds of services: that everything looks the same.

Let me explain: When it comes to personal websites I sometimes miss the old web-1.0 days, where everyone grabbed some webspace (like 10 MB storage and 500 MB traffic) and build their own creepy little homepage. Of course these days lacked connectivity and socialness, but if you leave these aspects out for a moment, the web was at least *individual* back then. Today, our (social) web experience and the way of interacting with one another is dictated by single companies. And this is not just a matter of visuality; it also refers to the fact how these companies define, depict and model the way we present ourselves and communicate with each other. This frustrates me a lot, as I see that it takes away lots of value from the basic idea of what the internet basically was ought to be. – However, that would be a whole topic in itself.

So, let’s get back on track: considering all this, I had these four requirements for my blog to be left over:

1. Self hosted (or at least: self hostable)
2. Minimal maintenance effort
3. Full control over layout
4. Blogposts in standardized data format (markdown preferred)

It didn’t take all that long to find a solution: [Jekyll](https://jekyllrb.com/) brings all these features and additionally, Github thankfully offers free Jekyll hosting with [Github Pages](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/) (which is awesome!). Since my old blogposts where already written in markdown I was able to migrate them in a short length of time.

## Frontend

Even though I didn’t intend to change the layout of my blog, I entirely rewrote my stylesheets. I did that not just for the sake of housekeeping, it truly was a necessary refactoring: My former stylesheets where written in LESS[^1] – which was new to me 2 years ago – and I frankly didn’t have much clue of what I was doing. Indeed, I did a lot of rookie mistakes:

- I made excessive use of variables, because I over-obeyed the DRY rule. As a result, I achieved the opposite of what I actually intended: my stylesheets where highly coupled and strongly dependent on one another. **→ Modularity: singular.**
- For some reason, I decided to keep my markup clean from CSS classes and the possibility to nest classes in LESS/SASS played into my hands (at least, that was what I thought). As a downside, my stylesheets became gigantic monoliths and reusability disrupted completely. **→ Changeability: painful.**
- I didn’t have a clear strategy to handle my media queries and it turned out I technically had four versions of my styles (since my layout has four breakpoints). In the end, my media queries where scattered and became very hard to track down. **→ Structure: unclear.**

Throughout the last year, I became a huge fan of the [BEM pattern](http://getbem.com/).
Although the double-dash/double-underscore notation seems pretty ugly at the first glance, it’s a clear and simple concept that taps the full potential of CSS preprocessors. In combination with Brad Frost’s [atomic design](http://patternlab.io/about.html) you can achieve clear structure and high modularity within your stylesheets. (However, I just used it  as an inspiration here, since my layout isn’t very extensive and it doesn’t make sense to cascade my few components that strictly.)

When I review my two year old LESS code and compare it to my current approach, I find the latter one not only to be way more maintainable and well-structured, but I also noticed how much the clean-code rules from “classic” programming languages can be adopted to LESS and SASS. It’s liberating to break up layouts into distinct components, orchestrate modules separately and think of CSS classes as a point of intersection between markup and styling.

If you are interested to get a complete impression of the styling of my blogposts, you can have a look at my [living styleguide](/styleguide).


[^1]: Now I go with SASS by the way, but I think there is not that much difference between the two of them.

<!-- *[DRY]: Don’t repeat yourself -->
