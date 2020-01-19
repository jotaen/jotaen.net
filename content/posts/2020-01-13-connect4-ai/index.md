+++
draft = true
title = "connect4-ai"
subtitle = "On building a game AI for “Connect Four”"
date = "2020-01-13"
tags = ["coding"]
image = "/posts/2020-01-13-connect4-ai/winter-tree.jpg"
image_colouring = 10
image_info = "Photo by Fabrice Villard on Unsplash"
id = "lAFT4"
url = "lAFT4/connect-4-game-ai-artificial-intelligence"
aliases = ["lAFT4"]
+++

You probably still know the game “Connect Four” from your childhood. It is also known under names like “Four Up“, “Four in a Row” or “Captain’s mistress” and goes like this: two players take turns dropping their discs into the slots of a 6×7 vertical grid. The first player who manages to connect four of their discs (either horizontally, vertically or diagonally) wins the match.

The game is so simple that basically every child can learn how to play it in no time. Connect Four is build around visual patterns that are natural for humans to reason about and its rules are intuitive as in they match up with physical mechanics, such as that discs fall through to the bottom of a slot, or that filled-up slots are closed off.

<div style="max-width:400px;">
<div style="position:relative;width:100%;height:0;padding-bottom:125%;">
    <iframe style="position:absolute;left:0;top:0;width:100%;height:100%;" src="https://static.jotaen.net/connect4-ai/index.html" frameborder="0"></iframe>
</div>
</div>

I just finished building an artificial intelligence for Connect Four that entirely runs in your browser. The game board above is interactive, so you can give it a try and virtually play against your own computer. ([Click here](https://static.jotaen.net/connect4-ai/index.html) to open the game in a separate window.)

While the game might be easy for humans to pick up, it is quite difficult to teach a computer to play it in a decent way. In this blog post I explain the basic conecpts and key components of such a game AI and how constraints and limitations can be dealt with. So in case you are not familiar with AIs yet, you can gain an understanding of what goes on behind the curtain.

You find the [source code](https://github.com/jotaen/connect4-ai) of my project on GitHub, if you are interested to dive deeper. Note though, that this blog post is not a detailed code walk-through or a step-by-step tutorial, since that would be well beyond scope.

# The basics

> **Artificial intelligence (AI)**, the ability of a digital computer or computer-controlled robot to perform tasks commonly associated with intelligent beings. ([Encyclopædia Britannica](https://www.britannica.com/technology/artificial-intelligence))

On a high level, the Connect Four AI is a set of (well established) algorithms that is used to predict and assess how the game can possibly evolve from any given situation. While computers are generally good at performing a lot of computations in a short amount of time, the problem space of Connect Four is enormous nonetheless: starting from an empty grid, there are almost 5 trillion[^1] possible courses through the game that will either end in one player winning or in a draw. Under the (of course ludicrously utopian) assumption that a computer would be capable of evaluating one prospective turn per clock stroke, it would take a 3 GhZ CPU up to half an hour to figure out its next move. Multiply that by the amount of clock cycles it takes for real and you understand that this wouldn’t be exactly fun to interact with.

My goal with this project was to build an AI that runs completely client-side and that is still challenging to play against. These objectives are somewhat contradictory, because the strength of the AI mostly depends on computing power while the client’s resources can be highly limited (e.g. someone using an older smartphone). In order to confine the waiting time for the user, I decided to concede a certain number computational cycles that the AI is allowed to execute until it must ultimately yield the next move. This is called “iteration budget”. Since the runtime of each iteration is roughly constant, the iteration budget is a simple and sufficient mechanism to keep the overall turn time within reasonable bounds.

The technology for the implementation is mostly dictated by the target platform, which is a web browser in this case – hence, I implemented the AI in JavaScript. It goes without saying that the general performance of the algorithms matter a lot, because the same functions are executed over and over again. Since my project has a strong experimental and educational character, I didn’t sacrifice good abstractions for better performance. If you are interested in details, you find the [source code](https://github.com/jotaen/connect4-ai) on GitHub. The tech stack is: JavaScript (mostly written in a functional style using the [Ramda library](https://ramdajs.com/)) and React for the web frontend.

# Components of the Connect Four AI

## Minimax and tree evaluation

The heart of the AI is an algorithm called Minimax. If you haven’t heard of that term, let me tell you that you have probably already applied it in daily live. Remember, for instance, how football teams were assembled back in school: starting with two captains, each team would alternatingly nominate one player to join them until no player is left over. The goals are to obtain the best players but also to establish a good balance of skills. Each team only pick one player at a time, so they must assume that the other team will select the next best available player for them and factor these predictions into their decision.

The way the AI evaluates future moves of Connect Four follows the same mechanism. It simulates dropping a disc into one of the free slots and then puts itself into the opponent’s shoes to see how they could possibly react. Based on these hypothetic outcomes, it tries out all further options again – and so on and so forth. Both players have precisely opponing goals, because a win for one player automatically means a loss for the other and vice versa[^2]. This decision making strategy can be modelled as a tree structure like so:

![](Decision tree for predicting future game evolvements)

The top of the branch (the **root node**) represents the current game situation. In the picture above there are three choices (think: three available slots to drop into) which are called **branches**. These lead to the next potential game states (**nodes**) from where on there are further choices. This way you can proceed to wander through the hypothetic future until you either reach a final state (a **leaf node**) or if you have reached the maximum tree depth and have to abort evaluation. The overall computing effort grows exponentially with the depth level.

In order to quantify leaf nodes the AI assigns a positive score to leaves where it wins, a negative score when it loses, and neutral score for a draw (e.g. `0`). In order to make a decision the tree is unwinded from the leaves: if a particular node is controlled by the AI, the branch with the highest score is chosen. If a node is controlled by the opponent, the AI assumes that the opponent will choose the branch with the lowest possible score. That way the scores bubble up from the leaves upwards. As soon as the root level branch happens to have a positive score the AI can be sure that it can enforce winning the game by entering that particular branch (i.e. dropping a disc into that slot).

## Heuristics

For most part of the game, the AI will not be able to evaluate the game tree to the very bottom and discover all leaves. Instead, the tree depth must be capped at some level in order to meet the iteration budget. Therefore, especially in the beginning of the game, there will be mostly unknown scores for the root level branches. Or worse, the AI might see itself confronted with only negatively scored branches, i.e. losses. Instead of “giving up” it should rather fight to the last breath, in the hope that the opponent might make a mistake.

In all of those cases, the AI can make reasonable assumptions in order to maximise its chances, despite there not being any ascertainable or necessarily positive outcomes in sight. These decision-making strategies are called “heuristics” and the AI implements the following of them:

#### Slot order:
Thorough analyses of Connect Four have proven that center slots generally give better chances than the outer ones to win the game in the best case or to establish advantageous strategies at the least. Therefore the AI will generally prefer center columns. Curiously, as an aside, the only chance for you to win against a perfect Connect Four AI would be to open the game in the center slot. The adjacent slots would only allow for a draw and the four outermost slots would inevitably make you lose the game the moment you drop the first disc into them. All this, however, would require the AI to have almost full prediction depth.

#### Relative scores:
There is one key difference in how humans and computers predict the future: the assessment of a computer either yields a well-defined score or no score at all, whereas the assessment of a human somehow gets more and more “fuzzy” with increasing prediction depth. It might happen that the AI detects negative scores (i.e. potential losses) on all root branches, but that you as human player don’t see your opportunities at all, because they are too far ahead. Therefore, the AI will always choose the “smallest evil” and enter the branch where the loss is the farthest away.

![](Relative scoring)

#### Acting on opportunities:
A similar mechanism comes into play when the AI only concludes indeterminate scores on the root level. This effectively means that it cannot enforce a win with making the next move. This doesn’t imply, however, that there wouldn’t be any win opportunities at all down the line. As we already discussed, humans tend to overlook or misjudge constellations the more turns they consist of or the farther away they are. Hence, the AI will favour branches with the highest chance for the human opponent to make a mistake, which the AI could then take advantage of. In other words: when there is no better choice, the AI tries to allure you into situations where it’s most likely for you to screw it up.

![](Chances)

## Deep cut-off

The end result of a Connect Four match comes down to all or nothing – you either win or you don’t win. There are, for example, no extra points for winning fast or for managing to connect more than four discs. This has an important implication for the evaluation of the game tree: from any given node, if the AI finds a winning path, it can stop evaluating all remaining branches (and hence corresponding subtrees) of that particular node. After all, it’s not important to know that there would be additional ways to win, a single one is enough. The AI is rather better off to safe precious iteration budget for other parts of the game tree. This technique is called “pruning” or “deep cut-off” and the potential savings in computational effort are often immense.

![](Cutting off subtrees and limiting local iteration depth)

When it comes to pruning there is one caveat in regards to the human opponent, though. Cutting off subtrees implies that the respective player will reliably spot the even most remote opportunity and follow that path thrustfully without making a mistake along the way. This is true for a computer, but not so much for a human being, as we already discussed in the previous section. Consequently, the AI cannot just cut off subtrees on behalf of the opponent the same way it does it for itself. It rather needs to figure out the closest possible loss for nodes that are controlled by the opponent. The AI can still optimise, however, because instead of cutting off it can limit the local subtree depth for adjacent branches to the level of the nearest loss candidate.

## Caching transpositions

Imagine the following opening scenario: you drop into slot 1, the AI drops into slot 2, then you drop into slot 3 and eventually the AI drops into slot 4. This same constellation can be reached in multiple other ways. But no matter through which series of turns the game ended up being there, the evaluation of that particular state will always be the same. This is a so-called “transposition”. The AI can therefore cache all its evaluations, as it is very likely that the same situations will be encountered multiple times during game tree evaluation. That reduces the overall effort significantly and comes at a well affordable memory cost.

## Iterative deepening

The naive approach to tree evaluation would be to just start digging down the tree and then work ourselves from the left to the right. We have an important constraint though, which is the maximum number of allowed iterations that the AI is supposed to perform. In the worst case, the iteration limit would strike while most of the root branches are still completely opaque and unevaluated. For that reason the AI must make sure to achieve a good compromise between tree depth and tree breadth.

Due to the unbalanced and unknown nature of the game tree the eventual overall effort cannot be precisely calculated upfront. The AI can, however, estimate the maximum tree depth that it is able to reach even under worst circumstances. Therefore, it starts by performing a depth-first search and perform a complete inspection of the game tree until that initial depth maximum.

There virtually will always be iteration budget left afterwards, so the AI continues to reiterate branch by branch and level by level in order to refine the results, until all iteration budget is exceeded[^3]. As explained ealier, the branches are always prioritised from the center to the edges and therefore also processed in that order. This means that iterative deepening automatically happens in line with branch priority. And, of course, only branches with unknown scores are reiterated.

You might wonder about this technique to completely start over evaluating a root branch only to increase its depth by one single level. Remember though, that the effort grows exponentially with the depth, so the cost of restoring an already inspected subtree is somewhat neglectable in contrast to the additional effort that it takes to increment the prediction depth from there on. Apart from that, the cache and all the other optimisations help to avoid redundant computations whenever possible.

## The “human touch”

Since the AI is composed from deterministic algorithms, it would theoretically always make the exact same decision for one particular game situation (or: transposition). A human could easily figure out the weak spot of the AI and then always reproduce the same choreography in order to win the game. To prevent this from happening, the AI will slightly distort the results in a random way under certain conditions. You will most likely notice that behaviour in the beginning of the game.


[^1]: The precise number of 4 531 985 219 092 can be found in the [On-Line Encyclopedia of Integer Sequences](https://oeis.org/A212693)
[^2]: “Minimax” is sometimes also called “Negamax” for that reason.
[^3]: The iteration budget is a soft limit, so it is supposed to be okay for the AI to slightly overshoot it.
