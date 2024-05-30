import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import spectrochempy as ch

def closest_index(array, number):
    # Calculate the absolute difference between each array element and the given number
    differences = [abs(x - number) for x in array]

    # Find the index of the smallest difference
    closest_index = differences.index(min(differences))

    return closest_index

class Spectrum:
    def __init__(self, filepath=None, sep0 = None, xdata=None, ydata = None,smooths = None):
        """
        Initialize a Spectrum object by giving one of the following:
            an path to the file to be read
            an array of x data and an array of y data
            an NDDataset object (likely with more than one spectra contained within it)
        Other parameters you may want to add
            sep0: tells pandas what separater to use to read a .csv file (used when you pass in an array of filepaths)
            smooths: pass a value, and the Spectrum object will assign any absorbance values greater than 'smooth' to the value of smooth
        Methods are: 
            get_x:      returns x data of averaged spectrum
            get_y:      returns y data of averaged spectrum
            get_M:      returns the molarity of the Molarity object
            plot:       plots the averaged spectrum
            get:        returns the object
        """
        
        if filepath is not None:
            if not str(filepath).endswith('.spa'):
                self.load_from_file(filepath,sep0)
            else:
                self.load_from_spa(filepath)
        elif xdata is not None:
            self.load_from_data(xdata,ydata)
        else:
            raise ValueError("Either 'path' or 'data' must be provided.")
        
        self.smooth = smooths
        self.n = len(self.y)
        if smooths is not None:
            self.smooth_ranges()

    def load_from_file(self, filepath,sep0):
        # Load spectrum data from file
        # Your implementation to load from file
        df = pd.read_csv(filepath, sep = sep0)
        self.x = df['X']
        self.y = df['Y']

    def load_from_spa(self, filepath):
        # Load spectrum data from file
        # Your implementation to load from file
        self.spa_object = ch.read_omnic(filepath)
        self.x = self.spa_object.x.values
        self.y = self.spa_object.values[0,:]

    def load_from_data(self, xdata,ydata):
        # Load spectrum data from pandas array
        # Your implementation to load from pandas array
        self.x = xdata
        self.y = ydata
    
    # Instance methods
    def get_x(self):
        # Method implementation
        return self.x
        
    def get_y(self):
        # Method implementation
        return self.y
    
    def plot(self,col = None,low = None,high = None,label = None,title = None):
        # plot
        plt.plot(self.x,self.y, color = col,label = label)
        plt.xlim(low,high)
        plt.title(title)
        plt.xlabel(r'Wavenumbers ($cm^-1$)')
        plt.ylabel('Absorbance')

    def get(self):
        return self

    def smooth_ranges(self):
        for i in range(self.n):
            if self.y[i] > self.smooth:
                self.y[i] = self.smooth