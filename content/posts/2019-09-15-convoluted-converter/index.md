+++
draft = true
title = "“The convoluted converter”"
subtitle = "A refactoring in 10 steps, guided by coding principles"
date = "2019-09-15"
tags = ["coding"]
image = "/drafts/2018-10-21-testing/puzzle.jpg"
image_info = ""
id = "0K2pE"
url = "0K2pE/clean-code-refactoring-kata"
aliases = ["0K2pE"]
+++

押忍 – welcome to my coding dojo! I hope you are well warmed up. Today we will go through a refactoring code-kata together, in which we take a piece of nasty “legacy” code and turn it into something nice. We gradually walk through the refactoring process in 10 steps, where every step is guided by a coding principle that we apply in order to transform the implementation as we go along.

Before we dive into code though, here is some context: The subject matter is a CLI application that goes by the catchy name `convr.js`. (As you can guess it is written in JavaScript and runs on NodeJS, but there is no in-depth knowledge required.) The purpose of the CLI tool is to convert different number formats from one base to another. Here is how you can use it:

```shell
$ node convr.js -hex 32335
> 0x7e4f

$ node convr.js -bin 0x8c
> 0b10001100

$ node convr.js -dec 0b1100
> 12
```

As you can see, the app takes two arguments: the first one specifies the desired target format and the second one represents the input value. The target format must be one of `-dec`, `-bin`, `-hex` and the format of the input value is detected automatically by means of the prefix. `0x` means hexadecimal, `0b` means binary and no prefix means decimal. The returned output adheres to this notation likewise. Furthermore, the app gracefully handles error cases, e.g. unknown target options, invalid input number formats or a wrong argument count.

Our task is to take the current implementation of this app and perform a non-functional refactoring. The goal is to improve code quality without changing behaviour or functionality. If you want to fiddle around with the app yourself, you find the sources [on Github](https://github.com/jotaen/coding-dojo/tree/master/convoluted-converter) along with some instructions how to run it. I also provided a [code browser](/posts/2019-09-15-convoluted-converter/steps/#original) that every refactoring step is linked to, which lets you conveniently skip back and fourth between the coding stages to get the full picture.

# The app

Buckle up, here comes our enemy:

```js
try {
  if (process.argv.length === 4) {
    const target = process.argv[2];
    const input = process.argv[3];
    if (target === "-bin" || target === "-hex" || target === "-dec") {
      if (/^(0b[01]+|0x[0-9a-fA-F]+|0|[1-9]\d*)$/.test(input)) {
        let decimal;
        const prefix = input.substr(0, 2);
        if (prefix === "0b") decimal = parseInt(input.substr(2), 2);
        else if (prefix === "0x") decimal = parseInt(input.substr(2), 16);
        else decimal = parseInt(input);
        if (target === "-bin") console.log("0b" + decimal.toString(2));
        else if (target === "-hex") console.log("0x" + decimal.toString(16));
        else console.log(decimal.toString());
      } else {
        throw "Input number invalid";
      }
    } else {
      throw "Target option invalid";
    }
  } else {
    throw "Wrong number of arguments";
  }
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

The algorithm in prose:

1. Check the process arguments: 2 of them are always given by NodeJS and we expect 2 from the user, which makes for a total of 4.
2. Check the first argument (`target`), to see whether it’s one of the three valid options.
3. Check the second argument (`input`) against a regular expression, to see whether it’s one of the three recognised formats. (They are divided by `|` characters, where `0b[01]+` is binary, `0x[0-9a-fA-F]+` is hexadecimal, `0|[1-9]\d*` is decimal.)
4. Extract the prefix and compute the decimal representation of the input number.
5. Translate the decimal representation into the desired target form and print it.
6. In all other cases, print appropriate error messages and exit the program with status code `1`.

# The refactoring

## #0. Make it work, make it right, make it fast

We are tasked with the refactoring of the innards of an existing application, without changing any of its behaviour. Hence, we should better say: “Keep it working, keep it right, keep it fast”. Or in other words: we must make sure to not accidentally introduce a performance- or feature-regression. This principle is numbered with “0” because it is a premise of our whole endeavour. There is no point in pondering about the style of code when we can’t be sure it’s functioning correctly.

For conducting a safe and stress-free refactoring we need sufficient test coverage. In our case it suggests itself to setup a collection of of end-to-end tests, that examine the CLI application as a whole. The performance can be measured by spot-checking various larger input values before and after. (A comprehensive benchmark is probably overkill here.)

For your convenience, I provided a [suite of end-to-end tests](https://github.com/jotaen/coding-dojo/blob/master/convoluted-converter/test.js) with the most important use cases. It is deliberately setup in a property-based manner, which makes it easy to turn the suite into unit tests later on. During the refactoring, we can run the test suite after every step, thus making sure that we only move tiny and safe increments as we “go further out on the limb”. (All stages that you see in the [code browser](/posts/2019-09-15-convoluted-converter/steps/#original) are satisfying the tests, by the way.)

## #1. Divide and conquer[^1]

There are a multitude of things that spring to mind when reading the original program code. But we cannot do all at once. The first step is to break down the code-monolith into manageable pieces that we can approach independently.

The initial goal is to bring the basic structure to light. That is: pulling up the innermost part into a separate function and extracting some constants. This is simple copy-and-paste for the most part, without touching the statements on a functional level. That results in mainly two code sections, the upper “conversion block” (`convert`) and the lower “main block” (the `try`/`catch`). Apart from that, there are two constants (`options`, `inputShape`) that seem associated with the “main block”.

```js
const convert = (target, input) => {
  let decimal;
  const prefix = input.substr(0, 2);
  if (prefix === "0b") decimal = parseInt(input.substr(2), 2);
  else if (prefix === "0x") decimal = parseInt(input.substr(2), 16);
  else decimal = parseInt(input);
  if (target === "-bin") return "0b" + decimal.toString(2);
  else if (target === "-hex") return "0x" + decimal.toString(16);
  else return decimal.toString();
};

const options = ["-bin", "-hex", "-dec"];
const inputShape = /^(0b[01]+|0x[0-9a-fA-F]+|0|[1-9]\d*)$/;

try {
  if (process.argv.length === 4) {
    const target = process.argv[2];
    const input = process.argv[3];
    if (options.includes(target)) {
      if (inputShape.test(input)) {
        const result = convert(target, input);
        console.log(result);
      } else {
        throw "Input number invalid";
      }
    } else {
      throw "Target option invalid";
    }
  } else {
    throw "Wrong number of arguments";
  }
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

## #2. Maximise cohesion[^2]

Let’s focus on the “main block”: its readability suffers from the nested `if` statements, where corresponding code (namely `if` and `else`) is divided by multiple lines of unrelated statements in between. A common way of improving this is to negate the conditions and to make the code path flat and linear. This pattern is sometimes referred to as “early return”. It pushes the so-called “happy path” (the actual conversion) from somewhere in the thick of it down to the very end of the code block and exposes it prominently on first indentation level.

```js
try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const target = process.argv[2];
  if (!options.includes(target)) {
    throw "Target option invalid";
  }
  const input = process.argv[3];
  if (!inputShape.test(input)) {
    throw "Input number invalid";
  }
  const result = convert(target, input);
  console.log(result);
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

## #3. Schödinger variables[^3]

Here is how the “conversion block” currently looks:

```js
const convert = (target, input) => {
  let decimal;
  const prefix = input.substr(0, 2);
  if (prefix === "0b") decimal = parseInt(input.substr(2), 2);
  else if (prefix === "0x") decimal = parseInt(input.substr(2), 16);
  else decimal = parseInt(input);
  if (target === "-bin") return "0b" + decimal.toString(2);
  else if (target === "-hex") return "0x" + decimal.toString(16);
  else return decimal.toString();
};
```

There is an issue with how the variables are initialised. `decimal` is declared empty and given a value only at some later point. `prefix` is initialised with a value, but in case `input` is a decimal number this value is completely arbitrary and doesn’t mean anything. Both these things are not good practice, even if they don’t cause actual problems in this very case.

The situation is similar to Schrödinger’s cat: you need to open the box to see whether the cat is dead or alive. For us, the possibilities are worse though, because we can’t even be sure that we will find a cat at all. Maybe the box is empty. Or it contains a dog instead. Or a cad. Anyway. Imagine variables to be labelled boxes that contain something. If a variable is called “cat” then it should invariably reference a cat and nothing else. If a variable is called “cat” and references either a cat or nothing, then you are facing a “Schrödinger variable”.

It is pivotal to be uncompromisingly pedantic about variable management, especially in a dynamically typed language like JavaScript. Being sloppy can produce a remarkable amount of complexity and results in implicit interdependences that are terrible to work with. That often leads to brittle code and a defensive programming style. A variable declaration should always coincide with its value definition and hold a meaningful value from the very beginning over its entire lifecycle.

In our code, this can be achieved by pulling out a function, so that the assignment of `decimal` becomes an atomic operation. By using `switch` instead of `if`/`else` there is no need for an auxiliary variable anymore.

```js
const toDecimal = (input) => {
  switch(input.substr(0, 2)) {
    case "0b": return parseInt(input.substr(2), 2);
    case "0x": return parseInt(input.substr(2), 16);
  }
  return parseInt(input);
};

const convert = (target, input) => {
  const decimal = toDecimal(input);
  if (target === "-bin") return "0b" + decimal.toString(2);
  else if (target === "-hex") return "0x" + decimal.toString(16);
  else return decimal.toString();
};
```

## #4. Conditional complexity[^4]

There are two conditionals in our “conversion block” that each have 3 possible branches. That makes for a total of 9 possible execution paths through the method. (Side note: this number is not fixed, but it will grow linearly as we add conversion options to our program.) The multitude of `return` statements adds to this and is also a common origin of bugs. (Just imagine you accidentally drop one.)

This complexity is inherent in our application, so we cannot make it go away. We can alleviate working with it though, because using `if`, `else` or `switch` allows for more flexibility than we need. On the contrary: our conditionals follow a very uniform schema and can be expressed in a very succinct way instead. We can group the different cases in an object (`targetConverters`) and execute a dynamic lookup based on the first two characters of `input`.

```js
const targetConverters = {
  "-bin": d => "0b" + d.toString(2),
  "-hex": d => "0x" + d.toString(16),
  "-dec": d => d.toString(),
};

const inputConverters = {
  "0b": i => parseInt(i.substr(2), 2),
  "0x": i => parseInt(i.substr(2), 16),
  "": i => parseInt(i)
};

const convert = (target, input) => {
  const toDecimal = inputConverters[input.substr(0, 2)] || inputConverters[""];
  const decimal = toDecimal(input);
  return targetConverters[target](decimal);
};
```

This is similar to “pattern matching”, a technique that has been made popular by functional programming languages. It often is a good way to delineate the exact differences and similarities between various branches that can then be leveraged further.

## #5. Don’t repeat yourself[^5]

`targetConverters` and `inputConverters` contain redundant code. Their procedures are almost the same, apart from the “decimal” conversion that lack one argument in both cases. Upon closer look, however, we see that this missing argument defaults to `10` and can of course be also made explicit. This allows us to extract the redundant procedure calls and to handle their parametrisation programatically. The converter objects can thus be unified and boiled down to plain data. The retrieval of `inputConverters` must be adjusted to the new structure, of course.

```js
const converters = {
  "-bin": {base: 2, prefix: "0b"},
  "-hex": {base: 16, prefix: "0x"},
  "-dec": {base: 10, prefix: ""},
};

const convert = (target, input) => {
  const inputConverter = Object.values(converters)
    .find(c => c.prefix === input.substr(0, 2)) || converters["-dec"];
  const decimal = parseInt(
    input.substr(inputConverter.prefix.length),
    inputConverter.base
  );
  const targetConverter = converters[target];
  return targetConverter.prefix + decimal.toString(targetConverter.base);
};
```

There is also an opportunity to reduce repetition in the “main block” now. We don’t need to maintain a separate array with `options` for validating the `target` argument anymore. Instead, we can can draw upon the keys of the `converters` object. That is:

```js
// Now:
  const target = process.argv[2];
  if (!Object.keys(converters).includes(target)) {
    throw "Target option invalid";
  }

// Instead of:
  const options = ["-bin", "-hex", "-dec"];
  /*    [...]
   */
  const target = process.argv[2];
  if (!options.includes(target)) {
    throw "Target option invalid";
  }
```

## #6. Open-closed principle[^6]

The problem of redundancies is not solved yet – it is not immediately obvious anymore though. It becomes clear when you imagine we wanted to add a fourth conversion to the programm. This would still require us to touch 2 different places at the moment: `converters` and the `inputShape` regex for input validation. Furthermore, the prefix length is hard-coded and there is a special case for `"-dec"`. Needing to keep track of all this while extending the program puts a big burden on future maintainers. It’s all too easy to forget about just one of these aspects, so we better make sure to avoid the problem by design.

A good way of thinking of our specific conversion mechanisms is to perceive them as “plugins”. Every plugin embodies a specific variant of an otherwise self-reliant and impartial program. The program only depends on the plugin interface and every plugin implementation fully encapsulates its specific idiosyncracy. (In a class-based language we could express that more concisely by using interfaces.)

The previous step already indicated that this approach basically works, so we can try to push it further now. We chop up the big regular expression (`inputShape`) and allot its parts to the converter plugins. That also requires to adjust the respective algorithm for the validation, which happens to kill two birds with one stone: validation now coincides with finding the right input converter. We can pass it to `convert` and thereby eliminate the hard-coded prefix size as well as the special fallback case for `"-dec"`.

```js
const converters = {
  "-bin": {prefix: "0b", base: 2, shape: /^0b[01]+$/},
  "-hex": {prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]+$/},
  "-dec": {prefix: "", base: 10, shape: /(^0|[1-9]\d*)$/},
};

const convert = (inputConverter, target, input) => {
  const decimal = parseInt(
    input.substr(inputConverter.prefix.length),
    inputConverter.base
  );
  const targetConverter = converters[target];
  return targetConverter.prefix + decimal.toString(targetConverter.base);
};

try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const target = process.argv[2];
  if (!Object.keys(converters).includes(target)) {
    throw "Target option invalid";
  }
  const input = process.argv[3];
  const inputConverter = Object.values(converters).find(p => p.shape.test(input));
  if (!inputConverter) {
    throw "Input number invalid";
  }
  const result = convert(inputConverter, target, input);
  console.log(result);
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

The implementation of `convert` is now a fully generic algorithm that is unaware of peculiarities of specific converters.

## #7. Separation of concerns[^7]

Our program already reads very clear. However, in the “main block” we still mix side-effects (such as printing via `console.log` or accessing the runtime environment via `process.argv`) with business logic (such as finding an applicable converter plugin). These are different concerns that are mingled in one scope, which is not just ugly, but it also makes the code structure harder to navigate.

On top of that, passing both `inputConverter` and `input` to the convert function is redundant – it is possible to derive the appropriate converter plugin from the input value after all. And last but not least, why is `inputConverter` fetched in the “main block”, whereas `targetConverter` is obtained in `convert`? We need to clean this up and it suggests itself to make validation a concern of the “conversion block”.

```js
const converters = {
  "-bin": {prefix: "0b", base: 2, shape: /^0b[01]+$/},
  "-hex": {prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]+$/},
  "-dec": {prefix: "", base: 10, shape: /(^0|[1-9]\d*)$/},
};

const convert = (target, input) => {
  const inputConverter = Object.values(converters).find(p => p.shape.test(input));
  if (!inputConverter) {
    throw "Input number invalid";
  }
  const targetConverter = converters[target];
  if (!targetConverter) {
    throw "Target option invalid";
  }
  const decimal = parseInt(
    input.substr(inputConverter.prefix.length),
    inputConverter.base
  );
  return targetConverter.prefix + decimal.toString(targetConverter.base);
};

try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const target = process.argv[2];
  const input = process.argv[3];
  const result = convert(target, input);
  console.log(result);
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

`convert` has gained error handling as additional responsibility. That is fine, since validation is tightly coupled to finding the right converter plugins obviously. We wouldn’t win much by keeping both strictly separate – and we still have the option to break up `convert` into smaller pieces, if we find it too messy.

The “main block” is now left with all and only the dirty stuff: reading in the runtime environment, managing the processing and printing to the CLI. The pure code has been completely migrated to the “conversion block”. Having isolated the side-effects is a big win. (Spoiler: apart from one tiny adjustment, we won’t need to touch the “main block” anymore.)

## #8. Hello again, Schrödinger variables[^8]

Some nasty Schrödinger variables have sneaked in again: `inputConverter` and `targetConverter` may or may not contain what they promise and are thus guarded with a subsequent check to guarantee the integrity of the following code. Falling back to a default value is not possible here (like we did earlier with `... || converters["-dec"]`) – we want abort the operation by throwing an error message. In any event, we need to make sure that the assignment of the variables is either unconditionally successful or strictly prevented altogether.

```js
const convert = (target, input) => {
  const inputConverter = Object.values(converters).find(p => p.shape.test(input))
    || (() => {throw "Input number invalid"})();
  const targetConverter = converters[target]
    || (() => {throw "Target option invalid"})();
  const decimal = parseInt(
    input.substr(inputConverter.prefix.length),
    inputConverter.base
  );
  return targetConverter.prefix + decimal.toString(targetConverter.base);
};
```

Editor’s note: JavaScript wouldn’t allow a naked `throw` statement here, so we have to wrap it into a function. What you see is a so called “immediately invoked function expression”, that is an inlined lambda function, which is called right away. Unfortunately we don’t have anything similar to `java.lang.Optional` in JavaScript yet, so the techniques shown in this post are somewhat good alternatives to achieve analogous effects. (There are third-party libraries available of course.)

## #9. Make the domain model shine[^9]

The overall structure of our code is pretty nice now and the business part has been fully separated from the application part. However, the former (the “conversion block”) is characterised by an unexpressive, rather technical language:

- The name “converter” is not quite right, because a converter doesn’t actually do anything actively. It also leaves you in the dark about what it *is about* in particular.
- The variable name “decimal” is redundant, since `parseInt` returns a decimal number *by definition*. Also, this name doesn’t reveal anything new about *the reason* why we use this variable.
- The keys in the `converters` dictionary should not know how CLI options are formatted. The design of the domain should rather be agnostic about the nature of any outer context.

All those aspects indicate that we haven’t created a meaningful domain model yet that would reflect the language of the business. A good exercise to get clarity on that business language is to imagine how we would explain the core algorithm to a non-technical person. That narrative could sound like this:

> Here is how we convert a number: first we figure out what number systems we need to convert between. We normalise the input number to an intermediate form. Then, we translate the intermediate value to the desired target number system.

What does that mean in regards to our three findings above?

- What we called “converter” (or “converter plugin”) is actually a “number system”. This also appropriately reflects that it is a passive container, which only holds information.
- What we called “decimal” is actually an “intermediate” form. The fact that it is decimal is an unimportant detail.
- Instead of dealing with CLI options in the domain, we give them names that they can be identified by. For consistency, we also rename `target` to `targetName`.

```js
const numberSystems = [
  {name: "bin", prefix: "0b", base: 2, shape: /^0b[01]+$/},
  {name: "hex", prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]+$/},
  {name: "dec", prefix: "", base: 10, shape: /(^0|[1-9]\d*)$/},
];

const convert = (targetName, input) => {
  const inputNS = numberSystems.find(n => n.shape.test(input))
    || (() => {throw "Input number invalid"})();
  const targetNS = numberSystems.find(n => n.name === targetName)
    || (() => {throw "Target option invalid"})();
  const intermediate = parseInt(
    input.substr(inputNS.prefix.length),
    inputNS.base
  );
  return targetNS.prefix + intermediate.toString(targetNS.base);
};
```

Matching up CLI args with the converter names is not responsibility of the domain. In order to obtain `targetName`, we must simply strip of the initial `-` character from the process argument in the “main block”:

```js
const targetName = process.argv[2].substr(1);
```

## #10. Single level of abstraction[^10]

There is still something off with `convert`: On the one hand, we established expressive high-level domain terms like “number system” and “intermediate” form. On the other hand, we perform low-levelled operations like converting types (`parseInt`, `toString`) and tinkering around with strings (`substr`, `+`). That doesn’t play nicely together.

You might have noticed earlier that our business narrative used the terms “normalise” and “translate” do discern both operations, but we don’t see this reflected in the code language yet. It turns out that there is the opportunity to fill two needs with one deed by extracting two functions with those names, which also happen to encapsulate our low-levelled computations at the same time. As a result, the exposed abstraction level in `convert` becomes much more consistent.

```js
const normalise = (ns, input) => parseInt(input.substr(ns.prefix.length), ns.base);
const translate = (ns, intermediate) => ns.prefix + intermediate.toString(ns.base);
const convert = (targetName, input) => {
  const inputNS = numberSystems.find(n => n.shape.test(input))
    || (() => {throw "Input number invalid"})();
  const targetNS = numberSystems.find(n => n.name === targetName)
    || (() => {throw "Target option invalid"})();
  const intermediate = normalise(inputNS, input);
  return translate(targetNS, intermediate);
};
```

# The result

Let’s see it all together:

```js
const numberSystems = [
  {name: "bin", prefix: "0b", base: 2, shape: /^0b[01]+$/},
  {name: "hex", prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]+$/},
  {name: "dec", prefix: "", base: 10, shape: /(^0|[1-9]\d*)$/},
];

const normalise = (ns, input) => parseInt(input.substr(ns.prefix.length), ns.base);
const translate = (ns, intermediate) => ns.prefix + intermediate.toString(ns.base);
const convert = (targetName, input) => {
  const inputNS = numberSystems.find(n => n.shape.test(input))
    || (() => {throw "Input number invalid"})();
  const targetNS = numberSystems.find(n => n.name === targetName)
    || (() => {throw "Target option invalid"})();
  const intermediate = normalise(inputNS, input);
  return translate(targetNS, intermediate);
};

try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const targetName = process.argv[2].substr(1);
  const input = process.argv[3];
  const result = convert(targetName, input);
  console.log(result);
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

In order to assess the success of this refactoring, we can compare the refactored version to the original one. Here are five reasons why the new version is better:

- It is easier to navigate: the main concerns are separated by means of a layered code structure.
- It is easier to understand: we established consistent abstractions and meaningful naming.
- It is easier to modify: similar concepts are grouped together and segregated by clear interfaces.
- It is easier to extend: supporting additional number systems would only require code addition, not code modification.
- And, for the sake of completeness, it works just as before: we evidentially haven’t introduced a feature or performance regression.

This blog post almost exlusively dealt with non-functional aspects of code, so allow me to close with some philosophical remarks on this topic. Code quality is no law of nature, thus it’s hard to make absolute statements about it. Instead of asking “what is perfect?” I find it easier to think about the question “how can we improve it?” and to perceive code quality in the context of a living process. Common principles give us guidance, help us to make decisions and make it easier to reason about our intentions. Personal preference is likewise important, but remains arbitrary without a solid foundation underneath.

# It’s your turn!

If you had fun to follow me throughout this exercise, I’d like to encourage you to continue coding. You find the repository with some bonus tasks [on Github](https://github.com/jotaen/coding-dojo/tree/master/convoluted-converter). May the fork be with you!


[^1]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-1) of this step in the code browser
[^2]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-2) of this step in the code browser
[^3]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-3) of this step in the code browser
[^4]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-4) of this step in the code browser
[^5]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-5) of this step in the code browser
[^6]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-6) of this step in the code browser
[^7]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-7) of this step in the code browser
[^8]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-8) of this step in the code browser
[^9]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-9) of this step in the code browser
[^10]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-0) of this step in the code browser
