+++
title = "Waiting for Godot"
subtitle = "The factor of network overhead when loading a web page"
date = "2020-09-29"
tags = ["devops"]
image = "/posts/2020-09-29-latency/ethernet-cables.jpg"
image_info = ""
image_colouring = "320"
id = "hma2x"
url = "hma2x/network-overhead-latency"
aliases = ["hma2x"]
+++

If you open a web page (such as this one) and wait for it to be fully loaded, chances are that only a small portion of the overall waiting time is actually spent with processing the request on the webserver. A heavy toll is taken by the mechanisms used to transport all the bits and bytes over the wire.

Especially nowadays, web pages are not just simple “pages” anymore, but they are often small applications of considerable size that consist of dozens if not hundreds of individual pieces. The overhead of transferring all that data over the network can get out of hand fairly quickly – which is not just inefficient but eventually manifests itself in an experience that feels sluggish and brittle for end users. Fortunately, the protocol stack has evolved side by side with the complexity of web frontends in order to keep waiting times within bearable boundaries.

## Signal transmission

Let’s start with a basic primer in physics. Electrical signals race through cables with breakneck speed – yet, their journey is anything but instantaneous. Light travels at nearly 300,000 km/s in vacuum, which means that it approximately needs 3.3 ms to cover 1,000 km. That being said, it would take around 20 ms for a light beam to travel the linear distance of ~6,000 km between Frankfurt (Germany) and New York (USA).

In reality the bits are not sent through vacuum though, but they are – for the greater part – transported via optical fiber. The efficiency of these conduits is significantly lower than the theoretical maximum of the vacuum. A circumstance that is expressed by the so-called *refractive index*, which is typically ranging close to 1.5 for modern fiber cables. This means that the transmission takes 1½ times as long compared to vacuum and therefore lenghthens our transatlantic journey from 20 ms to about 30 ms.

Leaving out the fact here that suboptimal routing and various network devices along the way introduce further latency, it’s fair to assume that a roundtrip from Frankfurt to New York and back will take at least 60 ms to complete. (For the mere signal transmission alone, mind you!) This story would not be worth telling if all the data was transferred in one go. However, quite the opposite is true: the retrieval of a web page requires a multitude of individual exchanges of data units to be sent back and forth between client and server.

## Under the hood of HTTP

Visiting a web page – in brief – means composing a HTTP request[^1], sending that to the server in charge, and then processing the returning HTTP response. (Usually, further HTTPS requests are needed to be made until the web page is completely loaded and rendered.) For a single HTTP request a web browser typically needs to carry out the following procedure beforehand:

#### 1. DNS lookup (domain name system)
The domain name (e.g. `jotaen.net`) needs to be resolved in order to get to know the IP address of the corresponding server. The lookup is done iteratively and therefore can vary in time significantly. Fortunately, a DNS request is only performed once for one and the same domain name and the result gets cached for the time being.

#### 2. TCP handshake
The “envelope” in which HTTP requests usually get transferred is TCP, the *transmission control protocol*. Establishing a TCP connection requires a so-called *TCP-handshake* to be performed upfront, which consists of one full network roundtrip between client and server. 

#### 3. TLS handshake
Nowadays, most web connections are encrypted with TLS, the *transport layer security* protocol. (The term *SSL*, a predecessor of TLS, is still used synonymously.) The TLS handshake, in which meta information about the crypto algorithms is exchanged, requires a twofold back and forth between client and server.  

As you can see, there is a lot of toing and froing – and yet we haven’t send out a single bit of the actual HTTP request so far. Depending on the amount of data it contains, an HTTP message might need to get broken up into multiple TCP packets that get delivered one after the other. All TCP packets have to get acknowledged indiviually by the respective recipient, which necessitates significant extra time on the one hand, but is crucial for the reliability of the transmission on the other.

Furthermore, the maximum size of the packets is restricted in the initial phase and then gets gradually increased. This mechanism is referred to as *congestion control* and is an important strategy to avoid overloading the network. The cost of it is that TCP connections “start slow”: depending on the individual configuration, it might take a few roundtrips of transmission and acknowledgement to deliver even smaller amounts of data in the early phase of every TCP connection.

## Optimisations

As mentioned in the beginning, web pages have gotten more and more complex over the years, with both number and size of their indiviual pieces steadily growing. In order to keep up with this trend the involved protocols already underwent some important improvements:

- While HTTP/1 only allowed one request per TCP connection, with **HTTP/2** it became possible to send out multiple requests over one and the same TCP connection, which is called *multiplexing*. Additionally, servers are allowed to push resources to the client unaskedly, i.e. to send HTTP responses for requests the client has yet to make.
- TLS 1.2 required 3 full roundtrips for the initial handshake – **TLS 1.3** contents itself with up to 2 of them at the most. Moreover, the 0-RTT mechanism (*zero round trip time*) allows to skip the handshake completely for idempotent requests in case client and server have already communicated before.
- **TCP Fast Open** is a technique to shorten the handshake of successive TCP connections.

The most significant change that is about to come (at the time of this writing in September 2020) is the third revision of HTTP, in which TCP gets abandoned in favour of a new protocol called QUIC. QUIC builds on top of UDP and not only speeds up the initialisation of connections, but it also addresses the problem of *head-of-line-blocking* (which occurs when a series of network packets is held up by the first one being stuck).

Despite all those technical improvements in the network stack there is still the same advice holding true for web developers that was already well-known a decade ago: reduce size and number of assets, configure proper caching, and – wherever possible – serve content to users from geographically close locations.


[^1]: An HTTP request is a serial document to formally describe the request and its parameters.
