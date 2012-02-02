BECCA version 0.3.x

This code implements a brain-emulating cognition and control
architecture (BECCA). A BECCA agent is applied to various
tasks, each of which is defined in a directory named
'task_<taskname>'.

To run it, switch the working directory to the unzipped
BECCA_v0.3.x directory and run tester.m. Select the task to be
run by uncommenting the appropriate line in tester.m.

The code is designed to have an approximately object-oriented
mode of operation. These pseudo-objects in BECCA are related to
each other in a MATLAB structure in the following way:

task.
    agent.
        feature_map
        grouper
        model
        planner

For example, the model is an element of agent, which is an
element of task: task.agent.model

Each MATLAB function is titled '<classname>_<methodname>.m',
indicating the class and method it represents.
'<classname>_initialize.m' instantiates and initializes the
object <classname>. util is a static class containing useful
mathematical and image processing functions.


Tasks are structured in the same way, with unique folder names
denoting separate tasks. In order to create a new task, certain
methods with the following signatures must be included folder:

task = task_display( task); % displays progress to the user

task = task_initialize( task); % initializes the task

task = task_log_hist( task); % logs task progress

task = task_restore( task); % restores the task and agent from
a previous run, stored in memory

task = task_set_becca_parameters( task); % configures BECCA
parameters specifically for the task at hand

task = task_step( task); % executes one time step of the task

An optional method is often created as well in order to save
intermediate results of a task as it progresses:

void = task_save( task); % saves the current state of the task
and agent to disk

A task may have any number of internal variables, but only
three are necessary:

agent; % the BECCA agent

step_ctr; % the number of time steps taken in the life od the
agent

REPORTING_BLOCK_SIZE; % how many time steps should be taken
before reporting on the task's progress

The README in each task directory should explain its purpose,
details, and
instructions for interfacing with robot hardware, if any.

A task_stub is provided as a template for creating new tasks.
Copying and pasting from other tasks has proven effective as well.

see www.sandia.gov/rohrer for more detailed documentation,
papers, and videos.
