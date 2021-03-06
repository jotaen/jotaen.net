+++
title = "Asynchronous conditionals"
subtitle = "The idea behind JS promises"
date = "2016-01-31"
tags = ["coding"]
image = "love-locks.jpg"
id = "R9naP"
url = "R9naP/javascript-promises"
aliases = ["R9naP"]
+++

This blogpost is a beginner’s guide to JS promises. You will learn what a promise is, how you use it and how you avoid common pitfalls. However, there is one thing, which I don’t have an answer to: The reason, why these things are called “promises”. Perhaps, they are just another example where Karlton’s law[^1] has struck again. So, the first step to understand promises is to forget about the name for a moment.

## The problem with callbacks

Let’s make an example: If javascript were a synchronous programming language, you could write a database request like this:

```JavaScript
try {
  let result = db.find({id: 5});
  // let’s assume, we had defined the process function:
  process(result);
} catch(error) {
  console.log(error);
}
```

However, the `db` object behaves asynchronously, like many things in JavaScript. The main thread will not wait for the `db.find` method to be finished, for which reason the above code sample won’t work as expected. To get around this problem, it was a common pattern for a long time to pass a callback function into asynchronous methods as a parameter like this:

```JavaScript
db.find({id: 5}, (error, result) => {
  if (error) {
    console.log(error);
  } else {
    process(result);
  }
});
```

Why is this bad?

1. **It reads uglily**. Perhaps, this is not the major reason from a technical point of view, but as a programmer you should always aim to write the utmost expressive code possible. The case that you cannot should set off all your alarm bells.
2. **It’s not functional**. A function is meant to receive parameters, process them and then *return* something as result, which is solely dependent on the input. However, the callback parameter is not needed for processing and the function doesn’t return anything. This makes testing a lot more difficult and introduces unwanted side effects.
3. You **lose control** over the callback, since you leave its handling to an arbitrary library. That’s bad – your callback contains important business logic after all. Not only that you don’t know what `db.find` actually *does* with your callback; you cannot even be sure, that the callback only gets called *once*.
4. The **initial callstack is gone** and you lack much of the context when an error gets thrown or something else goes wrong. There is no way to throw an error back to the main stack.
5. It is the first step towards the so-called **callback hell**. Just imagine our handling is a bit more complex than this single call to the `process` function. Instead, let’s say you additionally have to read something from a file (async, of course) and then send both results to a REST API… Perhaps you can envision where this leads to.

## Asynchronous conditionals

Basically, the conditional approach from the first example isn’t that bad in principle. We just need to find a way to make it work for asynchronous actions. This is where promises step in. How does the following code sample read to you?

```JavaScript
db.find({id: 5})
.then(process)
.catch((error) => {
  console.log(error);
});
```

`db.find` now returns an object; more precisely: a promise object. The code comes quite close to the native `if else` statement and offers a clear API for the actual control flow (which is happening inside the promise). A promise can have three states:

1. **Pending**: The async action hasn’t finished yet.
2. **Resolved**: The async action has finished successfully. For handling that case, we pass a callback to the `then()` method.
3. **Rejected**: An error happened, wherefore the callback passed to `catch` gets invoked.

For understanding the basic idea behind promises, this is all you have to know in the first place.

## A view under the hood

Promises are a part of the ES6 standard and so they are built-in natively in JavaScript[^2]. However, promises aren’t a language feature (like the `let`-keyword for instance), they are just a programming pattern. That means, you could easily implement a promise library by yourself or even adapt this idea to another language.

If you want to work with promises seriously, you are best advised to acquaint yourself with the pattern – you will see, that promises are much more powerful than a bare conditional. And, that there are also a few things, you should better avoid. Here is some further reading on the topic:

- [Full tutorial](https://www.promisejs.org/) on how to write promises yourself
- A [detailed guide by Nolan Lawson](http://pouchdb.com/2015/05/18/we-have-a-problem-with-promises.html) with best practices and many common pitfalls. This is a must-read to gain deeper understanding.
- [Five recommendable patterns](https://remysharp.com/2014/11/19/my-five-promise-patterns) by Remy Sharp
- Don’t think of promises as a callback handling utility! Beware of [common anti-patterns](https://github.com/petkaantonov/bluebird/wiki/Promise-anti-patterns)

## Perspective: Async functions

There is a proposal for ES7, which introduces async functions and the keyword `await`. With that, we eventually have pretty much the same code as in the initial example:

```JavaScript
(async function() {
  try {
    let result = await db.find({id: 5});
    process(result);
  } catch (error) {
    console.log(error);
  }
}());
```

But: this is still experimental by now. Maybe the syntax will change, maybe it won’t make its way into the standard[^3]. Either way, you will have to use a preprocessor (transpiler, compiler, whateveriler) like Traceur or Babel in order to make this code work.


[^1]: “There are only two hard things in Computer Science: cache invalidation and naming things.” (Phil Karlton)
[^2]: For ES6 compatibility, see [this table](https://kangax.github.io/compat-table/es6/)
[^3]: **Update:** Async/await is officially [not part of ES7/ES2016](http://www.2ality.com/2016/01/ecmascript-2016.html)

<!-- *[ES6]: EcmaScript 6 -->
<!-- *[ES7]: EcmaScript 7 -->
