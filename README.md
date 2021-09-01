# Overview

A comparison of different pathfinding algorithms in order to see which one can most effectively navigate through a randomly-generated terrain map. Each terrain map is a 50 x 50 grid of cells with various "resistance" values, and the goal is to find the path of least resistance between opposite corners of the grid. For now, pathfinding is limited only to movement in the forward direction; the ability to move backward as well will be considered for future work.

<br/>

# Files

## Scripts

**Pathfinder** *(.R)* - The main script that controls execution and plotting of pathfinding events.

**PathfinderAlgorithms** *(.R)* - The four algorithms used to navigate through the terrain map.

**PathfinderFunctions** *(.R)* - Various functions essential to the functioning of the program; examples include terrain generation, setting initial conditions, advancing each turn, and setting up subroutines for the algorithms.

**PathfinderGridDisplay** *(.R)* - A rework of the `heatmap` function in the base R `stats` package, which changes the y-axis from the right side of the grid to the left. This code has not been cleaned up for clarity since it is not my own work, but rather an adaptation of the `heatmap` source code.

**PathfinderInfo** *(.Rmd)* - R Markdown used to create a detailed description of what this project is.

## Figures

**PathPlots** *(.jpeg)* - An example of a terrain map, along with paths that the four algorithms took for a single simulation.

**AlgorithmPerformance** *(.jpeg)* - Statistics on the performance of the four algorithms over 5000 simulations. Two plots (a density plot and a boxplot) show distribution of path resistances, and a barplot shows the proportion of simulations that each algorithm won (i.e. had the lowest path resistance). The dashed lines in the boxplot represent the mean path resistance.

## Other

**PathfinderInfo** *(.pdf)* - A more detailed description of what this project is and how it works.

**Header** *(.tex)* A TeX file with header specifications.

<br/>

# Featured Images

An example of pathfinding through a randomly-grnerated terrain map. Darker colours indicate high-resistance cells that incur larger penalties for any path drawn through them.

<kbd>![](https://github.com/TrevorHD/Pathfinder/blob/master/Figures/PathPlots.jpeg)</kbd>

A summary of algorithm performance resulting from 5000 simulations. The fourth algorithm narrowly outperforms the first one in terms of mean path resistance, but this is enough to give it a significant competitive advantage overall; the fourth algorithm won in more than 75% of all simulations!

<kbd>![](https://github.com/TrevorHD/Pathfinder/blob/master/Figures/AlgorithmPerformance.jpeg)</kbd>
