+++
type = "posts"
listed = false
title = "Styleguide"
subtitle = "The Haute Couture of my website"
date = "2015-12-27"
tags = ["blogging", "frontend", "design"]
image = "/fashionshow.jpg"
image_colouring = 192
image_info = "Foto by herlitz_pbs (https://www.flickr.com/photos/herlitzpbs/10800093004) released under CC-BY-ND 2.0 (https://creativecommons.org/licenses/by-nd/2.0/)"
id = "styleguide"
+++

This is a meta post that specifies the layout and design elements of my website. It is written in the style of a blog post and therefore also serves as a visual example for one.

# Typography

The [“input“ font face](http://input.fontbureau.com) has a technical look goes nicely with this blog, whose topics cover coding and technology mainly. The fact that it comes with a whole bunch of different styles is a strong advantage, since typography is the most important stylistic device on text-heavy sites.

- **Text can be bold to indicate strong emphasis or highlight a passage.**
- *Italic (or: obligue) text can be used for light emphasis. It has a slightly thiner font-weight to stick out a bit more.*
- <a href="#" onclick="return false" class="link">Weblinks</a> come in blue and underlined; <a href="#" onclick="return false" class="link--visited">visited websites</a> are colored purple. (Unfortunately, the latter has come a bit out of fashion, but I consider it to be a very important feature – isn’t the web all about links?)
- Then, `there is inline code`, which is monospaced on a light grey background. `There is enough` spacing so that two code pieces in subsequent lines don’t collide.
- All text selection is in the same colour as the header bar. Try it out!

# Block elements

## Paragraph (and headlines)

A Paragraph is a block of running text. It is supposed to be between a couple and around a dozen of lines of text. The line-length is up to 80 characters at most, to support legibility. The space between two subsequent paragraphs is around 1½ times the line height.

The two preceding headlines serve as example for H1 and H2 headlines, a H3 headline is shown before the next “lorem ipsum” paragraph. H1 is a break to divide the text into multiple chapters: it is rather thin in font weight, but it is generously surrounded by whitespace to make it sufficiently prominent. H2 is a sub-division within a chapter (with some extra whitespace), wheres H3 is associated with its subsequent paragraph (with no extra whitespace).

### H3 headline

Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt[^1] ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Table

|Rank|First Sentence|Book Title|Author|
|--:|--------------|----|------|
|  1|Als Gregor Samsa eines Morgens aus unruhigen Träumen erwachte, fand er sich in seinem Bett zu einem ungeheueren Ungeziefer verwandelt.|Die Verwandlung|Franz Kafka|
|  2|Stately, plump Buck Mulligan came from the stairhead, bearing a bowl of lather on which a mirror and a razor lay crossed.|Ulysses|James Joyce|
|  3|In principio era il Verbo e il Verbo era presso Dio, e il Verbo era Dio.|Il Nome Della Rosa|Umberto Eco|
|  4|It was a bright, cold day in April, and the clocks were striking thirteen.|1984|George Orwell|
|  5|In der Mottengasse elf, oben unter dem Dach hinter dem siebten Balken in dem Haus, wo der alte Eisenbahnsignalvorsteher Herr Gleisenagel wohnt, steht eine sehr geheimnisvolle Kiste.|Lari Fari Mogelzahn|Janosch|

Side note: due to technical limitations, there can’t be footnotes in tables.

## Code

```ruby
# Returns a personalized salutation string
def greet(name)
  return "Hey, #{name}! How are you doing?"
end

puts greet("Mary")
```
[^2]

## List

1. Ordered list
2. Another list item
3. Third list item

- Unordered list
- Another list item
- Third list item

## Image

![A climber abseils from a very exposed summit needle](/fashionshow.jpg)[^3]

Images can also come in different proportions: small or large. (The above is regular.)

![A climber abseils from a very exposed summit needle](/fashionshow.jpg#small)

## Blockquote

> The path of the righteous man is beset on all sides by the iniquities of the selfish and the tyranny of evil men. Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of darkness, for he is truly his brother’s keeper and the finder of lost children. And I will strike down upon thee with great vengeance and furious anger those who attempt to poison and destroy my brothers. And you will know my name is the Lord when I lay my vengeance upon thee.[^4]

[^1]: Footnote for a piece of text within a paragraph
[^2]: Footnote for a code block, here a piece of Ruby code
[^3]: Footnote for an image, here a fashion show
[^4]: Footnote for a blockquote, here a citation from the movie Pulp Fiction (Ezekiel 25,17)
