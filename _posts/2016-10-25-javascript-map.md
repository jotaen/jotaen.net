---
layout:        blogpost
title:         The map method
subtitle:      Exploring functional javascript
date:          2016-10-25
tags:          [javascript, functional programming, code]
redirect_from: /PzmvA/
permalink:     PzmvA/javascript-map
image:         /assets/2016/topographic-map.jpg
---

A few weeks ago I published a blogpost in which I presented a [functional code kata in Javascript](/L2hWc/the-discount-campaign) and explained how I solved it using build-in Javascript methods (e.g. `Array.prototype.map`). However, it is worth to have a look at different implementations of these concepts in third party libraries, because there are slight but important differences.

In this blogpost, we have a closer look at the `map` function. First of all: What is `map` actually? It is a function that takes an iterable (e.g. an array) as argument and applies a callback on each of the containing values. The original data doesn’t get mutated, instead the result is returned as a new value.

{% highlight javascript %}
const square = (n) => n * n
const numbers = [1, 2, 3]

const result = numbers.map(square)
console.log(result) // [1, 4, 9]
{% endhighlight %}

In general, all objects, where `map` can be invoked on, are called *functors*. So, in this case, `numbers` is a functor, because it can be mapped over.

Let’s compare three different implementations of `map`: The one, that comes on the array prototype (shown in the example above) and the ones from [lodash](https://lodash.com/docs/#map) and [Ramda](http://ramdajs.com/docs/#map).

# Basic usage

All three `map` implementations come with a different signature:

{% highlight javascript %}
const _ = require('lodash')
const R = require('ramda')

const square = (n) => n * n
const numbers = [1, 2, 3]

// standard Javascript:
numbers.map(square) // => [1, 4, 9]

// lodash:
_.map(numbers, square) // => [1, 4, 9]

// Ramda: (both ways are possible)
R.map(square, numbers) // => [1, 4, 9]
R.map(square)(numbers) // => [1, 4, 9]
{% endhighlight %}

# Data structures

One major difference are the types, that can be mapped over and the types that get returned. In standard Javascript, the `map` method is exclusively available on the `Array` prototype, so it is not possible to apply this functionality to an object or any other value – at least not without transforming them to an array upfront.

This is, where both lodash and Ramda take a more powerful approach: They can handle other types, lodash even supports `null` and `undefined`. However, they behave a bit differently in the data structure that they return. lodash consistently returns an array, no matter what you input. Ramda on the other hand keeps the original structure in the certain case where the functor is an object.

{% highlight javascript %}
// Object
const prices = {shoes: 60, pants: 80}
const applyRebate = (o) => o * 0.5
_.map(prices, applyRebate) // => [30, 40]
R.map(applyRebate, prices) // => {shoes: 30, pants: 40}

// String
const name = 'Peter'
const uppercase = (s) => s.toUpperCase()
_.map(name, uppercase) // => ['P', 'E', 'T', 'E', 'R']
R.map(uppercase, name) // => ['P', 'E', 'T', 'E', 'R']

// Undefined
const identity = (x) => x
_.map(undefined, identity) // => []
R.map(identity, undefined) // => ERROR!
{% endhighlight %}

# Currying

A basic feature of Ramda is that functions can be curried. That means, you don’t need to pass all arguments at once, but you can pass them one after the other in subsequent calls. The actual function body is invoked just with the last call. That way, it is possible to “configure” functions and pass them around. Currying is the main reason why Ramda has a different order of the arguments (compared to lodash or `Array.prototype`).

{% highlight javascript %}
const square = (n) => n * n
const numbers = [1, 2, 3]

const squareMap = R.map(square)
console.log(typeof squareMap) // => function

squareMap(numbers) // => [1, 4, 9]
{% endhighlight %}

Currying looks somewhat magical at the first glance, but when you have a closer look, it is a rather simple concept that allows higher decoupling and composability of code. Let’s consider the `applyRebate` function above, where the rebate of `0.5` was hardcoded. We could improve this by making `applyRebate` a higher-order function[^1] that can be curried.

{% highlight javascript %}
const applyRebate = (percent) => (value) => percent * value
const prices = {shoes: 60, pants: 80}

R.map(applyRebate(0.5), prices)
_.map(prices, applyRebate(0.5))
{% endhighlight %}

# What’s next?

The comparisons spotted in this blogpost show the most basic and obvious differences between standard Javascript, lodash and Ramda. But there still remain (as usual) certain edge cases, that you may stumble across some time. One is pointed out in [this piece written by Reg Braithwaite](https://github.com/raganwald-deprecated/homoiconic/blob/master/2013/01/madness.md).


[^1]: Functions that take another function as argument or return one are called “higher-order function”. This is also referred to as “function as data”.
