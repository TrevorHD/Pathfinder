# Overview

This project compares different pathfinding methods in order to see which one can most effectively navigate through a randomly-generated terrain map. Each terrain map is a 50 x 50 grid of cells with various "resistance" values, and the goal is to find the path of least resistance between opposite corners of the grid. For now, pathfinding is limited only to movement in the forward direction; the ability to move backward will be the goal of future work.

# Files

**Pathfinder** *(.R)* - The main script that controls execution and plotting of pathfinding events.

**PathfinderAlgorithms** *(.R)* - The four algorithms used to navigate through the terrain map.

**PathfinderFunctions** *(.R)* - Various functions essential to the functioning of the program; examples include terrain generation, setting initial conditions, advancing each turn, and setting up subroutines for the algorithms.

**PathfinderGridDisplay** *(.R)* - A rework of the `heatmap` function in the base R `stats` package, which changes the y-axis from the right side of the grid to the left. This code has not been cleaned up for clarity since it is not my own work, but rather an adaptation of the `heatmap` source code.

**PathfinderInfo** *(.Rmd)* - R Markdown used to create a detailed description of what this project is.

**PathfinderInfo** *(.pdf)* - A more detailed description of what this project is and how it works.
