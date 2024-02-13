# ACM - Assignment 1
To run:

1) Set the path to this directory in the startup.R file
2) Run startup.R (you may need to install some packages first)
3a) Run runMP_singlegame.R to simulate a single game between two players.
3b) Run runMP_tournament.R to simulate a tournament between many players (i.e. the heatmap thing)


Other files included: 

I) MPagents.R contains the different agents that play the game, coded as R6Class objects. There are three types of agents included (apart from one placeholder class, which doesn't do anything): Random choice with bias, WSLS with noise, and TOM1-WSLS with noise. The agents all use a single parameter (p[0;1]), and for all agents, p = 0.5 means that they make unbiased random decisions. 
- For the RAND agent, p is the decision bias. p is equal to the probability of choosing "1".
- For the WSLS agent, p = 1 results in a "win-stay, lose-shift"-strategy, whereas p = 0 results in "win-shift, lose-stay". 
- For the TOM1-WSLS model, p = 1 results in a strategy assuming the other player uses "win-stay, lose-shift", and p = 0 results in a strategy assuming the other player uses "win-shift, lose-stay". 

II) MPgame.R contains the rules of the game. This R6Class object takes two MPagent objects as inputs and simulates a game of some amount of trials. The game choices and winrates are stored in the gameRecord property of the object. The MPgame objects also contains a plotting method to plot the results of the game. 