+++
title = "Make 404s fun!"
subtitle = "Suddenly find yourself on the shell of a crashed web server"
date = "2016-08-20"
tags = ["project", "meta", "404", "webshell"]
image = "/assets/2016/errorpage-webshell.jpg"
id = "jBZuH"
url = "jBZuH/errorpage-with-webshelljs"
aliases = ["jBZuH"]
+++

Error pages are a topic in itself: In the best case, people don’t see the error page of a website for a single time. And if they do so, they probably followed a broken or outdated link and find themselves stuck, since they don’t came out in the place they were actually looking for. This being the case, most error pages offer a search form or a possibility to contact someone.

On the other hand, error pages are also a refuge for creativeness – instead of boring the visitor with off-the-shelf phrases about how sorry you feel, a 404 page can be a both fun and interactive experience. During the last week I set out and realized an idea, that I kept in my mind for a long time: I created a command line interpreter that runs in a browser and comes with a simple abstraction of a filesystem and user management.

The first use case of this webshell is the 404 page of this blog: When you hit a non existing URL, it seems like the server crashed due to the fact that the requested URL could not be resolved and you find yourself on the bare metal of the server (at least that is what it looks like).

## Try it out

To visit my new error page, you must enter a non existing URL on my domain. (Or click on this link for your convenience: [jotaen.net/error-404](/error-404).) If you don’t know what to do, just type `help` to see all the commands or `help "command"` to see, what one particular command does.

You can also fiddle around in this box:

<script src="http://static.jotaen.net/webshell.js/dist/webshell.js"></script>
<link rel="stylesheet" property="stylesheet" href="/assets/static/webshell-dark.css">
<div id="tryItOut" class="webshell" style="height: 20em"></div>
<script>createWebshell('tryItOut')</script>

The name of the project is webshell.js and the [sources reside on GitHub](https://github.com/jotaen/webshell.js). The project bids you and your contributions welcome! So feel free to open an issue or to implement your favorite shell command by yourself. There are still many todos left and also a few bugs to fix. When the project has moved along, I probably will write a dedicated blog post about it. Meanwhile, here is just a brief overview:

- There is a basic set of commands available yet. My design approach is to make the implementation of commands as easy as possible, since the amount of available commands is what makes the webshell rich and fun eventually.
- So far, the shell has a command history (arrow keys), auto completion for pathes (tab key) and the ability to cancel inputs (command-c). It handles relative and absolute pathes and understands basic operators like `&&`, `&`, `|`, `>` and `>>`
- I use Redux for handling and managing the state, which turned out to be pretty convenient. Note, that the state is stored in the local storage of your browser, so everything from the filesystem up to your command history is restored when you return.
- DOM operations are written in pure, vanilla JS. (There is actually not much DOM manipulation going on, as you can imagine.)
- It is possible to customize the look by writing own themes. Currently, I’m experimenting with how to make the output responsive. Try it out by resizing your browser window.

## Appendix: Some other nice 404 pages

If you investigate about 404 pages in google, you find a ton of resources about this topic. Here are a some of my personal favorites:

- Every programmer probably knows [Octocat dressed like Yoda](https://github.com/404). (By the way, they also have a similar [status 500 page](https://github.com/500).)
- [Bret Victor](http://worrydream.com/404notfound) adopted René Magrittes famous “Ceci n’es pas une pipe” image
- Tumblr shows fascinating [full size animations](https://www.tumblr.com/404). It’s worth to refresh the site a few times.
- The french web developer Romain Brasier turns back time, where a [Lemming consisted of a dozen pixels](http://www.romainbrasier.fr/404.php?lang=en)
