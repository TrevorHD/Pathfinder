##### Generate terrain ------------------------------------------------------------------------------------

# Function to generate the terrain map
terrain <- function(){
  
  # Randomly generate a number of cells for low (l), medium (m) and high (h) resistances
  
  # High resistance
  h.2 <- as.numeric(sample(50:100, size = 1))       # r = 1000
  h.1 <- as.numeric(sample(100:200, size = 1))      # r = 100
  
  # Medium resistance
  m.3 <- as.numeric(sample(200:350, size = 1))      # r = 50
  m.2 <- as.numeric(sample(350:500, size = 1))      # r = 20
  m.1 <- as.numeric(sample(500:700, size = 1))      # r = 10
  
  # Low resistance
  l.2 <- as.numeric(sample(400:600, size = 1))      # r = 5
  l.1 <- 2500 - h.2 - h.1 - m.3 - m.2 - m.1 - l.2   # r = 1
  
  # Create sequence of the randomly-generated cells
  arrangement <- sample(c(rep(1000, h.2), rep(100, h.1), rep(50, m.3), rep(20, m.2), rep(10, m.1), 
                          rep(5, l.2), rep(1, l.1)), size = 2500, replace = FALSE)
  
  # Turn above sequence into output of 50 x 50 matrix
  return(matrix(arrangement, nrow = 50, byrow = TRUE))}





##### Set initial conditions ------------------------------------------------------------------------------

# Function to run before every simulation, setting the initial conditions
init <- function(){
  
  # Set starting x (n.col) and y (n.row) coordinates
  n.col <<- 1
  n.row <<- 1
  
  # Set total resistance counter
  r.total <<- field[1, 1]
  
  # Set turn counter
  turn <<- 0
  
  # Reset turn advancement condition
  c.next <<- FALSE}





##### Update conditions -----------------------------------------------------------------------------------

# At end of turn, update conditions
update <- function(){
  
  # Update total resistance counter
  r.total <<- r.total + choices$r
  
  # Update turn counter
  turn <<- turn + 1
  
  # Update plotting coordinates from previous turn
  # Used only for plotting in grid.segments
  x.old <<- 0.0215 + 0.0195*(n.col - 1)
  y.old <<- 0.0215 + 0.0195*(n.row - 1)
  
  # Update x (n.col) and y (n.row) coordinates
  n.col <<- choices$x
  n.row <<- choices$y
  
  # Update plotting coordinates for current turn
  # Used only for plotting in grid.segments
  x.new <<- 0.0215 + 0.0195*(n.col - 1)
  y.new <<- 0.0215 + 0.0195*(n.row - 1)
  
  # Reset turn advancement condition
  c.next <<- FALSE}





##### FLAR calculations -----------------------------------------------------------------------------------

# Calculate coordinates and resistance of choices in the forward (up and right) direction
calc.choices <- function(){
  
  # Detect edge cases when determining available moves in forward direction; only one choice
  # Since path can't go down or to the left, we don't consider edge cases of x = 1 or y = 1
  if(n.row == 50){
    choices <- data.frame(n.col + 1, n.row, field[n.row, n.col + 1])}
  if(n.col == 50){
    choices <- data.frame(n.col, n.row + 1, field[n.row + 1, n.col])}
  
  # If not an edge case, then calculate both choices
  if(n.col != 50 && n.row != 50){
    choices <- data.frame(cbind(c(n.col + 1, n.col), c(n.row, n.row + 1), 
                                c(field[n.row, n.col + 1], field[n.row + 1, n.col])))}
  
  # Output data frame of choices as well as their coordinates and resistance values
  return(choices)}





##### FNSR Calculations -----------------------------------------------------------------------------------

# Function that, for each choice, computes total resistance for 3 forward neighbour cells
nn <- function(i){
  
  # Select the ith choice
  ch.col <- choices[i, 1]
  ch.row <- choices[i, 2]
  
  # Detect edge cases; in these cases, the FNSR total consists of only one cell
  if(ch.col == 50 && ch.row != 50){
    return(field[ch.row + 1, ch.col])}
  if(ch.row == 50 && ch.col != 50){
    return(field[ch.row, ch.col + 1])}
  
  # If on ending cell, return zero since simulation has ended
  # Function works without this, but this prevents an error from being returned
  if(ch.col == 50 && ch.row == 50){
    return(0)}
  
  # If not an edge case, then calculate total resistance for all 3 forward neighbour cells
  if(ch.col != 50 && ch.row != 50){
    return(sum(c(field[ch.row, ch.col + 1], field[ch.row + 1, ch.col + 1], 
                 field[ch.row + 1, ch.col]) == 1))}}





##### FTCS Calculations -----------------------------------------------------------------------------------

# Function returning, for a given choice, the smallest total resistance of all possible combinations of 3
# additional moves in the forward direction
ahead <- function(i){
  
  # Sub-function that calculates next choices given a current choice
  ahead.next <- function(input.choices, choice.index, output.name){
    choices.new <- get(input.choices)
    ch.col <- choices.new[choice.index, 1]
    ch.row <- choices.new[choice.index, 2]
    assign(output.name, data.frame(cbind(c(ch.col + 1, ch.col), c(ch.row, ch.row + 1), 
                                         c(field[ch.row, ch.col + 1], field[ch.row + 1, ch.col]))), 
           envir = .GlobalEnv)}
  
  # Do not initiate look-ahead if at or only one cell from boundary
  if(n.row >= 49 || n.col >= 49){
    min.r <- NA}
  
  # Look another tile ahead of first set of choices
  if(n.row < 49 && n.col < 49){
    ahead.next("choices", i, "choices.2")}
  
  # Restrict total look-ahead to 2 if at least one coordinate is 2 cells from boundary
  if(n.row == 48 || n.col == 48){
    min.r <- min(choices.2[1, 3], choices.2[2, 3])}
  
  # Look 2 tiles ahead of first set of choices
  if(n.row < 48 && n.col < 48){
    ahead.next("choices.2", 1, "choices.2a")
    ahead.next("choices.2", 2, "choices.2b")}
  
  # Restrict total look-ahead to 3 if at least one coordinate is 3 cells from boundary
  if(n.row == 47 || n.col == 47){
    min.r <- min(c(choices.2[1, 3] + choices.2a[1, 3],
                   choices.2[1, 3] + choices.2a[2, 3],
                   choices.2[2, 3] + choices.2b[1, 3],
                   choices.2[2, 3] + choices.2b[2, 3]))}
  
  # Look 3 tiles ahead of first set of choices
  if(n.row < 47 && n.col < 47){
    ahead.next("choices.2a", 1, "choices.2aa")
    ahead.next("choices.2a", 2, "choices.2ab")
    ahead.next("choices.2b", 1, "choices.2ba")
    ahead.next("choices.2b", 2, "choices.2bb")}
  
  # Find sum of resistances across all possible sets of moves
  if(n.row <= 46 && n.col <= 46){
    min.r <- min(choices.2[1, 3] + choices.2a[1, 3] + choices.2aa[1, 3],
                 choices.2[1, 3] + choices.2a[1, 3] + choices.2aa[2, 3],
                 choices.2[1, 3] + choices.2a[2, 3] + choices.2ab[1, 3],
                 choices.2[1, 3] + choices.2a[2, 3] + choices.2ab[2, 3],
                 choices.2[2, 3] + choices.2b[1, 3] + choices.2ba[1, 3],
                 choices.2[2, 3] + choices.2b[1, 3] + choices.2ba[2, 3],
                 choices.2[2, 3] + choices.2b[2, 3] + choices.2bb[1, 3],
                 choices.2[2, 3] + choices.2b[2, 3] + choices.2bb[2, 3])}
  
  # Output the value of the 3-cell predicted path with the smallest total resistance
  return(min.r)}





##### Path plotting ---------------------------------------------------------------------------------------

# Function that ploth an algorithm's path through the grid
plot.path <- function(colour, linetype){
  grid.segments(x0 = x.old, x1 = x.new, y0 = y.old, y1 = y.new, 
                gp = gpar(lwd = 5, col = colour, lty = linetype))}

