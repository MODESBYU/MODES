import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

class Spectrum:
    def __init__(self, filepath=None, sep0 = None, xdata=None, ydata = None):
        if filepath is not None:
            self.load_from_file(filepath,sep0)
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
