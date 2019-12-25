+++
type = "posts"
title = "Styleguide"
subtitle = "The Haute Couture of my website"
date = "2015-12-27"
tags = ["blogging", "frontend", "design"]
image = "/fashionshow.jpg"
image_info = "Foto by herlitz_pbs (https://www.flickr.com/photos/herlitzpbs/10800093004) released under CC-BY-ND 2.0 (https://creativecommons.org/licenses/by-nd/2.0/)"
id = "styleguide"
+++

This is a meta post that specifies the layout and design elements of my website. It is written in the style of a blog post and therefore also serves as a visual example for one.

# Typography

The [“input“ font face](http://input.fontbureau.com) has a technical look goes nicely with this blog, whose topics cover coding and technology mainly. The fact that it comes with a whole bunch of different styles is a strong advantage, since typography is the most important stylistic device on text-heavy sites.

- **Bold text** and *italic (or: obligue) text*
- <a href="#" onclick="return false" class="link">Weblinks</a> come in blue and underlined; <a href="#" onclick="return false" class="link--visited">visited websites</a> are colored purple. (Unfortunately, the latter has come a bit out of fashion, but I consider it to be a very important feature – isn’t the web all about links?)
- Then, `there is inline code`, which is monospaced on a light grey background.
- All text selection is in the same colour as the header bar. Try it out!

# Block elements

## Paragraph

This is a block of text.

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt[^1] ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Table

|Rank|First Sentence|Book Title|Author|
|--:|--------------|----|------|
|  1|Als Gregor Samsa eines Morgens aus unruhigen Träumen erwachte, fand er sich in seinem Bett zu einem ungeheueren Ungeziefer verwandelt.|Die Verwandlung|Franz Kafka|
|  2|Stately, plump Buck Mulligan came from the stairhead, bearing a bowl of lather on which a mirror and a razor lay crossed.|Ulysses|James Joyce|
|  3|In principio era il Verbo e il Verbo era presso Dio, e il Verbo era Dio.[^2]|Il Nome Della Rosa|Umberto Eco|
|  4|It was a bright, cold day in April, and the clocks were striking thirteen.|1984|George Orwell|
|  5|In der Mottengasse elf, oben unter dem Dach hinter dem siebten Balken in dem Haus, wo der alte Eisenbahnsignalvorsteher Herr Gleisenagel wohnt, steht eine sehr geheimnisvolle Kiste.|Lari Fari Mogelzahn|Janosch|

## Code

```ruby
# Returns a personalized salutation string
def greet(name)
  return "Hey, #{name}! How are you doing?"
end

puts greet("Mary")
```
[^3]

## List

1. Ordered list
2. Another list item
3. Third list item

- Unordered list
- Another list item
- Third list item

## Image

![A climber abseils from a very exposed summit needle](/salbit.jpg)[^4]

## Blockquote

> The path of the righteous man is beset on all sides by the iniquities of the selfish and the tyranny of evil men. Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of darkness, for he is truly his brother’s keeper and the finder of lost children. And I will strike down upon thee with great vengeance and furious anger those who attempt to poison and destroy my brothers. And you will know my name is the Lord when I lay my vengeance upon thee.[^5]

[^1]: Footnote for a piece of text within a paragraph
[^2]: Footnote for a piece of text within a table
[^3]: Footnote for a code block, here a piece of Ruby code
[^4]: Footnote for an image, here me on top of a mountain
[^5]: Footnote for a blockquote, here a citation from the movie Pulp Fiction (Ezekiel 25,17)
