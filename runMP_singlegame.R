# Reset workspace and load packages
source('startup.R')

nTrials = 1000
# Parameter values
# For RAND, p = Bias (probability of choosing '1')
#
# For WSLS, 1 = Win-stay-lose-shift, 
#           0.5 = Unbiased random choice, 
#           0 = Win-shift-lose-stay 
#
# For TOM1, 1 = Assume opponent plays win-stay-lose-shift, 
#           0.5 = Unbiased random choice, 
#           0 = Assume opponent plays win-shift-lose-stay 
pOdd = 0.1
pEven = 0.1

# Define agents
Odd = MPwsls$new(name = 'WSLS', params = c(pOdd), role = 'odd')
Even = MPtom1$new(name = 'TOM1', params = c(pEven), role = 'even')

# Define game and run
G = MPgame$new(ODD = Odd, EVN = Even, trials = nTrials)
G$runGame()

G$pltGame()