+++
title = "Crypto Yahtzee"
subtitle = "Rolling the dices, peer to peer"
date = "2020-04-19"
tags = ["project"]
image = "/posts/2020-04-19-crypto-yahtzee/dices.jpg"
image_colouring = "150"
id = "K001f"
url = "K001f/crypto-yahtzee"
aliases = ["K001f"]
+++

The first ever recorded match of correspondence chess took place in 1804 in the Netherlands. If you don’t know what “correspondence chess” is, you can imagine it as being some sort of precursor for online gaming – minus the internet of course. Instead, the player’s turns are exchanged via post cards, which means that a match can easily take several months. (A single one, mind you). From a modern software development point of view, this is a nightmare both in terms of transaction latency and transport security.

The world of remote gaming has obviously changed, especially in the last two decades. Although peer-to-peer implementations exist (even within the action genre) the majority of today’s multiplayer games are carried out via dedicated, central servers. This approach makes a lot of things simpler, because the game provider has full control over the course of the match: orchestrating the players is less complex and no participant is able to manipulate the game to their own advantage.

However, the idea of playing peer-to-peer like in the old days can live on and be applied to modern communication infrastructure. That is especially true for turn-based parlour games like chess or Yahtzee. My most recent toy project was the implementation of a transactionally robust and cryptographically secure mechanism to play the dice game Yahtzee without needing an authoritative server. I describe this concept in the following post and you also find a playable reference implementation on Github. (Be warned about the latter, though – it’s a bit geeky.)

![Command line interface of my Crypto Yahtzee reference implementation](TODO)

[^1]

# Game Protocol

A quick reminder of the rules: [Yahtzee](https://en.wikipedia.org/wiki/Yahtzee) is played with usually a handful of players who take turns one after the other. Every player has three attempts per turn to roll five dices,  which they need to achieve certain combinations with. (E.g., five in a row, equivalent to a straight in Poker.) The scores are recorded on a scorecard and the game is finished once all 13 categories have been accomplished (or dismissed) by all players.

In a peer-to-peer version there is no game server that could hold the state of a match. Therefore, every player maintains their own copy of the game state and updates it by exchanging transactions with their opponents. E.g., “I keep the two fours and roll the other dices again” or “I record the current cast with a score of 4 in the ‘aces’ category”.

* Check state compatibility

# Security

Security-wise, there are two problems at hand: how can we be sure that a transaction was issued by a participant of the match and not by some evil “man-in-the-middle”? Even with verified authorship, however, a nasty spoilsport could record transactions of one game and then intersperse them in the next one just to confuse everybody. The answer to these problems are cryptographic signatures and hash chains.

#### Cryptographic signatures:
Before a match starts, the participants generate an [asymmetric key pairs](https://en.wikipedia.org/wiki/Public-key_cryptography) and distribute their public key through a trustful source. Transactions get signed by the original author with their (secret) private key. Everyone in posession of the corresponding public key can then verify the authenticity.

#### Hash chains:
Each player keeps track of all received transactions by appending them to a hash chain. Every transaction contains a checksum (hash) of the preceding transaction, which guarantees definite order within the chain. If just a single bit of data was incompatible, then all subsequent hashes would compute differently. Unique affiliation to a particular chain is ensured by adding a unique identifier to the root block of the chain.

![Illustration of a hash chain with signed transactions]()

# Rolling dices

Checking that someone doesn’t cheat when rolling dices is a no-brainer in real life: you just watch them doing it. That’s obviously not an option in a distributed peer-to-peer setup. Generating a truly random dice roll that cannot be manipulated requires a multi-step procedure:

1. Every player generates a random bit sequence (value) on their own computer. In the first round, only the hash of their random values are shared between all players.
2. Once all players have populated their hashes, the original values are revealed. Everyone can verify that all values match up with the previously published hashes and that nothing had been altered after the fact.
3. The random values now get fed into a function that transforms them into a dice value (i.e. a number between 1 and 6). The algorithm is a deterministic mapping, so it always yields the same result for one and the same given input values.

One important remark here: in my implementation I use 32-bit bit sequences for the random bit sequences. That, however, would make it quite easy for players to generate rainbow tables that allow for a reverse lookup of the hashes. There are multiple ways to circumvent this – I decided to make use of strong unique seeds, which makes rainbow table generation virtually impossible.

# Networking

* buffering, network failover
* block arrival order
* not truly p2p, broker


[^1]: A screenshot of the command line interface of my p2p Yahtzee implementation
