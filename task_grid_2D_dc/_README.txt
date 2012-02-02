Two-dimensional grid task

dc stands for decoupled. It's just like the task_grid_2D task except that 
the two dimensions are decoupled. The basic feature vector represents a
row and a column separately, not coupled together.

In this task, the agent steps North, South, East, or West in a
5 x 5 grid-world. Position (4,4) is rewarded (1/2) and (2,2) is
punished (-1/2).  There is also a penalty of -1/20 for each horizontal
or vertical step taken. Horizonal and vertical positions are reported
separately as basic features, rather than raw sensory inputs.

This is intended to be a
simple-as-possible-but-slightly-more-interesting-
that-the-one-dimensional-task task for troubleshooting BECCA.

Optimal performance is between 0.3 and 0.35.