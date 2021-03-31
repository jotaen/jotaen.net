+++
title = "Espresso"
subtitle = "Reactive, fast and testable sketching for Arduino"
date = "2020-10-21"
tags = ["project", "coding"]
image = "coffee-beans.jpg"
image_colouring = "10"
id = "e7ewR"
url = "e7ewR/espresso-arduino-library"
aliases = ["e7ewR"]
+++

Every now and then I get my Arduino out of my drawer and tinker around with some smaller electric projects. I love Arduino for how approachable it is: it lets you focus on developing your application and gets all the heavy lifting out of your way, such as power management, flashing, or juggling CPU registers. On the other hand, I’m often racking my brain when it comes to writing code for it. The programming model of Arduino (and microcontrollers in general) is highly procedural, while the nature of my applications is often inherently event-driven. (“When switch A is closed, do B.”)

In order to address this personal nuisance I pondered about a way of creating a more fitting mental model for these kinds of applications. I wanted to keep the simplicity while not creating any illusions about the tight memory and CPU constraints of microcontroller environments. The outcome of that is a small framework written in C++ that I named “Espresso”. It exposes a different approach to writing Arduino programs, which I outline in the following blog post. You find the sources on [Github](https://github.com/jotaen/Espresso) – the framework basically works, but consider the current state of it more as a proof-of-concept in order to explore the basic idea. There is a bit of documentation, which should help you to navigate around. [Feedback and thoughts](/mail/) highly appreciated.


# Quick primer on Arduino

In case you are not familiar with Arduino so far, let me quickly fill you in on some basics: Arduino provides a C library with functions to access all board functions, like reading signals from electric inputs, controlling electric outputs, or handling time. An Arduino program (colloquially referred to as “sketch“) implements two predefined functions, `setup` and `loop`. The setup function is invoked a single time once the board is turned on; the loop function is called over and over again until someone pulls the power plug.[^1]

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

This is a fairly simple example, but you might be able to anticipate how the `loop` function will grow and become more complex and nested as you add more functionality to your application. Of course you can extract subroutines to mitigate this, but the procedural nature will still remain.


# Espresso

In comparison to the sketch above, I want to demonstrate how the same functionality can be implemented with Espresso. Along with that I explain the basic ideas and concepts behind the framework.

## Object-orientation

In Espresso all features of the Arduino board are represented as objects and their corresponding setup and functionality is fully encapsulated. All state is kept up to date by an internal event loop that takes care of triggering the user-provided callbacks. This approach fundamentally changes the notion of sketches: the loop mechanism is hidden away completely and the code turns into a declarative expression of objects and their relationship with each other.

The following code implements the same functionality as the initial reference sketch: it lights up an LED for 3 seconds after a button has been pressed.

```cpp
// led-sketch.ino

#include <Espresso.h>

const unsigned long DURATION = 3000;

DigitalInput button(7);
DigitalOutput led(13);
Timer ledTimer;
Observer<bool> buttonObserver;

void onSetup() {
  buttonObserver.observe([](){ return button.value(); });

  buttonObserver.onChange([](bool isHigh){
    if (isHigh) {
        led.write(HIGH);
        ledTimer.runOnce(DURATION);
    }
  });

  ledTimer.onTrigger([](){ led.write(LOW); });
}
```

As you can see, there is no `loop` function anymore, but only objects whose behaviour is configured in the `onSetup` function that is executed once on startup. The different concerns are separated from each other and the API allows you to clearly express what the involved objects are there for. The `buttonObserver` constantly monitors the state of the `led` and triggers the callback as soon as it detects a change.[^2] The trigger-function of `ledTimer` is invoked after the timer has been started and the specified interval has elapsed. The orchestration of all that happens behind the scenes within the framework.


## Testing

Since all system calls are fully encapsulated in Espresso you can link your sketches against a virtualised runtime, which is also provided by the framework. This has two main benefits: 

1. It allows you to develop sketches in isolation, without having to upload them to a physical board. In fact, the board doesn’t even have to be set up in any way: writing code and doing the wiring can happen completely independent from each other.
2. It allows you to write tests for your sketches, which helps you to specify the behaviour of your application and to avoid introducing regressions in the future.

Writing such a test procedure looks as follows. Notice that the only thing we need to do is include *Virtuino* (the virtualised runtime) and your original, unmodified sketch file. The code can be compiled and executed on any computer.

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

Performance is not the primary design goal of Espresso. Nevertheless, the object-oriented and event-driven approach allows for some interesting optimisations. The original Arduino library has some inefficiencies that are due to its procedural nature: for most pin operations, it needs to perform some pre-checks upon every call. For example, if you call `analogWrite()` it verifies that the respective pin is associated with a pulse-width modulator. In Espresso, these checks are performed just a single time during the initialisation phase, so the actual I/O operations can be carried out without further ado. That makes them about twice as fast as their original equivalents.

Another thing is the analog-digital converter, which the Arduino Uno only offers a single one of and which is shared across all analog input pins. The A/D conversion takes around 0.1 ms for turning an analog electrical signal into a discrete floating point number. In the original Arduino library, the call to `analogRead` is blocking and waits for the conversion process to complete before it yields a value. With Espresso, by contrast, the conversion happens in the background and doesn’t block the main loop. That doesn’t speed up the conversion process itself of course, but at least the rest of the program can carry on in the meantime without being halted.

# Closing remarks

Of course there is no such thing as a free lunch. That being said I also want to point out some (current and conceptual) shortcomings of Espresso.

The object-orientation comes with a slight memory overhead and I tried my best to keep the footprint of all classes as small as possible. The biggest one is `Timer` currently, which consumes 16 bytes per instance.[^3] The encapsulation also implies that all objects are supposed to be long-lived, so using a pin as output and input alternately is not directly supported.

A current design constraint in the API is that all event handlers are regular function pointers. (Which non-capturing lambdas are equivalent to in C++.) This is convenient and simple on the one hand, but it also limits the degree of high-level programming, because you cannot parametrise the handlers and reuse them in different contexts. Alternative options here would be capturing lambdas or functors. The first, however, would require the use of `std::function` (which has undesired memory characteristics), whereas the latter comes at the expense of more verbose syntax. I’m still undecided here and need to experiment further.


[^1]: This, by the way, is not special for microcontroller programming generally – it might actually surprise you how little overhead the original Arduino library has.

[^2]: All reactive components are automatically registered at the event loop upon creation.

[^3]: The Arduino Uno has 2048 bytes of SRAM.
