+++
draft = true
title = "Swing the brush"
subtitle = "Some small improvements of my blog"
date = "2018-04-15"
tags = ["blogging"]
image = "/posts/2018-04-15-spring-cleaning/painting.jpg"
image_info = "Photo by Khara Woods (unsplash.com/@kharaoke)"
id = "98d7d"
url = "98d7d/spring-cleaning"
aliases = ["98d7d"]
+++

This post is a entry into the virtual changelog of my blog. Over the past couple of weeks I set out to do a little spring cleaning and improved some smaller things that kept bothering me since quite a while. Allow me to share the three most interesting improvements here.

## #1 – Content structure

I didn’t want to have categories for sorting my content, because I think a hierarchical structure is too limited for my purposes. That’s why I decided to go with tags back in the day, as they are more versatile than a strict and “one-dimensional” category system. However, I used to assign tags more less randomly so far. They also didn’t provide any further functionality other than somehow indicating the topic a post is about.

I got out of this misery in three easy steps:

1. I made a content inventory and clustered all the posts I had written so far to get a comprehensive overview. Eventually I identified 2 main groups: what kind of content a post belongs to and – if it has a technical subject – in which part of the tech stack it is residing. I re-tagged all my posts in that respect and think it makes for a meaningful order now.
2. I redesigned the homepage so that it doesn’t plainly enumerating all the posts anymore as it used to do before. Instead, it only shows the most recent posts and outlines the content structure of the blog, which helps new visitors find their way around quicker.
3. I created an archive page that now lists out all the posts one by one. The page is filterable by tag as well, which effectively allows to browse the content. Apart from that, whenever you click on a tag somewhere it takes you to the archive page and applies the respective filter.

## #2 – Menu and icons

The biggest visual improvement are the new icons in the menu, which have been designd by my talented coworker Charisse[^1]. It was especially tricky to pick an adequate icon for the archive page and I realised once more that it’s certainly not optimal to have a menu design that is mainly based on icons. The current situation is still somewhat okay-ish for me though, as I want to keep the slender menu bar for it’s space efficiency.

Furthermore, I enhanced the accessibility of the menu by simply increasing the icon size, which makes a noticable difference on touch displays. On small screens – when the header flips to the top – the navigation is also not statically attached at the top anymore but it slides in and out as you scroll.

## #3 – Build system

Recently I had a short outage in production after a deployment: the reason for this was a breaking change in the blog engine I use[^2] that I didn’t notice since my local binary version differed from the one on the build server. Hence, I decided to reimplement my build setup with Docker in order to have platform independent and reproducible builds.

I setup a Makefile to hold my Docker commands and organise the build steps. Interestingly, it’s not the first time that I ended up introducing Makefiles in smaller web projects. Even though they aren’t precisely suitable for that purpose, their simplicity and ease-of-use convince me again and again. I probably will dedicate an entire blog post to that topic someday in the future.


[^1]: Charisse also advised on many other details – thanks heaps for your help!

[^2]: Learn about the [technical setup of my blog here](/e7ywT/deploying-static-website-to-aws/). In a nutshell: I use Hugo, Travis-CI and AWS S3.
