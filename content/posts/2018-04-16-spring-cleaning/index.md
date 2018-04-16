+++
title = "Swing the brush"
subtitle = "Spring cleaning of my blog"
date = "2018-04-16"
tags = ["blogging"]
image = "/posts/2018-04-16-spring-cleaning/painting.jpg"
image_info = "Photo by Khara Woods (unsplash.com/@kharaoke)"
id = "IgXy1"
url = "IgXy1/spring-cleaning"
aliases = ["IgXy1"]
+++

This post is a entry into the virtual changelog of my blog. Over the past couple of weeks I set out to do a little spring cleaning and improved some smaller things that kept bothering me since quite a while. Allow me to share the four most interesting improvements here.

## #1 – Content structure

I never wanted to have categories to sort my content, because I think a hierarchical structure is too limited for my purposes. That’s why I decided to go with tags back in the day, as they are more versatile than a strict and “one-dimensional” category system. However, I used to assign tags more less arbitrary due to the lack of an organisational principal so far. They also didn’t provide any further functionality beyond somehow indicating the topic a post is about.

I got out of this misery in three easy steps:

1. I started with a content inventory and clustered all the posts I had written so far to get a comprehensive overview. Eventually I identified two main groups: what kind of content a post belongs to and – if it has a technical subject – in which part of the tech stack it is residing. I re-tagged all my posts in that respect and think it makes for a meaningful order now.
2. I redesigned the homepage so that it doesn’t plainly enumerate all the posts anymore as it used to do before. Instead, it only shows the most recent entries, plus it neatly outlines the content structure of the blog, which helps new visitors find their way around quicker.
3. I created an archive page that lists out all the posts one by one. The page is filterable by tag as well, which effectively allows to browse in the content. Apart from that, whenever you click on a tag somewhere it takes you to the archive page and applies the respective filter.

## #2 – Menu and icons

The biggest visual improvement are the new icons in the menu, which have been designd by my talented coworker Charisse[^1]. It was especially tricky to pick an adequate icon for the archive page and I realised once more that it’s certainly not optimal to have a design that is mainly based on icons. The current situation is still somewhat okay-ish for me though, as I want to keep the slender menu bar for it’s space efficiency.

Furthermore, I enhanced the accessibility of the menu by simply increasing the icon size and margins, which makes a noticable difference on touch displays. On small screens – when the menu flips to the top – the navigation is also not statically attached at the top anymore but it slides in and out as you scroll.

## #3 – Build system

Recently I had a short outage in production after a deployment: the reason for this was a breaking change in the blog engine I use[^2] that I didn’t notice since my local binary version differed from the one on the build server. Hence, I decided to reimplement my build setup with Docker in order to have platform independent and reproducible builds.

I setup [a Makefile](https://github.com/jotaen/www.jotaen.net/blob/master/Makefile) to hold my Docker commands and organise the build steps. Interestingly, it’s not the first time that I ended up introducing Makefiles in smaller web projects. Even though they aren’t precisely suitable for that purpose, their simplicity and ease-of-use convince me again and again. I probably will dedicate an entire blog post to that topic someday in the future.

## #4 – Performance

All my content is statically served via a CDN, which is why the performance of my blog is fairly good already: the server latency is usually only a few milliseconds, so the almost sole decisive factor for performance is network speed. I could boost the loading time here a bit by optimising asset management:

- In the menu I use SVGs instead of PNGs now for icons and logo and embedd them directly into the markup to save unnecessary HTTP requests. (They also look a bit more crisp now.)
- All JavaScript is now included in the HTML code as well. I have only a few dozen lines of it anyway.
- The thumbnails on the homepage are optimised, so that they only weigh 5–10 KB each.

The transfer size for a (non-cached) request to the homepage is about 350 KB. The biggest asset by far are the fonts that I use, which sum up to an impressive 250 KB alone. Since typography is my strongest visual stylistic device I don’t want to make optimisations here, though. (My options would be limited anyway, since the fonts are served by a 3rd party provider.) The fonts have a fairly generous cache header, so they are only reloaded once a week. After all, I consider them to be bearable luxury.

For your interest: the tools that I mainly use to assess performance are [Webpagetest.org](https://www.webpagetest.org/), [Google PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/) and of course the [Google Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/network-performance/).

## The remainder

There are still things left on my todo list, like configuring and optimising my RSS Feed, and improving screen reader accessibility. If you have any further ideas, just let me know!


[^1]: Charisse also advised on many other details (thank you!). Go check her amazing illustrations on [Dribbble](https://dribbble.com/charisseysabel).

[^2]: Learn about the [technical setup of my blog here](/e7ywT/deploying-static-website-to-aws/). In a nutshell: I use Hugo, Travis-CI and AWS S3.
