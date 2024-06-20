# -*- coding: utf-8 -*-
"""
Created on Tue Jun 18 09:11:33 2024

@author: Modes Lab
"""

import numpy as np
import matplotlib.pyplot as plt
import os

path = os.path.dirname(os.getcwd())
path = path + "/6.13.2024 Testing/EG2.5_CA1/"

background = path + "dark_MAYP1115451__0__15-36-46-122.txt"
baseline = path + "baseline_80C_2_MAYP1115451__0__15-52-16-637.txt"
measurement = path + "EG2.5_CA1_attempt2_MAYP1115451__0__15-54-30-895.txt"


def absorbance(background, baseline, measurement, rows=14):
    # we take in 3 files, skip rows, and gather wavelength and intensity data
    backwave, backval = np.loadtxt(background, unpack = True, skiprows = rows)
    basewave, baseval = np.loadtxt(baseline, unpack = True, skiprows = rows)
    measurewave, measureval = np.loadtxt(measurement, unpack = True, skiprows = rows)
    
    absorbance = -np.log( (measureval-backval) / (baseval-backval) )
    
    plt.plot(measurewave[112:], absorbance[112:])
    plt.grid()
    plt.xlabel("Wavelength")
    plt.ylabel("Absorbance")
    plt.figtext(.05,-.05, "Absorption spectra of EG:CA 2.5:1")
    return measurewave, absorbance
    
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

wave, val = absorbance(background, baseline, measurement, rows = 14)