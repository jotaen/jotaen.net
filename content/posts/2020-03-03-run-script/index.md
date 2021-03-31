+++
title = "“Run” scripts"
subtitle = "Keeping track of commands in coding projects"
date = "2020-03-03"
tags = ["tooling"]
image = "control-panel.jpg"
image_info = "Photo by Patryk Grądys on Unsplash"
image_colouring = "190"
id = "rDuAZ"
url = "rDuAZ/run-script"
aliases = ["rDuAZ"]
+++

I recently came to appreciate a pattern, which helps me to keep track of commands that I frequently use in my repositories. I thought you might find it handy as well, so I wanted to share it with you. In the end, it’s nothing spectacular – just one of these small yet delightful things that contributes to making the development process a little more convenient.

For most of my projects I heavily rely on the command line to interact with the program I am working on: be it to start the main process, run the tests, install the dependencies, invoke the compiler or perform some other mandatory task while working on the project. These commands are not mere formalities – they represent the entrypoints into the project and as such should be treated like an inherent part of the repository. There is nothing more frustrating than checking out a code base and then being left clueless about how to get started or in which ways it is supposed to be used.

A common approach is to document commands in a README file. That, however, has the same disadvantage as any other form of documentation: it can get out of date all too quickly and there is no guarantee that it is complete to begin with. Apart from that it’s also not very pleasant to juggle around bare chunks of CLI commands taken from text files.

In software development there is a well-known way to make cumbersome things convenient and to condense unimportant details into something meaningful: abstractions. Why shouldn’t that idea be applicable to the CLI as well? It’s called *interface* for a reason, after all. We don’t need to be reminded all the time that our package manager is called “pip” (or “yarn”, “composer”, “nuget”, …) or what the filename suffix of our unit tests are. The only thing that matters is that we invoke something which installs dependencies or runs our tests. And hence, the name and API of this “something” should reflect these notions. Instead of `pip install -r requirements.txt` we should rather do:

```bash
$ ./run install
```

Let “run” take care of how to accomplish the installation.

# The “run” script

The `run` command demonstrated above is a plain bash script that resides in the project root and is a comprehensive collection of all essential project-specific procedures. These are accessible through subcommands, like `install`. For a python project a “run” script might look like this one:

```bash
#!/bin/bash

info() {
  echo "Requirements:"
  echo "- python 3.7.7"
  echo "- pip 20.0.2"
}

install() {
  pip install -r requirements.txt
}

start_server() {
  python src/server.py
}

test() {
  python -m unittest -p "*_test.py" ${@}
}

$1 ${@:2}
```

The functions shown above are arbitrary examples of course. In the end, this is just a plain regular bash script. Think of it as a pattern to promote a neat, clean and self-documenting structure while imposing as little technical overhead as possible.

In case you are not so familiar with bash scripts, here are some quick explanations on the `$` expressions. The last line is the most cryptic but also most important one, because it does the subcommand dispatching. `$1` refers to the first process argument (which is the “subcommand”) and executes the corresponding function. `${@:2}` is a bash expansion that extracts all but the first argument and hands them over to the invoked subcommand function. From within the function these arguments can be accessed in the same fashion, or passed through to another command via `${@}` as demonstrated in the `test()` function.

# Discussion

Setting up such a script ticks some important boxes for me. First of all it’s technically very simple – storing bash commands in a bash script seems like a very obvious thing to do. Apart from that it is an effective way to neatly organise all essential commands and expose them in one prominent file at the project root. Underlying details are covered up unless they are of interest, while the subcommands themselves actually tell you something meaningful. They serve as a uniform way to discover how a program is supposed to be interacted with.

I don’t want to sound too much like a vacuum salesman, this isn’t a one-size-fits-all solution of course. For example, for some languages or workflows it might make more sense to create IDE-specific procedures. That’s totally fine and still better than not providing anything at all. On the other hand it should be carefully considered whether the usage of certain IDEs or other supplementary tools should be enforced (or at least promoted) or whether simpler alternatives can be provided. A bash script is practically universal and can be executed on most UNIX systems, regardless of what tools the individual developers prefer.

I don’t want to open a debate here, my essential point is this: code bases should be easy to get started with, especially when they are shared across multiple collaborators or worked on irregularly. That’s not only a matter of convenience (even though this is a strong factor), but it rather is a sign of project maturity and professionalism. Therefore it is important to provide clear, reproducible entrypoints and reduce the friction of setup to a minimum. All the better if that can be accomplished through code in a lightweight and approachable way.

I’m curious: how do you organise commands in your projects? Feel free to reach out and share your experiences with me, you find my email below.
