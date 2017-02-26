+++
title = "Optimizing for print"
subtitle = "The champions league of responsive webdesign"
date = "2016-11-13"
tags = ["layout", "meta", "typography"]
image = "/posts/2016-11-13-print/printing-press.jpg"
id = "L9yVd"
url = "L9yVd/optimizing-for-print"
aliases = ["L9yVd"]
+++

Responsive webdesign doesn’t mean that you can just optimize for various screen (or viewport) sizes. Beyond that, you can adjust the layout also for entirely different output devices – for instance, a printer. And before you wonder: yes, even in 2016 there are perfectly valid reasons to print out a website:

- You don’t want to expose an (expensive) electronic device in a dirty or wet environment
- You want to proof-read a draft text but you prefer to use real pencils for making annotations
- You temporarily cannot (for whichever reason) use your laptop, tablet or smartphone

However, I think that the term “printing out a website” is a bit unartful, since in most cases a user is not interested in printing out a pixel-perfect copy of the actual site, but she rather wants to print out the relevant *content* that the page contains. This puts the whole topic into a slightly different perspective.

Since I recently optimized the print layout for my blog, I want to share my thoughts and experiences with you in this blogpost.

## Page format

Let’s start with the page format: Fortunately, the situation in print is a bit more neat than it is on screen. Basically, there are just two page formats to consider, which are most common in home and office environments. Both formats vary in sizes and ratio

- DIN A4: 210mm × 297mm
- US letter: 215.9mm × 279.4mm

DIN A4 is more longish whereas the US letter format is more clinched. Eventually, both formats are quite similar though.

In terms of the width, I optimized the print layout for the DIN A4 format, because when it fits there it automatically will work on US letters (since these are wider). However, I ignored the differences in height, since blogposts are continuous text – I just let the browser or printer take care of the pagination.

By the way, the basic page layout can be setup in CSS via [`@page`](https://developer.mozilla.org/en/docs/Web/CSS/@page).

## Ink is expensive

Most people have an intuitive understanding that every printed sheet of paper comes at a certain cost. It would be a mistake to think that this exclusively applies to print and that resources in a virtual environment are for free. In fact, the cost of a single webpage request can [easily outrange the average daily income](https://whatdoesmysitecost.com) in poorer countries. However, that would be a whole topic in itself.

Most browsers automatically address some basic issues in order to save ink. (E.g. they will not print background images or background colors.) But especially in terms of images or other colored areas you should consider whether printing them adds any value. For example I don’t print the header image of my blogposts, because they have just illustrative purpose an can thus be spared out.

## You cannot click on things

The most obvious difference between paper and screen is that paper is not interactive. A sheet of paper is static and cannot be navigated on or interacted with. Clicking on links or hovering over items is not possible. This has some interesting implications.

### Interactive items might be left off

I see no value in printing out interactive items that would become meaningless in the printing context. This includes:

- Navigation
- Footer
- Search box
- Social buttons

Anyway, make sure that the layout doesn’t become too simplistic on the other hand. The user should be able to recognize the visual identity of the original website.

### Weblinks need to be spelled in full

The user may see an underlined word and recognize it as link, but the address information of a weblink is lost. (This is technically the `href` attribute of a link.) I solved this issue with the following CSS:

{% highlight scss %}
@media print {
    a:after {
      content: " [➚ " attr(href) "]";
    }
}
{% endhighlight %}

That way, the address of a link is written out and appears right after the link text. (Try it out by looking at the print preview of this page.) Depending on the length it might be a pain to typewrite the URL, but after all the URL information is preserved.

## Typography

It’s a typographical best practice to set text in a larger font size on screen. You can observe this when you compare an average book to an average website. (Just put book and screen side by side and measure with a ruler.)

Since I use a comparatively small font size on my blog, I didn’t make any adjustments for print. However, if you use a large font size, you might want to decrease it. (The general usage of relative units like `em` will turn to account here!)

## Under the hood: Some technical tips

### Where to put the CSS?

There are various possibilities for organizing the CSS code for the print styling. They can be defined as entirely separate style sheets and embedded via a `<link rel="myPrint.css" media="print">` tag in the HTML head section. This has the advantage that the CSS code only gets loaded when the user actually wants to print the page.

However, I prefer to have my stuff organized in a logical way: I decided to handle the print styling in place and keep it along with all the other rules. When using CSS preprocessing (SASS, LESS) this can be done like so:

{% highlight scss %}
.some-class {
    margin-top: 1em;
    @media print { margin-top: 20pt; }
}
{% endhighlight %}

### Units, dimensions

The correct unit for a printer is `pt`. When you really want to carry it to the extremes, then you can tweak every unit with a media query. I think this isn’t worth the hassle: most modern browsers do a good job in properly calculating the conversions by themselves.

### Relative dates

In case you use relative dates on your website (e.g. “yesterday”, “3 days ago”) remember that these become meaningless when printed out. You need to display them as fully qualified date string.

### Page breaks

You can enforce a page break with the `break-before` CSS property in order to ensure that different sections get printed on different pages. This allows the user to just print out certain sections that he is interested in by setting the page range in the print dialog.

### Developing

When you want to check the print rendering result, you can use the print preview of your browser. However, you might find that workflow a bit too sluggish: Most browsers offer rendering options in the development tools, so that you can emulate the media types.

And one last thing: Testing print layouts is equally effortful than testing screen layouts. Every browser renders differently, so make sure that you cover all major browsers.
