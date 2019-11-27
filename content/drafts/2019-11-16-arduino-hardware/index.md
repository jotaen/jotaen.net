+++
draft = true
title = "Arduino flightseeing"
subtitle = "An explanation of the Arduino Uno hardware layout"
date = "2019-11-14"
tags = ["hardware"]
image = "/posts/"
image_info = ""
id = "iJ6fF"
url = "iJ6fF/arduino-hardware-layout"
aliases = ["iJ6fF"]
+++

https://en.wikipedia.org/wiki/Integrated_circuit

# Main microcontroller

The ① ATmega328 microcontroller is the heart of the Arduino Uno. It is a fully self-contained mini computer that provides - among others – the following functionalities:

- Computing unit (CPU and ALU) for executing programs and processing data
- Volatile memory (2 Kb) to hold program and data during runtime
- Permanent storage for saving programs (up to 32 Kb) or data (up to 1 Kb) enduringly
- An RC oscillator (8 MHz) for clocking
- Electrical input and output ports, both digital and analog
- A serial interface for incoming and outgoing communication

As you can see, when we are speaking about the core functions of the Arduino we are actually referring to genuinely provided capabilities of the ATmega328 microcontroller. And indeed, all the pins described below are directly wired to the ports of the ATmega328. There is only one external device involved: a ② 16 MHz ceramic resonator, which is not only twice as fast than the build-in one but also considerably more precise.

The array of ③ 14 digital pins can be used as input or output for binary signals. Some of pins are marked with a `~` sign to indicate that they can also act as analog output. These are technically still digital pins though, because the analog signal is created by a mechanism called “pulse-width modulation”. The respective pins are associatetd with timers that can toggle the binary signal in rapid succession, thereby creating a quasi-analog signal determined by the ratio between on-time and off-time. Pin 0 and 1 serve a double-purpose . Pin 13 is wired to the ⑤ onboard LED.

Six ⑥ Analog Input Pins can convert analog input signals to a discrete integer value. The Atmega contains one analog-digital-converter for that purpose, which is shared across all those pins. The conversion process is relatively slow and takes around 0.1 ms, which makes for a overall maximum of about 10.000 AD-conversions per second (10 kHz). Apart from that, the analog input pins can also be used as ordinary digital pins.

Last but not least, there are a bunch of ⑦ pins for receiving power from or providing it to the outside, or for setting reference voltages.

A ⑧ 6-pin male connector nearby the Atmega chip provides an ISCP interface that can be used to transfer programs to the microcontroller via an external programming device. You’ll find yet another ISCP connector on the board, which we’ll cover later, since it’s not related to the ATmega328 chip.

# Power supply

The power supply section of the Arduino board is a sophisticated (read: well thought out) circuitry whose job is to ensure that a stable current is supplied to the board. You can think of it as an antechamber, where incoming current is regulated and stabilised before it is fed into the board’s 5V power supplies. The components of Arduino are quite sensitive in regards to electricity: ups and downs of the current could cause random malfunctions, undervoltage might slow down the board, and overvoltage can quickly cause severe damage that might be hard or impossible to repair. Hence, it is utterly important to have well-regulated 5V flowing within the power supplies.

Arduino is able to draw power from various sources. The most obvious one is the ① USB Socket, which is supposed to provide 5V according to the USB standard. This happens to presicely match the demand of the ATmega328 chip and can thus be used as is. Only a ② fuse is there to prevent damage to the board and the connected host computer from electrical overload, potentially caused by connected components.

Another way of supplying power is via the ③ coaxial power connector (or: barrel connector). Incoming current first passes a ④ diode, which only allows current to flow into one direction. This is a safety measure against coaxial connectors with wrong polarity. The current is then buffered in two big ⑤ capacitators that absorb electrical fluctuations in order to stabilize the power supply. Next, the big ⑥ voltage regulator converts the input current from a maximum of 17V down to a steady 5V output that is then eventually fed into the board’s power supply. The regulator will produce a considerable amount of heat though, depending on how close you get to the allowed input maximum.

The power lines of both described sources are connected to a ⑧ dual-operational amplifier. It contains an analog comparator that decides which of the two sources shall be drawn from and that toggles a ⑨ transistor accordingly. (A transistor basically is an electrically controlled switch.) 

Apart from all that, there is also the option to provide power through either the Vin-Pin or the 5V Pin. In the first case, current takes the same path as described for the coaxial power connector with the exception of the diode, which is not passed. In the second case, power is fed right into the board’s power supplies without any further ado and therefor required to be regulated externally.

Another smaller ⑦ voltage regulator reduces the regulated 5V down to 3.3V and forwards it to the 3.3V power Pin. The ⓪ Power-LED is wired directly to 5V and thus will light up whenever current is available in the board’s power supplies. Consequently, if it doesn’t shine, there is either no power at all or the LED is broken.

# The controlling unit

Arduino offers a very convenient way to load sketches from your computer onto the board via USB. Apart from the Arduino IDE (or some equivalent tool) there are several other components in place to make this happen. For one, there is yet another fully fledged ① microcontroller mounted, an ATmega16U2. It’s main responsibilities are to forward new sketches to the ATmega328 and to take care of the serial communication via USB to the host computer. Since USB has high demands in terms of clock precision, there is a dedicated ② 16 MHz quartz crystal connected. (Which is not wired to the ATmega328, by the way!) The ATmega16U2 is connected via the TX and RX pins to the ATmega328. The latter has a special bootloading sequence preinstalled that takes care of receiving newly available sketches from the former. The ③ TX and RX LEDs flash to indicate that there is serial communication going on.

There are multiple ways to restart the Arduino, the easiest of which is to press the onboard ④ reset button. Unlike previous versions of the Arduino Uno, you don’t have to manually reset it after uploading a new sketch, because the ATmega16U2 issues a reset signal after every upload. If you want, you can prevent that from happening by physically cutting out the metal in the ⑤ “reset-enable” jumper, which effectively interrupts the signal coming from both the reset button and the ATmega16U2.

An interesting option for expert users might be to connect something to the ⑥ JP2 jumpers. These are directly wired to four input channels on the ATmega16U2, which are unoccupied and free to use. That, however, would necessarily imply to manually upload a program via the ⑦ ISCP connector of the ATmega16U2.

# Wiring

Now that we have an understanding of the individual components, let’s have a look at how everything plays together. There aren’t any wires on the board, electricity rather flows through ① conductive traces. The Arduino Uno is a so-called printed circuit board (PCB), which means that there is a conducting layer on the top and on the bottom of the board. The manufacturer prints a layout of traces and areas (think: roads and places) onto the surfaces and treats them with acid. That way the non-printed surface sections vanish and distinct electrical pathes remain. On the top-side all the light-blue/green areas are conductive, whereas the dark ones are non-conductive. On the bottom-side it’s the greyish areas that conduct, while the white ones are isolating. The numerous ② little holes are called “vias” and act as a loophole bridging over from the front to the back. This is the only way to avoid unwanted intersections between the traces. The ③ conductive areas on both sides conduct ground voltage (GND) for the greater part.

Upon closer look you see some smaller surface-mounted devices (SMD):

- ④ Capacitators are mostly used for decoupling (read: smoothening) the current flow. The clock-rate of 16 MhZ would otherwise be enough to introduce a lot of noise and thus cause erratic behaviour.
- ⑤ Diodes are there for ensuring the current direction and preventing potential damage by reverse polarisation from the outside.
- ⑥ Resistors are limiting the amount of current. ⑦ resistor networks are space-efficient way of bundling multiple resistors into a small single device – they otherwise function in the same way.
