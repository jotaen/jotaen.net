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

# Main unit

- ① Main processor: ATmega 328P-PU
- ② 16 MHz Ceramic oscillator
- ③ Digital Pins
- ④ Analog Input Pins
- ⑤ [ISCP](https://en.wikipedia.org/wiki/In-system_programming)

# Power supply

- ① USB Socket
- ② Resettable Fuse (to prevent to much power to be drawn from host)
- ③ Coaxial power connector (barrel connector) / Vin-Pin
- ④ Diode
- ⑤ Capacitators
- [Voltage regulators](https://en.wikipedia.org/wiki/Voltage_regulator)
    - ⑥ 20V->5V
    - ⑦ 5V->3.3V
- ⑧ Dual-operational amplifier (LM358) with analog comparator https://arduino.stackexchange.com/questions/893/what-happens-if-i-power-the-arduino-with-both-the-usb-and-external-power-voltage
- ⑨ Transistor
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
