import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

class Spectrum:
    
    # Constructor method (optional)
    def __init__(self, filepath, sep0):
        df = pd.read_csv(filepath, sep = sep0)
        self.x = df['X']
        self.y = df['Y']
    
    # Instance methods
    def get_x(self):
        # Method implementation
        return self.x
        
    def get_y(self):
        # Method implementation
        return self.y
    
    def plot(self,col,low = 0,high = -1):
        plt.plot(self.x[low:high],self.y[low:high], color = col)
