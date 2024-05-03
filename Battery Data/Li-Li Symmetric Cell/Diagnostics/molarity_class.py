import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from spectrum_class import Spectrum

class Molarity:
    
    # Constructor method (optional)
    def __init__(self, filepath, sep0):
        """
        Initialize this class by giving it an array of paths to the spectra to be averaged;
        You also need to tell it what type of separater to use
        Methods are: 
            get_x
            get_y
            plot
            plot_all
        """
        self.n = len(filepath)

        # fill array with spectra
        self.spectra = np.array([])
        for i in range(self.n):
            a = pd.read_csv(filepath[i],sep = sep0)
            self.spectra = np.append(self.spectra,a)

        # average the array
        average = sum(self.spectra) / self.n
        self.spectrum = Spectrum(data = average)

        
    
    # Instance methods
    def get_x(self):
        """
        This method returns the x values of the averaged array found in the Molarity class
        """
        return self.spectrum.x()
        
    def get_y(self):
        """
        This method returns the y values of the averaged array found in the Molarity class
        """
        return self.spectrum.y()
    
    def plot(self,col,low = 0,high = -1):
        self.spectrum.plot(col,low,high)
