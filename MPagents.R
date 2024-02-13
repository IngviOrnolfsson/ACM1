##### PLACEHOLDER AGENT #####
MPbase <- R6Class("MPbase",list(
  
  ### PARAMETERS
  name = NULL,
  params = NULL,
  role = NULL,
  paramNames = NULL,
  paramDescription = NULL,
  
  ### CONSTRUCTOR AND PRINT
  initialize = function(name,
                        params,
                        role){
    self$name <- name
    self$params <- params
    self$role <- role},
  
  ### METHODS
  firstchoice = function(){choice <- NA},
  choicemodel = function(record,ir){choice <- NA}
))

##### RANDOM CHOICE AGENT #####
MPrand <- R6Class("MPrand",inherit = MPbase,list(
  
  ### CONSTRUCTOR
  initialize = function(name = 'RAND',
                        params = c(0.5),
                        role = ''){
    super$initialize(name,params,role)
    self$paramNames = c('Bias')
    self$paramDescription = c("Probability of choosing '1'")},
  
  ### METHODS
  firstchoice = function(){choice <- rbinom(1, 1, self$params[1])},
  choicemodel = function(record,ir){choice <- rbinom(1, 1, self$params[1])}
))

##### WIN-STAY LOSE-SHIFT CHOICE AGENT #####
MPwsls <- R6Class("MPwsls",inherit = MPbase,list(
  
  ### CONSTRUCTOR
  initialize = function(name = 'WSLS',
                        params = c(1),
                        role = ''){
    super$initialize(name,params,role)
    self$paramNames = c('WSLS rate')
    self$paramDescription = c("Probability of choosing WSLS heuristic")},
  
  ### METHODS
  firstchoice = function(){choice <- rbinom(1, 1, 0.5)},
  choicemodel = function(record,ir){
    
    prevChoice <- record$selfChoice[ir-1]
    prevWin <- record$win[ir-1]
    
    # Roll against noise_rate
    roll = rbinom(1, 1, self$params[1])
    
    # If success: win = stay, lose = shift
    # Else: win = shift, lose = stay
    WinStayLoseShift <- as.integer(prevWin==prevChoice)
    if (roll == 1) {nextChoice <- WinStayLoseShift} 
    else if (roll == 0) {nextChoice <- !WinStayLoseShift}
    
    return(nextChoice)}
))

##### THEORY-OF-MIND-1 WSLS AGENT #####
MPtom1 <- R6Class("MPtom1",inherit = MPbase,list(
  
  ### CONSTRUCTOR
  initialize = function(name = 'TOM1',
                        params = c(1),
                        role = ''){
    super$initialize(name,params,role)
    self$paramNames = c('TOM1 rate')
    self$paramDescription = c("Probability of choosing TOM1 heuristic")},
  
  ### METHODS
  firstchoice = function(){choice <- rbinom(1, 1, 0.5)},
  choicemodel = function(record,ir){
    prevChoiceOther <- record$otherChoice[ir-1]
    prevWinOther <- !record$win[ir-1]
    
    # Determine preferred play (assuming opponent plays win-stay)
    predictedOpponentPlay <- prevWinOther == prevChoiceOther
    if (self$role == 'odd'){preferredPlay <-  !predictedOpponentPlay}
    else if (self$role == 'even'){preferredPlay <- predictedOpponentPlay}
    
    # Roll against noise_rate, if success, follow preferred play
    roll = rbinom(1, 1, self$params[1])
    if (roll == 1) {nextChoice <- preferredPlay}
    else if (roll == 0) {nextChoice <- !preferredPlay}
    
    return(nextChoice)}
))

