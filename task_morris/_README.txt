two-dimensional visual servoing task based on the Morris water maze

In this task, BECCA can direct its gaze up, down, left, and
right, saccading about an image of a black square on a white
background. It is rewarded for directing it near the center.
The mural is not represented using basic features, but rather
using raw inputs, which BECCA must build into features. See

http://www.sandia.gov/~brrohre/doc/Rohrer11DevelopmentalAgentLearning.pdf

for a full writeup.

task_morris is very similar to task_image_2D, except that 
1) it places a visual target on a natural image background that changes 
periodically and 
2) it preprocesses its 
virtual camera pixels into center-surround inputs, rather than 
straight pixel values.

Simulation only.

Both MATLAB and Octave compatible.

Optimal performance is between 0.7 and 0.8 reward per time step.
