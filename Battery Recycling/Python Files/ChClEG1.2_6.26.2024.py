# -*- coding: utf-8 -*-
"""
Created on Wed Jun 26 15:48:05 2024

@author: ModesLab
"""

import numpy as np
import matplotlib.pyplot as plt
import os

path = os.path.dirname(os.getcwd())
path = path + "/6.26.2024/"

background = path + "dark_MAYP1115451__0__15-22-55-245.txt"
baseline = path + "baseline80C_MAYP1115451__0__15-23-52-175.txt"
measurement = path + "ChClEG12_MAYP1115451__0__15-25-32-145.txt"


def absorbance(background, baseline, measurement, rows=14):
    # we take in 3 files, skip rows, and gather wavelength and intensity data
    backwave, backval = np.loadtxt(background, unpack = True, skiprows = rows)
    basewave, baseval = np.loadtxt(baseline, unpack = True, skiprows = rows)
    measurewave, measureval = np.loadtxt(measurement, unpack = True, skiprows = rows)
    
    absorbance = -np.log( (measureval-backval) / (baseval-backval) )
    
    plt.plot(measurewave, absorbance)
    plt.grid()
    plt.xlabel("Wavelength")
    plt.ylabel("Absorbance")