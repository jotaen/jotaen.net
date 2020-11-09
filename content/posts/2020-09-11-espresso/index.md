+++
title = "Espresso"
subtitle = "Reactive, fast and testable sketching for Arduino"
date = "2020-11-09"
tags = ["project", "coding"]
image = "/posts/2020-11-09-espresso/coffee-beans.jpg"
image_colouring = "10"
id = "e7ewR"
url = "e7ewR/espresso-arduino-library"
aliases = ["e7ewR"]
+++

Every once in a while I get out my Arduino and tinker around with electric circuits.

# Quick primer on Arduino

In case you haven’t created an Arduino project yourself so far, let me quickly fill you in on some basics: Arduino provides a C library with functions to access all board functions, like reading electric inputs, setting electric outputs or working with time. An Arduino program – called “sketch“ – must implement two predefined functions, `setup` and `loop`. The setup function gets called a single time once the board is turned on; the loop function gets called over and over again until someone pulls the power plug. This, by the way, is not special at all for microcontroller programming generally – in fact it may actually be surprising how little abstraction the original Arduino library provides.

Anyway, here is a demo sketch that illustrates what a simple Arduino program looks like. It expects an LED to be wired to pin 13 and a button to pin 7. When the button is pushed the LED is supposed to light up for 3 seconds.

```cpp
#include <Arduino.h>

const unsigned long INTERVAL_MS = 3000;
const int PIN_LED = 13;
const int PIN_BUTTON = 7;

bool wasButtonPressed = false;
unsigned long ledTurnOffTime;

void setup() {
  pinMode(PIN_LED, OUTPUT);
  pinMode(PIN_BUTTON, INPUT);
}

void loop() {
  if (digitalRead(PIN_BUTTON) == HIGH) {
    wasButtonPressed = true;
    ledTurnOffTime = millis() + INTERVAL_MS;
  }
  if (wasButtonPressed && millis() > ledTurnOffTime) {
    wasButtonPressed = false;
    digitalWrite(PIN_LED, LOW);
  }
}
```

This is a fairly simple example, but you might be able to anticipate how the `loop` function will grow and become more complex as you add more functionality to your program. Of course you can extract subroutines to mitigate this, but the procedural nature will always remain.


# Espresso

In comparison to the sketch above, I want to demonstrate how the same functionality can be implemented in Espresso and I want to explain what the key ideas behind the framework are.

## Object-orientation

In Espresso all features of the Arduino board are represented as objects and their corresponding setup and functionality is fully encapsulated. All state is kept up to date by an internal event loop that takes care of triggering the user-provided callbacks. This approach fundamentally changes the notion of sketches: the loop mechanism is hidden away completely and the code turns into a declarative expression of objects and their relationship with each other.

The following code implements the same functionality as the initial reference sketch: it makes an LED light up for 3 seconds once a button has been pressed.

```cpp
// led-sketch.ino

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

As you can see, there is no `loop` function anymore, but only objects whose behaviour is configured in the `onSetup` function that gets executed once on startup. The different concerns are separated from each other and the API allows you to clearly express what the involved objects are there for.


## Testing

Since all system calls are fully encapsulated in Espresso, you can link your sketches against a virtualised runtime. This has two main benefits: 

1. It allows you to develop sketches in isolation, without having to upload them to a physical board. In fact, the board doesn’t even have to be set up in any way: writing code and doing the wiring can happen completely independent from each other.
2. It allows you to write tests for your sketches, which helps you to specify the behaviour of your application and to avoid introducing regressions in the future.

Writing such a test procedure looks as follows. Notice that the only thing we need to do is include *Virtuino* (the virtualised runtime) and your original, unmodified sketch file.

```cpp
// led-sketch-test.cpp

#include <assert.h>
#include <Virtuino.h>
#include "led-sketch.ino"

Virtuino virtuino;

// Simulate a brief incoming signal (e.g. a button press)
virtuino.setDigitalInput(button.pin(), HIGH);
virtuino.elapseMillis(50);
virtuino.setDigitalInput(button.pin(), LOW);

// Check that the LED reacts as expected by lighting up for 3 seconds
assert(led.isHigh());
virtuino.elapseMillis(3000);
assert(led.isLow());
```

An important clue is that not only the electric signaling is simulated, but you can also control the time. In the above code there is an overall time lapse of over 3000 milliseconds, yet the execution finishes almost instantaneously. (On my 2,5 GhZ machine, 24h “Arduino-hours” can be unwinded in just a few seconds.)


## Performance

Performance is not a primary design goal of Espresso. Nevertheless, the object-oriented and event-driven approach allows for some interesting optimisations. The original Arduino library has some inefficiencies that are due to its procedural nature: for most pin operations, it needs to perform some pre-checks upon every call. For example, if you you call `analogWrite()` it verifies that the respective pin is associated with a pulse-width modulator. In Espresso, these checks are performed just a single time during the initialisation phase, so the actual i/o operations can be carried out without further ado. That makes them about twice as fast as their original equivalents.

Another thing is the analog-digital converter, which the Arduino Uno only offers a single one of that is shared across all analog input pins. The A/D conversion itself takes around 0.1 ms until it has converted the analog electrical signal into a discrete floating point number. In the original Arduino library, the call to `analogRead` is blocking and waits for the conversion process to complete before it yields a value. With Espresso, however, the conversion happens in the background and doesn’t block the main loop. That doesn’t make the conversion process faster of course, but the rest of the program can carry on in the meantime without being halted.

# Discussion

Of course there is no such thing as a free lunch. That being said I also want to point out some (current and conceptual) shortcomings of Espresso.

The object-orientation comes with a slight memory overhead and I tried my best to keep the footprint of all classes as small as possible. The biggest one is `Timer` currently, which consumes 16 bytes per instance[^1]. The encapsulation also implies that all objects are supposed to be long-lived, so using a pin as output and input alternately is not directly supported.

A design constraint in the current API is that all event handlers are regular function pointers. (Which non-capturing lambdas are equivalent to in C++.) This is simple on the one hand, but it also limits the degree of high-level programming. Alternative options here would be capturing lambdas or functors. The first, however, would require the use of `std::function` (which has undesired runtime memory characteristics), whereas the latter comes at the expense of more verbose syntax.


[^1]: The Arduino Uno has 2048 bytes of SRAM.
