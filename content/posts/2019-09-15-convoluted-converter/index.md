+++
draft = true
title = "“The convoluted converter”"
subtitle = "A refactoring in 10 steps, guided by principles"
date = "2019-09-15"
tags = ["coding"]
image = "/drafts/2018-10-21-testing/puzzle.jpg"
image_info = ""
id = "0K2pE"
url = "0K2pE/clean-code-refactoring-kata"
aliases = ["0K2pE"]
+++

- Intro
- Refactoring goals
- Description of program (and sample usage)

```js
try {
  if (process.argv.length === 4) {
    const target = process.argv[2];
    const input = process.argv[3];
    if (["-bin", "-hex", "-dec"].includes(target) &&
        /^(0b[01]+|0x[0-9a-fA-F]+|[^0]\d*)$/.test(input)) {
      let decimal;
      const prefix = input.substr(0, 2);
      if (prefix === "0b") decimal = parseInt(input.substr(2), 2);
      else if (prefix === "0x") decimal = parseInt(input.substr(2), 16);
      else decimal = parseInt(input);
      if (target === "-bin") console.log("0b" + decimal.toString(2));
      else if (target === "-hex") console.log("0x" + decimal.toString(16));
      else console.log(decimal.toString());
    } else {
      throw "Input arguments invalid";
    }
  } else {
    throw "Wrong number of arguments";
  }
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

# The refactoring

## #0. Make it work, make it right, make it fast[^0]

We are tasked with the refactoring of the innards of an existing application, without changing any of its behaviour. Hence, we should better say: “Keep it working, keep it right, keep it fast”. In brief: we must make sure to not accidentally introduce a performance- or feature-regression.

The precondition for conducting a safe refactoring is sufficient test coverage. In our case it suggest itself to setup a collection of of end-to-end tests, that examine the CLI application as a whole. The performance can be measured by spot-checking various larger input values before and after. (A comprehensive benchmark is probably overkill for our purpose.)

For your convenience, I provided a test suite with the most important use cases. It is deliberately setup in a property-based manner, which makes it easy to turn the suite into unit tests later on. While proceeding in the refactoring, we can run the test suite after every step, thus making sure that we only move tiny and safe increments as we “go further out on the limb”.

## #1. Divide and conquer[^1]

There are a multitude of things that spring to mind when reading the original program code. But we cannot do all at once. The first step is to break down the code-monolith in manageable pieces that we can approach independently.

The initial goal is to bring the basic structure to light. That is: pulling up the innermost part into a separate function and extracting some constants. This is mostly simple copy-and-paste, without touching the statements on the functional level. The result are mainly two code sections, the “conversion block” (`convert`) and a “main block” (the `try`/`catch`). Apart from that, there are two constants (`options`, `inputShate`) floating in between and it is not clear yet where they really belong.

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
}

const options = ["-bin", "-hex", "-dec"];
const inputShape = /^(0b[01]+|0x[0-9a-fA-F]+|[^0]\d*)$/;

try {
  if (process.argv.length === 4) {
    const target = process.argv[2];
    const input = process.argv[3];
    if (options.includes(target) && inputShape.test(input)) {
      const result = convert(target, input);
      console.log(result);
    } else {
      throw "Input arguments invalid";
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
  const input = process.argv[3];
  if (!options.includes(target) || !inputShape.test(input)) {
    throw "Input arguments invalid";
  }
  const result = convert(target, input);
  console.log(result);
} catch(e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

## #3. Schödinger variables[^3]

Next, we look at the “conversion block”:

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
}
```

There is an issue with how the variables are initialised. `decimal` is declared empty and given its value only at some later point. `prefix` and is initialised with a value, but in case `input` is a decimal number this value is completely arbitrary and doesn’t mean anything. Both things are not good practice, even though they don’t cause actual problems in this very case. The problem is similar to Schrödinger’s cat: you need to open the box to see how the cat is doing. That results in implicit interdependences that are terrible to work with and often lead to a defensive programming style.

We can almost always avoid that. A variable declaration should always coincide with its value definition and hold a meaningful value from the very beginning over its entire lifecycle. In this case, this can be achieved by pulling out a function, so that the assignment of `decimal` becomes an atomic operation. By using `switch` instead of `if`/`else` there is no need for an auxiliary variable anymore.

```js
const toDecimal = (input) => {
  switch(input.substr(0, 2)) {
    case "0b": return parseInt(input.substr(2), 2)
    case "0x": return parseInt(input.substr(2), 16)
  }
  return parseInt(input);
}

const convert = (target, input) => {
  const decimal = toDecimal(input);
  if (target === "-bin") return "0b" + decimal.toString(2);
  else if (target === "-hex") return "0x" + decimal.toString(16);
  else return decimal.toString();
}
```

## #4. Conditional complexity[^4]

There are two conditionals in our “conversion block” that each have 3 possible branches. That makes for a total of 9 possible execution paths through the method. (Side note: this number is not fixed, it will rather grow linearly as we add conversion options to our program.) The multitude of `return` statements adds to this and is also a common origin of bugs.

This complexity is inherent in our programm, so there is nothing we can do about it. But using `if`, `else` or `switch` allows for undesired flexibility, which doesn’t meet the uniform schema that our conditionals follow. For the decisions that we have to make, there is a more succinct way to express. We can group the different cases in an object (`targetConverters`) and execute a dynamic lookup based on the first two characters of `input`.

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

This technique is similar to the “pattern matching” that has been made popular by functional programming languages. It is often a good way to carve out the exact differences between the cases.

## #5. Don’t repeat yourself[^5]

`targetConverters` and `inputConverters` contain redundant code. The only remaining difference is the “decimal” conversion, that lack one argument in both cases. Upon closer look, however, we see that this missing argument defaults to `10` and can of course be also made explicit. This allows us to extract the redundant procedure calls and to handle their parametrisation programatically. The converter objects can thus be unified and boiled down to plain data.

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
  const targetConverter = converters[target]
  return targetConverter.prefix + decimal.toString(targetConverter.base);
};
```

There is also an opportunity to reduce repetition in the “main block” now. We don’t need to maintain a separate array with `options` for validating the `target` argument anymore. Instead, we can can draw upon the keys of the `converters` object. That is:

```js
// now:
if (!Object.keys(converters).includes(target) || !inputShape.test(input)) {
  throw "Input arguments invalid";
}

// before:
if (!options.includes(target) || !inputShape.test(input)) {
  throw "Input arguments invalid";
}
```

## #6. Open-closed principle[^6]

The problem of redundancies is not solved yet, which is not immediately obvious anymore though. It becomes clear when you imagine we wanted to add a fourth conversion to the programm. This would still require us to touch 2 different places at the moment: `converters` and the `inputShape` regex for input validation. Furthermore, a prefix size of `2` is hard-coded and there is a special case for `"-dec"`. Needing to keep track of all this while extending the program puts a big burden on future maintainers. It’s all too easy to forget about just one of these aspects, so we better make sure to avoid the problem by design.

A good way of thinking of our specific conversion algorithms is to perceive them as “plugins”. Every plugin embodies a specific variant of an otherwise self-contained and impartial program. (In a class-based language, the program would only depend on the plugin interface and every plugin implementation would encapsulate.)

The previous step already suggested that this approach can work, so let’s try to push it further. We chop up the big regular expression (`inputShape`) and allot its parts to the plugins, which also requires to adjust the respective algorithm for the validation. The latter kills two birds with one stone, because it turns out to be a better way to find the “input converter” (which is now called `inputPlugin`). As a consequence, we can eliminate the hard-coded prefix size as well as the special fallback case for `"-dec"`, leaving the implementation of `convert` as fully generic.

```js
const plugins = {
  "-bin": {prefix: "0b", base: 2, shape: /^0b[01]+$/},
  "-hex": {prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]+$/},
  "-dec": {prefix: "", base: 10, shape: /^[^0]\d*$/},
};

const convert = (inputPlugin, target, input) => {
  const decimal = parseInt(
    input.substr(inputPlugin.prefix.length),
    inputPlugin.base
  );
  const targetPlugin = plugins[target]
  return targetPlugin.prefix + decimal.toString(targetPlugin.base);
};

try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const target = process.argv[2];
  const input = process.argv[3];
  const inputPlugin = Object.values(plugins).find(p => p.shape.test(input));
  if (!Object.keys(plugins).includes(target) || !inputPlugin) {
    throw "Input arguments invalid";
  }
  const result = convert(inputPlugin, target, input);
  console.log(result);
} catch(e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

## #7. Separation of concerns[^7]

As of step 6, our program already reads very clear. However, in the “main block” we still mix side-effects (such as printing via `console.log` or accessing the runtime environment via `process.argv`) with business logic (such as finding an applicable plugin). These are different concerns that are mingled in one scope, which is not just ugly, but it also makes the code structure harder to navigate.

Not to mention that passing both `inputPlugin` and `input` to the convert function is redundant – it is possible to derive the appropriate plugin from the input value after all. It makes sense to relocate the concern of validation to `convert` entirely.

```js
const plugins = {
  "-bin": {prefix: "0b", base: 2, shape: /^0b[01]+$/},
  "-hex": {prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]+$/},
  "-dec": {prefix: "" , base: 10, shape: /^[^0]\d*$/},
};

const convert = (target, input) => {
  const inputPlugin = Object.values(plugins).find(p => p.shape.test(input));
  if (!Object.keys(plugins).includes(target) || !inputPlugin) {
    throw "Input arguments invalid";
  }
  const decimal = parseInt(
    input.substr(inputPlugin.prefix.length),
    inputPlugin.base
  );
  const outputPlugin = plugins[target];
  return outputPlugin.prefix + decimal.toString(outputPlugin.base);
}

try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const target = process.argv[2];
  const input = process.argv[3];
  const result = convert(target, input);
  console.log(result)
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

`convert` is has gained error handling as additional responsibility. That is fine, since validation is tightly coupled to finding the right plugins. We wouldn’t win much by keeping both strictly separate and we still have the option to break up `convert` in smaller pieces, if we find it too messy.

The “main block” is now left with all and only the dirty stuff: reading in the runtime environment, managing the processing and printing to the CLI. The pure code has been completely migrated to the “conversion block”. (Spoiler: apart from one tiny adjustment, we won’t need to touch the “main block” anymore.)

There is one cleanup that we need to do here: especially after moving around pieces of code it is worthwhile to take a step back. By reiterating over the merged code with a fresh perspective we can often find opportunities for simplification, sometimes we can even push open a door to a whole new abstraction. (The “aha”-moment, when things immediately make sense.)

We can moderately improve the outcome of step 7, because we can unify the lookup and validation of `outputPlugin`: Instead of checking whether it exists and then fetching it, we can try to fetch it right away and then check on it the same way we do for `inputPlugin`.

```js
const convert = (target, input) => {
  const inputPlugin = Object.values(plugins).find(p => p.shape.test(input));
  const outputPlugin = plugins[target];
  if (!outputPlugin || !inputPlugin) {
    throw "Input arguments invalid";
  }
  const decimal = parseInt(
    input.substr(inputPlugin.prefix.length),
    inputPlugin.base
  );
  return outputPlugin.prefix + decimal.toString(outputPlugin.base);
}
```

## #8. Hello again, Schrödinger variables[^8]



## #9. Make the domain model shine[^9]

The overall structure of our code is pretty nice now and the business part has been fully separated from the application part. However, the latter (the “conversion block”) is characterised by a unexpressive, rather technical language:

- The name “plugin” only tells you what it *technically is*, but not what it *is about*.
- The name “decimal” is redundant, as in `parseInt` returns a decimal number *by definition*. Naming the variable that way doesn’t reveal anything new about *the reason* why we do this.
- The keys in the plugin dictionary should not know how CLI options are formatted. The design of the domain should rather be agnostic about the nature of any outer context.

All those aspects indicate that we haven’t created a meaningful domain model yet that would reflect the language of “the business”. A good exercise to get clarity on that business language is to imagine how we would explain the core algorithm to a non-technical person. That could sound like this:

> This is how we convert a number: first we figure out what number systems we need to convert between. We normalise the input number to an intermediate form. Then, we translate the intermediate value to the desired target number system.

What does that mean in regards to our three findings from above?

- What we called “plugin” is actually a “number system”.
- What we called “decimal” is an “intermediate” form. (The fact that it is decimal is an unimportant detail.)
- Instead of dealing with CLI options in the domain, we work with “names”. (And stripping the `-` is not responsibility of the domain.)

```js
const numberSystems = [
  {name: "bin", prefix: "0b", base: 2, shape: /^0b[01]+$/},
  {name: "hex", prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]+$/},
  {name: "dec", prefix: "", base: 10, shape: /^[0-9]+$/},
];

const convert = (targetName, input) => {
  const inputNS = numberSystems.find(n => n.shape.test(input));
  const targetNS = numberSystems.find(n => n.name === targetName);
  if (!inputNS || !targetNS) {
    throw "Input arguments invalid";
  }
  const intermediate = parseInt(
    input.substr(inputNS.prefix.length),
    inputNS.base
  );
  return targetNS.prefix + intermediate.toString(targetNS.base);
};

try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const targetName = process.argv[2].substr(1);
  const input = process.argv[3];
  const result = convert(targetName, input);
  console.log(result);
} catch(e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

## #10. Single level of abstraction[^10]

There is still something off with `convert`: On the one hand, we implemented nice high-level domain terms like “number system” or “intermediate” form. On the other hand, we do low-leveled operations like converting types (`toString`) and chopping off strings (`substr`). That doesn’t play nicely together.

You might have noticed that we have missed to implement something in the last step. The business explanation used the terms “normalise” and “translate” do discern both operations, which we don’t see reflected in the code language. It turns out that there is the opportunity to fill two needs with one deed by extracting two functions with those names, which also happen to encapsulate our low-level computations at the same time. As a result, the abstraction level in `convert` becomes much more consistent.

```js
const normalise = (ns, input) => parseInt(input.substr(ns.prefix.length), ns.base);
const translate = (ns, intermediate) => ns.prefix + intermediate.toString(ns.base);
const convert = (targetName, input) => {
  const inputNS = numberSystems.find(c => c.shape.test(input));
  const targetNS = numberSystems.find(c => c.name === targetName);
  if (!inputNS || !targetNS) {
    throw "Input arguments invalid";
  }
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
  {name: "dec", prefix: "", base: 10, shape: /^[0-9]+$/},
];

const normalise = (ns, input) => parseInt(input.substr(ns.prefix.length), ns.base);
const translate = (ns, intermediate) => ns.prefix + intermediate.toString(ns.base);
const convert = (targetName, input) => {
  const inputNS = numberSystems.find(c => c.shape.test(input));
  const targetNS = numberSystems.find(c => c.name === targetName);
  if (!inputNS || !targetNS) {
    throw "Input arguments invalid";
  }
  const intermediate = normalise(inputNS, input);
  return translate(targetNS, intermediate);
};

try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const targetName = process.argv[2].substr(1);
  const input = process.argv[3];
  const out = convert(targetName, input);
  console.log(out);
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

This blog post dealt almost exlusively with non-functional aspects of code, so allow me to close with some philosophical remarks on this topic.

Code quality is no law of nature, thus it’s hard to make absolute statements about it. Trying to define how “good code” looks does rarely lead anywhere productive. It’s more practical to think about code quality as a process instead. The value of principles is that they can guide us through this process, help us to make decisions and make it easier to reason about our intentions.

Regarding this refactoring, we are in the lucky position that we can compare the refactored version to the original one. That way, we don’t need to ponder about the question whether the refactoring result is good in itself, we can just assess its qualities in relation to what we had before. Based on that, we can make some clear statements:

- It is easier to navigate: the main concerns are separated by means of a layered architecture.
- It is easier to understand: we established consistent abstractions and meaningful naming.
- It is easier to modify: similar concepts are grouped together and segregated by clear interfaces.
- It is easier to extend: the variants of the 
- And, for the sake of completeness, it works just as before: we haven’t introduced a feature or performance regression. (This is proven through our tests and a benchmark.)

# It’s your turn!

If you had fun to follow me along this exercise, I’d like to encourage you to continue coding. Here are some follow up ideas that could help to make our program more powerful and user-friendly:

1. Add support for octal conversion, i.e. numbers prefixed with `0`, e.g. `04615`. The corresponding target option would be `-oct`.
2. Introduce aliasing for options: e.g. `-h`, `-x` and `-16` for hexadecimal (and equivalent for the other converters)
3. Complement the programm’s output so that it echos the input parameters for confirmation.
4. Introduce aliasing for the prefixes that determine the number format, like the `2r` prefix for binary numbers as it is common in Clojure (e.g. `2r10011101`)
5. Make the output easier to read, such as by “syntax-highlighting” the numbers in order to make it easier to tell the prefix apart from the value.

You find the code base and instructions how to run it on Github. May the fork be with you!


[^1]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-1) of this step
[^2]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-2) of this step
[^3]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-3) of this step
[^4]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-4) of this step
[^5]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-5) of this step
[^6]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-6) of this step
[^7]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-7) of this step
[^8]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-8) of this step
[^9]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-9) of this step
[^10]: [View full code](/posts/2019-09-15-convoluted-converter/steps/#step-0) of this step
