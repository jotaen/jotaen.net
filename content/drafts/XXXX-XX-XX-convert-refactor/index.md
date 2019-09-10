+++
draft = true
expiryDate = "2017-01-01"
title = "“The convoluted converter”"
subtitle = "A refactoring in 8 steps, guided by principles"
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
    if (["-bin", "-hex", "-dec"].includes(target) && /^(0b[01]*|0x[0-9a-fA-F]*|\d*)$/.test(input)) {
      let decimal;
      const inputPrefix = input.substr(0, 2);
      if (inputPrefix === "0b") decimal = parseInt(input.substr(2), 2);
      else if (inputPrefix === "0x") decimal = parseInt(input);
      else decimal = parseInt(input);
      if (target === "-bin") console.log("0b" + decimal.toString(2));
      else if (target === "-hex") console.log("0x" + decimal.toString(16));
      else console.log(decimal);
    } else {
      throw "Error: Input arguments invalid";
    }
  } else {
    throw "Error: Wrong number of arguments";
  }
} catch (e) {
  console.log(e);
  process.exit(1);
}
```

# Refactoring in steps – guided by clean code principles

## #0. Don’t improve for the worse

Before we touch a single line of existing code (sometimes rashly referred to as “legacy”) we need to make sure that we won’t break existing functionality while overhauling the implementation. The precondition for conducting a safe refactoring is sufficient test coverage. The best option in our case is a comprehensive suite of end-to-end tests, that examine the CLI application as a whole.

For your convenience, there is a basic test suite provided. It is deliberately setup in a property-based manner, which makes it easy to turn the suite into unit tests later on. Each of the following refactoring steps will satisfy the tests. That premise will help us iterate bit-by-bit instead of trying to tackle everything at once.

## #1. Separation of concerns

From the various things that spring to mind when reading the above program code we start with the coarse-grained ones. The first step is to break down the code-monolith in bite-sized chunks that we can approach independently. Therefore, we extract some variables and functions to bring the basic structure to light:

```js
// core logic
const convert = (input, target) => {
  let decimal;
  const inputPrefix = input.substr(0, 2);
  if (inputPrefix === "0b") decimal = parseInt(input.substr(2), 2);
  else if (inputPrefix === "0x") decimal = parseInt(input);
  else decimal = parseInt(input);
  if (target === "-bin") return "0b" + decimal.toString(2);
  else if (target === "-hex") return "0x" + decimal.toString(16);
  else return decimal.toString();
}

// constants
const numberShape = /^(0b[01]*|0x[0-9a-fA-F]*|\d*)$/;
const options = ["-bin", "-hex", "-dec"];

// main procudure
try {
  if (process.argv.length === 4) {
    const target = process.argv[2];
    const input = process.argv[3];
    if (options.includes(target) && numberShape.test(input)) {
      console.log(convert(input, target));
    } else {
      throw "Error: Input arguments invalid";
    }
  } else {
    throw "Error: Wrong number of arguments";
  }
} catch (e) {
  console.log(e);
  process.exit(1);
}

```

Note, that we have only done some simple copy-and-paste here without touching the statements on the functional level. Annotating the code sections with comments helps us to establish an overview in the beginning.

## #2. Maximise cohesion

Let’s focus on the `main procedure` code block: its readability suffers from the nested `if` statements, where corresponding code (namely `if` and `else`) is divided by multiple lines of unrelated statements. A common way of improving this is to negate the conditions and to make the code path flat and linear. This pattern is sometimes referred to as “early return”. It pushes the so-called “happy path” (the actual conversion) from somewhere in between towards the end of the code block and exposes it more prominently on first indentation level.

```js
// core logic
const convert = (input, target) => {
  let decimal;
  const inputPrefix = input.substr(0, 2);
  if (inputPrefix === "0b") decimal = parseInt(input.substr(2), 2);
  else if (inputPrefix === "0x") decimal = parseInt(input);
  else decimal = parseInt(input);
  if (target === "-bin") return "0b" + decimal.toString(2);
  else if (target === "-hex") return "0x" + decimal.toString(16);
  else return decimal.toString();
}

// constants
const numberShape = /^(0b[01]*|0x[0-9a-fA-F]*|\d*)$/;
const options = ["-bin", "-hex", "-dec"];

// main procedure
try {
  if (process.argv.length !== 4) {
    throw "Error: Wrong number of arguments";
  }
  const target = process.argv[2];
  const input = process.argv[3];
  if (!options.includes(target) || !numberShape.test(input)) {
    throw "Error: Input arguments invalid";
  }
  console.log(convert(input, target));
} catch(e) {
  console.log(e);
  process.exit(1);
}
```

## #3. Resource acquisition is initialisation (RAII)

Next, we switch to the `core logic` block: one problem is how the variables are initialised. `decimal` is declared empty and happens to be given a value later; `prefix` is initialised with a value, but in case of a decimal this will be arbitrary and just plain wrong. Both things don’t cause actual problems in this very case, but they increase code complexity unnecessarily, because the state of those variables is ambiguous and volatile.

We can borrow the RAII idiom here, which (in a transferred sense) says that the declaration of a variable (the resource acquisition) should always coincide with its value definition (initialisation). In other words: if we declare variables, they must hold a meaningful value at all times.

In order to initialise `decimal`, we need to look at the shape of `input`. We group the different algorithms in an object (`normaliser`) and execute a dynamic lookup based on the first two characters of `input`. This technique is called “pattern matching”: that way, there is no need for an intermediate `prefix` variable any more and we are able to initialise `decimal` right away.

```js
// core logic
const normaliser = {
  "0b": i => parseInt(i.substr(2), 2),
  "0x": i => parseInt(i.substr(2), 16),
  "": i => parseInt(i)
};

const convert = (input, target) => {
  const toDecimal = normaliser[input.substr(0, 2)] || normaliser[""];
  const decimal = toDecimal(input);
  if (target === "-bin") return "0b" + decimal.toString(2);
  else if (target === "-hex") return "0x" + decimal.toString(16);
  else return decimal.toString();
}
```

There is no way around accounting for the “decimal” special case, which doesn’t have a distinct prefix and therefore still requires a separate fallback mechanism (`... || normaliser[""]`). This is okay for now – and it will peter out anyway, as you’ll see soon.

## #4. Reduce cyclomatic complexity

There still is an untamed conditional in our code, that has the potential to grow linearly with the number of conversion options that the program offers. The corresponding number of `return` statements worsens the problem. In step 3 we already learned how to substitue a conditional with pattern matching, so it is an easy exercise to apply it to the output conversion as well.

```js
// core logic
const normaliser = {
  "0b": i => parseInt(i.substr(2), 2),
  "0x": i => parseInt(i.substr(2), 16),
  "": i => parseInt(i)
};

const converter = {
  "-bin": d => "0b" + d.toString(2),
  "-hex": d => "0x" + d.toString(16),
  "-dec": d => d.toString(),
}

const convert = (input, target) => {
  const toDecimal = normaliser[input.substr(0, 2)] || normaliser[""];
  const decimal = toDecimal(input);
  return converter[target](decimal);
}
```

## #5. Don’t repeat yourself

`normaliser` and `converter` now contain redundant code. The only remaining difference is the “decimal” conversion, that lack one argument in both cases. Upon closer look, however, we see that this missing argument defaults to `10`, so we are able to spell it out. This allows us to extract the redundant procedure calls and to handle their parametrisation programatically. The converter objects can thus be boiled down to plain data.

```js
// core logic
const normaliser = {
  "0b": 2,
  "0x": 16,
  "": 10
};

const converter = {
  "-bin": "0b",
  "-hex": "0x",
  "-dec": "",
};

const convert = (input, target) => {
  const inputPrefix = input.substr(0, 2) in normaliser ? input.substr(0, 2) : "";
  const inputBase = normaliser[inputPrefix];
  const decimal = parseInt(input.substr(inputPrefix.length), inputBase);
  const outputPrefix = converter[target]
  const outputBase = normaliser[outputPrefix];
  return outputPrefix + decimal.toString(outputBase);
}
```

But what happened to `convert`? Its implementation was neatly concise before! Now it exploded and we had to introduce a lot of auxiliary variables to compute the conversion. This is clearly not a good sign. Before we hastily revert our changes though, we should take a step back: we better tackle this issue from a different angle.

## #6. Open-closed principle

The problem of redundancies is not solved yet. This becomes clear when you imagine we wanted to add a fourth conversion to the programm. This would require us to touch 4 different places at the moment: `normaliser`, `converter`, `numberShape` and `options` – needing to keep all of them in sync is an avoidable risk, plus it puts a big burden on future maintainers of our application.

A good way of thinking of our specific conversion algorithms is to view them as plugins. A plugin would be the distillate of 
 The previous step already showed us that this approach basically works, it was just not particularly nice yet. These should be managed in one central place and fully self-contained in regards to their particular conversion functionality.

Based on these ideas, we aim to make the following data structure happen:

```js
const converters = [
  {name: "bin", prefix: "0b", base: 2, shape: /^0b[01]*$/},
  {name: "hex", prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]*$/},
  {name: "dec", prefix: "", base: 10, shape: /^[0-9]*$/},
];
```

## #7. Single responsibility principle

The following rewrite divides these concerns into distinct code pieces:

```js
const convert = (target, input) => {
  const from = converters.find(c => c.shape.test(input));
  const to = converters.find(c => c.opt === target);
  if (!from || !to) {
    throw "Input arguments invalid";
  }
  const inputValue = input.substr(from.prefix.length);
  const decimal = parseInt(inputValue, from.base);
  return to.prefix + decimal.toString(to.base);
};
```

## #8. Isolate side-effects

As of step 6, our program already reads very clear. However, in the `main` code block we still mix side-effects (such as printing via `console.log` or accessing the runtime environment via `process.argv`) with business logic (such as finding applicable converters and applying the input value to it). These are different levels of abstractions that are mingled on one level, which is not just ugly, but it also makes the code harder to navigate.

All side-effects have been isolated and driven into one single corner. The rest of the code is pure algorithms. The function signatures clearly indicate which layer they belong to, which makes the annotating comments from earlier superfluous.

```js
try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const out = convert(process.argv[2], process.argv[3]);
  console.log(out);
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

# The result

```js
const converters = [
  {name: "bin", prefix: "0b", base: 2, shape: /^0b[01]*$/},
  {name: "hex", prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]*$/},
  {name: "dec", prefix: "", base: 10, shape: /^[0-9]*$/},
];

const convert = (target, input) => {
  const from = converters.find(c => c.shape.test(input));
  const to = converters.find(c => c.name === target);
  if (!from || !to) {
    throw "Input arguments invalid";
  }
  const inputValue = input.substr(from.prefix.length);
  const decimal = parseInt(inputValue, from.base);
  return to.prefix + decimal.toString(to.base);
};

try {
  if (process.argv.length !== 4) {
    throw "Wrong number of arguments";
  }
  const out = convert(process.argv[2].substr(1), process.argv[3]);
  console.log(out);
} catch (e) {
  console.log("Error: " + e);
  process.exit(1);
}
```

- It works (just as before)
- Sufficient performance
- Clear structure (layered architecture)
- Easy to extend
- Meaningful abstractions
- Comprehensive naming

# It’s your turn!

If you had fun to follow me along this exercise, I’d like to encourage you to continue coding. Here are some follow up ideas that could help to make our program more powerful and user-friendly:

1. Add support for octal conversion, i.e. numbers prefixed with `0`, e.g. `04615`. The corresponding target option would be `-oct`.
2. Introduce aliasing for options: e.g. `-h`, `-x` and `-16` for hexadecimal (and equivalent for the other converters)
3. Complement the programm’s output so that it echos the input parameters for confirmation.
4. Introduce aliasing for the prefixes that determine the number format, like the `2r` prefix for binary numbers as it is common in Clojure (e.g. `2r10011101`)
5. Make the output easier to read, such as by “syntax-highlighting” the numbers in order to make it easier to tell the prefix apart from the value.

You find the code base and instructions how to run it on Github. May the fork be with you!

[^1]: See [“Response Times: The 3 Important Limits”](https://www.nngroup.com/articles/response-times-3-important-limits/) by the Nielsen Norman Group
