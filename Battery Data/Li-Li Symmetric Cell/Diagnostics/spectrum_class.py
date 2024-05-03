import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

class Spectrum:
    def __init__(self, filepath=None, sep0 = None, data=None):
        if filepath is not None:
            self.load_from_file(filepath,sep0)
        elif data is not None:
            self.load_from_data(data)
        else:
            raise ValueError("Either 'path' or 'data' must be provided.")

    def load_from_file(self, filepath,sep0):
        # Load spectrum data from file
        print("Loading spectrum from file:", filepath)
        # Your implementation to load from file
        df = pd.read_csv(filepath, sep = sep0)
        self.x = df['X']
        self.y = df['Y']

    def load_from_data(self, data):
        # Load spectrum data from pandas array
        print("Loading spectrum from data:", data)
        # Your implementation to load from pandas array
        self.x = data['X']
        self.y = data['Y']
    
    # Instance methods
    def get_x(self):
        # Method implementation
        return self.x
        
    def get_y(self):
        # Method implementation
        return self.y
    
    def plot(self,col,low = 0,high = -1):
        plt.plot(self.x[low:high],self.y[low:high], color = col)
