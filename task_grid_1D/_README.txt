One-dimensional grid task

In this task, the agent steps forward and backward along a
line. The fourth position is rewarded (+1/2) and the ninth
position is punished (-1/2). There is also a slight punishment
for effort expended in trying to move, i.e. taking actions.

This is intended to be a simple-as-possible task for
troubleshooting BECCA.

The theoretically optimal performance without exploration is 0.5 
reward per time step.
In practice, the best performance the algorithm can achieve with the 
exploration levels given is around 0.35 to 0.37 reward per time step.
