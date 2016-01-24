---
layout:     blogpost
title:      Stop using ASCII Art
subtitle:   Explore the super powers of your Mac keyboard
date:       2016-01-24
tags:       [mac, typography]
permalink:  4haPC/mac-keybindings
image:      /assets/2016/typewriter.jpg
image_info: Image by Raúl Hernández González (https://www.flickr.com/photos/rahego/3863524572) released under CC-BY-2.0 (https://creativecommons.org/licenses/by/2.0/)
---


||Use this|Instead of that|
|-|-----|-----|
|Quotes|“Quotation marks”|\"Inches symbol\"|
||„Gänsefüßchen (german)“|\"Inches symbol\"|
||«Guillemets (french)»|\<\<Greater/smaller than\>\>|
|Apostrophies|That’s a correct apostrophe|That\'s the symbol for the foot unit|
|Three dots|Ellipses…|Three single dots\... (too wide)|
|Dash|Long — dash|Hyphen - (or minus)|
|Multiplication|Multiplcation sign: 7×2|7*2 or 7x2 (letter “x”)|
|Division|Fraction: 5⁄8 or obelus: 5÷8|Slash: 5/8|
|Copyright|© and ® and ™|(c) and (R) and TM|
|Inequality|≠ or ≈|!= or ~|
|Arrows|➔→➚➤▶ and much more|-> or => or \-->|
|Checkmark|✓✔︎ (don’t confuse with sqrt √)|[x]|
|Bullets|• or ·|o or - or +|
|Symbols|♥ or ★|<3 or *|

If you want to boost your productivity, it’s worth investing a few hours to customize your keyboard workflows.

# Special Character Panel

This feature is available from OSX 10.8. I just mention it here for the sake of completeness, since most people will probably know it already.

By hitting the key combination `Cmd`+`Ctrl`+`Space` a panel with special chars and emojis will show up systemwide. That is pretty cool when you are looking for a funny smiley or an exotic symbol; however, for often used characters this workflow is too slow. It requires too much steps to select a character, either by navigating by keyboard or by having to use the mouse or trackpad.

# Create a custom keyboard layout

The most convenient way to enter a character is with one single key stroke.  But since the keyboard size is limited (typically there are 45 keys under the tips of your fingers) the amount of characters to output is limited either. For that reason there are some modifier keys, which alter the behavior of your keyboards:

- `shift`
- `option`
- `option`+`shift`

This sums up to an impressive 180 characters! The `shift` key is well-kwown, whereas the `option`-modifier lives in the shadow: Either people aren’t used to it at all, or they are just familiar with a few combinations for particular characters. However, what most Mac users probably won’t know, is that you can entirely customize the assignment of keys by creating your own keyboard layout in OSX.

Keyboard layouts are stored as a bundle containing simple XML files. You can either edit these manually, however you will find it more convenient to use the free tool [Ukulele](http://scripts.sil.org/ukelele). Since it comes with quite an extend documentation, I just provide the following starting points for you:

- [Ukulele website](http://scripts.sil.org/ukelele)
- The Ukulele PDF manual, available from the help menu in the application
- “How to make a custom keyboard layout in MacOS” on [Super User](http://superuser.com/questions/665494/how-to-make-a-custom-keyboard-layout-in-macos)

In general, the easiest way is to import your currently used keyboard layout, customize it and then export and activate it. That way, you can reassign all the key combinations for `option` and `option`+`shift` so that they output your most frequently used special characters (or emojis).

[^1]

![Keyboard layout with](/assets/2016/keyboard-layout.gif)

Last but not least, I recommend you to activate the keyboard icon in the system tray via your system settings. That way, you can quickly display a virtual keyboard, which reveals all the “hidden” characters when you press `shift` or `option`.

# Keybindings for text manipulation

But your keyboard can do more than just outputting special characters. If you are familiar with text editors like vi, emacs, Sublime or Atom, you are probably used to a whole bunch of text manipulation features, like:

- Moving or splitting lines
- Selecting words or paragraphs
- Duplicating or deleting lines
- Toggling case

On Mac OSX you can obtain all these features systemwide[^2] by using a custom `KeyBindings.dict` file, which lives in the Library under your home folder. This enables all the above features for any application like Pages, Mail, Chrome, Notes, Slack and so on.

Configuring these actions is simple and straightforward. All you need is to go over the tutorial and a few examples:

- [Tutorial](http://www.hcs.harvard.edu/~jrus/Site/cocoa-text.html)
- [Examples](http://osxnotes.net/keybindings.html) for various keybindings
- [Reference at Apple’s Website](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/EventOverview/TextDefaultsBindings/TextDefaultsBindings.html)

Another possibility is to use the tool [Karabiner](https://pqrs.org/osx/karabiner/), which offers a GUI for all these features. For my personal taste, it is a bit too heavy, though.


[^1]: [My keyboard layout](https://github.com/jotaen/mac-bootstrap/tree/master/Library/Keyboard%20Layouts/DeutschJan.bundle/Contents): normal; with option-key; with option+shift. In case you wonder: My default keyboard is German.
[^2]: Only Constraint: This won’t work in non Cocoa apps
