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

# The heart

- ① Main processor: ATmega 328P-PU
- ② 16 MHz Ceramic oscillator
- ③ Digital Pins
- ④ Analog Input Pins
- ⑤ Power Pins
- ⑥ [ISCP](https://en.wikipedia.org/wiki/In-system_programming)

# Powerhouse

The power supply section of the Arduino board is a sophisticated (read: well thought out) circuitry whose job is to ensure that a stable current is supplied to the board. You can think of it as a lobby(?), where incoming current is conditioned and regulated, before it is fed into the board’s 5V power supplies. The mounted components are quite sensitive: while undervoltage can slow down the board or bring it to a halt, overvoltage can quickly cause severe damage that might be hard to repair. (Casually speaking, the device is “bricked” then, because it is just as useful.) Hence, it is utterly important to have well-regulated 5V flowing within the power supplies.

Arduino is capable to draw power from multiple sources. The most obvious one is the ① USB Socket, which is supposed to provide 5V according to the USB standard. This happens to presicely match the demand of the Atmega-chip and can thus be used as is. Only a ② fuse is there to prevent damage to the board and the connected host computer from potential electrical overload.

Another way of supplying power is via the ③ coaxial power connector (or: barrel connector). Incoming current is first passes a ④ diode, which only allows current to flow into one direction. This is a safety measure against a coaxial connector potentially having the wrong polarity. The current is then buffered in two big ⑤ capacitators that absorb electrical fluctuations in order to stabilize the power supply. The big ⑥ voltage regulator caps input voltage of up to 17V and provides a steady 5V output that is then fed into the board’s power supply. It will produce a considerable amount of heat, depending on how close you get to the allowed input maximum.

Both power lines are connected to a ⑦ dual-operational amplifier, whose analog comparator decides which of the two shall be drawn from. Consequently, a ⑧ transistor gets toggled accordingly.

For the sake of comleteness: power can also be supplied via the Vin-Pin or the 5V Pin. In the first case, current takes the same path as described for the coaxial power connector with the exception of the diode, which is not passed. In the second case, power is supposed to be regulated externally and therefor fed right into the board’s power supplies without any further ado.

There is another, smaller ⑨ voltage regulator that reduces the regulated 5V to 3.3V and its output is connected to the 3.3V power Pin.

-   (LM358) with analog comparator https://arduino.stackexchange.com/questions/893/what-happens-if-i-power-the-arduino-with-both-the-usb-and-external-power-voltage
- ⓪ Power-LED

# Auxiliary devices

- ① mega16U2
    - Serial communication
    - [328P-Bootloading](https://www.arduino.cc/en/Hacking/Bootloader?from=Tutorial.Bootloader)
- ② [16 MHz quartz crystal](https://en.wikipedia.org/wiki/Crystal_oscillator)
ceramic resonator
- ③ Reset Button
- ④ ISCP (or ISP)
- ⑤ JP2
- ⑥ RESET EN
- ⑦ TX/RX LEDs
- ⑧ Onboard LED

# Wiring

- ① Conductive traces
- ② Vias
- ③ Conductive areas: mostly ground (GND)
- ④ Status LEDs
- SMDs:
    - ⑤ Capacitators (decoupling) https://forum.digikey.com/t/smt-electrolytic-capacitor-with-no-voltage-rating/974
    - ⑥ Diodes
    - ⑦/⑧ Resistors / Resistor networks
