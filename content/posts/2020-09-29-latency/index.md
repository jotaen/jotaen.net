+++
title = "Waiting for Godot"
subtitle = "The hidden performance implications of sending bits over the wire"
date = "2020-09-29"
tags = ["devops"]
image = "ethernet-cables.jpg"
image_info = ""
image_colouring = "320"
id = "hma2x"
url = "hma2x/network-overhead-latency"
aliases = ["hma2x"]
+++

If you open a web page (such as this one) and wait for it to be fully loaded, chances are that only a small portion of the overall waiting time is actually spent with processing the request on the webserver. A heavy toll is taken by the mechanisms used to transfer all the bits and bytes over the wire. And by that I don’t mean the pure downlink rate, but rather the communication overhead that is imposed by the involved transport protocols, which have a significant share in the overall latency.

Especially nowadays, web pages are not just simple “pages” anymore, but they are often small applications of considerable size that consist of dozens if not hundreds of individual pieces. Delivering all that data is quite a challenge, at least when it needs to be done in a way that is both reasonably fast and reliable. Fortunately, the protocol stack has evolved side by side with the complexity of web frontends over the years in order to keep waiting times within bearable boundaries.

## Signal transmission

Let’s start with a basic primer in physics. Electrical signals race through cables with breakneck speed – yet, their journey is anything but instantaneous. Light travels at nearly 300,000 km/s in vacuum, which means that it approximately takes 3.3 ms to cover 1,000 km. That being said, it would take around 20 ms for a light beam to travel the linear distance of ~6,000 km between Frankfurt (Germany) and New York (USA).

In reality the bits are not sent through vacuum though, but they are – for the greater part of long-haul connections – transported via optical fiber. The efficiency of these conduits is significantly lower than the theoretical maximum of the vacuum. This circumstance is expressed by the so-called *refractive index*, which typically ranges close to 1.5 for modern fiber cables.[^1] This means that the transmission takes 1½ times as long compared to vacuum and therefore lengthens our intercontinental journey from 20 ms to about 30 ms.

Leaving out the fact here that suboptimal routing and various network devices along the way introduce further latency, it’s fair to assume that a roundtrip from Frankfurt to New York and back will take at least 60 ms to complete. (For the mere signal transmission alone, mind you!) This story would not be worth telling if all the data was transferred in one go. However, quite the opposite is true: the execution of a single web request requires a multitude of sequential data units to be sent back and forth between client and server. If you imagine that there were, say, ten roundtrips necessary in order to complete our transatlantic request, then 600 ms would already be spent only for the signals commuting through the wires.

## Under the hood of HTTP

Visiting a web page – in brief – means composing a HTTP request[^2], sending that to the server in charge, and then processing the returned HTTP response. (Usually, further requests need to be made until the web page is fully loaded and rendered, but for simplicity we will just consider a single one here.) For a HTTP request a web browser typically has to carry out the following procedure:

#### 1. DNS lookup (domain name system)
The domain name (e.g. `jotaen.net`) needs to be resolved in order to get to know the IP address of the corresponding server. The lookup is done iteratively starting from the nearest DNS server and therefore the number of necessary roundtrips can vary a lot. Fortunately, a DNS request is only performed once for one and the same domain name and the result is cached for the time being.

#### 2. TCP handshake
The “envelope” in which HTTP requests usually are transferred is TCP, the *transmission control protocol*. Establishing a TCP connection requires a so-called *TCP-handshake* to be performed upfront, which consists of one full network roundtrip between client and server. 

#### 3. TLS handshake
Nowadays, most web connections are encrypted with TLS[^3], the *transport layer security* protocol. The TLS handshake, in which meta information about the crypto algorithms is exchanged, requires a twofold back and forth between client and server.  

#### 4. Data transfer
As you can see, there was a lot of toing and froing so far. And yet we haven’t send out a single bit of the actual HTTP request – this can finally happen now. Depending on the amount of data it contains, an HTTP message must be broken up into multiple TCP packets that are delivered one after the other. All these TCP packets have to be acknowledged indiviually by the respective recipient, which necessitates significant extra time. (On the other hand it is crucial for the reliability of the transmission.) Once the last bit of the HTTP response has arrived at the client, the connection is closed.

One characteristic feature of TCP is that the maximum packet size is restricted in the initial phase and only is gradually increased. This mechanism is referred to as *congestion control* and is an important strategy to avoid overloading the network. The cost of it is that TCP connections “start slow”: depending on the individual configuration, it might take a few roundtrips of transmission and acknowledgement to deliver even smaller amounts of data in the early phase of every TCP connection.

## Optimisations

As mentioned in the beginning, web pages have gotten more and more complex over the years, with both number and size of their indiviual pieces steadily growing. In order to keep up with this trend the involved protocols already underwent some important improvements:

- While HTTP/1 only allowed one request per TCP connection, with **HTTP/2** it became possible to send out multiple requests over one and the same TCP connection, which is called *multiplexing*. Additionally, servers are allowed to push resources to the client unaskedly, i.e. to send HTTP responses for requests the client has yet to make.
- TLS 1.2 required 3 full roundtrips for the initial handshake – **TLS 1.3** contents itself with up to 2 of them at the most. The 0-RTT mechanism (*zero round trip time*) allows to skip the handshake completely for idempotent requests in case client and server have already communicated before.
- **TCP Fast Open** is a technique to shorten the handshake of successive TCP connections, because client and server already “know each other”.

The most significant change that is about to come (at the time of this writing in September 2020) is the third revision of HTTP, in which TCP is abandoned in favour of a new transport protocol called QUIC. QUIC builds on top of UDP and not only speeds up the initialisation of connections, but it also addresses the fundamental problem of *head-of-line-blocking*. This phenomenon occurs when a series of network packets is held up by the first one being stuck and is one of the biggest weaknesses of using TCP for web requests.

As you can see, major bottlenecks of transport mechanisms are 1) the number of communication roundtrips that are needed to establish a connection and exchange data over it, 2) the geographical distance that the signals have to travel, and 3) the efficiency of the protocols when it comes to transferring multiple chunks of related data in one go. Taking care of that is mostly the job of the implementors of server engines. For application developers, however, there is still the same advice holding true that was already well-known a decade ago: reduce the size and number of assets, make sure that caching is properly setup, and – wherever possible – serve content to users from geographically close locations.


[^1]: Curiously, the propagation speed for signals in copper wire is not so much lower, by the way, but fiber is superior in terms of bandwidth and maximum distance.
[^2]: An HTTP request is a serial document to formally describe the request and its parameters.
[^3]: The term SSL, a predecessor of TLS, is still used synonymously.
