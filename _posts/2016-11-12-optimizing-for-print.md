---
layout:        blogpost
title:         Optimizing for print
subtitle:      The champions league of responsive webdesign
date:          2016-11-12
tags:          [layout, styling]
redirect_from: /abc34/
permalink:     abc34/optimizing-for-print
image:         /assets/2016/printer.jpg
---

Responsive webdesign does not just mean that you optimize for different screen (or viewport) sizes, but you can do that also for entirely different output devices like a printer. And before you ask: yes, even in 2016 there are perfectly valid reasons to print out a website:

- You don’t want to expose an (expensive) electronic device in a dirty or wet environment
- You want to proof-read a draft text but you prefer to use real pencils for making annotations
- You temporarily cannot (for whichever reason) use your laptop, tablet or smartphone

Side note: The term “printing out a website” is a bit misleading, since in most cases a user is not interested in printing out a pixel-perfect copy of the actual site, but she rather wants to print out the relevant *content* that the site contains. This might put the whole process into a slightly different perspective.

I want to share my thoughts and experiences as I adjusted the print layout for my blogposts.

## Page format

Let’s start with the page format: Fortunately, the situation in print is a bit more neat than it is on screen. Basically, there are just two page formats to considerate that are most common in home and office environments:

- DIN A4: 210mm × 297mm
- US letter: 215.9mm × 279.4mm

Both formats vary in sizes a little bit: DIN A4 is a bit more longish whereas the US letter format comes a bit more clinched. Eventually both formats are quite similar though.

In terms of the width, I optimized the print layout for the DIN A4 format, because when it fits there it automatically will work on US letters (since these are wider). However, I ignored the differences in height, since blogposts are continuous text – I just let the browser or printer take care of the pagination.

By the way, the basic layout of the pages can be setup in CSS with the [`@page` at-rule](https://developer.mozilla.org/en/docs/Web/CSS/@page).

## Ink is expensive

Most people have an intuitive understanding that every printed sheet of paper comes at a certain cost. However, it would be a mistake to think that resources on a website are for free. In fact, the cost of a single webpage request can [easily outrange the average daily income](https://whatdoesmysitecost.com) in poor countries. But that would be a whole topic in itself.

## You cannot click on things

The most obvious difference between paper and screen are that paper is not interactive. A sheet of paper is static and cannot be navigated on or interacted with. Clicking on links or hovering over items is not possible. This has some interesting implications.

### Interactive items might be left off

I see no value in printing out interactive items that would become meaningless in the printing context. This includes:

- Navigation
- Footer
- Social buttons

### Weblinks need to be spelled in full

The user may see an underlined word and know that it is a link, but by default, the address information of a weblink is lost. (This is technically the `href` attribute of a link.) I solved this issue with the following CSS:

{% highlight css %}
@media print {
    a:after {
      content: " [➚ " attr(href) "]";
    }
}
{% endhighlight %}

That way, the address of a link gets written out after the link text. (Try it out by looking at the print preview of this page.)

## Under the hood: Some technical details

### Where to put the CSS?

2 Options:

- Dedicated print stylesheet
- Print media queries in place (SASS)

### Units, dimensions

- Units

### Typography

### Page breaks

With the `break-before` CSS property you can enforce a page break to ensure that different sections get printed on different pages. This allows the user to just print out certain sections that he is interested in.