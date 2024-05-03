import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import spectrochempy as ch

class Spectrum:
    def __init__(self, filepath=None, sep0 = None, xdata=None, ydata = None,spa = False):
        if filepath is not None:
            if not spa:
                self.load_from_file(filepath,sep0)
            else:
                self.load_from_spa(filepath)
        elif xdata is not None:
            self.load_from_data(xdata,ydata)
        else:
            raise ValueError("Either 'path' or 'data' must be provided.")

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
    
    def plot(self,col = None,low = 0,high = -1,label = None):
        plt.plot(self.x[low:high],self.y[low:high], color = col,label = label)
