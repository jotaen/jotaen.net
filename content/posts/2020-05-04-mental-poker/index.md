+++
title = "Mental Poker"
subtitle = "Dealing cards, peer to peer"
date = "2020-05-04"
tags = ["crypto"]
image = "game-cards.jpg"
image_colouring = "50"
id = "2A4BQ"
url = "2A4BQ/mental-poker-explained"
aliases = ["2A4BQ"]
+++

The other week [I had written about my project](/K001f/crypto-yahtzee) in which I built a cryptographically secured implementation for playing the dice game Yahtzee peer-to-peer. Some people were curious about the design of the game protocol, especially in regards to the dice rolling procedure. This is quite fascinating indeed, because even though the algorithm is quite simple in the end, you first need to wrap your head around the constraints and implications that are imposed by peer-to-peer setups. The absence of an authoritative and trusted third party can be made up for by means of cryptography.

I thought you might be interested in a follow-up blog post on that topic, because apart from rolling dice there are other interesting algorithms that can be used for implementing distributed parlour games. One of them solves the problem of shuffling cards and drawing them from a deck, either face up or face down. It has become popular under the name “Mental Poker” and was developed as early as in 1979 by Adi Shamir, Ronald Rivest and Leonard Adleman[^1]. (These, by the way, are the very same people who invented the RSA cryptosystem, hence the acronym.) This blog post gives you an overview of the protocol.


# Commutative Encryption

The *Mental Poker* protocol is based around the idea of commutative encryption and it is important to understand this concept beforehand. We speak of commutative encryption when a message is encrypted by multiple participants consecutively, while the decryption can happen in arbitrary order, as long as all keys eventually get applied. A nice physical analogy of commutative encryption is to think of a box that is sealed with multiple locks, where each lock belongs to one person. The order and the timing in which the locks are placed or removed doesn’t matter; the box can only be opened if all locks have been taken away by their owners.

In order to understand how that works on a computational level, let’s look at an example. For the sake of simplicity we are going to use the `XOR` bit-operation as cipher algorithm on 8-bit fixed-width words. That’s suitable to explain the basic idea but in reality it wouldn’t work from a practical point of view, let alone would it make for sufficiently strong cryptography. The mechanism, however, remains the same.

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
a ^ b = b ^ a = x    (commutative property)
```


# Mental Poker

Now that we have learned about commutative encryption we can look at the *Mental Poker* protocol. Alice and Bob will again act as model for the explanation, but you could add an arbitrary amount of players to the game if you’d like.

First of all, Alice and Bob need to agree on a deck of cards they want to play with. That might be any number and kind of cards that can be represented by some unique identifier (think of a list of `enum` values in Java). The procedure for preparing a deck and using it throughout the game requires multiple round-trips to be made:

#### 1. Shuffling the deck:
Alice shuffles the cards, i.e. she brings the list of card identifiers into a random order. She generates one secret key, encrypts all values with it and sends the resulting list to Bob. Without being able to know what the values actually mean, Bob also reorders the list randomly and encrypts all values with his own key. He then returns the result back to Alice. Alice now possesses a list of multi-encrypted identifiers. The order of cards is ultimately determined now, yet no player alone is able to figure out which list value corresponds to which card, as every player can only partially decrypt the list.

#### 2. Making the cards “drawable”:
While the deck is shuffled and concealed, the cards cannot be drawn individually yet. That is because each player had used a single key for the entire list during the shuffling phase – sharing these keys would lead to revealing the deck in its entirety. Therefore, the players need to swap their initial key (one per *deck* per player) with individual keys (one per *card* per player), i.e. they have to decrypt and reencrypt all values separately. Like in the first round, the list gets passed from player to player, so that everyone can carry out the procedure. Once the list ends up at Alice again the deck is ready to go.

#### 3. Dealing cards:
When a player wants to draw or reveal a card, they need to send a request to the other players and collect the corresponding keys from them. The other players check whether they consent with the request according to the rules of the game and send back their respective key. A card can be dealt face down or played face up; in the former case the requester just holds back their own key for the time being, in the latter they share it as well.


# Practical considerations

Using something like `XOR` alone is anything but a good choice as cipher scheme for *Mental Poker*. The most obvious vulnerability is referred to as “known-plaintext attack”: since both Alice and Bob know the original card identifiers, they can derive the adversaries’ secret key from the ciphertexts with minimal overhead and reveal the actual cards. Using strong and secure algorithms[^3] solves that (and other) problems but can also introduce noticeable latencies at the same time, due to the overall number of necessary cryptographic operations.

Apart from that there are some tricky practical problems, like what to do when a player drops out. In real-world Poker that might happen at any time without disrupting the other players in the match. With *Mental Poker*, however, the game would come to a halt, because the other players would be left unable to decrypt cards in the deck without the aid of everyone who was involved in the shuffling.

I’m not aware of there being commercial applications of *Mental Poker* and I guess that this is mostly due to the practical issues outlined above. There is, however, a lot of research around these questions. So in case you are curious enough, you will find countless papers and other interesting resources online for further reading.


[^1]: You can read [the original paper](http://people.csail.mit.edu/rivest/ShamirRivestAdleman-MentalPoker.pdf) as it was published in the Mathematical Gardener
[^2]: Friendly reminder: the inverse operation of `XOR` is again `XOR` (it’s therefore said to be “involutory”)
[^3]: For a detailed discussion of possible algorithms you find some more infos in [this paper](http://crypto.stanford.edu/~pgolle/papers/poker.pdf) for example
