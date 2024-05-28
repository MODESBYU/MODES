import numpy as np
from scipy.signal import find_peaks, peak_widths
import matplotlib.pyplot as plt

basewave, basei = np.loadtxt("run1_MAYP1115451__0__10-04-48-254.txt", unpack = True, skiprows = 14)
wave, i = np.loadtxt("run2_MAYP1115451__0__10-08-15-563.txt", unpack = True, skiprows = 14)

def transmission(baseline, data):
    tranmissionfile = np.array([])
    for i in range(len(baseline)):
        value = 1 - (baseline - data)/baseline
        transmissionfile = np.append(tranmissionfile, value)
    return transmissionfile
trans = transmission(basei, i)

def absorption(baseline, data):
    absfile = np.array([])
    for i in range(len(baseline)):
        value = (baseline - data)/baseline
        absfile = np.append(absfile, value)
    return absfile
abs = absorption(basei, i)
plt.plot(wave, trans)
