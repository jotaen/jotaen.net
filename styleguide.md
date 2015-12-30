---
layout:     blogpost
title:      "Living styleguide"
subtitle:   "How my blogposts are styled"
date:       2014-12-27T17:04:25+0100
categories: meta
permalink:  /styleguide
image:      /static/fashionshow.jpg
---

The header section above is a container which takes up ~40% vertical space. It is intended to show a full size image[^1]. The headline (and subheadline) for the blogpost is centered and the letters have one of the available colors (see below) as background.

# Basic styling

## Typography

The font face is »input« by David Jonathan Ross[^2]. Due to its technical look it goes nicely with this blog, whose topics cover coding and technology mainly. The fact that it comes with a whole bunch of different styles is a strong advantage, since typography is the most important stylistic device on text-heavy sites. However, because using webfonts is also a matter of frontend performance, just the following styles are included:

- Regular text: Input Sans Condensed 300 (regular & italic)
- Strong text: Input Serif Compressed 700 italic (regular & italic)
- Captions: Input Sans Compressed 300 (italic)
- Code: Input Sans Mono Narrow 300 (regular)

## Inline styles

- **Bold text is not just bold**, it uses the serif typeface additionally.
- *This is italic (or: obligue) text*
- [Weblinks](https://you-never-have-been.here) come in blue and underlined; [visited websites](//jotaen.net) are colored purple. Unfortunately, the latter has come a bit out of fashion, but I consider it to be a very important feature – isn’t the web all about links?
- Then, `there is inline code`, which has grey background and is – surprisingly – monospaced.
- Lastly, although not an actual inline style, all text selection is brown. Try it out!

## Colors



# Block elements

## Table

|Nr.|First Sentence|Book|Author|
|--:|-----|----|------|
|  1|Als Gregor Samsa eines Morgens aus unruhigen Träumen erwachte, fand er sich in seinem Bett zu einem ungeheueren Ungeziefer verwandelt|Die Verwandlung|Franz Kafka|
|  2|Stately, plump Buck Mulligan came from the stairhead, bearing a bowl of lather on which a mirror and a razor lay crossed.|Ulysses|James Joyce|
|  3|In principio era il Verbo e il Verbo era presso Dio, e il Verbo era Dio.|Il Nome Della Rosa|Umberto Eco|
|  4|It was a bright, cold day in April, and the clocks were striking thirteen|1984|George Orwell|
|  5|In der Mottengasse elf, oben unter dem Dach hinter dem siebten Balken in dem Haus, wo der alte Eisenbahnsignalvorsteher Herr Gleisenagel wohnt, steht eine sehr geheimnisvolle Kiste.|Lari Fari Mogelzahn|Janosch|

## Code

{: .language-ruby}
    # Returns a personalized salutation string
    def greet(name)
      return "Hey, #{name}! How are you doing?"
    end

    puts greet("Mary")

## List

1. Ordered list
2. With subitems

- Unordered list
- With subitems

## Blockquote

> The path of the righteous man is beset on all sides by the iniquities of the selfish and the tyranny of evil men. Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of darkness, for he is truly his brother’s keeper and the finder of lost children. And I will strike down upon thee with great vengeance and furious anger those who attempt to poison and destroy my brothers. And you will know I am the Lord when I lay my vengeance upon you.[^3]

## Image

[^1]: Foto by [herlitz_pbs](https://www.flickr.com/photos/herlitzpbs/10800093004) released under [CC-BY-ND 2.0](https://creativecommons.org/licenses/by-nd/2.0/)
[^2]: The font has [its own website](http://input.fontbureau.com). It’s worth having a look there.
[^3]: Source: Ezekiel 25:17 or [Pulp Fiction](https://www.youtube.com/watch?v=BdxD8DWt_pU) for your convenience
