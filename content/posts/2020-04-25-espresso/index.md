+++
title = "Espresso"
subtitle = "Object-oriented framework for Arduino"
date = "2020-05-03"
tags = ["project", "coding"]
image = "/posts/2020-04-25-espresso/coffee-beans.jpg"
image_colouring = "10"
id = "e7ewR"
url = "e7ewR/espresso-arduino-library"
aliases = ["e7ewR"]
+++

In case you haven’t created an Arduino project yourself so far, let me quickly fill you in on some basics: Arduino provides a C library with APIs to access all board functions, like reading electric inputs, setting electric outputs or writing data to the serial port. An Arduino program – called “sketch“ – must implement two predefined functions, `setup` and `loop`. The setup function gets called a single time once the board is turned on; the loop function gets called over and over again until someone pulls the power plug.

Here is a demo sketch. It expects an LED to be wired to pin 13 and a button to pin 7. When the button is pushed the LED is supposed to light up for 3 seconds.

```cpp
#include <Arduino.h>

const unsigned long INTERVAL_MS = 3000;
const int PIN_LED = 13;
const int PIN_BUTTON = 7;
bool wasButtonPressed = false;
unsigned long turnLedOffAt;

void setup() {
  pinMode(PIN_LED, OUTPUT);
  pinMode(PIN_BUTTON, INPUT);
}

void loop() {
  if (digitalRead(PIN_BUTTON) == HIGH) {
    wasButtonPressed = true;
    turnLedOffAt = millis() + INTERVAL_MS;
  }
  if (wasButtonPressed && millis() > turnLedOffAt) {
    wasButtonPressed = false;
    digitalWrite(PIN_LED, LOW);
  }
}
```

This is a fairly simple example, but you might be able to anticipate how the `loop` function will ever grow and become more complex, even when sub procedures are extracted.

# Object-orientation

The key idea behind Espresso is to represent the features of the Arduino board as objects and to fully encapsulate their corresponding functionality. All state is kept up to date by an internal event loop that takes care of triggering the right user-provided callbacks. This approach fundamentally changes the notion of sketches: the loop mechanism is hidden away completely and the code rather turns into a declarative expression of objects and their relationship with each other.

```cpp
// Filename: "my-led-sketch.ino"
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

Performance is not a primary concern of the framework. Nevertheless, the object-oriented and event-driven architecture allowed for some worthwhile optimisations, which I was more than happy to take advantage of. On the other hand, the event loop abstraction comes at a certain cost, despite its implementation being as lightweight as possible.

In terms of performance, the Arduino library has some shortcoming that are due to its procedural nature. For most pin operations, Arduino needs to perform some pre-checks on every call. For example, if you you call `analogWrite()` it verifies that the respective pin is associated with a pulse-width modulator. In Espresso, these checks are performed just a single time during the initialisation phase, so the actual i/o operations can then be carried out without further ado and consequently are about twice as fast.

There is one notable exception for the analog input: the Arduino Uno offers just one single analog-digital converter that is shared across all analog input pins. In the procedural Arduino library, the call to `analogRead` must therefore block and wait for the conversion process to complete before it can return with a value. This takes around 0.1 ms per call. With Espresso, the conversion happens in the background and doesn’t block the loop. (The maximum conversion frequency itself doesn’t increase of course.)

# Memory

Memory is a scarce resource on microcontrollers. An object-oriented library of course introduces some overhead compared to a purely procedural approach. An important goal of Espresso was to minimise the memory footprint of the objects it provides – most of them are just a few bytes each. The biggest one currently is the `Timer`, which consumes a whopping 16 bytes per instance.

One constraint is that only non-capturing lambdas can be used as handler functions (callbacks). Non-capturing lambdas in C++ are effectively treated as regular, global functions and can thus be referenced via a plain function pointer. Capturing lambdas would have necessitated the use of `std::function`, which 1) allocates more stack memory and 2) has opaque dynamic memory behaviour at runtime. I’m not sure yet whether that is a good tradeoff – on the one hand I prefer function pointers for their memory characteristics, on the other hand the degree of high-level programming can be severely limited. One possible alternative option would be the use of functors, even though that would make the API more verbose.

# Next steps?

As I mentioned in the introduction, I see Espresso mainly as experiment. I already used it in several smaller projects and found it very pleasant to work with for my use cases. (Then again, this is almost always true for creators of libraries.)
