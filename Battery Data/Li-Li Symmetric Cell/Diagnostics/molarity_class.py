import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from spectrum_class import Spectrum
from typing import Dict
from spectrochempy import NDDataset


class Molarity:
    
    # Constructor method (optional)
    def __init__(self, filepath = None, array_of_Spectrum = None, obj: NDDataset = None, sep0 = None,M = None,smooth = None):
        """
        Initialize a Molarity object by giving one of the following:
            an array of paths to the spectra to be averaged
            an array of Spectrum objects
            an NDDataset object (likely with more than one spectra contained within it)
        Other parameters you may want to add
            sep0: tells pandas what separater to use to read a .csv file (used when you pass in an array of filepaths)
            M: a float that tells the molarity of the Molarity object (all spectra should be for the same molarity)
            smooth: pass a value, and the Spectrum object will assign any absorbance values greater than 'smooth' to the value of smooth
        Methods are: 
            get_x:      returns x data of averaged spectrum
            get_y:      returns y data of averaged spectrum
            get_M:      returns the molarity of the Molarity object
            plot:       plots the averaged spectrum
            plot_all:   plots all of the spectra
            get_all:    returns an array of Spectrum objects
        """

        if filepath is not None:
            # initialize a normal filepath
            self.n = len(filepath)

            # fill array with spectra
            self.spectra = np.array([])
            for i in range(self.n):
                a = Spectrum(filepath[i],sep0 = sep0,smooths = smooth)
                self.spectra = np.append(self.spectra,a)

        elif array_of_Spectrum is not None:
            # initialize the object
            self.spectra = array_of_Spectrum

        elif obj is not None:
            # get the data
            xdata = obj.x.data
            ydata_full = obj.data

            # get the length of the array
            self.n = len(ydata_full)
            spectra = []
            for i in range(self.n):
                y_temp = ydata_full[i]
                spectrum = Spectrum(xdata = xdata,ydata = y_temp,smooths = smooth)
                spectra.append(spectrum)
            self.spectra = spectra

        else:
            raise ValueError("Either 'path' array, 'Spectrum' array, or array of spectrochempy objects must be provided.")
        

        

        # average the array
        x_ave = 0
        y_ave = 0
        for i in self.spectra:
            x_ave += i.get_x()
            y_ave += i.get_y()
        x_ave = x_ave / self.n
        y_ave = y_ave / self.n
        self.spectrum = Spectrum(xdata = x_ave,ydata = y_ave)

        # assign class molarity
        self.M = M

        
    
    # Instance methods
    def get_x(self):
        """
        This method returns the x values of the averaged array found in the Molarity class
        """
        return self.spectrum.get_x()
        
    def get_y(self):
        """
        This method returns the y values of the averaged array found in the Molarity class
        """
        return self.spectrum.get_y()
    
    def get_M(self):
        """
        This method returns the molarity that corresponds to the averaged spectrum
        """
        return self.M
    
    def plot(self,col = None,low = 0,high = -1,label = None):
        """
        This method plots the averaged spectrum
        """
        self.spectrum.plot(col,low,high,label = label)

    def plot_all(self,col = None,low = None,high = None,label = None):
        """
        This method plots all of the individual spectra
        """
        for i in self.spectra:
            i.plot(col,low,high,label,title = str(self.M) + ' M')
        

    def get_all(self):
        """
        returns an array of all spectra in the Molarity object
        """
        return self.spectra