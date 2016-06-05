---
layout:        blogpost
title:         “The discount campaign”
subtitle:      A functional javascript code kata
date:          2016-06-05
tags:          [javascript, kata]
redirect_from: /abcdef/
permalink:     abcdef/the-discount-campaign
image:         /assets/2016/aikido-dojo.jpg
---

- What is a code kata?
- Where does the term kata come from?

# The discount campaign

## Problem

The owner of a skateboard shop asks you for help: In order to attract more students and pupils to come to her store, she is about to launch a discount campaign for the new year 2016. The idea is to offer a rebate for the period of one month during January. Since she has a pretty much complete set of customer data, she wants to get an overview over the average revenue within the target group, so that she can calculate a proper discount.

## Task

The customer data can be found in the [`data/customer.json`](data/customer.json) file. This is what the data structure looks like:

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

For the data analysis, all purchases of the current calendar year (2015) within the target group must be taken into consideration. The shop owner is interested in…

- the revenue aggregated by months (from January 2015 until December 2015)
- the total revenue throughout the entire year 2015

As a technical constraint for this kata, there are no control statements allowed: `if`, `else`, `while`, `for`, `do`, `switch` can not be used for the solution. Instead, the kata should be used with a purely functional approach.

# My solution
