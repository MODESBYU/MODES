# -*- coding: utf-8 -*-
"""
Created on Thu Jun 13 09:10:27 2024
@author: Modes Lab
Choline Chloride:Ethylene Glycol 1:2
"""

import numpy as np
import matplotlib.pyplot as plt
import os

path = os.path.dirname(os.getcwd())
path = path + "/6.11.2024/"

background = path + "dark_retry_MAYP1115451__0__09-39-36-776.txt"
baseline = path + "baseline_80C_2_MAYP1115451__0__15-51-25-736.txt"
measurement = path + "ChClEG1.2/ChClEG12_MAYP1115451__1__15-53-37-917.txt"


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
    plt.figtext(.05,-.05, "Absorption spectra of ChCl:EG 1:2")
    
def transmission(background, baseline, measurement, rows):
    backwave, backval = np.loadtxt(background, unpack = True, skiprows = rows)
    basewave, baseval = np.loadtxt(baseline, unpack = True, skiprows = rows)
    measurewave, measureval = np.loadtxt(measurement, unpack = True, skiprows = rows)
    
    # this method is questionable, look into transmission stuff
    absorbance = -np.log( (measureval-backval) / (baseval-backval) )
    transmission = 1 - absorbance
    
    plt.plot(measurewave, transmission)
    plt.grid()
    plt.xlabel("Wavelength")
    plt.ylabel("Transmission")
    plt.show

absorbance(background, baseline, measurement, rows = 14)