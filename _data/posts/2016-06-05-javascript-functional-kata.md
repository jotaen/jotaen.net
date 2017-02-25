---
layout:        blogpost
title:         “The discount campaign”
subtitle:      A functional javascript code kata
date:          2016-06-05
tags:          [javascript, kata]
redirect_from: /L2hWc/
permalink:     L2hWc/the-discount-campaign
image:         /assets/2016/aikido-dojo.jpg
---

The term kata originated from martial arts such as Karate. A kata is a sequence of a few dozens of movements (kicks, punches, jumps), which the executor performs against an imaginary opponent. For example, in the Shotokan Karate style there exist 30 different katas. Each one has a different thematic priority and they all share the goal of perfecting the basic techniques and moves.[^1]

The idea of katas was carried forward from martial arts to programming. Basically, the motivation is the same: repeating certain techniques over an over again, thereby training the “muscle memory” and getting into the way of applying patterns better and more efficiently. In programming, there are no standardized katas (as in Karate, for instance), so a whole bunch of different problems are circulating all over the internet. Unlike in Karate, a code kata only describes a problem and maybe impose some constraints on the solution process. However, the solution itself is left open to the programmer, who can put as much creativity into it as she likes to.

# “The Discount Campaign”

I recently started a [repository for JavaScript katas on Github](https://github.com/jotaen/code-katas.js) and want to present the first kata in this blogpost – it is called “The Discount Campaign”. The source code and sample data for this kata be [found on the GitHub repo](https://github.com/jotaen/code-katas.js/tree/master/discount-campaign).

## Problem

The owner of a skateboard shop asks you for help: In order to attract more students and pupils to come to her store, she is about to launch a discount campaign. The idea is to offer a rebate for the period of one month. Since she has a pretty much complete set of customer data, she wants to get an overview over the average revenue within the target group, so that she can calculate a proper discount.

## Task

The customer data can be found in the [`data/customer.json`](https://github.com/jotaen/code-katas.js/tree/master/discount-campaign/data/customer.json) file. This is what the data structure looks like:

{% highlight json %}
[
  {
    "name": "Rebecca Miller",
    "job": "student",
    "age": 29,
    "orders": [
      {"date": "2015-04-12", "total": 59.99},
      {"date": "2014-12-08", "total": 14.95},
      {"date": "2012-09-26", "total": 102.47}
    ]
  }
]
{% endhighlight %}

The conditions for participation for customers are defined as follows:

- The job status of the customer must be one of `student`, `pupil` or `apprentice`
- The age must be 25 or less (the owner does not want to support long term students!)

For the data analysis, all purchases of the calendar year (in this case: 2015) within the target group must be taken into consideration. The shop owner is interested in…

- the revenue aggregated by months (from January 2015 until December 2015)
- the total revenue throughout the entire year 2015

## Technical constraints

It is **not allowed to use control flow statements** to solve this kata: Do not use `if`, `while`, `for`, `do`, `switch`. (Sidenote: `Array.prototype.forEach()` is okay, though.)

# My solution

The [solution I came up with](https://github.com/jotaen/code-katas.js/tree/master/discount-campaign)[^2] is just one possibility to solve this kata. My script generates the following output:

{% highlight text %}
Revenue for students in 2015
----------------------------
Jan:  1155.36 €
Feb:   476.43 €
Mar:  1773.00 €
Apr:  1415.22 €
May:  1208.16 €
Jun:  1454.00 €
Jul:  1607.12 €
Aug:  1317.84 €
Sep:   976.02 €
Oct:   767.35 €
Nov:  1228.07 €
Dec:  1582.14 €
===============
∑    14960.71 €
{% endhighlight %}

Although the whole thing is a command line utility, I consider it to be important to put some thought into the presentation of the calculated result.

- There is a headline and a small description, which provide a minimum of context.
- The list shows the names of the months (instead of bare numbers).
- And – as a small but important detail – the numbers are right aligned.

Let me walk you through the code. First of all, there is the general question how the basic approach looks like: Do I just write a single script? Do I write tests? Am I interested in fiddling around with the data or do I seek for the most straightforward solution?

The answer to all this does not differ from how you would solve real world problems. Of course it is just a kata, but the goal is to practice in a realistic way:

1. There are several levels of abstractions here: data I/O, data transformation, calculation. Each abstraction level is isolated in its own module, resulting in mutiple files.
2. Would I write tests if this were a real world application? Of course I would. Hence I also write tests for this kata.
3. There is a lot to be learned from data. In this case, the data is randomly generated, but despite it’s interesting to modify the parameters and see how they affect the result. Therefore the individual transormation steps should be loosely coupled.

My solution consists of three modules:

### calculate.js
This is where the data transformation takes place and where you can explore the data. It’s super interesting to insert a `console.log` statement, comment out the function chain and then reactivate one function after another and see the data transforming step by step. Moreover, you can try to adjust the parameters: How did the revenue look like in 2014? What if we adjust the age limit? Does it have a big effect, when the discount is only offered to pupils?

### lib.js
This is a generic and reusable library of helper functions, which are used in the `filter`, `map` and `reduce` functions. All these functions are unit-tested and have a super clear API, so that they can be used safely.

### app.js
This is the entry point of the application. Its responsibility is to initiate the calculation and print the results. There is no logic here, instead there are side effects all the more.


[^1]: If you are interested in how a Karate kata looks like, see [this video of Jonathan Mottram](https://www.youtube.com/watch?v=qLmA9r0M8Do) performing the unsu kata.
[^2]: Clone the repo and run `npm start` to see the result. The source files live in `src/`
