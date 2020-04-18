+++
title = "Crypto Yahtzee"
subtitle = "Rolling the dices, peer to peer"
date = "2020-04-19"
tags = ["project"]
image = "/posts/2020-04-19-crypto-yahtzee/dices.jpg"
image_colouring = "210"
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

In a peer-to-peer version there is no game server that can hold the state of a match. Therefore, every player maintains their own copy of the game state and updates it by exchanging transactions. E.g., “I keep the two fours and roll the other dices again” or “I record the current cast with a score of 4 in the ‘aces’ category”.

# Security

Security-wise, there are two problems at hand: how can we be sure that a transaction was issued by a fellow player and not by some evil man-in-the-middle? Even with verified authorship, however, a nasty spoilsport could record transactions of one game and then intersperse them in the next one just to confuse everybody. The answer to these problems are cryptographic signatures and hash chains.

#### Cryptographic signatures:
Before a match starts, the participants generate an [asymmetric key pair](https://en.wikipedia.org/wiki/Public-key_cryptography) and distribute their public key through a trustful source. Transactions get signed by the original author with their (secret) private key and can be verified by everyone in posession of the corresponding public key.

#### Hash chains:
Each player keeps track of all received transactions by appending them to a hash chain. Every transaction contains a checksum (hash) of the preceding transaction, which guarantees definite order within the chain. If just a single bit of data was incompatible, then all subsequent hashes would compute differently. Unique affiliation to a particular chain is ensured by adding a unique identifier to the root block of the chain.

# Rolling dices

Checking that someone doesn’t cheat when rolling dices is a no-brainer in real life: you just watch them doing it. That’s obviously not an option in a distributed peer-to-peer setup. There are still ways to generate random numbers in a manner that cannot be compromised or manipulated. Such a procedure is twofold:

1. Every player generates a random number on their own computer. In the first step, only the hash value of their numbers get distributed.
2. Once all players have populated their hashes, the underlying random numbers are revealed. Everyone can verify that all numbers match up with their previously published hashes, which implies that nobody has 

The result of rolling the dices that way is determined through a universal and deterministic function that takes a list of seed numbers and maps to a dice value.

# Networking

[^1]: A screenshot of the command line interface of my p2p Yahtzee implementation
