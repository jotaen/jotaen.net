+++
id = "styleguide"
type = "post"
title = "Living styleguide"
subtitle = "The Haute Couture of my blogposts"
date = "2014-12-27"
tags = ["meta"]
image = "/fashionshow.jpg"
image_info = "Foto by herlitz_pbs (https://www.flickr.com/photos/herlitzpbs/10800093004) released under CC-BY-ND 2.0 (https://creativecommons.org/licenses/by-nd/2.0/)"
+++

The header section above is a container which takes up ~40% vertical space. It is intended to show a full size image. The headline (and subheadline) for the blogpost is centered and the letters have one of the available colors (see below) as background.

# Basic styling

## Typography

The font face has a technical look goes nicely with this blog, whose topics cover coding and technology mainly. The font is called “input” and was created by David Jonathan Ross[^1]. The fact that it comes with a whole bunch of different styles is a strong advantage, since typography is the most important stylistic device on text-heavy sites. However, because using webfonts is also a matter of frontend performance, just the following styles are included:

- Regular text: Input Sans Condensed 300 (regular & italic)
- Strong text: Input Serif Compressed 700 italic (regular & italic)
- Captions: Input Sans Compressed 300 (italic)
- Code: Input Sans Mono Narrow 300 (regular)

## Inline styles

- **Bold text is not just bold**, it uses the serif typeface additionally.
- *This is italic (or: obligue) text*
- The <a href="#foo" onclick="return false" class="link">Weblinks</a> come in blue and underlined; <a href="#foo" onclick="return false" class="link--visited">visited websites</a> are colored purple. Unfortunately, the latter has come a bit out of fashion, but I consider it to be a very important feature – isn’t the web all about links?
- Then, `there is inline code`, which has a light grey background and is – wait for it… – monospaced.
- Lastly, although not an actual inline style, all text selection is brown. Try it out!

## Colors

<p style="background-color:#5a3e35;text-align:center;color:#fff;">brown: #5a3e35</p>
<p style="background-color:#8d1699;text-align:center;color:#fff;">purple: #8d1699</p>
<p style="background-color:#0d668d;text-align:center;color:#fff;">blue: #0d668d</p>
<p style="background-color:#c0253e;text-align:center;color:#fff;">red: #c0253e</p>
<p style="background-color:#f34c17;text-align:center;color:#fff;">orange: #f34c17</p>
<p style="background-color:#65c858;text-align:center;color:#000;">green: #65c858</p>
<p style="background-color:#cac43b;text-align:center;color:#000;">yellow: #cac43b</p>

# Block elements

## Table

|Nr.|First Sentence|Book|Author|
|--:|--------------|----|------|
|  1|Als Gregor Samsa eines Morgens aus unruhigen Träumen erwachte, fand er sich in seinem Bett zu einem ungeheueren Ungeziefer verwandelt|Die Verwandlung|Franz Kafka|
|  2|Stately, plump Buck Mulligan came from the stairhead, bearing a bowl of lather on which a mirror and a razor lay crossed.|Ulysses|James Joyce|
|  3|In principio era il Verbo e il Verbo era presso Dio, e il Verbo era Dio.|Il Nome Della Rosa|Umberto Eco|
|  4|It was a bright, cold day in April, and the clocks were striking thirteen|1984|George Orwell|
|  5|In der Mottengasse elf, oben unter dem Dach hinter dem siebten Balken in dem Haus, wo der alte Eisenbahnsignalvorsteher Herr Gleisenagel wohnt, steht eine sehr geheimnisvolle Kiste.|Lari Fari Mogelzahn|Janosch|

## Code

[^2]

{% highlight ruby %}
# Returns a personalized salutation string
def greet(name)
  return "Hey, #{name}! How are you doing?"
end

puts greet("Mary")
{% endhighlight %}

## List

1. Ordered list
2. Another list item
3. Third list item

- Unordered list
- Another list item
- Third list item

## Image

[^3]

![Abseiling from the salbit summit needle in the swiss alps](/salbit.jpg)

## Blockquote

[^4]

> The path of the righteous man is beset on all sides by the iniquities of the selfish and the tyranny of evil men. Blessed is he who, in the name of charity and good will, shepherds the weak through the valley of darkness, for he is truly his brother’s keeper and the finder of lost children. And I will strike down upon thee with great vengeance and furious anger those who attempt to poison and destroy my brothers. And you will know my name is the Lord when I lay my vengeance upon thee.

[^1]: Check out the [website](http://input.fontbureau.com), it’s worth having a look there.
[^2]: Some fancy ruby code…
[^3]: Abseiling from the salbit summit needle in the swiss alps
[^4]: Source: Ezekiel 25,17 (in the [Pulp Fiction](https://www.youtube.com/watch?v=BdxD8DWt_pU) translation)
