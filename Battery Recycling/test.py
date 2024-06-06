# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import numpy as np
import os
import matplotlib.pyplot as plt


def absorbance(background, baseline, directory, rows=14):
    # we take in 2 files for our background and baseline and a directory to read all files from its folder so we can collect large amounts of data
    data = np.array([])
    for file in os.listdir(directory):
        backwave, backval = np.loadtxt(background, unpack = True, skiprows = rows)
        basewave, baseval = np.loadtxt(baseline, unpack = True, skiprows = rows)
        measurewave, measureval = np.loadtxt(file, unpack = True, skiprows = rows)
        absorbance = -np.log( (measureval-backval) / (baseval-backval) )
        data = np.append(data, absorbance, axis = 1)
    for i in range(len(data[0:])):
        plt.plot(measurewave, data[:,i])
        plt.grid()
        plt.xlabel("Wavelength")
        plt.ylabel("Absorbance")
    return measurewave, data

