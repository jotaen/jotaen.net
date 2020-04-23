+++
title = "Espresso"
subtitle = "Object-oriented framework for Arduino"
date = "2020-04-25"
tags = ["project", "coding"]
image = "/posts/2020-04-25-espresso/coffee-beans.jpg"
image_colouring = "10"
id = "e7ewR"
url = "e7ewR/espresso-arduino-library"
aliases = ["e7ewR"]
+++

Every once in a while I dig out my Arduino board to tinker around with small electric projects. Even though (or especially because?) I’m not an expert in circuitry and microcontrollers, I enjoy the Arduino as it is easily approachable.

In case you haven’t created an Arduino project yourself so far, let me quickly fill you in on some basics: Arduino provides a C library with APIs to access all board functions, like reading electric inputs, setting electric outputs or writing data to the serial port. An Arduino program – called “sketch“ – must implement two predefined functions, `setup` and `loop`. The setup function gets called a single time once the board is turned on; the loop function gets called over and over again until someone pulls the power plug.

```cpp
// TODO procedural implementation of led sketch
```

The code above expects an LED to be wired to pin 13 and a button to pin 7. When the button is pushed the LED is supposed to light up for 3 seconds.

This is a fairly simple demo sketch, but you can easily imagine how the complexity of the `loop` grows the more logic gets added to the program. [[TODO Motivation etc.]]

# Object-orientation

The key idea behind Espresso is to represent the features of the Arduino board as objects and to fully encapsulate their corresponding functionality. All state is kept up to date by an internal event loop that takes care of triggering the right user-provided callbacks. This approach fundamentally changes the notion of sketches: the loop mechanism is hidden away completely and the code rather turns into a declarative expression of objects and their relationship with each other.

```cpp
// File: "my-led-sketch.ino"
#include <Espresso.h>

const unsigned long DURATION = 3000;

DigitalInput button(7);
DigitalOutput led(13);
Timer ledTimer;
Observer<bool> buttonObserver;

void onSetup() {
  buttonObserver.observe([](){ return button.isHigh(); });
  buttonObserver.onChange([](bool isHigh){
    if (isHigh) {
        led.write(HIGH);
        ledTimer.runOnce(DURATION);
    }
  });
  ledTimer.onTrigger([](){ led.write(LOW); });
}
```

# Unit testing

Since the actual Arduino API is completely wrapped up in classes, the sketches can be linked against and executed in a fully virtualised environment. That allows writing automated tests, which not only is helpful to avoid regressions, but can also speed up the development process significantly. This is mainly because the sketches don’t need to be uploaded to the board and tried out through a manual process. In fact, writing code and doing the wiring can be accomplished in entirely separate steps.

```cpp
#include <assert.h>
#include <Virtuino.h>
#include "my-led-sketch.ino"

Virtuino virtuino;

// Simulate a brief incoming signal (e.g. a button press)
virtuino.setDigitalInput(button.pin(), HIGH);
virtuino.setDigitalInput(button.pin(), LOW);

// Check that the LED reacts as expected by lighting up for 3 seconds
assert(led.isHigh());
virtuino.elapseMillis(DURATION);
assert(led.isLow());
```

An important clue is that not only the electric signalling is mocked, but that there is also a simulation of time. Despite the waiting time of 3 seconds (`DURATION`) the test finishes instantaneously. On my 2,5 GhZ machine, 24h Arduino-hours can be unwinded in just a few seconds.

# Performance

I cannot give an overall comparison of the performance. On the one hand I was able to make some worthwhile optimisations under the hood, on the other hand the event loop abstraction comes at a certain cost, despite the implementation being very lightweight.

In terms of performance, the Arduino library has some shortcoming that are due to its procedural nature. For most pin operations, Arduino needs to perform pre-checks on every call – think of what happened if you call `analogWrite` on a pin that isn’t associated with a pulse-width modulator? In Espresso, these checks are performed just a single time on object construction, so the actual i/o operations can then be performed without further ado and consequently are about twice as fast.

There is one major (positive) exception for the analog input, however: the Arduino Uno only offers one analog-digital converter that is shared across all pins. In the procedural Arduino library, the call to `analogRead` must wait out the entire conversion process before it can yield a value. This takes around 10 ms on every call. With Espresso, the a/d-conversion happens in the background. This of course doesn’t increase the analog reading frequency, but it prevents the main loop from being blocked.

# Memory

Memory is scarse on Arduino. This of course doesn’t go together overly well with a library concept that encourages the use of objects and handler functions. An important goal of Espresso was to keep the memory footprint low. The most expensive object currently is the `Timer`, which consumes 16 bytes per object.

One pivotal constraint is that only non-capturing lambdas can be used as handler functions (callbacks). Non-capturing lambdas in C++ are effectively treated as regular, global functions and can thus be stored in a plain function pointer. Capturing lambdas would have demanded using `std::function`, which 1) consumes a more static memory and might do further dynamic allocations at runtime, which is something I prefer to avoid doing on a microcontroller. One major downside of all this is that it limits the degree of high-level programming. An alternative option are functors, but that would make the API more verbose.

# Next steps?

As I mentioned in the introduction, I see Espresso mainly as experiment. I already used it in several smaller projects and found it very pleasant for my use cases. But then again, this is almost always true for creators of libraries.
