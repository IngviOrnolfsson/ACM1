# Reset workspace and load packages
source('startup.R')

# Number of trials per game
nTrials = 100

# Parameter ranges to include in tournament
pOdd = seq(0, 1, by = 0.1)
pEven = seq(0, 1, by = 0.1)

# Table for game outcomes
data = tibble(expand.grid(WSLS_rate = pOdd,TOM1_rate = pEven))
data$winrateEVN = NA

# Loop over parameter combinations
tic = Sys.time()  # Timing the loop
for (i in 1:nrow(data)){
  
  # Define agents
  Odd = MPwsls$new(name = 'WSLS', params = c(data$WSLS_rate[i]), role = 'odd')
  Even = MPtom1$new(name = 'TOM1', params = c(data$TOM1_rate[i]), role = 'even') 
  
  # Define game and run it
  G = MPgame$new(ODD = Odd, EVN = Even, trials = nTrials)
  G$runGame()
  
  data$winrateEVN[i] = slice_max(G$gameRecord,trial,n=1)$cumWinEVN
}

# Print loop time
toc = Sys.time()
(Trun = toc-tic)

# Plot heatmap
ggplot(data, aes(WSLS_rate, TOM1_rate, fill= winrateEVN)) + 
  geom_tile()