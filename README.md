# Overview

A case study examining several from-scratch implementations of different pathfinding algorithms in order to see which one can most effectively navigate through randomly-generated terrain maps. Each terrain map is a 50 x 50 grid of cells with various "resistance" values, and the goal is to find the path of least resistance between opposite corners of the grid.

<br/>

# Files

## Scripts

**Header** *(.tex)* - Markdown with header specifications for the report.

**HMFix** *(.R)* - Script for reworking the `heatmap` function in the base R `stats` package to switch axis positioning. This code has not been cleaned up for clarity since it is not my own work, but rather an adaptation of the `heatmap` source code.

**PF1** *(.R)* - Script for defining key functions involved in generating terrain, setting initial conditions, advancing each turn, and setting up algorithm subroutines.

**PF2** *(.R)* - Script for defining the algorithms used to navigate through the terrain map.

**PF3** *(.R)* - Script for controlling algorithm execution and plotting pathfinding events.

**PF4** *(.Rmd)* - Script for generating figures and rendering output to PDF.

## Figures

**PFPlots1** *(.jpeg)* - Plots showing a sample terrain map, along with paths that the four algorithms took for a single simulation.

**PFPlots2** *(.jpeg)* - Plots showing relative algorithm performance.

## Writeups

**Pathfinder** *(.pdf)* - Report for the case study.

<br/>

# Featured Images

An example of pathfinding through a randomly-grnerated terrain map. Darker colours indicate high-resistance cells that incur larger penalties for any path drawn through them.

<kbd>![](https://github.com/TrevorHD/Pathfinder/blob/master/Figures/PFPlots1.jpeg)</kbd>

A summary of algorithm performance resulting from 5000 simulations. The fourth algorithm narrowly outperforms the first one in terms of mean path resistance, but this is enough to give it a significant competitive advantage overall; the fourth algorithm won in more than 75% of all simulations.

<kbd>![](https://github.com/TrevorHD/Pathfinder/blob/master/Figures/PFPlots2.jpeg)</kbd>
