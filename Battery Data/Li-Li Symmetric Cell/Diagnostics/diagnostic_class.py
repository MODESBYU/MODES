import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
from spectrum_class import Spectrum
from molarity_class import Molarity
from sklearn.metrics import r2_score

def closest_index(array, number):
    # Calculate the absolute difference between each array element and the given number
    differences = [abs(x - number) for x in array]

    # Find the index of the smallest difference
    closest_index = differences.index(min(differences))

    return closest_index

class Diagnostic:
    # ------------------------- Initialize the object
    # Constructor method (optional)
    def __init__(self, array):
        """
        Initialize this class with an array of Molarity objects
        """
        self.n = len(array)
        self.spectra = array

        # fill molarity array
        self.molarities = np.zeros(self.n)
        for i in range(len(array)):
            self.molarities[i] = array[i].get_M()
    
    # ------------------------- Functions that find the y data
    def peak_height(self,a):
        # initialize output
        ydata = np.zeros(self.n)

        # fill it based on a correlation
        for i in range(self.n):
            x = closest_index(self.spectra[i].get_x(),a)
            ydata[i] = self.spectra[i].get_y()[x]
        return ydata
    
    def peak_ratio(self,a,b):
        # initialize output
        ydata = np.zeros(self.n)

        # fill it based on a correlation
        for i in range(self.n):
            x1 = closest_index(self.spectra[i].get_x(),a)
            x2 = closest_index(self.spectra[i].get_x(),b)
            ydata[i] = self.spectra[i].get_y()[x1] / self.spectra[i].get_y()[x2]
        return ydata
    
    def peak_integration(self,a,b):
        # initialize output
        ydata = np.zeros(self.n)
        
        # find the spectra with the lowest molarity
        j = 0
        for i in self.spectra:
            if i.get_M() < self.spectra[j].get_M():
                j = i

        # find bounding values
        x1 = closest_index(self.spectra[0].get_x(),a)
        x2 = closest_index(self.spectra[0].get_x(),b)

        # fill output array based on a correlation
        for i in range(self.n):
            y_val = self.spectra[i].get_y() - self.spectra[j].get_y()
            ydata[i] = np.trapz(y_val[x1:x2])
        return ydata


    # ------------------------- Functions that will be run
    def linear(self,type = 'peak_height',loc = 1000, loc2 = None,plot = False,label0 = 'y = ax + b'):
        """
        This method fits the specified data to a function of the form 'f(x) = ax + b'
        Takes inputs:
            data to compare (type): peak_height, peak_ratio, peak_integration
            lower peak wavenumber (loc)
            upper peak wavenumber (loc2) (needed for peak_ratio and peak_integration)
            plot boolean (plot) depending if you want to plot or not
            optional label (label0)
        """
        # get the y_data
        ydata = np.zeros(self.n)
        if type == 'peak_height':
            ydata = self.peak_height(loc)
        elif type == 'peak_ratio':
            ydata = self.peak_ratio(loc,loc2)
        elif type == 'peak_integration':
            ydata = self.peak_integration(loc,loc2)
        else:
            print('Invalid type; please select peak_height, peak_ratio, or peak_integration')

        # function to be fit
        def fit(x,a,b):
            return (a * x) + b
        
        # fit
        params,extras = curve_fit(fit,self.molarities,ydata)
        
        # plotting if desired
        if plot:
            # plot the points
            plt.scatter(self.molarities, ydata)

            # plot the linspace
            Cmin = min(self.molarities)
            Cmax = max(self.molarities)
            C = np.linspace(Cmin,Cmax,1000)
            plt.plot(C,fit(C,params[0],params[1]),label = label0)

            # format the plot
            plt.title(r'Fit to $y = ax + b$')
            plt.xlabel('Concentration (M)')
            plt.ylabel(type)
            plt.legend()
        
        # find the r^2 value
        r = r2_score(ydata,fit(self.molarities,params[0],params[1]))
        return params, r
    
    def inverse(self,type = 'peak_height',loc = 1000, loc2 = None,plot = False,label0 = 'y = (a / (x + b) + c'):
        """
        This method fits the specified data to a function of the form 'f(x) = x^-1'
        Takes inputs:
            data to compare (type): peak_height, peak_ratio, peak_integration
            lower peak wavenumber (loc)
            upper peak wavenumber (loc2) (needed for peak_ratio and peak_integration)
            plot boolean (plot) depending if you want to plot or not
            optional label (label0)
        """
        # get the y_data
        ydata = np.zeros(self.n)
        if type == 'peak_height':
            ydata = self.peak_height(loc)
        elif type == 'peak_ratio':
            ydata = self.peak_ratio(loc,loc2)
        elif type == 'peak_integration':
            ydata = self.peak_integration(loc,loc2)
        else:
            print('Invalid type; please select peak_height, peak_ratio, or peak_integration')

        # function to be fit
        def fit(x,a,b,c):
            return (a / (b + x)) + c
        
        # fit
        params,extras = curve_fit(fit,self.molarities,ydata)
        
        # plotting if desired
        if plot:
            # plot the points
            plt.scatter(self.molarities, ydata)

            # plot the linspace
            Cmin = min(self.molarities)
            Cmax = max(self.molarities)
            C = np.linspace(Cmin,Cmax,1000)
            plt.plot(C,fit(C,params[0],params[1],params[2]),label = label0)

            # format the plot
            plt.title(r'Fit to $y = \frac{a}{x + b} + c$')
            plt.xlabel('Concentration (M)')
            plt.ylabel(type)
            plt.legend()

        # find the r^2 value
        r = r2_score(ydata,fit(self.molarities,params[0],params[1],params[2]))
        return params,r
    
    # plotting function
    def plot(self,low = 0,high = -1):
        """
        This function plots all of the averaged spectra
        Takes inputs of a low x value and a high x value
        """
        plt.figure(figsize = (20,6))
        if high == -1:
            plt.xlim(self.spectra[0].get_x()[0],self.spectra[0].get_x()[len(self.spectra[0].get_x()) - 1])
        else:
            x1 = closest_index(self.spectra[0].get_x(),low)
            x2 = closest_index(self.spectra[0].get_x(),high)
            plt.xlim(self.spectra[0].get_x()[x1],self.spectra[0].get_x()[x2])
        for i in range(self.n):
            self.spectra[i].plot(label = str(self.spectra[i].get_M()) + ' M')
        plt.title('Averaged Spectra')
        plt.xlabel(r'Wavenumbers ($cm^{-1}$)')
        plt.ylabel('Absorbance')
        plt.legend()
        plt.show()