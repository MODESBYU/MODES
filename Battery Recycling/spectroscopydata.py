#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon May 20 16:00:14 2024

@author: williammulberry
"""

import math
import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import find_peaks, peak_widths
# file1 = ''
# file2 = ''
# basewave, basei = np.loadtxt(file1, unpack = True, skiprows = 14)
# wavelength, i = np.loadtxt(file2, unpack = True, skiprows = 14)

# def transmission(thresh, data):
#     trans = np.array([])
#     for i in range(len(thresh)):
#         value = 1 - (thresh-data)/thresh
#         trans = np.append(trans, value)
#     return trans

# def absorption(thresh, data):
#     absorb = np.array([])
#     for i in range(len(thresh)):
#         value = (thresh-data)/thresh
#         absorb = np.append(absorb, value)
#     return absorb
    
# aps = absorption(basei, i)



##im just running it with the transmission txt file, it can work with most however, just have to change a few things
def absorbrun(reference_file, absorbance_file, rows1, rows2):
    # answer = input("Is the file a transmission file?")
    wave, value = np.loadtxt(absorbance_file, unpack = True, skiprows = rows1)
    waveref, valueref = np.loadtxt(reference_file, unpack = True, skiprows = rows2)
    # if answer == "yes":
    value = (abs(valueref-value))/valueref
    # else:
    #     value = (abs(valueref-value))/valueref
    peaks = find_peaks(value, height = .3)
    peaks = peaks[0]
    widths = peak_widths(value, peaks, rel_height = 0.5)
    #peak resolution
    #peaks worth looking at are found with signal to noise ratio
    #noise is 3 times standard deviation
    widths = widths[0]
    wavlength_loc = wave[peaks]
    plt.plot(wave, value)
    plt.grid()
    print("Noticeable bands are at ",wavlength_loc,"\n", "The peaks have widths of ", widths )
    
