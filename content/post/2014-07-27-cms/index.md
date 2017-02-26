+++
type = "post"
title = "The backside of CMS-ease"
subtitle = "Providing a basis for clients to get along"
date = "2014-07-27"
tags = ["cms", "thoughts"]
image = "/post/2014-07-27-cms/book-stack.jpg"
id = "xba0w"
url = "xba0w/the-backside-of-cms-ease"
aliases = ["xba0w"]
+++

Recently, I got asked to relaunch the website of the [local mountaineers association](http://dav-aachen.de). Their previous website was eventually so broken, that they could hardly maintain it at all. (The CMS was outdated since 6 years!) However, they had a reason for waiting so long and I think this is a good example, which shows, that content management systems also have some backsides.

First, a few words about the situation of my client. In Germany, such associations (which we call “Verein”) are mostly driven by volunteers. Everybody can contribute and participate actively with their skills. The previous website was created by such a volunteer. He setup a CMS and maintained it and everything worked great, until he was not available for the association any longer – with him the website slowly but steadily rusted away. Unfortunately the board didn’t found someone as replacement; on the other hand, they feared this whole situation to start over.

For this project, I worked not only on the relaunch itself, but spent much diligence in establishing a solid basis, that allows to run the website with minimal effort. I wanted to share my thoughts on that topic and cover the major aspects in this article.

[^1]

![Layouts of the new website compared to the print design](/post/2014-07-27-cms/davac-layout.png)

## Basic approach

Even though the CMS-developers contrive to make things easy to use, a CMS is still a complex system. Therefore, after a website is brought to completion and everything is configured, a conscientious hand-over with a subsequent period of support is indispensible without doubt. (This is usually offered as “training”.) To be honest, I think, one should not attach too much importance to this. Instead, things should be put on the right track much earlier.

Let’s think of an example: I often experienced, that people still write their letters in Arial (or Calibri, or whichever is the default font in their word processor) and put their logo someplace it just fits, although they have a tailor-made corporate design in their drawer. I am convinced, that everybody has in some way a sense for the consistency of design and structure. In fact, most people mind about design more than they actually suppose they would. However, it is a long road between just recognising a corporate identity on the one hand, and producing a compliant and appropriate document on the other. I would argue, that 95% of all people worldwide are not consciously aware of the difference between Arial and a font like Univers. Nevertheless, all of them would be able to distinguish a professionally designed document from a “homemade” one.

What does all this mean in the terms of a CMS? It means, that the client possibly does not come with the attitude to fundamentally understand the CMS and become a somewhat expert. Of course they are fascinated by the cool backend interface and all the features, which it offers. But in the end, they just want to have their things get done, without bothering themselves too much with the system itself. And this is a perfectly reasonable approach you cannot blame anyone for. Actually, the opposite is true: Regardless of what the client <i>says</i> he would need, the developer is in duty of figuring out, what his needs are in fact and, even more important, what he is capable to maintain on long term basis. The basic approach of the whole developement process must focus on this question – and perhaps in the end a static website turns out to be a far more viable choice instead of a CMS, which needs to be understood, maintained and supplied with content. There are just yet too many websites out there, where the last contribution in the “news” section is anything – except new.

## Focussing on use cases

In case of this website project, we sat down together and worked out a list of actual use cases, which covered about 90% of all expected regular tasks. In the end, this list contained seven items and I strived upon making these workflows as convenient and clear of tripping hazards as possible. For example, I freed the backend interface from unnecessary distractions by removing all unused options. (If the template is not configured to show the address of a contact, why should the backend offer a formfield for this?) Also, I stripped down the built-in text editor, so that it is not allowed to use anything else than a small selection of predefined styles. (Because when there *is* a button for choosing the font color, people will use it.)

In order to make things replicable it suggests itself to write documentation. Documentation is a killer argument, because everyone wants to have it. The trouble is, that nobody does want to read it. As a consequence, documentation must be as short and as practical as possible. When focussing on use cases this can be best accomplished with checklists. These show up, e.g. when writing a news article, and remind the client in brief points, what a news article must look like. The phrasing is result-oriented, so the client can go over the list and easily compare, whether the assertations apply or not. If so, he can publish and has at the same time the acknowledgement, that his work is appropriate.

## Third-party components

There is a massive choice of third-party components, which you can conveniently scroll through in the embedded extension gallery of the CMS-backend. And the installation couldn’t be easier, since there are only two clicks required to install them. However, components do not only differ in the length of their feature list; there are a few other things to considerate apart from it:

- The **code quality** varies significantly (like otherwise noticeable in the PHP ecosystem). There are some addons, which have an empurpled description, but when you open the source code you are wondering why it is actually working at all. The contrary extreme are obviously professionally engineered and tested addons, which are, on the downside, often stripped down free versions of commercial products and their vendors have a reasonable interest in making you purchase them.
- Another thing are **support and updates**: This is often forgotten in the early stages, but can turn out to be a severe problem later, for example, when the developer of a particular component doesn’t pursue his project any more. That brings you on the spot to replace it, which means, you will have to migrate all the according data by hand. If you would just ignore the problem, you run into the danger that this single component keeps the whole system from being updated.

In this particular project, I made a preselection of components and discussed the assets and drawbacks with my client. It turned out to be a valuable option for them to pay for commercial upgrades and support in the future. As a consequence I solely chose such components, since these offered the best basis to long-rangingly rely upon. In general, I think it is worthwhile to seek for solutions using the own means of the CMS in the first place, before installing too much unnecessary components undeliberately – even if these are better adapted for a particular task.


[^1]: Showcase: The [redesigned website](http://dav-aachen.de) of my client goes quite well with the previously existing print layouts (on the right)
