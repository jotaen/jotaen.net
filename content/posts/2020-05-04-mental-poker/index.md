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

Last week I had written about my project in which I built a cryptographically secured implementation for playing the dice game Yahtzee peer-to-peer. Some people were curious about the design of the game protocol, especially in regards to the dice rolling procedure. This is quite fascinating indeed, because even though the algorithm is actually quite simple in the end, you first need to wrap your head around the requirements and constraints that are imposed by peer-to-peer setups.

I thought you might be interested in a follow-up blog post on that topic, because apart from rolling dice there are other interesting algorithms that can be used for implementing distributed parlour games. (Again: without using an authoritative third-party server to facilitate the process.) One of them solves the problem of shuffling cards and drawing them from a deck, either face up or face down. It has become popular under the name “Mental Poker” and was developed as early as in 1979 by Adi Shamir, Ronald Rivest and Leonard Adleman[^1]. (By the way, these are the very same cryptographers who invented the RSA cryptosystem, hence the acronym).

# Commutative Encryption

The *Mental Poker* protocol is based on the idea of commutative symmetric encryption and it is important to understand that concept beforehand. Commutative encryption is a mechanism to encrypt messages by multiple participants consecutively (like the layers of an onion), whereas the decryption can still happen in arbitrary order, as long as all keys eventually get applied.

In order to understand how that works computationally, let’s look at an example. One upfront remark: for the sake of simplicity of this explanation we are going to use the `XOR` bit operation as encryption algorithm on 8-bit fixed-width words. That’s okay for this very example but in reality it would neither work from a practical point of view, nor would it make for sufficiently strong cryptography.

Let’s say there are two participants, Alice and Bob. First, Alice encrypts a plain message with her secret key and sends the result to Bob.

```txt
11101101    (Original “plain“ message)
01100011    (Alice’s secret key)
========
10001110    (XOR’ed result)
```

Now, Bob encrypts the result that he had received from Alice with his secret key. Bob cannot read the original message though, because he doesn’t know Alice’s key. Bob sends his result back to Alice.

```txt
10001110    (The result from Alice)
10111001    (Bob’s secret key)
========
00110111    (XOR’ed result)
```

The eventual ciphertext is now effectively encrypted twice and both keys are needed to restore the original message. The order in which you apply the keys for decryption doesn’t matter:[^2] whether you decrypt with Alice’s key first and with Bob’s key second, or the other way around – the result is the same. Or in mathematical terms:

```txt
     a ^ b = x
<=>  b ^ a = x
```


# Mental Poker

Now that we know how commutative encryption works we can look at the *Mental Poker* protocol. Alice and Bob will again act as model for the explanation, but you could add an arbitrary amount of players to the game if you’d like.

First of all, Alice and Bob need to agree on a deck of cards they want to play with. That might be any number and kind of cards that can be represented by some unique identifier (think of an `enum` in Java). The procedure for preparing a deck for a match requires two round-trips:

#### 1. Shuffling the deck:
Alice shuffles the cards, i.e. she brings the list of card identifiers into a random order. She generates one secret key, encrypts all values with it and sends the result to Bob. Without be able to know what the list actually contains, Bob also reorders the items randomly and encrypts them with his own key. He then returns the result back to Alice. Alice now possesses a list of multi-encrypted identifiers. The order of cards is ultimately determined, yet no player alone is able to figure out which list item corresponds to which card, as every player can only partially decrypt the list.

#### 2. Making the cards “drawable”:
While the deck is shuffled now, the cards cannot be drawn individually yet, because in the initial phase there was only one key per player. Sharing these initial keys would lead to revealing the deck in its entirety. Therefore, the players need to swap their initial key (one per *deck* per player) with individual keys (one per *card* per player), i.e. they have to decrypt and reencrypt all items. The order of cards doesn’t change anymore, so every player can carry out the procedure one after the other.

When a player wants to draw or reveal a card, they need to send a request to the other players and collect the corresponding keys from them. The other players decide on their own whether they agree with the request and send back their respective keys according to the rules of the game. That way a card can be dealt face down or revealed face up: in the former case the requester still holds back their own key, so they can already decrypt a card privately while leaving everyone else in the unknown until they eventually share the “final” key in return.

# Practical considerations

One major drawback of *Mental Poker* is that shuffling a deck is relatively slow, because it requires every player to encrypt every card (plus the initial encryption round-trip). Due to the nature of the algorithm the steps cannot be parallelised, but they have to happen one player at a time. There are known ways to optimise the overall shuffling time, but these are either specific to Poker or require trusted third-party services to be employed. Either way, it’s still interesting to see that such an implementation is basically possible.


[^1]: You can read [the original paper](http://people.csail.mit.edu/rivest/ShamirRivestAdleman-MentalPoker.pdf) as it was published in the Mathematical Gardener.
[^2]: In case you want to double-check: the inverse operation of `XOR` is again `XOR`.
