#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 31 14:00:38 2024

@author: williammulberry
"""
import numpy as np
import matplotlib.pyplot as plt
import os
import glob
import scipy.signal as sp

path = os.path.dirname(os.getcwd())
path = path + "/6.6.2024 Testing/"

background = path + "dark.txt"

baseline = path + "background_MAYP1115451__1__09-32-25-157.txt"

testdata = path + "red4_MAYP1115451__0__09-42-21-108.txt"

path_folder = path + "concentration tests/"

directory = glob.glob(os.path.join(path_folder, '*.txt'))

concentration = np.array([2,3,5])


def absorbances(background, baseline, directory, rows=14):
   # we take in 2 files for our background and baseline and a directory to read all files from its folder so we can collect large amounts of data
   data = np.zeros((len(directory),2068))
   a = 0
   for file in directory:
           backwave, backval = np.loadtxt(background, unpack = True, skiprows = rows)
           basewave, baseval = np.loadtxt(baseline, unpack = True, skiprows = rows)
           measurewave, measureval = np.loadtxt(file, unpack = True, skiprows = rows)
           absorbance = -np.log( (measureval-backval) / (baseval-backval) )
           data[a,:] = absorbance
           a = a + 1
   for i in range(len(data[0:])):
       plt.plot(measurewave, data[i,:])
       plt.grid()
       plt.xlabel("Wavelength")
       plt.ylabel("Absorbance")
   plt.plot(measurewave, -np.log( (baseval-backval) / (baseval-backval) ))
   return measurewave, data




def absorbance(background, baseline, file, rows = 14):
    backwave, backval = np.loadtxt(background, unpack = True, skiprows = rows)
    basewave, baseval = np.loadtxt(baseline, unpack = True, skiprows = rows)
    measurewave, measureval = np.loadtxt(file, unpack = True, skiprows = rows)
    absorbance = -np.log( (measureval-backval) / (baseval-backval) )
    return absorbance




measurewave, data = absorbances(background, baseline ,directory, 14)
newdata = absorbance(background, baseline, testdata, 14)
noise = np.std(background)  


j = sp.find_peaks(data[0,:],width = 10, height = .01)

def prediction(measurewave, concentrations, data, peakwidths, peakheights, newdata):
    peakdata = sp.find_peaks(data[-1,:],width = peakwidths, height = peakheights)
    
    peaks = peakdata[0]
    
    conc_pred = np.array([])
    
    for i in range(len(peaks)):
        plotdata = np.array([])
        for j in range(len(data[:,0])):
            plotdata = np.append(plotdata, data[j, peaks[i]])
        A,B = np.polyfit(concentrations, plotdata,deg = 1)
        conc_pred = np.append(conc_pred, (newdata[peaks[i]] - B)/A)
    return conc_pred
        
final_predictions = prediction(measurewave, concentration, data, 10, 0.01, newdata)
        
        
        
    

        
    


