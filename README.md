# Behavior-classification-through-DKFs

Contents of the repository:
- main.m: a Matlab function that executes a simulation of the environment
- runner.m: a Matlab script that calls multiple times the function in main.m in order to perform many tests with different parameters. The data produced is saved in .mat files
- test_run.m: a Matlab script that executes the same code that is executed when calling the function inside main.m. This useful for developing and testing purposes
- draw_plots.m: a Matlab script that plots results obtained during multiple tests, the data used for the plots is the one produced by runner.m
- data folder: the folder includes data collected with 61 different experiments (61 different parameter combinations) with 1000 executions for each class for each experiment
