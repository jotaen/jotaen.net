+++
title = "Mental Poker"
subtitle = "A p2p algorithm for playing card games"
date = "2020-05-04"
tags = ["coding"]
image = "/posts/2020-05-04-mental-poker/game-cards.jpg"
image_colouring = "50"
id = "2A4BQ"
url = "2A4BQ/mental-poker-explained"
aliases = ["2A4BQ"]
+++

Last week I had written about my project in which I built a cryptographically secure implementation for playing the dice game Yahtzee peer-to-peer. Some people were curious about the design of the game protocol, especially in regards to the dice rolling procedure. This is quite fascinating indeed, because while the algorithm is actually quite simple, you first need to wrap your head around the requirements and constraints that are imposed by peer-to-peer setups.

I thought you might be interested in a follow-up blog post on that topic, because apart from rolling dice there are other interesting algorithms that can be used for implementing distributed parlour games. (Again: without using an authoritative third-party server to facilitate the process.) One of them solves the problem of shuffling cards and drawing them from a deck, either face up or face down. It has become popular under the name “Mental Poker” and was already developed in 1979 by Adi Shamir, Ronald Rivest and Leonard Adleman[^1] – the very same cryptographers by the way who invented the RSA cryptosystem (hence the acronym).

# Commutative Encryption

The *Mental Poker* protocol is based on the idea of commutative symmetric encryption and it is important to understand that concept beforehand. Commutative encryption is a mechanism for messages that get encrypted by multiple participants subsequently. The clue is that the individual keys can be applied in arbitrary order, regardless of the order in which they had been used for encryption.

In order to understand how that works, let’s look at an example. One upfront remark: for the sake of simplicity we are going to use the `XOR` bit operation as encryption algorithm on 8-bit fixed-width words. That’s okay for this example but in reality that would neither work from a practical point of view, nor would it make for sufficiently strong encryption.

Let’s say there are two participants, Alice and Bob. First, Alice encrypts a plain message with her secret key and sends the result to Bob:

```txt
11101101    (Original “plain“ message)
01100011    (Alice’s secret key)
========
10001110    (XOR result)
```

Now, Bob encrypts the result that he had received from Alice with his secret key. Bob cannot read the original message though, because he doesn’t know Alice’s key. The message is effectively encrypted twice now and Bob sends it back to Alice.

```txt
10001110    (The result from Alice)
10111001    (Bob’s secret key)
========
00110111    (XOR result)
```

The eventual ciphertext is now encrypted twice and both keys are needed to restore the original message. The order in which you apply the keys for decryption doesn’t matter:[^2] whether you decrypt with Alice’s key first and with Bob’s key second, or the other way around – the result is the same. Or, in mathematical terms:

```txt
     r ^ a ^ b = m
<=>  r ^ b ^ a = m
```


# Mental Poker

Now that we know how commutative encryption works we can look at the *Mental Poker* protocol. Alice and Bob will again act as model for the explanation, but you could add an arbitrary amount of players to the game if you’d like.

First of all, Alice and Bob need to agree on a deck of cards they want to play with. That might be any number and kind of cards that can be represented by some unique identifier (think of an `enum` in Java). The procedure for setting up the deck requires two round-trips:

#### 1. Shuffling the deck:
Alice shuffles the cards, i.e. she brings the list of card identifiers into a random order. She generates one secret key, encrypts all values with it and sends the result to Bob. Without be able to know what the list actually contains, Bob also reorders the items randomly and encrypts them all with his key. He finally returns the result back to Alice. Alice now possesses a list of double-encrypted identifiers. The order of cards is ultimately determined, yet no player alone is able to figure out which list item corresponds to which card.

#### 2. Making the cards “drawable”:
While the deck is shuffled now, the cards cannot be drawn individually yet, since every player had just used a single key during the shuffling phase. By sharing the initial keys, the entire deck would be revealed. Therefore, the players need to swap their “universal” shuffling key with individual keys, one for every card. (They first apply the shuffling key to partially decrypt all items and then apply the new individual keys.) This is done by every player one after the other.

When a player wants to draw or reveal a card, they need to send a request to the other players to collect the corresponding keys. The other players can decide whether they agree with the request and send back their respective keys. That way cards can be dealt face down or revealed face up: in the former case the requester doesn’t share his keys back, thereby effectively keeping the cards secret to everyone except for themself.


[^1]: You can read the original paper [here](http://people.csail.mit.edu/rivest/ShamirRivestAdleman-MentalPoker.pdf), as it was published in the Mathematical Gardener in 1981.
[^2]: In case you want to double-check: the inverse operation of `XOR` is again `XOR`.
