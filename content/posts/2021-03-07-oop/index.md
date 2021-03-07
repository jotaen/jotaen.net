+++
title = "Storytime"
subtitle = "How I failed to become a game developer at the age of 13"
date = "2021-03-07"
tags = ["thoughts"]
image = "/posts/2021-03-07-oop/broken-sword.jpg"
image_info = "The opening scene of the game “Broken Sword” by Revolution Software, which I was (and still am) a huge fan of"
image_colouring = "10"
id = "DnKeU"
url = "DnKeU/storytime-failing-to-become-game-developer"
aliases = ["DnKeU"]
+++

I started programming at the tender age of 13. Should this sound impressive to you, then allow me to put things into perspective here. By “programming” I mean that a friend showed me how to setup a C++ file and that you could use the `cout`[^1] command to make text appear on the terminal. Of course you had to *convert* the code into this strange “a.out” file before you could run it. I had no idea what this meant and it also seemed a bit complicated in my opinion, but anyways. I was immediately excited about C++ and started to write all kinds of little programs, most of which with the purpose of printing out silly messages or trying to make the terminal crash.

My C++ skills improved quickly, I learned about loops and ifs, and my programs continued to grow. (30 lines of code and more!) It didn’t take long for me to add `cin` to my repertoire of commands as well. This was a real game changer, because it allowed me to build interactive command line tools that responded to user input: for example, I created a program that would ask you to type in your name, in order to say hello to you afterwards – personalised, of course.

Or another one that would prompt you for a secret password. I put this program in the Windows startup folder, so it would automatically be launched after the computer had booted. The clue was that I had configured the terminal window to go fullscreen by default, so it would cover up the entire screen. The program would only exit (and thus close the terminal window) after the user had entered the right password. That way my computer was effectively password-protected.

Well, that’s what I thought, at least. I later discovered that you could just quit the terminal by pressing “Alt+F4”, which was kind of a bummer. Despite feeling confident that no one in my family was clever enough to exploit this vulnerability, I decided to abandon my custom login system in favour of setting up a BIOS password. (Which my friend assured me of was basically uncrackable.)

## Creating my own game

At that time I used to play lots of point-and-click adventures, such as Monkey Island, Broken Sword or The Longest Journey. Therefore it seemed all too obvious to combine my passion for gaming with my newly acquired programming skills: I wanted to build my own adventure!

There was just one problem. While I knew how to create *text-based* programs, I didn’t have a clue how to build anything *graphical*. The cool games all consisted of colourful objects that moved around on the screen and that you could interact with, and I wanted to have that too. Due to my `cout` and `cin` superpowers I felt that I was sort of halfway there, I just had to figure out the technique for making *objects* appear on the screen instead of text.

I went to the local book store in order to close this knowledge gap[^2]. Since I had no idea what to look for precisely I simply browsed through the shelves in the hopes to find something that would teach me how to create this kind of “visual” software in C++. I soon realised that my quest was harder than initially expected. The variety of books was immense, but none of them seemed to address my specific problem directly. Also, many of the price tags I saw weren’t really compatible with my budget.

Frustration was starting to rise: why on earth can’t there be a regularly-sized, regularly-priced book that would just help me get started with making graphical programs? I wasn’t interested in all the other parts of C++ after all, I just wanted to create a game with interactive visual elements and colourful objects in it. That didn’t seem too much to ask for.

So, what to do now? Should I leave the book store empty-handed? No, I didn’t want to be stuck with text forever. There just *had* to be a book that would meet my needs, so I scanned the array of titles once again. And then – finally – I saw it. A handy paperback with maybe 200 pages. I mean, that’s a reasonable size for a book, isn’t it? Price: fifteen bucks. There we go! The cover showed some colourful geometric shapes. Oh boy, this looks promising! And in big bold letters it said: “Introduction to object-oriented programming in C++”. Jackpot. This was exactly what I had been looking for.

I couldn’t contain myself – I bought the book straight away and rushed home. It was summer holidays, I was motivated, so 200 pages should be doable fairly quickly. I was probably only a week or two away from creating my first prototype of a graphical game, how cool is that? And thanks to my new book, this time it would have real objects in it and not just boring text!

My excitement lasted until I was about halfway into page two. I immediately sensed that something was off here. While the title clearly suggested that the book was about objects in C++, the author wasn’t even remotely talking about anything related to graphics. In fact, I had to admit that I didn’t have the vaguest idea what the author was talking about *at all*. I hastily skimmed through the pages: no illustrations, no colours, no objects. This wasn’t good.

I felt devastated. I had put all my hopes into this book, but my goal of creating my own game had receded into the distance. I also felt betrayed by the author. Why would someone call a book “object-oriented“ (and even draw objects on the cover) when it didn’t have anything to do with *actual* objects? This was a major disappointment.

Eventually, I surrendered. It just seemed impossible for me to get a hold of how to create graphical games in C++. Fortunately, the situation was slightly eased by the fact that I had picked up some HTML and CSS around that time. That, along with my virtuoso abilities in MS Paint, allowed me to design coloured objects and arrange them on the screen to my liking.

That way I managed to create something faintly reminiscent of a point-and-click adventure in the web browser, even though my approach felt a bit “static” and also wasn’t particularly interactive. The game sceneries were basically HTML pages containing a bunch of hand-drawn images. One of the images was a link pointing to the next page, so you had to scan the page with your mouse cursor in order to find it and “move forward in the story”. The game was quite short, so for experienced adventurists it would maybe take 2 minutes or so to finish. (Which includes watching a gif-based cutscene.) Not *quite* like Monkey Island, but at least there were objects, so there is that.

## Take-aways

Fast-forward to today. When looking back on this story there are three things I’d like to mention in conclusion. First and foremost: I finally got around to creating an [interactive game with real objects](https://github.com/jotaen/spaceshooter). And you know what? The objects are not just appearing on the screen, but they are in the code too. If that doesn’t tick the box I don’t know what does.

Second, I was able to forgive the author of the book. Today I know that my misunderstanding wasn’t their fault. (It wasn’t mine, though, either.)
What remained is a deep aversion against the anemic methodologies that use to come out of all those “foo-oriented” or “whatever-driven” programming paradigms. I probably should consult a psychoanalyst to debate the root causes of this in order to eventually come to terms with my trauma. Aside from that it might be a good topic to elaborate on in a future blog post.

And last but not least, I found out that my friend was wrong – the only acceptable way to protect data on your computer from unauthorised access is by encrypting the hard-drive with a strong password.


[^1]: In C++ [`cout`](https://en.cppreference.com/w/cpp/io/cout) is for printing to stdout and [`cin`](https://en.cppreference.com/w/cpp/io/cin) is for reading from stdin. The “c” stands for “character”.

[^2]: Just for context, this story took place around the year 2000 and I didn’t even have reliable internet access at that time.
