---
layout:        blogpost
title:         Working with events and objects on Arduino
subtitle:      A rapid prototyping framework called yps
date:          2014-01-27
tags:          [arduino, c++, framework, project]
redirect_from: /w7yGk/
permalink:     w7yGk/working-with-events-and-objects-on-arduino
image:         /assets/2014/arduino.jpg
---

Sometimes, I use my Arduino for experimenting with basic electrical circuits and setups. I appreciate the approach to have a fully functional microcontroller, you just can play around with, without needing to bother yourself too much with elementary stuff like hardware programmers or the soldering of circuit boards. However, I always thought that writing sketches could be a bit more convenient, so that you can focus rather on creating your actual circuitry than on how it is to be implemented as sketch.

For that purpose, I developed and released a small event-oriented and object-based framework, which acts as abstraction layer. I named it “yps” (which was a popular german magazine with comics and stuff you could fiddle around with). Sketches with yps will gain modularity and readability, which is perfect for the early stage of testing and prototyping. You find the [https://github.com/jotaen/yps](yps repository on github) – it includes detailed documentation, samples and a tutorial, which should help to get started.

# Compare for yourself

A common Arduino sketch is quite low-leveled and unnecessarily hard to read. Also, performance is not an issue in many cases, which would prevent you from using abstractions.

Here are two implementations of the same line-up: A LED, which blinks at 2 Hz, and a button, which makes the LED blink at 10 Hz whilst pressed down. At first, you see the common approach with `setup()` and `loop()`. As comparison, you see the same implementation written with yps.

### An common Arduino sketch

{% highlight cpp %}
int button = 7;
int led = 13;

void setup() {
  pinMode(led,OUTPUT);
  pinMode(button,INPUT);
  state = LOW;
  lastToggled = 0;
}

void loop() {
  if (digitalRead(button)==HIGH) {
    increment = 100;
  }
  else {
    increment = 500;
  }
  if (millis() > lastToggled+increment) {
    state = !state;
    digitalWrite(led,state);
    lastToggled = millis();
  }
}
{% endhighlight %}

### The same process implemented with yps

{% highlight cpp %}
#include <yps.h>

DigitalInput<7> button;
DigitalOutput<13> led;
Metronome clock;

void resetInterval() {
  clock.interval(500);
}
void speedInterval() {
  clock.interval(100);
}
void toggleLed() {
  bool state = led.state();
  led.state( !state );
}

// This function is predeclared and gets called
// once at the very beginning:
void onLaunch() {
  clock.onTrigger(toggleLed);
  clock.run(500);
  button.onHigh(speedInterval);
  button.onLow(resetInterval);
}
{% endhighlight %}
