##### Load packages ---------------------------------------------------------------------------------------

library(grid)
library(gridBase)
library(tidyverse)





##### Initialise sub-routines and other functions ---------------------------------------------------------

# Load new heatmap function
source("https://raw.githubusercontent.com/TrevorHD/Pathfinder/master/Scripts/PathfinderGridDisplay.R")

# Load pathfinder functions and sub-routines
source("https://raw.githubusercontent.com/TrevorHD/Pathfinder/master/Scripts/PathfinderFunctions.R")





##### Initialise simulation and plotting ------------------------------------------------------------------

# Should simulations be replicated many times in order to test effectiveness?
# Setting to TRUE will run many simulations and will plot performance stats
# Setting to FALSE will only run one simulation, but will plot paths travelled
replicate.on <- TRUE

# Generate terrain
field <- terrain()

# Initialise graphics and plot terrain
if(replicate.on == FALSE){
  
  # Prepare graphics device
  jpeg(filename = "PathPlots.jpeg", width = 2000, height = 2000, units = "px")
  
  # Create blank page
  grid.newpage()
  plot.new()
  
  # Shrink margins so things plotted near edges don't get cut off
  par(mar = c(1, 1, 1, 1))
  
  # Set grid layout and activate it
  gly <- grid.layout(5000, 5000)
  pushViewport(viewport(layout = gly, gp = gpar(fill = "white")))
  
  # Plot the terrain map, with darker shades of blue representing higher resistance
  heatmap.new(field, Rowv = NA, Colv = NA, scale = "none", breaks = c(0, 1, 5, 10, 20, 50, 100, 1000),
              margins = c(2, 2), col =  c(rgb(r = 236, g = 240, b = 255, maxColorValue = 255),
                                          rgb(r = 220, g = 228, b = 255, maxColorValue = 255),
                                          rgb(r = 193, g = 206, b = 255, maxColorValue = 255),
                                          rgb(r = 155, g = 175, b = 255, maxColorValue = 255),
                                          rgb(r = 115, g = 143, b = 255, maxColorValue = 255),
                                          rgb(r = 58,  g = 88,  b = 209, maxColorValue = 255),
                                          rgb(r = 27,  g = 46,  b = 124, maxColorValue = 255)))}





##### Execute algorithms ----------------------------------------------------------------------------------

# Run algorithms only once
if(replicate.on == FALSE){
  
  # Run all four algorithms
  source("https://raw.githubusercontent.com/TrevorHD/Pathfinder/master/Scripts/PathfinderAlgorithms.R")}

# Run algorithms many times to compare effectiveness
# Be patient, as this may take a while...
if(replicate.on == TRUE){
    
  # Set "win" tracker to zero
  tracker.win <- c(0, 0, 0, 0)
    
  # Set simulation total resistance trackers to zero for each algorithm
  for(i in 1:4){
    assign(paste0("tracker.a", i), c())}
    
  # Run algorithms many times via simulation
  for(i in 1:5000){
      
    # Generate new terrain map for each simulation
    field <- terrain()
    
    # Run all four algorithms
    source("https://raw.githubusercontent.com/TrevorHD/Pathfinder/master/Scripts/PathfinderAlgorithms.R")
      
    # Choose the "winner" as the algorithm with the lowest resistance
    num <- which.min(c(a1.r, a2.r, a3.r, a4.r))
      
    # Update the "win" tracker
    tracker.win[num] <- tracker.win[num] + 1
      
    # Add total resistance from each algorithm to its respective tracker
    for(i in 1:4){
      assign(paste0("tracker.a", i), append(get(paste0("tracker.a", i)),
                                            get(paste0("a", i, ".r"))))}}}





##### Finalise plotting -----------------------------------------------------------------------------------

# Finalise plotting
if(replicate.on == FALSE){

  # Plot the beginning and end points
  grid.points(x = c(0.0215, 0.9770), y = c(0.0215, 0.9770), pch = 19, gp = gpar(cex = 2))
  
  # Add legend for lines
  legend(x = -0.02, y = 1.02, col = c("black", "red", "yellow", "forestgreen"), 
         lwd = rep(4, 4), lty = c(1, 6, 2, 3), cex = 3, box.lwd = 2,
         legend = c("1", "2", "3", "4"), title = "  Algorithm ", title.adj = 0.4, bg = "white")
  
  # Add legend for cells
  legend(x = -0.02, y = 0.87, cex = 3.045, box.lwd = 2, title.adj = 0.5,
         fill = c(rgb(r = 236, g = 240, b = 255, maxColorValue = 255),
                  rgb(r = 220, g = 228, b = 255, maxColorValue = 255),
                  rgb(r = 193, g = 206, b = 255, maxColorValue = 255),
                  rgb(r = 155, g = 175, b = 255, maxColorValue = 255),
                  rgb(r = 115, g = 143, b = 255, maxColorValue = 255),
                  rgb(r = 58,  g = 88,  b = 209, maxColorValue = 255),
                  rgb(r = 27,  g = 46,  b = 124, maxColorValue = 255)), 
         legend = c("1", "5", "10", "20", "50", "100" ,"1000"), title = "Resistance", bg = "white")

  # Deactivate grid layout; finalise graphics save
  popViewport()
  dev.off()}





##### Visualise algorithm performance ---------------------------------------------------------------------

# Plot performance stats
if(replicate.on == TRUE){

  # Prepare graphics device
  jpeg(filename = "AlgorithmPerformance.jpeg", width = 2150, height = 700, units = "px")

  # Create blank page
  grid.newpage()
  plot.new()

  # Set grid layout and activate it
  gly <- grid.layout(700, 2150)
  pushViewport(viewport(layout = gly))

  # Probability distributions of total resistance for each algorithm
  pushViewport(viewport(layout = gly, layout.pos.col = 25:725, layout.pos.row = 25:695))
  par(fig = gridFIG(), new = TRUE, cex.lab = 1.5, cex.axis = 1.3)
  plot(density(tracker.a1), col = "black", ylim = c(0, max(density(tracker.a4)$y)), 
       ylab = "Probability Density", xlab = "Path Resistance", lwd = 2, main = NA)
  legend("topright", col = c("black", "red", "yellow", "forestgreen"), lwd = rep(4, 4), 
         legend = c("1", "2", "3", "4"), title = "Algorithm", title.adj = 0, bty = "n", cex = 1.7)
  for(i in 2:4){
    colours <- c("red", "yellow", "forestgreen")
    lines(density(get(paste0("tracker.a", i))), col = colours[i - 1], lwd = 2)}
  popViewport()

  # Boxplots of total resistance for each algorithm
  pushViewport(viewport(layout = gly, layout.pos.col = 725:1425, layout.pos.row = 25:695))
  par(fig = gridFIG(), new = TRUE, cex.lab = 1.5, cex.axis = 1.3)
  boxplot(tracker.a1, tracker.a2, tracker.a3, tracker.a4)
  title(xlab = "Algorithm", line = 3)
  title(ylab = "Path Resistance", line = 3)
  for(i in 1:4){
    segments(x0 = i - 0.392, x1 = i + 0.4, y0 = mean(get(paste0("tracker.a", i))), 
             y1 = mean(get(paste0("tracker.a", i))), col = c("black", "red", "yellow", "forestgreen")[i], 
             lty = 3, lwd = 3)}
  popViewport()

  # Number of wins for each algorithm
  # Note that barplot is called twice so we can put the reference lines behind the bars
  pushViewport(viewport(layout = gly, layout.pos.col = 1425:2125, layout.pos.row = 25:695))
  par(fig = gridFIG(), new = TRUE, cex.lab = 1.5, cex.axis = 1.3)
  barplot(rep(NA, 4), ylim = c(0, 0.8), axes = FALSE)
  abline(h = seq(0.1, 0.8, by = 0.1), col = "grey", lty = 3)
  barplot(tracker.win/sum(tracker.win), col = c("black", "red", "yellow", "forestgreen"),
          yaxt = "n", xlab = "Algorithm", names.arg = c("1", "2", "3", "4"), ylim = c(0, 0.8), 
          add = TRUE)
  axis(2, at = seq(0, 0.8, by = 0.1), labels = TRUE)
  title(ylab = "Proportion of Simulations Won", line = 3)
  box()
  popViewport()
  
  # Add subtitle text
  grid.text(label = c("Distribution of total path resistance over 5000 simulations.",
                      "Distribution of total path resistance over 5000 simulations.",
                      "Proportion of 5000 simulations won by each algorithm."), 
            x = c(0.185, 0.505, 0.83), y = rep(0.93, 3), just = "centre",
            gp = gpar(fontsize = 20, col = "black", fontface = "italic"))

  # Deactivate grid layout; finalise graphics save
  popViewport()
  dev.off()}
