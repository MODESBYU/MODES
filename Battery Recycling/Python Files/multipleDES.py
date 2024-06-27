# -*- coding: utf-8 -*-
"""
Created on Tue Jun 18 13:02:21 2024
Multiple DES Solvent Graph
@author: Modes Lab
"""

import numpy as np
import matplotlib.pyplot as plt
import os

path = os.path.dirname(os.getcwd())
# path = path + "/6.6.2024 Testing/SDS test/"

# background = path + "dark_MAYP1115451__1__10-25-52-102.txt"
# baseline = path + "background_MAYP1115451__2__10-36-25-886.txt"
# measurement = path + "ChCl_U_MAYP1115451__5__10-46-53-397.txt"

def absorbance(background, baseline, measurement, rows=14):
    # we take in 3 files, skip rows, and gather wavelength and intensity data
    backwave, backval = np.loadtxt(background, unpack = True, skiprows = rows)
    basewave, baseval = np.loadtxt(baseline, unpack = True, skiprows = rows)
    measurewave, measureval = np.loadtxt(measurement, unpack = True, skiprows = rows)
    
    absorbance = -np.log( (measureval-backval) / (baseval-backval) )
    
    return measurewave, absorbance


wave, chcl_u = absorbance(path+"\\6.6.2024 Testing\\ChCl_Urea test\\dark.txt",path+"\\6.6.2024 Testing\\ChCl_Urea test\\background_80_degrees.txt",path+"\\6.6.2024 Testing\\ChCl_Urea test\\ChCl_U_MAYP1115451__0__10-46-50-568.txt")
wave, chcl_eg = absorbance(path+"\\6.11.2024\\dark_retry_MAYP1115451__0__09-39-36-776.txt",path+"\\6.11.2024\\baseline_80C_3_MAYP1115451__0__15-52-22-079.txt",path+"\\6.11.2024\\ChClEG1.2\\ChClEG12_MAYP1115451__0__15-53-31-435.txt")
wave, eg_ca = absorbance(path+"\\6.13.2024 Testing\\EG2.5_CA1\\dark_MAYP1115451__0__15-36-46-122.txt",path+"\\6.13.2024 Testing\\EG2.5_CA1\\baseline_80C_2_MAYP1115451__0__15-52-16-637.txt",path+"\\6.13.2024 Testing\\EG2.5_CA1\\EG2.5_CA1_attempt2_MAYP1115451__0__15-54-30-895.txt")

# plot
plt.plot(wave, chcl_u, label="ChCl:Urea 1:2")
plt.plot(wave, chcl_eg, label="ChCl:EG 1:2")
plt.plot(wave, eg_ca, label="EG:CA 2.5:1")
plt.legend(loc="upper right")
plt.grid()
plt.xlabel("Wavelength (nm)")
plt.ylabel("Absorbance")