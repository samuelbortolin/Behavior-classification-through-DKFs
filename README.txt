Content of the folder:
	- main.m: a Matlab function that executes a simulation of the environment
	- runner.m: a Matlab script that calls multiple times the function in main.m in order to perform many tests with different parameters. The data produced is saved in .mat files
	- test_run.m: a Matlab script that executes the same code that is executed when calling the function inside main.m. This useful for developing and testing purposes
	- draw_plots.m: a Matlab script that plots results obtained during multiple tests, the data used for the plots is the one produced by runner.m
	- data folder: the folder includes data collected with 61 different experiments (61 different parameter combinations) with 1000 executions for each class for each experiment

Change log:
	- At the beginning without measurements for the entity position the covariance of the prior is much higher
	- Computed node_number at each iteration in order to update correctly the DKFs
	- Added share of a, F and node_number to sensors that do not have measurements
	- Use the direction of the previous step to predict the next position of the animal
	- Increase sensor standard deviation in order to give more weight to the system model
	- Stopped the process when no more measurements are collected by the sensors
	- Plotting new graphs in draw_plots.m script
