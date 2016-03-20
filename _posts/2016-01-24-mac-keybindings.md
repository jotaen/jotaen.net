---
layout:     blogpost
title:      Stop using ASCII Art
subtitle:   Explore the super powers of your Mac keyboard
date:       2016-01-24
tags:       [mac, typography]
permalink:  4haPC/stop-using-ascii-art
image:      /assets/2016/typewriter.jpg
---

Sometimes I hate myself for being so passionate about typography. The whole world is full of poor typefaces and wrong quotation marks, nobody seems to be able to typeset deliberately and people even spend a lot of money for [blass plates in Arial](https://twitter.com/espiekermann/status/690879223473553410).

Good typography has plenty of aspects. This blogpost contents itself with picking out a single one of them: The problem of getting characters from your head into your computer. And this technical barrier is embodied by your keyboard.

I would like to give you some starting points on this topic.[^1] Unfortunately, there is no out-of-the-box solution, since the use of keyboards is highly dependent on both locality and personal preferences. However, I can promise that you can optimize your workflows and massively improve your keyboard productivity with an investment of just a few hours.


# Go beyond ASCII

Imagine, you handwrite a text:

- How do your quotation marks look like?
- How do you write fractions or other mathematic symbols?
- What kind of symbols do you use? (Arrows, hearts, checkmarks, smileys, stars, …)

However, when people are sitting in front of their computers, all of this seems to be forgotten. If you have a close look, you will see the following, most common mistakes each and every day:

|                | Use this                       | Instead of that                      |
|----------------|--------------------------------|--------------------------------------|
| Quotes         | “Quotation marks”              | \"Inches symbol\"                    |
|                | „Gänsefüßchen (german)“        | \"Inches symbol\"                    |
|                | «Guillemets (french)»          | \<\<Greater/smaller than\>\>         |
| Apostrophies   | That’s a correct apostrophe    | That\'s the symbol for the foot unit |
| Three dots     | Ellipses…                      | Three single dots\... (too wide)     |
| Dash           | Long — dash                    | Hyphen - (or minus)                  |
| Multiplication | Multiplcation sign: 7×2        | 7*2 or 7x2 (letter “x”)              |
| Division       | Fraction: 5⁄8 or obelus: 5÷8   | Slash: 5/8                           |
| Copyright      | © and ® and ™                  | (c) and (R) and TM                   |
| Inequality     | ≠ or ≈                         | != or ~                              |
| Arrows         | ➔→➚➤▶ and much more            | -> or => or \-->                     |
| Checkmark      | ✓✔︎ [^2]                        | [x]                                  |
| Bullets        | • or ·                         | o or - or +                          |
| Symbols        | ♥ or ★                         | <3 or *                              |

Do modern computers really offer such a limited character set? Are we still forced to get by with typewriter characters, which just look most alike? The answer is: No! Unicode is no pie in the sky anymore. The latest version of it contains more than 120.000 characters. And you can make use of all of them, everywhere: in e-mails, in text documents and even yet in many programming languages. The only thing you need to know is how to “invoke” them!

## Special Character Panel

This feature is available from OSX 10.8. I just mention it here for the sake of completeness, since most people will probably know it already.

By hitting the key combination `Cmd`+`Ctrl`+`Space` a panel with special chars and emojis will show up systemwide. That is pretty cool when you are looking for a funny smiley or an exotic symbol; however, for often used characters this workflow is too slow. It requires too much steps to select a character, either by navigating by keyboard or by having to use the mouse or trackpad.

## Create a custom keyboard layout

The most convenient way to enter a character is with one single key stroke. But since the keyboard size is limited (typically there are 45 keys under the tips of your fingers) the amount of characters to output is limited either. For that reason there are some modifier keys, which alter the behavior of your keyboards and make additional characters accessible:

- `shift`
- `option`
- `option`+`shift`

This sums up to an impressive 180 characters! The `shift` key is well-kwown, whereas the `option`-modifier lives in the shadow: Either people aren’t used to it at all, or they are just familiar with a few combinations for particular characters. However, what most Mac users probably won’t know, is that you can entirely customize the assignment of keys by creating your own keyboard layout in OSX.

Keyboard layouts are stored as a bundle containing simple XML files. You can either edit these manually, however you will find it more convenient to use the free tool [Ukulele](http://scripts.sil.org/ukelele). Since it comes with quite an extend documentation, I just provide the following starting points for you:

- [Ukulele website](http://scripts.sil.org/ukelele)
- The Ukulele PDF manual, available from the help menu in the application
- “How to make a custom keyboard layout in MacOS” on [Super User](http://superuser.com/questions/665494/how-to-make-a-custom-keyboard-layout-in-macos)

In general, the easiest way is to import your currently used keyboard layout, customize it and then export and activate it. That way, you can reassign all the key combinations for `option` and `option`+`shift` so that they output your most frequently used special characters (or emojis).

[^3]

![Keyboard layout with](/assets/2016/keyboard-layout.gif)

Last but not least, I recommend you to activate the keyboard icon in the system tray via your system settings. That way, you can quickly display a virtual keyboard, which reveals all the “hidden” characters when you press `shift` or `option`. That can be good reminder sometimes.


# Text manipulation

But your keyboard can do more than just outputting special characters. If you are familiar with text editors like vi, emacs, Sublime or Atom, you are probably used to a whole bunch of text manipulation features, like:

- Moving or splitting lines
- Selecting words and paragraphs
- Duplicating or deleting lines
- Setting and toggling case

On Mac OSX you can obtain all these features systemwide[^4] by using a custom `KeyBindings.dict` file, which lives in the Library under your home folder. This enables all the above features for any application like Pages, Mail, Chrome, Notes and so on.

Configuring these actions is simple and straightforward. All you need is to go over the tutorial and a few examples:

- [Tutorial](http://www.hcs.harvard.edu/~jrus/Site/cocoa-text.html)
- [Examples](http://osxnotes.net/keybindings.html) for various keybindings
- [Reference at Apple’s Website](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/EventOverview/TextDefaultsBindings/TextDefaultsBindings.html)

Another possibility is to use the tool [Karabiner](https://pqrs.org/osx/karabiner/), which offers a GUI for all these features. For my personal taste, it is a bit too heavy, though. However, it’s worth to have a look at their website.


[^1]: Attention: This is a Mac specific blogpost!
[^2]: Not to be confused with the square root symbol: √
[^3]: [My keyboard layout](https://github.com/jotaen/mac-bootstrap/tree/master/Library/Keyboard%20Layouts/DeutschJan.bundle/Contents): normal; with option-key; with option+shift. In case you wonder: I have a german computer.
[^4]: Only Constraint: This won’t work in non Cocoa apps
