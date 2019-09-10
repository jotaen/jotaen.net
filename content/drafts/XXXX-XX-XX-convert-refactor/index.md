+++
draft = true
expiryDate = "2017-01-01"
title = "“The convoluted conversion confusion”"
subtitle = "A refactoring guided by clean code principles"
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
if (process.argv.length === 4) {
  const target = process.argv[2];
  const input = process.argv[3];
  if (["-b", "-h", "-d"].includes(target) && /^(0b[01]*|0x[0-9a-fA-F]*|\d*)$/.test(input)) {
    let decimal;
    const inputPrefix = input.substr(0, 2);
    if (inputPrefix === "0b") decimal = parseInt(input.substr(2), 2);
    else if (inputPrefix === "0x") decimal = parseInt(input);
    else decimal = parseInt(input);
    if (target === "-b") console.log(decimal.toString(2));
    else if (target === "-h") console.log(decimal.toString(16));
    else console.log(decimal);
  } else {
    console.log("Error: Input arguments invalid");
    process.exit(1);
  }
} else {
  console.log("Error: Wrong number of arguments")
  process.exit(1);
}
```

# Refactoring guided by clean code principles

## #0. Don’t Improve for the Worse

Before we touch a single line of existing code (sometimes rashly referred to as “legacy”) we need to make sure that we won’t break existing functionality while overhauling the implementation. The precondition for conducting a safe refactoring is sufficient test coverage. The best option in our case is a comprehensive suite of end-to-end tests, that examine the CLI application as a whole.

For your convenience, there is a basic test suite provided. It is deliberately setup in a property-based manner, which makes it easy to turn the suite into unit tests later on. Each of the following refactoring steps will satisfy the tests. That premise will help us iterate bit-by-bit instead of trying to tackle everything at once.

## #1. Separation of Concerns

From the various things that spring to mind when reading the above program code we start with the coarse-grained ones. The first step is to break down the code-monolith in bite-sized chunks that we can approach independently. Therefore, we extract some variables and functions to bring the basic structure to light:

```js
// core logic
const convert = (input, target) => {
  let decimal;
  const inputPrefix = input.substr(0, 2);
  if (inputPrefix === "0b") decimal = parseInt(input.substr(2), 2);
  else if (inputPrefix === "0x") decimal = parseInt(input);
  else decimal = parseInt(input);
  if (target === "-b") return "0b" + decimal.toString(2);
  else if (target === "-h") return "0x" + decimal.toString(16);
  else return decimal.toString();
}

// constants
const numberShape = /^(0b[01]*|0x[0-9a-fA-F]*|\d*)$/;
const options = ["-b", "-h", "-d"];

// main procudure
if (process.argv.length === 4) {
  const target = process.argv[2];
  const input = process.argv[3];
  if (options.includes(target) && numberShape.test(input)) {
    console.log(convert(input, target));
  } else {
    console.log("Error: Input arguments invalid");
    process.exit(1);
  }
} else {
  console.log("Error: Wrong number of arguments");
  process.exit(1);
}
```

Note, that we have only done some simple copy-and-paste here without touching the statements on the functional level. Annotating the code sections with comments helps us to establish an overview in the beginning.

## #2. Cohesion

Let’s focus on the `main procedure` code block: its readability suffers from the nested `if` statements, where corresponding code (namely `if` and `else`) is divided by multiple lines of unrelated statements. A common way of improving this is to negate the conditions and to make the code path flat and linear. This pattern is sometimes referred to as “early return”. It pushes the so-called “happy path” (the actual conversion) from somewhere in between towards the end of the code block and exposes it more prominently on first indentation level.

```js
// core logic [UNCHANGED]
const convert = (input, target) => {
  let decimal;
  const inputPrefix = input.substr(0, 2);
  if (inputPrefix === "0b") decimal = parseInt(input.substr(2), 2);
  else if (inputPrefix === "0x") decimal = parseInt(input);
  else decimal = parseInt(input);
  if (target === "-b") return "0b" + decimal.toString(2);
  else if (target === "-h") return "0x" + decimal.toString(16);
  else return decimal.toString();
}

// constants [UNCHANGED]
const numberShape = /^(0b[01]*|0x[0-9a-fA-F]*|\d*)$/;
const options = ["-b", "-h", "-d"];

// main procedure
if (process.argv.length !== 4) {
  console.log("Error: Wrong number of arguments");
  process.exit(1);
}
const target = process.argv[2];
const input = process.argv[3];
if (!options.includes(target) || !numberShape.test(input)) {
  console.log("Error: Input arguments invalid");
  process.exit(1);
}

console.log(convert(input, target));
```

## #3. Resource Acquisition is Initialisation (RAII)

Next, we switch to the `core logic` block: one problem is how the variables are initialised. `decimal` is declared empty and happens to be given a value later; `prefix` is initialised with a value, but in case of a decimal this will be arbitrary and just plain wrong. Both things don’t cause actual problems in this very case, but they increase code complexity unnecessarily, because the state of those variables is ambiguous and volatile.

We can borrow the RAII idiom here, which (in a transferred sense) says that the declaration of a variable (the resource acquisition) should always coincide with its value definition (initialisation). In other words: if we declare variables, they must hold a meaningful value at all times.

In order to initialise `decimal`, we need to look at the shape of `input`. We group the different algorithms in an object (`inputConverters`) and execute a dynamic lookup based on the first two characters of `input`. This technique is called “pattern matching”: that way, there is no need for an intermediate `prefix` variable any more and we are able to initialise `decimal` right away.

```js
// core logic
const inputConverters = {
  "0b": i => parseInt(i.substr(2), 2),
  "0x": i => parseInt(i.substr(2), 16),
  "": i => parseInt(i)
};

const convert = (input, target) => {
  const toDecimal = inputConverters[input.substr(0, 2)] || inputConverters[""];
  const decimal = toDecimal(input);
  if (target === "-b") return "0b" + decimal.toString(2);
  else if (target === "-h") return "0x" + decimal.toString(16);
  else return decimal.toString();
}

// constants [UNCHANGED]
const numberShape = /^(0b[01]*|0x[0-9a-fA-F]*|\d*)$/;
const options = ["-b", "-h", "-d"];

// main procedure [UNCHANGED]
if (process.argv.length !== 4) {
  console.log("Error: Wrong number of arguments");
  process.exit(1);
}
const target = process.argv[2];
const input = process.argv[3];
if (!options.includes(target) || !numberShape.test(input)) {
  console.log("Error: Input arguments invalid");
  process.exit(1);
}

console.log(convert(input, target));
```

There is no way around accounting for the “decimal” special case, which doesn’t have a distinct prefix and therefore still requires a separate fallback mechanism (`... || inputConverters[""]`). This is okay for now – and it will peter out anyway, as you’ll see soon.

## #4. Cyclomatic Complexity

There still is an untamed conditional in our code, that has the potential to grow linearly with the number of conversion options that the program offers. The corresponding number of `return` statements worsens the problem. In step 3 we already learned how to substitue a conditional with pattern matching, so it is an easy exercise to apply it to the output conversion as well.

```js
// core logic
const inputConverters = {
  "0b": i => parseInt(i.substr(2), 2),
  "0x": i => parseInt(i.substr(2), 16),
  "": i => parseInt(i)
};

const outputConverters = {
  "-b": d => "0b" + d.toString(2),
  "-h": d => "0x" + d.toString(16),
  "-d": d => d.toString(),
}

const convert = (input, target) => {
  const toDecimal = inputConverters[input.substr(0, 2)] || inputConverters[""];
  const decimal = toDecimal(input);
  return outputConverters[target](decimal);
}

// constants [UNCHANGED]
const numberShape = /^(0b[01]*|0x[0-9a-fA-F]*|\d*)$/;
const options = ["-b", "-h", "-d"];

// main procedure [UNCHANGED]
if (process.argv.length !== 4) {
  console.log("Error: Wrong number of arguments");
  process.exit(1);
}
const target = process.argv[2];
const input = process.argv[3];
if (!options.includes(target) || !numberShape.test(input)) {
  console.log("Error: Input arguments invalid");
  process.exit(1);
}

console.log(convert(input, target));
```

## #5. Don’t Repeat Yourself

`inputConverters` and `outputConverters` now contain redundant code. The only remaining difference is the “decimal” conversion, that lack one argument in both cases. Upon closer look, however, we see that this missing argument defaults to `10`, so we are able to spell it out. This allows us to extract the redundant procedure calls and to handle their parametrisation programatically. The converter objects can thus be boiled down to plain data.

```js
// core logic
const inputConverters = {
  "0b": 2,
  "0x": 16,
  "": 10
};

const outputConverters = {
  "-b": "0b",
  "-h": "0x",
  "-d": "",
};

const convert = (input, target) => {
  const inputPrefix = input.substr(0, 2) in inputConverters ? input.substr(0, 2) : "";
  const inputBase = inputConverters[inputPrefix];
  const decimal = parseInt(input.substr(inputPrefix.length), inputBase);
  const outputPrefix = outputConverters[target]
  const outputBase = inputConverters[outputPrefix];
  return outputPrefix + decimal.toString(outputBase);
}

// constants [UNCHANGED]
const numberShape = /^(0b[01]*|0x[0-9a-fA-F]*|\d*)$/;
const options = ["-b", "-h", "-d"];

// main procedure [UNCHANGED]
if (process.argv.length !== 4) {
  console.log("Error: Wrong number of arguments");
  process.exit(1);
}
const target = process.argv[2];
const input = process.argv[3];
if (!options.includes(target) || !numberShape.test(input)) {
  console.log("Error: Input arguments invalid");
  process.exit(1);
}

console.log(convert(input, target));
```

But what happened to `convert`? Its implementation was neatly concise before! Now it exploded and we had to introduce a lot of auxiliary variables to compute the conversion. This is clearly not a good sign. Before we hastily revert our changes though, we should take a step back: there is a better spot to place the lever.

## #6. Open-Closed Principle

The problem of redundancies is not solved yet. This becomes clear when you imagine we wanted to add a fourth conversion to the programm. This would require us to touch 4 different places at the moment: `inputConverters`, `outputConverters`, `numberShape` and `options` – needing to keep all of them in sync is an avoidable risk, plus it puts a big burden on future maintainers of our application.

A good way of thinking of our specific conversion algorithms is to view them as plugins. These should be managed in one central place and fully self-contained in regards to their particular conversion functionality. Following our current approach, it turns out we can combine all of the above four components into one single data structure.

```js
// core logic
const converters = [
  {opt: "-b", prefix: "0b", base: 2, shape: /^0b[01]*$/},
  {opt: "-h", prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]*$/},
  {opt: "-d", prefix: "", base: 10, shape: /^[0-9]*$/},
];

const convert = (input, from, to) => {
  const value = input.substr(from.prefix.length);
  const decimal = parseInt(value, from.base);
  return to.prefix + decimal.toString(to.base);
}

// main
if (process.argv.length !== 4) {
  console.log("Error: Wrong number of arguments");
  process.exit(1);
}
const input = process.argv[3];
const from = converters.find(c => c.shape.test(input));
const to = converters.find(c => c.opt === process.argv[2]);
if (!from || !to) {
  console.log("Error: Input arguments invalid");
  process.exit(1);
}

console.log(convert(input, from, to));
```

## #7. Single Level of Abstraction

As of step 6, our program already reads very clear. However, in the `main` code block we still mix procedural instructions and side-effects (such as printing via `console.log` or accessing the runtime environment via `process.argv`) with business logic (such as finding applicable converters and applying the input value to it). These are different levels of abstractions that are mingled on one level, which is not just ugly, but it also makes the code harder to navigate.

The following rewrite divides these concerns into distinct code pieces:

```js
const converters = [
  {opt: "-b", prefix: "0b", base: 2, shape: /^0b[01]*$/},
  {opt: "-h", prefix: "0x", base: 16, shape: /^0x[0-9a-fA-F]*$/},
  {opt: "-d", prefix: "", base: 10, shape: /^[0-9]*$/},
];

const apply = (from, to, input) => {
  const value = input.substr(from.prefix.length);
  const decimal = parseInt(value, from.base);
  return to.prefix + decimal.toString(to.base);
}

const convert = (target, input) => {
  const from = converters.find(c => c.shape.test(input));
  const to = converters.find(c => c.opt === target);
  return (from && to) ?
    Promise.resolve(apply(from, to, input)) :
    Promise.reject("Input arguments invalid")
}

const main = args => (args.length === 4 ?
    Promise.resolve({option: args[2], input: args[3]}) :
    Promise.reject("Wrong number of arguments"))
  .then(a => convert(a.option, a.input))
  .then(out => ({ out, status: 0 }))
  .catch(msg => ({ out: "Error: " + msg, status: 1}));

main(process.argv).then(r => {
  console.log(r.out);
  process.exit(r.status);
});
```

All side-effects have been isolated and driven into one single corner (the very last statement). The rest of the code is pure algorithms. The function signatures clearly indicate which layer they belong to, which makes the annotating comments from earlier superfluous. The overall structure has become faintly reminiscent of the MVC architecture: `converters`, `apply` and `convert` make up the model; `main` serves as controller and yields a view structure, that gets rendered in the final invocation step.

One remark about the usage of `Promise` here: this might seem a bit unusual at first glance, because there is nothing asyncronous going on here. Instead, we are using `Promise` in a monadic way to implement an alternative control flow. It would be obviously more correct to use a proper functional data structure (such as `Either`) from some external library. This, however, is a formality here – the decisive point is that: using a monadic pattern allows us move procedural code into meaningful and atomic functions, whose scopes are managed in a fine-granular way. Objects are grouped together, the respective steps in the main control flow only have access to a well-defined set of variables.

## #8. Keep it Simple, Stupid

One of the most chellenging questions about code quality is: “what is good enough?”. How do we know when to stop? If you consider the modifications carried out from step 6 to step 7, we had to pay some extra lines of code only to buy better abstractions. The code as shown in step 6 was quite straightforward after all, so why bother to improve it further?

To some degree, code design is a matter of taste and personal style. For what it’s worth, I prefer a (pragmatic) functional coding style, therefore the outlined reasoning in the last step justify these changes. It’s important to acknowledge the importance of personal preferences, but at the same time this shouldn’t become a knockout-argument. “Principle over preference”: speak a consistent, predictable code language and base decisions primarily on retracable, objective reasoning. Personal taste can then be exercised withing these boundaries.

## #9. Beware of Premature (Performance) Optimisations

Someone might ask:

> “But! Isn’t the refactored code slower than the original version? Aren’t you aware that there are n regexes now instead of just one? You also loop over the array – twice!”.

This can be contradicted easily through a benchmark: as a matter of fact, I couldn’t detect any performance difference at all. In both cases, the CLI runtime is miles below the 100 ms threshold under which typical users perceive a system’s reaction as instantaneous. This might look different in another context, but it’s pointless to ponder about such a fictional scenario without having a reproducible benchmark. (As a side note: the biggest time sink at the moment is the NodeJS startup, not the actual code execution.)

# You Ain’t Gonna Need It?

If you had fun to follow me along this exercise, I’d like to encourage you to continue coding. Do worry about YAGNI – but not now! Here are some follow up ideas that could help to make our program more powerful and user-friendly:

1. Add support for octal conversion: i.e. numbers prefixed with `0`, e.g. `04615`. The corresponding target option would be `-o`.
2. Introduce aliasing for options: e.g. `-hex`, `-x` and `-16` for hexadecimal (and similar for the other converters)
3. Complement the programm’s output so that it echos the input parameters for confirmation.
4. Introduce aliasing for the prefixes that determine the number format: e.g. the `2r` prefix for binary numbers as it is common in Clojure (e.g. `2r10011101`)
5. Make the output easier to read: e.g. by “syntax-highlighting” the numbers, to make it easier to tell the prefix apart from the value.

You find the code base and instructions how to run it on Github. May the fork be with you!
