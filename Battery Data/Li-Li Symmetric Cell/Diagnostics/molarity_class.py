import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from spectrum_class import Spectrum

class Molarity:
    
    # Constructor method (optional)
    def __init__(self, filepath = None, array = None, sep0 = None,M = None):
        """
        Initialize this class by giving it an array of paths to the spectra to be averaged;
        You also need to tell it what type of separater to use
        Methods are: 
            get_x
            get_y
            get_M
            plot
            plot_all
        """

        if filepath is not None:
            if not str(filepath).endswith('.spa'):
                self.load_from_file(filepath,sep0)
                self.n = len(filepath)

                # fill array with spectra
                self.spectra = np.array([])
                for i in range(self.n):
                    a = Spectrum(filepath[i],sep0)
                    self.spectra = np.append(self.spectra,a)
            else:
                self.n = len(filepath)

                # fill array with spectra
                self.spectra = np.array([])
                for i in range(self.n):
                    a = Spectrum(filepath[i],spa = True)
                    self.spectra = np.append(self.spectra,a)
        elif array is not None:
            self.spectra = array
        else:
            raise ValueError("Either 'path array' or 'Spectrum array' must be provided.")
        

        

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
