+++
draft = true
title = "connect4-ai"
subtitle = "On building a game AI for “Connect Four”"
date = "2020-01-13"
tags = ["coding"]
image = "/posts/2020-01-13/connect-four-tree.jpg"
image_colouring = 230
image_info = ""
id = "lAFT4"
url = "lAFT4/connect-4-game-ai-artificial-intelligence"
aliases = ["lAFT4"]
+++

You probably still know the game “Connect Four” from your childhood. It is also known under names like “Four Up“, “Four in a Row” or “Captain’s mistress” and goes like this: two players take turns dropping their discs into the slots of a 6×7 vertical grid. The first player who manages to connect four of their discs (either horizontally, vertically or diagonally) wins the match.

The game is so simple that basically every child can learn how to play it in no time. Connect Four is build around visual patterns that are natural for humans to work with and its rules are intuitive as in they match up with physical mechanics, such as that discs fall through to the bottom of a slot, or that filled-up slots are not playable.

I just finished building an artificial intelligence for Connect Four that entirely runs in your browser. The game board below is interactive, so you can give it a try and virtually play against your own computer. ([Click here](https://static.jotaen.net/connect4-ai/index.html) to open the game in a separate window.)

<div style="max-width:400px;">
<div style="position:relative;width:100%;height:0;padding-bottom:125%;">
    <iframe style="position:absolute;left:0;top:0;width:100%;height:100%;" src="https://static.jotaen.net/connect4-ai/index.html" frameborder="0"></iframe>
</div>
</div>

While the game might be easy for humans to pick up, it is quite difficult to teach a modern computer to play it in a decent way. In this blog post I will go over the key aspects of how a game AI like this can be build and how to deal with constraints and limitations. (It is not, however, a detailed walk-through of source code or a step-by-step tutorial, since both would be well beyond scope for a single blog post.)

# The basics

> **Artificial intelligence (AI)**, the ability of a digital computer or computer-controlled robot to perform tasks commonly associated with intelligent beings. [^1]

On a high level, my Connect Four AI is basically a set of algorithms that is used to predict and assess how the game can possibly evolve from any given situation. While computers are generally good at performing a lot of computations in a short amount of time, the problem space of Connect Four is still enormous: starting from an empty grid, there are almost 5 trillion possible courses[^2] through the game that will end either in one player winning or in a draw. Under the (of course ludicrously utopian) assumption that a computer would be capable of evaluating one prospective turn per clock stroke, it would take a 3 GhZ CPU up to half an hour to figure out its next move. Multiply that by the amount of clock cycles it takes for real and it becomes clear that this wouldn’t be exactly fun to play with.

- Constraints
    - Platform
    - Iteration budget per turn (~ runtime), soft limit
    - General performance of implementation
- [project](https://github.com/jotaen/connect4-ai)

# Components of the Connect Four AI

## Minimax and tree evaluation

The heart of my AI is an algorithm called Minimax. If you haven’t heard of that term, let me tell you that you have probably already applied it in daily live. Remember, for instance, how football teams were assembled back in school: starting with two captains, each team would alternatingly nominate one player to join them until no player is left. Since every team can only pick one player at a time, they must assume that the other team will select the next best available player and factor these predictions into their decision.

The way my AI evaluates future moves of Connect Four follows the same mechanism. It simulates dropping a disc into one of the free slots and then puts itself into the opponent’s shoes to see how they could possibly react. Based on these hypothetic outcomes, it tries out all further options again – and so on and so forth. This decision making strategy can be modelled as a tree structure like so:

![](Hypothetic decision tree for predicting future game evolvements)

- Tree depth, effort
- Terminology: Root, leaf, node, branch, subtree, score, (prediction) depth

Note that both players have precisely opponing goals, because a win for one player automatically means a loss for the other and vice versa[^3]. That being said, the AI can assign a positive score to leaves where it wins, a negative score when it loses, and neutral score for a draw (e.g. `0`). To find the best path, the AI would select a branch with a high score for its own turns and a branch with a low score when it simulates the opponent’s turns. The score bubbles up from the leaves to the root, as long as the respective decisions on every tree level are compulsory according to the above rules. Hence, when there is a root branch with positive score, the AI knows that it can enforce a win by deciding for this branch.

## Heuristics

For most part of the game, my AI will not be able to evaluate the game tree to the very bottom and discover all leaves. Instead, the tree depth must be capped at some level in order to meet the iteration budget. Therefore, especially in the beginning of the game, there will be mostly unknown scores for the root level branches. Or worse, the AI might see itself confronted with only negatively scored branches, i.e. losses. Instead of “giving up” it should rather fight to the last breath, in the hope that the opponent might make a mistake.

In all of those cases, the AI can make reasonable assumptions in order to maximise its chances, despite there not being any ascertainable or necessarily positive outcomes in sight. These decision-making strategies are called “heuristics” and my AI implements the following of them:

- Thorough analyses of Connect Four have proven that center slots generally give better chances than the outer ones to win the game in the best case or to establish advantageous strategies at the least. Therefore my AI will generally prefer center columns. Curiously, as an aside, the only chance for you to win against a perfect Connect Four AI would be to open the game in the center slot. The adjacent slots would only allow for a draw and the four outermost slots would inevitably make you lose the game the moment you drop the first disc into them. All this, however, would require the AI to have almost full prediction depth.
- There is one key difference in how humans and computers predict the future: the assessment of a computer either yields a well-defined score or no score at all, whereas the assessment of a human somehow gets more and more “fuzzy” with increasing prediction depth. Consequently, humans tend to overlook or misjudge constellations the more turns they consist of or the farther away they are. Hence, the AI will favour branches with the highest chance for the human opponent to make a mistake that the AI could take advantage of. In other words: the AI tries to allure you into constellations where it’s most likely for you to screw it up.
- Scoring factoring in depth

## Deep cut-off

The end result of a Connect Four match is all or nothing. There are, for example, no extra points for winning fast or for managing to connect more than four discs. This has an important implication for the evaluation of the game tree: from any given node, if the AI finds a winning path, it can stop evaluating all remaining branches of that particular node. After all, it is not important to know that there would also be other ways to win. Instead, the AI is better off to safe precious iteration budget for other parts of the game tree. This technique is called “pruning” or “deep cut-off” and the potential savings in computational effort can be immense.

When it comes to pruning there is one caveat in regards to the human opponent. Cutting off subtrees implicitly assumes that the respective player will reliably spot the even most remote opportunity and follow that path thrustfully without making a mistake along the way. This is true for a computer, but not for a human being, as we already discussed in the previous section. Consequently, the AI cannot just cut off subtrees on behalf of the opponent the same way it does it for itself. It rather always needs to figure out the closest possible loss for any turn the opponent can make. Instead of cutting off an opponent’s subtree, the AI will limit the local iteration depth, but it needs to proceed evaluation in order to find the leaf with the highest score.

## Caching transpositions

Imagine the following opening scenario: you drop into slot 1, the AI drops into slot 2, then you drop into slot 3 and eventually the AI drops into slot 4. This same constellation can be reached in multiple other ways. But no matter through which previous events the game ended up being there, the evaluation of that particular state will always be the same. This is a so-called “transposition”. The AI can therefore cache all its evaluations, as it is very likely that the same situations will be encountered multiple times during game tree evaluation. That reduces the overall effort significantly and only comes at a very reasonable memory cost.

## Iterative deepening

- Why iterative deepening in the first place?

Since my AI is given a specific iteration budget it can mathematically estimate the maximum tree depth that it is able to reach even under worst circumstances. Therefore, it starts by performing a depth-first search till that certain level. Since there is virtually always iteration budget left afterwards, the AI continues to reiterate branch by branch and level by level in order to refine the results, until all iteration budget is exceeded. As explained ealier, the branches are always prioritised from the center to the edges and therefore also processed in that order. This means that iterative deepening automatically happens in line with branch priority.

## The “human touch”


[^1]: The definition of “AI” as of the [Encyclopædia Britannica](https://www.britannica.com/technology/artificial-intelligence)
[^2]: The precise number of 4,531,985,219,092 can be found in the [On-Line Encyclopedia of Integer Sequences](https://oeis.org/A212693)
[^3]: “Minimax” is sometimes also called “Negamax” for that reason.
