---
layout:     blogpost
title:      Asynchronous conditionals
subtitle:   A beginner’s guide to JS promises
date:       2016-01-31
tags:       [javascript, pattern]
permalink:  R9naP/javascript-promises
image:      /assets/2016/love-locks.jpg
---

This blogpost is a beginner’s guide to JS promises. You will learn what a promise is, how you use it and how you avoid some common pitfalls. However, there is one thing, which I don’t have an answer to: The reason, why they are called “promises”. In my opinion it’s just another example where Karlton’s law[^1] has struck again. So, the first step to understand promises is to forget about the name.

## The problem with callbacks

Let’s make an example: If javascript were a synchronous programming language, you could write a database request like this:

{% highlight js %}
try {
  let result = db.find({id: 5});
  // let’s assume, we had defined the process function:
  process(result);
} catch(error) {
  console.log(error);
}
{% endhighlight %}

However, the `db` object is asynchronous, like most things in JavaScript. The main thread will not wait for the `db.find` method to be finished, for which reason the above code sample won’t work. To get around this problem, it was a common pattern to pass a callback function into asynchronous methods as a parameter like this:

{% highlight js %}
db.find({id: 5}, (error, result) => {
  if (error) {
    console.log(error);
  } else {
    process(result);
  }
});
{% endhighlight %}

Why is this bad?

1. **It reads uglily**. Perhaps, this is not the major reason from a technical point of view, but as a programmer you should always aim to write the utmost expressive code possible. In case you cannot, it should set off your alarm bells.
2. **It’s not functional**. A function is meant to receive parameters solely for processing and then *return* something as result. However, the callback parameter is not needed for processing and the function doesn’t return anything. This makes testing a lot more difficult and enforces side effects.
3. You **lose control** over the callback, which contains important business logic after all. Not only that you don’t know what `db.find` actually *does* with your callback; you cannot even be sure, that the callback only gets called once.
4. The **initial callstack is gone**. Since you leave the callback handling to an arbitrary library, you lack the initial context when an error gets thrown or something else goes wrong.
5. This code is the first step towards the so-called **callback hell**. Just imagine, you don’t want to just output the result to the console; instead, you have to read something from a file (asynchronously, of course) and then send both results to a REST API… Perhaps you can envision where this leads to.

## Asynchronous conditionals

Basically, the conditional approach from the first example isn’t that bad. We just need to find a way to make it work for asynchronous actions. This is where promises step in. How does the following code sample read to you?

{% highlight js %}
db.find({id: 5})
.then(process)
.catch((error) => {
  console.log(error);
});
{% endhighlight %}

`db.find` returns a promise object. A promise can have three states:

1. **Unresolved**: The async action hasn’t finished yet.
2. **Resolved**: The async action has finished successfully. For handling that case, we pass a callback to the `then()` method.
3. **Rejected**: An error happened, wherefore the callback passed to `catch` gets invoked.

If you have understood this code sample and the necessity of avoiding the callback pattern, you got the basic idea of promises. Anyway, there are a few more things to know, if you want to use them.

## A view under the hood

Promises are a part of the ES6 standard and so they are built-in natively in JavaScript since then. However, promises aren’t a language feature (like the `let`-keyword for instance), they are just a programming pattern. That means, you could easily implement a promise library by yourself or even adapt this idea to another language.

### Further reading

- A [detailed guide by Nolan Lawson](http://pouchdb.com/2015/05/18/we-have-a-problem-with-promises.html) with best practices and many pitfalls
- Some [Promise anti-patterns](https://github.com/petkaantonov/bluebird/wiki/Promise-anti-patterns) to be aware of

## Perspective: Async functions


[^1]: “There are only two hard things in Computer Science: cache invalidation and naming things.” (Phil Karlton)

*[ES6]: EcmaScript 6
