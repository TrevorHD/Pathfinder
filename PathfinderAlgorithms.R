##### Algorithm 1 -----------------------------------------------------------------------------------------

# Implementation order:
# FLAR
# FRAN

# Set initial conditions
init()

# Run simulation until end is reached
while(n.col != 50 || n.row != 50){
  
  # Calculate choices in the forward direction
  choices <- calc.choices()
  
  # Label choices for easier selection
  names(choices) <- c("x", "y", "r")
  
  # Execute FLAR
  choices <- subset(choices, r == min(r), select = c(x, y, r))
  
  # Proceed to next turn if FLAR is successful
  if(nrow(choices) == 1){
    c.next <- TRUE}
  
  # If FLAR fails, execute FRAN
  if(nrow(choices) != 1){
    rand <- sample(1:nrow(choices), size = 1)
    choices <- choices[rand, ]
    c.next <- TRUE}
  
  # At end of turn, update conditions
  if(c.next == TRUE){
    update()}
  
  # Plot path on terrain map given colour and line type
  if(plot.on == TRUE){
    plot.path("black", 1)}}

# Store total resistance for comparison against other algorithms
a1.r <- r.total





##### Algorithm 2 -----------------------------------------------------------------------------------------

# Implementation order:
# FNSR
# FLAR
# FRAN

# Set initial conditions
init()

# Run simulation until end is reached
while(n.col != 50 || n.row != 50){
  
  # Calculate choices in the forward direction
  choices <- calc.choices()
  
  # For both choices, compute total resistance for 3 forward neighbour cells
  choices <- cbind(choices, sapply(1:nrow(choices), nn.1))
  
  # Label choices for easier selection
  names(choices) <- c("x", "y", "r", "nn")
  
  # Execute FNSR
  choices <- subset(choices, nn == min(nn), select = c(x, y, r, nn))
  
  # Proceed to next turn if FNSR is successful
  if(nrow(choices) == 1){
    c.next <- TRUE}
  
  # If FNSR fails, execute FLAR
  if(nrow(choices) != 1){
    choices <- subset(choices, r == min(r), select = c(x, y, r))
    c.next <- TRUE}
  
  # Proceed to next turn if FLAR is successful
  if(nrow(choices) == 1){
    c.next <- TRUE}

  # If FLAR fails, execute FRAN
  if(nrow(choices) != 1){
    rand <- sample(1:nrow(choices), size = 1)
    choices <- choices[rand, ]
    c.next <- TRUE}
  
  # At end of turn, update conditions
  if(c.next == TRUE){
    update()}
  
  # Plot path on terrain map given colour and line type
  if(plot.on == TRUE){
    plot.path("red", 6)}}

# Store total resistance for comparison against other algorithms
a2.r <- r.total





##### Algorithm 3 -----------------------------------------------------------------------------------------

# Implementation order:
# FTCS
# FLAR
# FRAN

# Set initial conditions
init()

# Run simulation until end is reached
while(n.col != 50 || n.row != 50){
  
  # Calculate choices in the forward direction
  choices <- calc.choices()
  
  # Apply the above function to both choices in the first set
  choices <- cbind(choices, sapply(1:nrow(choices), ahead))
  
  # Label choices for easier selection
  names(choices) <- c("x", "y", "r", "ahead")
  
  # Execute FTCS
  if(!(NA %in% choices$ahead)){
    choices <- subset(choices, ahead == min(ahead), select = c(x, y, r, ahead))}
  
  # Proceed to next turn if FTCS is successful
  if(nrow(choices) == 1){
    c.next <- TRUE}
  
  # If FTCS fails, execute FLAR
  if(nrow(choices != 1)){
    choices <- subset(choices, r == min(r), select = c(x, y, r, ahead))}
  
  # Proceed to next turn if FLAR is successful
  if(nrow(choices) == 1){
    c.next <- TRUE}
  
# If FLAR fails, execute FRAN
  if(nrow(choices) != 1){
    rand <- sample(1:nrow(choices), size = 1)
    choices <- choices[rand, ]
    c.next <- TRUE}
  
  # At end of turn, update conditions
  if(c.next == TRUE){
    update()}
  
  # Plot path on terrain map given colour and line type
  if(plot.on == TRUE){
    plot.path("yellow", 2)}}

# Store total resistance for comparison against other algorithms
a3.r <- r.total





##### Algorithm 4 -----------------------------------------------------------------------------------------

# Implementation order:
# FFCS
# FLAR
# FRAN

# Set initial conditions
init()

# Run simulation until end is reached
while(n.col != 50 || n.row != 50){
  
  # Calculate choices in the forward direction
  choices <- calc.choices()
  
  # Apply the above function to both choices in the first set
  choices <- cbind(choices, sapply(1:nrow(choices), ahead))
  
  # Label choices for easier selection
  names(choices) <- c("x", "y", "r", "ahead")
  
  # Calculate total resistance for 4 cells ahead of current cell
  choices <- mutate(choices, total = r + ahead)
  
  # Execute FFCS
  if(!(NA %in% choices$total)){
    choices <- subset(choices, total == min(total), select = c(x, y, r, total))}
  
  # Proceed to next turn if FFCS is successful
  if(nrow(choices) == 1){
    c.next <- TRUE}
  
  # If FFCS fails, execute FLAR
  if(nrow(choices != 1)){
    choices <- subset(choices, r == min(r), select = c(x, y, r))}
  
  # Proceed to next turn if FLAR is successful
  if(nrow(choices) == 1){
    c.next <- TRUE}
  
  # If FLAR fails, execute FRAN
  if(nrow(choices) != 1){
    rand <- sample(1:nrow(choices), size = 1)
    choices <- choices[rand, ]
    c.next <- TRUE}
  
  # At end of turn, update conditions
  if(c.next == TRUE){
    update()}
  
  # Plot path on terrain map given colour and line type
  if(plot.on == TRUE){
    plot.path("forestgreen", 3)}}

# Store total resistance for comparison against other algorithms
a4.r <- r.total
