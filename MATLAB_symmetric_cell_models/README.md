This folder is a collection of MATLAB scripts/functions that run a model of a lithium-lithium symmetric cell. (i.e. both anode and cathode are lithium, a voltage is applied and this drives the cell away from equilibrium, and it can then provide a charge until it returns to equilibrium).

The most important scripts from the original files are 'RunSimulation.m' and 'inputs.m'. These are the two that the user interacts with, as for the most part the other files are functions that those two files call. You can also change some of the information within the 'plotResults.m' file; changing these is largely cosmetic and will only change what graphs are produced by the program. Below is a basic description of how to use each file (and therefore the whole simulation system as a whole).

'inputs.m'
    This file is where you change your parameters. Parameters I commonly changed were the cell geometries (i.e. electrolyte gap, cross-sectional area), battery chemistry (i.e. initial concentration), and simulation parameters (i.e. user current load, time). 

'RunSimulation.m'
    This file is the one you execute. Once you adjust your parameters (see 'inputs.m' section above) and save the 'inputs.m' file, run this file to run the simulation and see the results, typically expressed through plots (see 'plotResults.m' section below)

'plotResults.m'
    This file controls what is plotted. At the top of the file, in the section titled "Plot Flags," change the number next to any of the plots you want generated to 1. Any plots assigned the number 1 will be plotted next time you run 'RunSimulation.m', and any marked with a 0 will not be run.

-------------------------------------------------------------------------

I also added a folder called 'simulation_solver'. This folder is not important to the simulation as a whole, everything else can run without it. This folder contains files that take an input of data (data obtained by running the lithium-lithium symmetric cell and collecting data; needs a format of a 2D array of concentrations, along with a time array and a position array that correspond to the concentration array).

The 'simulation_solver' folder contains a number of different files, often in parallel with the original simulation. 'coeff_solver.m' is the main file for this portion, and it is the main one you run. Below is a quick rundown of what each file does.

'coeff_solver.m'
    Takes an input of data, runs a minimization function (fmincon) to minimize the error between the input data and the simulation by adjusting the transference number (t+) and the diffusion coefficient (D_o). This is where you would change the path and file name to get the program to use the data you want to compare the simulation to. 

'msqe.m'
    Runs the simulation given input t+/D_o (from fmincon function) and calculates the mean squared error between the resulting simulation data and the input data.

'RunSim_solver'
    This file is essentially the same as 'RunSimulation.m', but it takes an input array (t+ and D_o) and returns a concentration array (2D), as well as time and position arrays (both 1D).

'inputs_solver.m'
    This file is essentially the same as 'inputs.m', but it takes an input array of t+ and D_o and initializes those two variables using the input array. This is how the input array from fmincon gets used.

The following functions aren't used to run the minimization function, but they were used when I was testing and developing these scripts.

'data_messer_upper.m' 
    When we were developing these programs, we didn't have any "real" data to compare the simulation to. Therefore, I just ran the original simulation with D_o and t+ as a function of concentration and used that data. In an attempt to replicate/simulate the imperfect data we would obtain from real experiments, I ran the data through this file; it just randomly adjusts every data point within a factor of +/-.5%.

Honestly, I'm not super familiar with MATLAB, so a lot of this code is probably a mess. If something doesn't work, ChatGPT is great at helping with troubleshooting! 