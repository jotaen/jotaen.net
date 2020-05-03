+++
title = "Mental Poker"
subtitle = "A secure peer-to-peer algorithm for card games"
date = "2020-05-04"
tags = ["coding"]
image = "/posts/2020-05-04-mental-poker/game-cards.jpg"
image_colouring = "150"
id = "2A4BQ"
url = "2A4BQ/mental-poker-explained"
aliases = ["2A4BQ"]
+++

Last week I wrote about the project that I released, in which I built a cryptographically secure peer-to-peer implementation of the dice game Yahtzee. 
Although it only comes with a rudimentary command line interface, it still is surprisingly fun to play. Some people were also curious about the design of the game protocol, especially in regards to the dice rolling procedure. The algorithm is actually quite simple, but you first need to wrap your head around the characteristics and constraints that are imposed by the peer-to-peer setup.

I thought you might be interested in this follow-up blog post, because apart from rolling dice there are more algorithms that can be used for implementing distributed parlour games. One of them has become popular under the name “Mental Poker” and describes a protocol for shuffling cards and drawing them from a deck. (Just to remind you: without needing an authorative third-party server!) It was developed in 1979 by Adi Shamir, Ronald Rivest and Leonard Adleman[^1], the very same cryptographers who invented the RSA cryptosystem (hence acronym: RSA).

# Commutative Encryption

The Mental Poker protocol is based on the idea of commutative symmetric encryption. When a message gets encrypted by multiple participants subsequently, the individual keys can be applied in arbitrary order during decryption.

In order to understand how that works, let’s look at an example. Despite not being cryptographically secure per se, we use the `XOR` bit operation as encryption procedure for the sake of simplicity. Let’s say there are two participants, Alice and Bob. First, Alice encrypts a plain message with her secret key and sends the result to Bob.

```
MESSAGE:    11101101 (original “plain“ message)
ALICE KEY:  01100011
            ======== (XOR)
            10001110
```

Now, Bob encrypts the received result with his secret key and sends it back to Alice. Bob cannot read the original message though, because he doesn’t know Alice’s key. The message is effectively encrypted twice now.

```
MESSAGE:    10001110 (the result from Alice)
BOB KEY:    10111001
            ======== (XOR)
            00110111
```

The eventual ciphertext is now encrypted twice and both keys are needed to restore the original message. And as you can try for yourself, the order in which you apply the keys for decryption doesn’t matter.[^2] Whether you decrypt with Alice’s key first and with Bob’s key second, or the other way around – the result is the same. Or, in mathematical terms:

```
     r ^ a ^ b = m
<=>  r ^ b ^ a = m
```


# Mental Poker

With the knowledge on commutative encryption we can now look at the Mental Poker protocol. Alice and Bob will again act as model for the explanation, but you could add an arbitrary amount of players to the game if you’d like. In the first step Alice and Bob need to agree on a deck of cards they want to play with. Every card needs to be uniquely identifiable, for example by an integer or any other distinguishable value.

### 1. Shuffling the deck
Alice shuffles the cards, i.e. she creates a list of randomly ordered identifiers. Next, she encrypts all values and sends the result to Bob. Without being able to tell which card is which, Bob shuffles all values again and encrypts them with his own secret key. He then returns the result back to Alice.

### 2. Making the cards individually drawable
Alice now applies her secret key to the list of values in order to partially decrypt them. Since she doesn’t know Bob’s key, she is unable to tell in which way Bob had reordered the cards.


[^1]: You can read the original paper [here](http://people.csail.mit.edu/rivest/ShamirRivestAdleman-MentalPoker.pdf), as it was published in the Mathematical Gardener in 1981.
[^2]: The inverse operation of `XOR` is again `XOR`.
