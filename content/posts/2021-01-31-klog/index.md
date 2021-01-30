+++
title = "klog"
subtitle = "Time tracking in plain text files"
date = "2021-01-31"
tags = ["project", "coding"]
image = "/posts/2021-01-31-klog/notebook.jpg"
image_colouring = "320"
id = "9zRPA"
url = "9zRPA/klog-time-tracking-plain-textfiles"
aliases = ["9zRPA"]
+++

One topic that kept me thinking on and off for a couple of years now is time tracking. The motivation behind this is rather practical, as I was (and still am) interested to keep track of my working hours. Back in the day, when I used to work fulltime, I wanted to know how well on track I was with the 40 hours that I agreed to devote to my employer. Nowadays, as a freelancer, I need to track my working hours for bookkeeping reasons, as my invoices are based on an hourly rate.

There exist countless web services for time tracking, some of which offering an impressive feature set that cater for all imaginable use-cases. However, I never felt too much appeal to use them. It’s not that I have any special requirements or practice an extravagant workflow. My reluctance is instead stemming from a conceptual level: keeping a track of time is a rather simple thing to do, so why rely on (semi-) commercial online services that build on complex technology stacks for something that you can basically do with a pencil and a piece of paper?

What did the trick quite well for me throughout all those years was a spreadsheet that I setup and maintained by hand. It allowed me to enter data quickly and I could also run some simple evaluations, e.g. in order to aggregate the entries by week or month. While this solution was both simple and flexible, it also felt a bit cumbersome, especially for things like writing formulas or configuring pivot tables. As a programmer I am in the fortunate position to build my own tools if I don’t find anything that suits me sufficiently.

The longer I work with computers the more I appreciate the freedom and simplicity of plain text files: not being bound to using proprietary software to open or edit them; not being exposed to the risk that your data gets sold to advertising companies; no lock-in on arbitrary subscription plans. Instead, the data is all yours and you can rest assured that you will be able to work with it for years to come. Viewing or manipulating the files can be done with any off-the-shelf text editor, and syncing them across multiple devices is as easy as putting them into your Dropbox folder.

Born out of this conception I experimented with different formats to record time tracking data using plain text files. Over the past weeks I tried out various structures to model and layout the information. What I came up with is a lightweight format with minimal syntax that I called “klog”. The idea is to record the data in a similar format as you would using a physical notebook. This is basically the date, then time-related entries such as a time range or duration of how long something took, and maybe a short note about what you did.

![A terminal window demonstrating the file format and the command line tool usage](/posts/2021-01-31-klog/demo.gif)

I implemented a parser for this file format along with a small command line tool, so that it is possible to evaluate the data programatically. You find the project [on Github](https://github.com/jotaen/klog), where you can also download the binary in order to experiment with klog. If you happen to be interested in this idea I’d appreciate some feedback and learn about your use-cases. klog obviously fits *my* needs, but I aimed for making it general-purpose enough so that other people may find it useful too.

Building klog was not just a fun programming exercise, but I also ran into some interesting questions: shall timezones be supported? Is it okay to restrict time values to hours and minutes, but to omit the seconds part for convenience? What if someone starts an activity close to midnight and finishes it on the next day, like doing a night shift? How can you start tracking something that’s not yet finished and therefore doesn’t have an end time? I wrote a brief guide (that you find in the repository) that gives a tour of klog and also covers these questions.

The command line tool is fairly minimalistic for now, as I first want to validate that my basic idea sustains before investing more work into it. It can basically pretty-print, filter and evaluate files, but not more so far. I attributed special attention to error handling, so in case there are formatting errors you should see precise and (hopefully) helpful error messages. The application is written in Go, which ensures that it runs cross-platform without relying on runtime dependencies, and – as a bonus – it’s also quite fast even on large data sets.

And as for the name, since my original use-case is tracking work times, “klog” is what we call a “Kofferwort” in German: a blend of the two terms “work” and “log”.
