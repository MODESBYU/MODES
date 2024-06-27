# -*- coding: utf-8 -*-
"""
Kevan Williams
5/23/2024
Absorbance Calculation - Plot
Background - dark measurement - adjusts for inconsistency in the detector
Baseline - empty cell, or cell with pure solution
Measurement - measurement taken with actual data
"""

import numpy as np
import matplotlib.pyplot as plt
import os

path = os.path.dirname(os.getcwd())
path = path + "/6.18.2024 Testing/"

background = path + "dark_MAYP1115451__0__16-39-51-939.txt"
baseline = path + "baseline_MAYP1115451__0__16-24-01-255.txt"
measurement = path + "EG_CA"

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