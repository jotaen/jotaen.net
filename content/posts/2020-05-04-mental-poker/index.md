+++
title = "Mental Poker"
subtitle = "Dealing cards, peer to peer"
date = "2020-05-04"
tags = ["crypto"]
image = "/posts/2020-05-04-mental-poker/game-cards.jpg"
image_colouring = "50"
id = "2A4BQ"
url = "2A4BQ/mental-poker-explained"
aliases = ["2A4BQ"]
+++

The other week [I had written about my project](/K001f/crypto-yahtzee) in which I built a cryptographically secured implementation for playing the dice game Yahtzee peer-to-peer. Some people were curious about the design of the game protocol, especially in regards to the dice rolling procedure. This is quite fascinating indeed, because even though the algorithm is quite simple in the end, you first need to wrap your head around the constraints and implications that are imposed by peer-to-peer setups. The absence of an authoritative and trusted third party can be made up for by means of cryptography.

I thought you might be interested in a follow-up blog post on that topic, because apart from rolling dice there are other interesting algorithms that can be used for implementing distributed parlour games. One of them solves the problem of shuffling cards and drawing them from a deck, either face up or face down. It has become popular under the name “Mental Poker” and was developed as early as in 1979 by Adi Shamir, Ronald Rivest and Leonard Adleman[^1]. (These, by the way, are the very same people who invented the RSA cryptosystem, hence the acronym.) This blog post gives you an overview of the protocol.


# Commutative Encryption

The *Mental Poker* protocol is based around the idea of commutative encryption and it is important to understand this concept beforehand. We speak of commutative encryption when a message is encrypted by multiple participants consecutively, while the decryption can happen in arbitrary order, as long as all keys eventually get applied. A nice physical analogy of commutative encryption is to think of a box that is sealed with multiple locks, where each lock belongs to one person. The order and the timing in which the locks are placed or removed doesn’t matter and the box can only be opened if all locks have been taken away by their owners.

In order to understand how that works on a computational level, let’s look at an example. One upfront remark: for the sake of simplicity of we are going to use the `XOR` bit operation as cipher algorithm on 8-bit fixed-width words. That’s suitable to explain the basic mechanism but in reality it wouldn’t work from a practical point of view, let alone would it make for sufficiently strong cryptography.

Let’s say there are two participants, Alice and Bob. First, Alice encrypts a plain message with her secret key and sends the result to Bob.

```txt
11101101    (Original “plain“ message)
01100011    (Alice’s secret key)
========
10001110    (XOR’ed result)
```

Now, Bob encrypts the result that he had received from Alice with his secret key. Bob cannot read the original message though, because he doesn’t know Alice’s key.

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

Now that we have learned about commutative encryption we can look at the *Mental Poker* protocol. Alice and Bob will again act as model for the explanation, but you could add an arbitrary amount of players to the game if you’d like.

First of all, Alice and Bob need to agree on a deck of cards they want to play with. That might be any number and kind of cards that can be represented by some unique identifier (think of a List of `enum` values in Java). The procedure for preparing a deck and using it throughout the game requires multiple round-trips to be made:

#### 1. Shuffling the deck:
Alice shuffles the cards, i.e. she brings the list of card identifiers into a random order. She generates one secret key, encrypts all values with it and sends the resulting list to Bob. Without be able to know what the values actually mean, Bob also reorders the list randomly and encrypts all values with his own key. He then returns the result back to Alice. Alice now possesses a list of multi-encrypted identifiers. The order of cards is ultimately determined now, yet no player alone is able to figure out which list value corresponds to which card, as every player can only partially decrypt the list.

#### 2. Making the cards “drawable”:
While the deck is shuffled now, the cards cannot be drawn individually yet, because each player used a single key for the entire list during the shuffling phase – sharing these keys would lead to revealing the deck in its entirety. Therefore, the players need to swap their initial key (one per *deck* per player) with individual keys (one per *card* per player), i.e. they have to decrypt and reencrypt all value. That procedure is carried out by every player one after the other.

#### 3. Dealing cards:
When a player wants to draw or reveal a card, they need to send a request to the other players and collect the corresponding keys from them. The other players check whether they agree with the request according to the rules of the game and send back their respective key. That way a card can be dealt face down or played face up: in the former case the requester just holds back their own key for the time being.


# Practical considerations

You can now also easily see why `XOR` is anything but a good choice as cipher scheme for *Mental Poker*. The most obvious vulnerability is referred to as “known-plaintext attack”: since both Alice and Bob know the original card identifiers, they can easily derive the adversaries’ secret key from the ciphertexts and reveal the actual cards. Using strong enough cryptographic algorithms solves that problem but introduces major latencies at the same time, due to the overall number of necessary encryptions. To make matters worse, this process needs to happen one player at a time and cannot really be optimised for efficiency.

Apart from that there are some tricky practical problems, like what to do when a player drops out. In real-world Poker that can happen at any time without disrupting the other players in the match. With *Mental Poker*, however, the game would come to a halt, because the other players are being left unable to decrypt cards in the deck without the aid of everyone who was involved in its shuffling.

I’m not aware that there are commercial applications of *Mental Poker* and I guess that this is mostly due to the practical issues outlined above. There is, however, a lot of research going on. So in case you are curious enough, you will find countless papers and other interesting resources online.


[^1]: You can read [the original paper](http://people.csail.mit.edu/rivest/ShamirRivestAdleman-MentalPoker.pdf) as it was published in the Mathematical Gardener.
[^2]: Friendly reminder: the inverse operation of `XOR` is again `XOR`.
