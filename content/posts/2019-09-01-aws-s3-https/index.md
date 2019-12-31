+++
title = "Running in circles"
subtitle = "How I spent half a day fixing something that was perfectly fine"
date = "2019-09-01"
tags = ["devops"]
image = "/posts/2019-09-01-aws-s3-https/running-track.jpg"
image_colouring = 310
image_info = "Photo by chuttersnap on Unsplash"
id = "iCb10"
url = "iCb10/running-in-circles"
aliases = ["iCb10"]
+++

Today I spent half of my day running a full circle to rediscover the solution for a problem that I had already solved just fine. What started off as trivial issue went sideways pretty quickly – and that for no reason, as I should find out later. But it’s always easy to know better in hindsight. I’m sharing this story not just in the hope that it’s an entertaining read, but also because it vividly illustrates how misadventure often unfolds as sum of the bumps and scratches that you accumulate while chasing the rabbit down the hole.

Before we dive into it, let me fill you in on some technical background: the subject matter here is this very website (my blog), which is hosted on AWS. The website itself exclusively consists of static files, which are uploaded to an S3 file storage bucket. My domain doesn’t point to this bucket directly, there is a CloudFront CDN in between that I primarily need for SSL encryption (not so much for caching). In brief: if you navigate to my domain, the request goes to CloudFront, which terminates HTTPS and internally forwards the request to S3 to retrieve the content.

If you want to learn more, I recommend you reading [an earlier post](/e7ywT/deploying-static-website-to-aws) in which I outline the design behind my blog in more detail. It’s a neat and robust setup that works quite smoothly. (Well, mostly.)

# Half a day for nothing

This morning, I received an E-Mail from AWS that alerted me about an issue regarding the access policy of my S3 bucket:

> We’re writing to notify you that your AWS account has one or more S3 buckets that allow read or write access from any user on the Internet.

Immediately anticipating the worst case – which would be anonymous write access for everyone – I hastily logged into the AWS web console. For the bucket with my website’s files it read:

> This bucket has public access. You have provided public access to this bucket. We highly recommend that you never grant any kind of public access to your S3 bucket.

My bucket policy indeed allowed everyone to read from it, but that appeared fine to me, since my website is static and all-public anyway. On the other hand, I understood that my setting was unnecessarily broad, since strictly speaking the only single consumer should be the CloudFront CDN. I decided to use this occasion to improve my setup and narrow down the access rights to what was actually needed. Chore time!

It seemed as if the only necessary thing to do was to change the bucket principal from “everyone” to the internal ID of my particular CloudFront CDN. It took a while to accomplish that, because the web UI wouldn’t let me apply this ID. The error message didn’t bother to explain why and so I was clueless whether formatting or an incompatibility was the problem. I looked for corresponding options in CloudFront and fiddled around until (somehow…) the modified bucket policy got accepted.

My initial delight only lasted a brief moment until I received a notification that my entire website went offline[^1]. I assumed the bucket policy to be valid for now, so I went to review what I had modified in the CloudFront configuration. If you haven’t worked with AWS before, let me tell you that the web UI can be a bit tricky sometimes: there are disabled buttons that don’t reveal why that is or what you can do. I also struggled with an erratic form that toggled its entire structure with me failing to understand why. I became confused and my trust in the web UI started to get impaired.

In order to rule out that no stale or funny config state could cause trouble, I decided to re-setup the CloudFront CDN from scratch, just to be on the safe side. I eventually brought the CDN back up and managed to wire it up to S3, including the restricted bucket access mentioned above. The setup was “by the book” using the preconfigured way to connect CloudFront to S3, which the web UI conveniently offered. It finally seemed to work: I saw my home page again.

What didn’t work was clicking on links to subpages, such as individual posts. I quickly figured out that this was related to the way I map URLs to the file system, where I rely on the mechanism of automatically looking up index-files as it is common for other file servers (such as Apache[^2]). This behaviour only seemed to work on root level now, but not for any of the subordinate paths. It dawned me that I had maneuvered myself into a dead end.

Back to square one: I had captured the old CloudFront configuration before discarding it and while carefully comparing it with the new one, I noticed that the S3 URL appeared in a slightly different format, plus that the old config lacked some S3 specific options that the new one offered. This rang a bell – suddenly I remembered me dealing with this very problem 2 years ago. To verify my suspicion I decided to rebuild my old CloudFront configuration. And this time it worked again. (More on that in a second.)

All in all, more than half a day went into this adventure. The only thing that made steady progress was my level of anger and desperation. In the end, it all collapsed like a house of cards: I ended up with the exact same configuration that I had when I started in the morning. The warnings didn’t disappear of course – but now I knew that they were also never meant to.

Here is the gist: Given you use the combination of S3 and CloudFront like I do, and given your website contains `index.html` files in subdirectories that you want to be looked up automatically, then you have to understand these things:

- S3 itself doesn’t care about any index files floating around. There is the “static website hosting” option that provides this behaviour, but don’t be tricked by this being labelled as “property” of the bucket. It doesn’t actually change any of the bucket’s behaviour, instead it is an independent feature that provides a *seperate* webserver interface.
- A CDN also doesn’t care about the presence of index files – which is no surprise, because that’s none of its core business. Nevertheless, CloudFront offers you index-file lookup on the URL root. This is a special option though that only works for root-, not for subdirectories.
- When wiring CloudFront and S3 together, the web UI suggests all available S3 buckets upon setup. But beware: it only lists the S3 interfaces, not the webserver ones, even when these are turned on. The webserver interface URLs need to be found and typed in manually. While both the S3 interface and the webserver interface speak ordinary HTTP, they differ in function as the former is authenticated whereas latter is not. The UI doesn’t give much indication about this, it’s only the URL that appears in different format.
- Only the webserver interface provides the desired index-file lookup across all directories. But: it doesn’t care about authentication or bucket policies at all, so the bucket access policy must grant read access to everyone. That is necessitated by design – and contradicts the warning, which is displayed.

To sum it up: in order to make my use case happen, you have to turn on “static website hosting” on the bucket, allow read access for everyone and connect CloudFront to the respective webserver interface, not to the S3 interface. This is what I already had in the morning and it took me as long to rediscover.

# Lessons learned

Surprise, surprise: it all makes sense afterwards, once you understand the nature of things and think it through. But then again, this doesn’t help you on the battlefield. Anyway, writing this blog post was a good exercise to cheer myself up a little bit from the wasted hours of today’s encounter. Additionally, I hope it prevents me from running into this specific pitfall ever again. In the end, these things happen sometimes. They are not a big deal, but I still think that we can learn something from them. I distilled some takeaways – and as there are always two parties in a conflict, I blame half of them on me and half of them on AWS.

### How I can do better:

- **Don’t underestimate your enemy.** AWS is a powerful beast that is anything but easy-peasy plug-and-play. I have routinely worked with S3, CloudFront and other AWS services a while ago, but haven’t done so in recent months. Therefore, my knowledge was a bit rusted. If you find yourself in a similar situation, take a step back in the beginning to refresh your mind, rather than to roll up the sleeves right away and start digging haphazardly.
- **Write memos to your future self.**[^3] It is crucial to document non-obvious information for future reference. When configurations, systems or code cannot be designed in a straightforward and self-explanatory way, make sure to write up decisions and their underlying reasoning somewhere. Forgetting the nitty-gritty details is all too easy and it’s rarely worth to run into the same troubles more than once.
- **Be prepared when going off-road.** The way I use the CloudFront-S3 tandem for my website is certainly not wildly exotic, but it might be slightly off the “signposted paths”. The more custom something is, the more prone it is to breaking. The risk is on you, but keep in mind that there are often easier alternatives. It’s a balancing act at the end of the day.

### What I wish AWS could do better:

*(Or: what I would do better if I was AWS)*

- **Don’t alert people for nothing.** The warning spoke about “one or more S3 buckets that allow read or write access” and thus advised me to “restrict access”. Since the issue is security-related, I assumed that there is something wrong that needed urgent fixing. It only occurred to me later that the E-Mail was apparently auto-generated and only loosely referring to my actual configuration.
- **Improve the UI models.** Some UI quirks caused serious headache for me. Even though I’m a software developer myself, I often find modern technology complex and intimidating. I am a firm believer, however, that complexity can be tamed and technology can be made accessible in a human-friendly way. This is hard work though: developers and designers have to elaborate a distinct mental model that clearly conveys how things are supposed to be interacted with. I find this to be the most important goal of UI engineering.
- **Level up S3 static hosting.** I don’t know much about S3 internals, but from the outside it seems like the “static website hosting” functionality could be incorporated into the platform in a more reasonable manner. Its current use case is quite specific (and also limited) and the way the feature is designed can cause confusion about its actual capabilities, especially in the interplay with other AWS resources.


[^1]: Just to get that straight: I didn’t bother about downtime here, because this is my private blog. In a professional environment I would have approached this differently.
[^2]: E.g. for the Apache web server, if you request a directory (`/foo`) it would go look for the file `/foo/index.html` and return its content.
[^3]: I actually did document the [AWS setup of my blog](/e7ywT/deploying-static-website-to-aws) back then and I just revised the explanations to make them clearer.
