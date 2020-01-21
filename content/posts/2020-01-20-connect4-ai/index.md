+++
title = "connect4-ai"
subtitle = "On building a game AI for “Connect Four”"
date = "2020-01-20"
tags = ["coding", "project"]
image = "/posts/2020-01-20-connect4-ai/winter-tree.jpg"
image_colouring = 10
image_info = "Photo by Fabrice Villard on Unsplash"
id = "lAFT4"
url = "lAFT4/connect-4-game-ai-artificial-intelligence"
aliases = ["lAFT4"]
+++

You probably still know the game “Connect Four” from your childhood. It is also known under names like “Four Up“, “Four in a Row” or “Captain’s mistress” and goes like this: two players take turns dropping their discs into the slots of a 6×7&nbsp;vertical grid. The first player who manages to connect four of their discs (either horizontally, vertically or diagonally) wins the match.

The game is so simple that basically every child can learn to play it in no time. Connect Four is build around visual patterns that are natural for humans to reason about and its rules are intuitive as in they match up with physical mechanics, such as that discs fall through to the bottom of a slot, or that filled-up slots are no longer playable. But as easy as the game might be for humans to pick up, as challenging it is to teach a computer to play it in a decent way.

<div style="max-width:400px;">
<div style="position:relative;width:100%;height:0;padding-bottom:125%;">
    <iframe style="position:absolute;left:0;top:0;width:100%;height:100%;" src="https://static.jotaen.net/connect4-ai/index.html" frameborder="0"></iframe>
</div>
</div>

I just finished building an artificial intelligence for Connect Four that entirely runs in your browser. The game board above is interactive, so you can give it a try and virtually play against your own computer. ([Click here](https://static.jotaen.net/connect4-ai/index.html) to open the game in a separate window.) In this blog post I explain the basic conecpts and key components of such a game AI and how constraints and limitations can be dealt with. You find the [source code](https://github.com/jotaen/connect4-ai) of my project on GitHub, if you are interested to dive deeper. Note though, that this blog post is not a detailed code walk-through or a step-by-step tutorial, since that would be well beyond scope.

# The basics

> **Artificial intelligence (AI)**, the ability of a digital computer or computer-controlled robot to perform tasks commonly associated with intelligent beings. ([Encyclopædia Britannica](https://www.britannica.com/technology/artificial-intelligence))

On a high level, the Connect Four AI is a set of (well established) algorithms, which are used to predict and assess how the game could possibly evolve from any given situation. While computers are generally good at performing a lot of calculations in a short amount of time, the problem space of Connect Four is enormous nonetheless: starting from an empty grid, there are almost 5&nbsp;trillion[^1] possible courses through the game that will either end in one player winning or in a draw. Under the (of course ludicrously utopian) assumption that a computer would be capable of evaluating one prospective turn per clock stroke, it would take a 3&nbsp;GhZ CPU up to half an hour to eventually decide for a single move. Multiply that by the amount of clock cycles it takes for real and you understand that this wouldn’t be exactly fun to interact with.

My goal with this project was to build an AI that runs completely client-side and that is still challenging to play against. These objectives are somewhat contradictory, because the strength of the AI mostly depends on computing power while the client’s resources can be highly limited (e.g. on older smartphones). In order to limit the waiting time for the user, I decided to concede a certain number of computational cycles that the AI is allowed to execute until it must ultimately yield its next move. This artificial constraint is called “iteration budget”. Since the runtime of each iteration is roughly constant, the iteration budget is a simple and sufficient mechanism to keep the overall turn time within reasonable bounds.

The technology for the implementation is mostly dictated by the target platform (the web browser), which is why I wrote the AI in JavaScript. It goes without saying that the general performance of the algorithms matters a lot, because the functions are executed over and over again. My project has a strong experimental and educational character, so I attributed more importance to modularity and coding style consistency than to excessive performance optimisations. You also might notice that the involved components sometimes have overlapping (redundant) effects.

The [source code](https://github.com/jotaen/connect4-ai) resides on GitHub and the tech stack is: JavaScript (mostly written in a functional style using the [Ramda library](https://ramdajs.com/)) and React for the web frontend. There is also a CLI interface.

# Components of the Connect Four AI

## Minimax and tree evaluation

The heart of the AI is an algorithm called Minimax. If that name sounds unfamiliar to you, let me tell you that you have probably already applied it in daily live. Remember, for instance, how football teams were assembled back in school: starting with two captains, each team alternatingly nominates one player to join them until no player is left. The goals are to obtain the best players on the one hand and to establish a good balance of skills at the same time. Each team can only pick one player per turn, so in order to achieve the best possible result they also need to factor in what player the other team will most likely choose afterwards.

The way the AI evaluates future moves in Connect Four follows the same mechanism. It simulates dropping a disc into each of the free slots and then puts itself into the opponent’s shoes to see how they could possibly react. Based on these hypothetic outcomes, the AI tries out all further options again – and so on and so forth. Both players have precisely opponing goals, because a win for one player automatically means a loss for the other and vice versa[^2]. This decision making strategy can be modelled as a tree structure like so:

![Decision tree for predicting future game evolvements](/posts/2020-01-20-connect4-ai/game-tree.png)

Let’s settle on some terminology first: the top of the **tree** is called **root node** and represents the current game situation after the opponent has finished their turn. In the picture above there are three choices (think: three available slots to drop into) which are called **branches**. These lead to the next potential game states (**nodes**) and their subsequent **subtrees**. This way the hypothetic future of the game can be explored until a final state is reached – a **leaf node**. This either means that one player has won or that the game has ended in a draw. The **depth** of the above tree is 3&nbsp;levels. The numbers that are assigned to the leaf nodes are **scores** that are needed to make a quantified decision. Positive scores indicate that the AI would win the game, negative scores mean that it would lose, and a neutral score is a draw (here: `0`).

In order to render a decision for the next move, the tree is unwinded from the leaves upwards. For every node on our way up we do the following: if the AI is on turn (i.e. MAX gets to choose a branch) the branch with the highest score is chosen. When the opponent is on turn (i.e. MIN gets to choose a branch), the AI assumes that the opponent would choose the branch with the lowest possible score. The score of the elected branch becomes the score of the current node. That way a score bubbles up from the leaves to the root, while the decision strategy alternates at every level.

If a root branch happens to show a positive score, the AI can be sure that it is able to enforce a win by entering that particular branch (i.e. dropping a disc into that slot). In the above example, the AI would decide for the middle branch, because regardless of how the opponent reacts, the AI can bring the game to a win. This is different for both of the other branches, where the match will either be lost (left branch) or ends with a draw (right branch). At the end of the day we can only speculate about the opponent’s actions of course, but at least we have no reason to believe that they would do us a favour intentionally.

The Minimax algorithm is the heart of the Connect Four AI. While “thinking” the computer repetitively simulates turn after turn in the hope to find a path through the tree that will eventually lead to a definite win. Most of the time, unfortunately, things are not that convenient…

## Heuristics

For most of the time during the game, the AI will not be able to evaluate the game tree to find all leaves. Remember: the maximum tree depth is 42 for a blank grid and we already learned that this would require evaluating almost 5&nbsp;trillion nodes. Realistically, we can expect to evaluate some thousands or ten thousands of nodes at most, depending on the client’s hardware. The tree depth must consequently be capped at a relatively early level in order to meet the iteration budget. That also implicates that especially in the beginning of the match there will be mostly unknown scores for the root level branches.

The computer can still make reasonable assumptions in order to maximise its chances, despite there not being any ascertainable or necessarily positive outcomes in sight. These experiential decision-making strategies are called “heuristics” and the AI implements the following of them:

#### Slot order:
Center slots give better chances than the outer ones to win the game in the best case or to establish advantageous constellations at the least. Therefore the AI will generally prefer slots in the middle. Fun fact, as an aside: the only chance for you to win against a perfect Connect Four AI would be to open the game in the center slot. The adjacent slots would only allow for a draw and the four outermost slots would inevitably make you lose the game the moment you drop the first disc into them. All this, however, would require the AI to have nearly full prediction depth and it could stall its loss until the grid is almost completely filled up.

#### Depth-based scores:
There is one key difference in how humans and computers predict the future: the assessment of a computer either yields a well-defined score or no score at all, whereas the assessment of a human somehow gets more and more “fuzzy” with increasing prediction depth. As shown in the tree below it might happen that the AI detects negative scores (i.e. potential losses) for all root branches. No matter how the AI would decide, the opponent can potentially enforce a loss in any event. As a human player, however, you maybe don’t even recognise all your opportunities, because they are too far ahead. In order to account for that human characteristic, the AI will always choose the “smallest evil” and enter the branch where the loss is the farthest away. In the tree below the AI would go for the middle branch, because there is at least a slight chance to turn the tide if the opponent happens to make a mistake during their turn. Without factoring depth into the scores, it would appear as if the AI “gave up” the moment it detects a hopeless situation. Instead of making a seemingly random move (*all* slots are losses, after all) it should always respond to the most obvious threat, because the opponent might not even be aware that they had gained the upper hand altogether.

![Relative scoring](/posts/2020-01-20-connect4-ai/relative-scoring.png)

#### Acting on opportunities:
A similar mechanism comes into play when the AI concludes nothing better than indeterminate scores for the root branches. This effectively means the game won’t enter a definite state within the next two turns. (Well, at least as far as the AI can tell…) This doesn’t imply, however, that there wouldn’t be any good opportunities down the line. As we already discussed, humans tend to overlook or misjudge constellations the more turns they consist of or the farther away they are. Therefore, the AI will favour branches with the highest chance for the human opponent to make a mistake, which the AI could then take advantage of. In other words: when there is no better option, the AI tries to allure you into situations where it’s most likely for you to screw it up.

## Deep cut-off / pruning

The end result of a Connect Four match comes down to all or nothing – you either win or you don’t win. There are, for example, no extra points for winning fast or for managing to connect more than four discs. This has an important implication for the evaluation of the game tree: from any given node, if the AI finds an enforcable path, it can stop evaluating all remaining adjacent branches (and hence the corresponding subtrees) of that particular node. After all, it’s not important to know that there would be additional ways to win – a single one is enough. The AI is rather better off to safe precious iteration budget for other parts of the game tree. This technique is called “pruning” or “deep cut-off” and the potential savings in computational effort can be immense.

When it comes to pruning there is one caveat in regards to the human opponent, though. Cutting off subtrees presumes that the respective player will reliably spot the even most remote opportunity and follow that path thrustfully without making a mistake along the way. This is true for a computer, but not so much for a human being, as we already discussed in the previous section. Consequently, the AI cannot just cut off subtrees on behalf of the opponent the same way it does it for itself. It rather needs to continue evaluating that node in order to detect the closest of all possible losses. Again: the more concrete an opportunity is, the more likely it is for the opponent to recognise that! There is still room for optimisation, though: the prediction depth for the subtrees of such a node can be limited, because the AI only needs to check for loss candidates that are *closer* than the one already found.

![Pruning / deep cut-off](/posts/2020-01-20-connect4-ai/pruning.png)

The above tree shows how both techniques come into effect. The right part shows how entire subtrees are cut off once an enforcable positive score has been found. All the adjacent branches for that node can be disregarded just as if they wouldn’t even exist. The left part shows how the prediction depth for a subtree is limited when an enforcable negative score has been found. If the AI didn’t do this, the corresponding root level branch would errorneously show a score of `-0.5` instead of `-1`, which could cause the AI to make a badly informed and thus unfavourable decision. (Not in this very example, of course, but much more in general.)

## Caching transpositions

Imagine the following opening scenario: you drop into slot&nbsp;1, the AI drops into slot&nbsp;2, then you drop into slot&nbsp;3 and eventually the AI drops into slot&nbsp;4. This same constellation can be reached in multiple other ways. But no matter through which series of turns the game ended up being there, the evaluation of that particular state will always be the same. This is a so-called “transposition”. The AI can therefore cache all its evaluations, as it is very likely that the same situations will be encountered multiple times during game tree evaluation. That reduces the overall effort significantly and comes at a well affordable memory cost.

## Iterative deepening

A naive approach to tree evaluation would be to just start digging down the tree and then work from the left all the way to the right. That would neglect a pivotal constraint, though: the AI is supposed to respect a maximum number of allowed iterations for the sake of an endurable turn time. A worst case scenario would be that the AI is deep down in the guts of the leftmost subtree, when the iteration limit suddenly strikes. No further evaluations could be started and there would be nothing else but to make a very risky random move. To prevent this from happening the AI must make sure to achieve a good compromise between tree depth and tree breadth, according to the saying: “done is better than perfect”.

Due to the unbalanced and unforeseeable nature of the tree the eventual overall effort cannot be precisely calculated upfront. The AI can, however, estimate the *maximum* tree depth that it is able to reach assuming the worst circumstances. Therefore, it starts performing a depth-first search till that level. As there is almost always iteration budget left afterwards, the AI continues to reiterate branch by branch and level by level in order to refine the results, until all iteration budget is exceeded[^3]. As explained ealier, the branches are ordered by likeliness, which means that iterative deepening automatically happens in line with branch priority. (And, of course, only branches with unknown scores are reiterated.)

It might strike you odd that the AI completely starts over evaluating a subtree from the root on, only in order to increase the depth by one single level. Keep in mind, though, that the effort grows exponentially with the depth, so the cost of restoring an already inspected subtree is somewhat neglectable in contrast to the additional effort that it takes to increment the prediction depth from there on. Apart from that, the cache and all the other optimisations help to avoid redundant computations whenever possible.

## The “human touch”

Since the AI is composed from deterministic algorithms, it always makes the exact same decision for one particular game situation (or: transposition). In mathematic terms, the AI is a reproducible function from a board state to the next move. An opponent could easily figure out weak spots and then always rattle off the same choreography. To prevent this from happening, the AI will slightly distort the results in a normally distributed random way under certain conditions. You might be able to notice that effect in the early turns of the match, but without debug information it’s still hard to tell for sure.

# Conclusion

Speaking of the “human touch”: I’m quite happy with how the AI came about. Admittedly, I’m not a particularly strong Connect Four player myself, so due to the current shortcomings of the implementation I’m more or less on eye level. Sometimes I manage to defeat the computer, but often times the AI does already rise against its creator. (I’m fine with that, though.) Unrelated to all things algorithms, there are two vital factors that make me enjoy playing the game quite a bit: 1)&nbsp;the fact that the difficulty can be adjusted and 2)&nbsp;the pleasant user interface. Curiously, both are very much unrelated to the core subject of this project.

If I were to improve the AI further, I probably would implement more heuristics. The biggest threat is the opponent building up catch-22 (or: Zugzwang) situations, since the computer cannot recognise them reliably yet in case they are too “far away” and thus beyond the prediction depth.

In case your are interested in learning more about AI fundamentals and the related algorithms, I highly recommend the [online course on artificial intelligence](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-034-artificial-intelligence-fall-2010/) held by Patrick Winston at MIT in&nbsp;2010.


[^1]: The precise number of 4 531 985 219 092 can be found in the [On-Line Encyclopedia of Integer Sequences](https://oeis.org/A212693)
[^2]: Connect Four is a so-called [“zero-sum” game](https://en.wikipedia.org/wiki/Zero-sum_game) and the algorithm can also be referred to as “Negamax”.
[^3]: The iteration budget is a soft limit, so it is supposed to be okay for the AI to slightly overshoot it.
