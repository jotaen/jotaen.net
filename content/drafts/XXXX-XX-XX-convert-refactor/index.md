+++
draft = true
expiryDate = "2017-01-01"
title = "“The convoluted converter”"
subtitle = "A refactoring in 10 steps, guided by principles"
date = "2019-09-11"
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
      const value = input.substr(2);
      if (prefix === "0b") decimal = parseInt(value, 2);
      else if (prefix === "0x") decimal = parseInt(value, 16);
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

## #0. Make it work, make it right, make it fast

Since we take an existing application and refactor its innards, we should better say: “Keep it working, keep it right, keep it fast”.

Before we touch a single line of existing code (which sometimes is rashly referred to as “legacy code”) we need to make sure that we won’t break existing functionality while overhauling the implementation. The precondition for conducting a safe refactoring is sufficient test coverage. The best option in our case is a comprehensive suite of end-to-end tests, that examine the CLI application as a whole.

For your convenience, I provided a test suite with the most important use cases. It is deliberately setup in a property-based manner, which makes it easy to turn the suite into unit tests later on. Each of the following refactoring steps will satisfy the tests. That premise will help us iterate bit-by-bit instead of trying to tackle everything at once.

## #1. Divide and conquer

From the various things that spring to mind when reading the above program code we start with the coarse-grained ones. The first step is to break down the code-monolith in bite-sized chunks that we can approach independently. Therefore, we extract some variables and functions to bring the basic structure to light:

```js
// core logic
const convert = (target, input) => {
  let decimal;
  const prefix = input.substr(0, 2);
  const value = input.substr(2);
  if (prefix === "0b") decimal = parseInt(value, 2);
  else if (prefix === "0x") decimal = parseInt(value, 16);
  else decimal = parseInt(input);
  if (target === "-bin") return "0b" + decimal.toString(2);
  else if (target === "-hex") return "0x" + decimal.toString(16);
  else return decimal.toString();
}

const options = ["-bin", "-hex", "-dec"];
const inputShape = /^(0b[01]+|0x[0-9a-fA-F]+|[^0]\d*)$/;

// main
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

Note, that we have only done some simple copy-and-paste here without touching the statements on the functional level. (Exception: `return`.) Annotating the code sections with comments helps us to establish an overview in the beginning.

## #2. Maximise cohesion

Let’s focus on the `main` code block: its readability suffers from the nested `if` statements, where corresponding code (namely `if` and `else`) is divided by multiple lines of unrelated statements. A common way of improving this is to negate the conditions and to make the code path flat and linear. This pattern is sometimes referred to as “early return”. It pushes the so-called “happy path” (the actual conversion) from somewhere in the thick of it down to the very end of the code block and exposes it prominently on first indentation level.

```js
// main
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

## #3. Variable declaration is initialisation

Next, we switch to the `core logic` block: one problem is how the variables are initialised. `decimal` is declared empty and happens to be given a value later; `prefix` and `value` are initialised with a value, but in case `input` is decimal these values be arbitrary and just plain wrong. Both things don’t cause actual problems in this very case, but they increase code complexity unnecessarily, because the state of those variables is ambiguous and volatile.

I adapted the term “variable declaration is initialisation” from the C++ idiom “resource acquisition is initialisation”. The latter is coined to class-internal resource management, but its idea applies to variable management in just the same way. A variable declaration should always coincide with its value definition, so that it holds a meaningful value from the very beginning over its entire lifecycle. Uninitialised or arbitrarily defined variables are an unnecessary risk that can almost always be avoided.

```js
// core logic
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

- IIFE vs. ternary

## #4. Minimise cyclomatic complexity

There some conditionals in our code that potentially grows linearly with the number of conversion options that the program offers. The corresponding number of `return` statements worsens the problem and is also a common origin of bugs.

In order to initialise `decimal`, we need to look at the shape of `input`. We group the different algorithms in an object (`toDecimalDict`) and execute a dynamic lookup based on the first two characters of `input`. This technique is called “pattern matching”. That way, there is no need for an intermediate `prefix` variable any more and we are able to initialise `decimal` right away.

```js
// core logic
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

Only decision left is `toDecimal` fallback.

## #5. Don’t repeat yourself

`targetConverters` and `inputConverters` now contain redundant code. The only remaining difference is the “decimal” conversion, that lack one argument in both cases. Upon closer look, however, we see that this missing argument defaults to `10`, so we are able to spell it out. This allows us to extract the redundant procedure calls and to handle their parametrisation programatically. The converter objects can thus be boiled down to plain data.

```js
// core logic
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

In `main` we reuse the converters to validate the target option.

```js
const inputShape = /^(0b[01]+|0x[0-9a-fA-F]+|[^0]\d*)$/;

// main
try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const target = process.argv[2];
  const input = process.argv[3];
  if (!Object.keys(converters).includes(target) || !inputShape.test(input)) {
    throw "Input arguments invalid";
  }
  const result = convert(target, input);
  console.log(result);
} catch(e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

## #6. Open-closed principle

The problem of redundancies is not solved yet. This is not immediately obvious anymore, but it becomes clear when you imagine we wanted to add a fourth conversion to the programm. This would still require us to touch 3 different places at the moment: `targetConverters` and `inputConverters`, plus the `inputShape` regex for input validation. Needing to keep all of them in sync is puts a big burden on future maintainers of our application. Forgetting about one of these places is a common source of defects, so this problem should be avoided by all means as far as ever possible.

A good way of thinking of our specific conversion algorithms is to view them as plugins. A plugin would be the distillate of 
 The previous step already showed us that this approach basically works, it was just not particularly nice yet. These should be managed in one central place and fully self-contained in regards to their particular conversion functionality.

Based on these ideas, we aim to make the following data structure happen:

```js
// core logic
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

// main
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

## #7. Separation of concerns

As of step 6, our program already reads very clear. However, in the `main` code block we still mix side-effects (such as printing via `console.log` or accessing the runtime environment via `process.argv`) with business logic (such as finding applicable numberSystems and applying the input value to it). These are different levels of abstractions that are mingled on one level, which is not just ugly, but it also makes the code harder to navigate.

All side-effects have been isolated and driven into one single corner. The rest of the code is pure algorithms. The function signatures clearly indicate which layer they belong to, which makes the annotating comments from earlier superfluous.

```js
// core logic
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

// main
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

## #8. Keep it simple, stupid

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

## #9. Distill the domain model

While the overall structure in step 8 is fine, the code in the upper block has a very technical language.

- The name “plugin” only tells you what they *are*, but not what they *do*.
- The name “decimal” is redundant – `parseInt` always returns a decimal number after all, so naming the variable that way doesn’t reveal anything new about *why* that is.
- The plugin dictionary is keyed by the CLI options – however, the core logic shouldn’t actually know anything about this outer context.

All those statements indicate that we haven’t worked out a meaningful domain model yet. Instead of reflecting the language of the business processes, the code speaks a technical language that makes it hard to reason about. A good exercise to get clarity on the business language is to think of how:

> First we figure out what number systems we need to convert between. That way, we can normalise the input value to a universal intermediate form. From there, we can translate it to the desired target form.

```js
// core logic
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

// main
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

## #10. Single level of abstraction

There is still something off with `convert`: On the one hand, we implemented nice high-level domain terms like “number system” or “intermediate” form. On the other hand, we do low-leveled operations like converting types (`toString`) and chopping off strings (`substr`). That doesn’t play together nicely.

If you have payed close attention, we missed to implement something in the last step. The business explanation used the terms “normalise” and “translate” do discern both operations, which we haven’t reflected in the code language yet. It turns out that there is the opportunity to catch two birds with one stone by extracting out two functions with that name, which happen to encapsulate our low-level operations at the same time. As a result, the abstraction level in `convert` becomes much more consistent.

```js
// core logic
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

Let’s put it all together. Is this good code now?

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

Code quality is no law of nature, thus it’s hard to make absolute statements about it. Trying to define how “perfect code” looks as in it was some definite state doesn’t lead anywhere. It’s more practical to think about code quality as a process instead

We can unarguably assess is the difference between two implementations in comparison. So, in our case, the refactored version is better than the original one for the following reasons:

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

[^1]: See [“Response Times: The 3 Important Limits”](https://www.nngroup.com/articles/response-times-3-important-limits/) by the Nielsen Norman Group
