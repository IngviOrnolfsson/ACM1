MPgame <- R6Class("MPgame",list(
  
  # General notes/terminology: 
  # EVN = Even, the player who is trying to match the pennies
  # ODD = Odd, the player who is trying to NOT match the pennies
  
  ### PARAMETERS
  ODD = NULL,
  EVN = NULL,
  trials = NULL,
  gameRecord = NULL,
  
  ### CONSTRUCTOR
  initialize = function(ODD = MPrand$new(),
                        EVN = MPwsls$new(),
                        trials = 100){
    self$ODD <- ODD
    self$EVN <- EVN
    self$trials <- trials
    self$gameRecord = tibble(trial = seq(trials),
                             choiceODD = rep(NA,trials),
                             choiceEVN = rep(NA,trials), 
                             winODD = rep(NA,trials),
                             winEVN = rep(NA,trials),
                             cumWinODD = rep(NA,trials),
                             cumWinEVN = rep(NA,trials))},
  ### METHODS 
  
  ## runGame(): Run a single game
  runGame = function(){
    for (i in 1:self$trials) {
      
      # Determine current choice
      if (i == 1){
        choiceODD <- self$ODD$firstchoice()
        choiceEVN <- self$EVN$firstchoice()}
      
      else {
        gameRecordODD = tibble(selfChoice = self$gameRecord$choiceODD,
                               otherChoice = self$gameRecord$choiceEVN,
                               win = self$gameRecord$winODD)
        gameRecordEVN = tibble(selfChoice = self$gameRecord$choiceEVN,
                               otherChoice = self$gameRecord$choiceODD,
                               win = self$gameRecord$winEVN)
        
        choiceODD <- self$ODD$choicemodel(gameRecordODD,i)
        choiceEVN <- self$EVN$choicemodel(gameRecordEVN,i)}
      
      # Determine winner
      winEVN = as.integer(choiceODD == choiceEVN)
      winODD = 1-winEVN
      
      # Record results
      self$gameRecord$choiceEVN[i] <- choiceEVN
      self$gameRecord$choiceODD[i] <- choiceODD
      self$gameRecord$winEVN[i] <- winEVN
      self$gameRecord$winODD[i] <- winODD}
    
    self$gameRecord$cumWinEVN <- cumsum(self$gameRecord$winEVN) / self$gameRecord$trial
    self$gameRecord$cumWinODD <- cumsum(self$gameRecord$winODD) / self$gameRecord$trial},
  
  ## pltGame(): Plot results of a single game
  pltGame = function(){
    Tchoice = slice_min(melt(select(G$gameRecord,trial,choiceEVN,choiceODD),id.vars = 'trial'),order_by = trial,n = 20)
    p1 <- ggplot(Tchoice, aes(x = trial, y = value, col = variable)) + 
      geom_line() + scale_x_continuous(breaks=c(1:10)) + scale_y_continuous(name = 'Choice',limits = c(0,1))
    
    Tcumwin = melt(select(G$gameRecord,trial,cumWinEVN,cumWinODD),id.vars = 'trial')
    winrateEVN = slice_max(G$gameRecord,trial)$cumWinEVN
    winrateODD = slice_max(G$gameRecord,trial)$cumWinODD
    p2 <- ggplot(Tcumwin, aes(x = trial, y = value, col = variable)) + 
      geom_line() + scale_y_continuous(name = 'Cumulative winrate',limits = c(0,1)) +
      annotate("text", x = self$trials*0.95, y = min(winrateEVN+0.02,0.97), label = winrateEVN) + 
      annotate("text", x = self$trials*0.95, y = min(winrateODD+0.02,0.97), label = winrateODD) 
    p1 + p2
    }
))