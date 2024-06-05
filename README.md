# MODES

A repository for transferring data and sharing code/information with one another. Focused around the testing, modelling, and charactization of lithium ion batteries.

# Definitions

Repository: 
      a folder that connects to Github and can therefore update and change with the online version

# Repository Set Up

A lot of this guide was taken from Collin's README.md and ENVIRONMENT.md, with clarifications added in places where I did not understand, and with minor adjustments so you can use it to add both the `neural` repository and the `MODES` repository.

Determine where you would like the code to live on your machine. This can be something like `/Users/<your_username>/code` on `Mac` and `Linux` or `C:\Users\<your_username>\code` on `Windows`.

In your `Terminal`, `Command Prompt`, `Anaconda Prompt`, whatever you use, run the following commands to get into your folder and `clone` this repository.

Replace the `your_url_here` with the link to the repository. On either `Github` or `GitLab`, on the main page of the repository (program), click the green/blue `code` button, and copy the url labelled `https`. This is the easiest way to clone into a repository

```bash
cd /Users/<your_username>/code    # Mac or Linux
cd C:\Users\<your_username>\code  # Windows
git clone your_url_here
```

Once you have successfully cloned the repository, execute the below command to enter into the folder/repository, replacing `folder_name` with the name of the folder.
```bash
cd folder_name
```

# General Use of a Repository
### Note: This does not apply to the `neural` repository, as we will not push our changes to the machine learning folder

Any time you want to use the repository, you will likely want to 'pull' updates from the server to avoid any conflicts with the edits of others. It is often good practice to pull updates from the server right before you send your updates to the server, again with the goal of minimizing conflicts. To pull, run the following command in your terminal (I use `Git Bash`) once you have navigated into the repository folder.
```bash
git pull origin main
```
To send your changes/edits to the server, you will need to run the following three commands.
```bash
git add .               # this command tells git that you want it to pay attention to all of the files you changed
git commit -m 'message' # this command adds a message; change 'message' to a string describing the edits you made
git push origin main    # this command finally pushes the changes to the server
```
Alternatively, for either pulling or pushing, you can double click the files labelled `windows_pull` and `windows_push` to do the same thing. `windows_push` will prompt you to enter a commit message.

# Setting up the Machine Learning

Begin by opening a GitBash command prompt. This is where you will run the neural network and execute the following lines of code.

### Note: I made some adjustments on the Lab computer in an effort to get the machine learning algorithm to run. If you download it fresh from GitLab, you will likely have to make some code adjustments for it to run. See the bottom of this README for a list of the adjustments I made. If you are going to make these changes, make them BEFORE you make the virtual environment. If you don't, changes made in files other than run_cnn.py won't affect the virtual environment.

Below are Collin's instructions for creating a virtual environment, with the addition of the correct version of Python. You must use Python 3.8 (or a similar version). Newer versions of a few of the packages changed some of the file types used, rendering the code unusable for newer versions of Python. If you download Python 3.8 and run the code below, you should still be able to use a higher version of Python for everything else, but use Python 3.8 in a virtual environment for the machine learning.

```bash
# Change directory to the repsository (if not already there).
cd Desktop/Machine_Learning/neural

# Create a new virtual python environment.
python3.8 -m venv neural-venv       # neural-venv can be replaced with whatever you want your virtual environment to be called

# Activate the virtual environment.
source neural-venv/bin/activate     # Mac-OS: again, neural-venv is your virtual environment
source neural-venv/Scripts/activate # Windows: again, neural-venv is your virtual environment

# Always good practice to keep pip up to date.
python -m pip install --upgrade pip

# Install the required python libraries specified in the setup.py.
python -m pip install .
```

# Using the Machine Learning

Every time you want to use the machine learning, you will need to make sure the virtual environment is activated. To do so, run the following command once you have navigated to the repository. Be sure to note that `neural-venv` is just the name of the virtual environment you created and can be changed to match your virtual environment.

```bash
source neural-venv/bin/activate     # Mac-OS
source neural-venv/Scripts/activate # Windows
```

The below is all from Collin's README.md

**Note**: On Windows, it may be necessary to enable long paths. Please follow
the Powershell section in the guide
[here](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=powershell#enable-long-paths-in-windows-10-version-1607-and-later)
to do this.

Having completed the commands above, you can now move on to running the code in
the repository.

# Training Using Different Data Sets:
If you want to use a different data set (other than the default data) to train/run the machine learning algorithm, you will need to change a couple of variable names. See the section on adjustments to the machine learning code at the end of this README for instructions on what to change.

# Code Execution (from Collin)

At this point, life is easy. You have everything set up and can now run the
respective code in your `Terminal`. This repository contains two model training
pipelines for the battery data:

1. `neural/ionic` - This is the single-component model training pipeline. This
   pipeline is dedicated towards training, predicting, and plotting the lithium
   ion (LiPF6) concentration from the datasets.
2. `neural/system` - This is the multi-component model training pipeline. This
   pipeline is dedicated towards training, predicting, and plotting the mole
   fractions of EC, EMC, and LiPF6 in the datasets.

```bash
# Run one of the following codes to enter the pipeline of your choice
cd neural/ionic
cd neural/system
```

Both the `ionic` and `system` folders contain a `run_cnn.py` script which will
be the primary interaction point for training and prediction. Both scripts
utilize the comment `argument_parser.py` and `electro_cnn.py` files from the
`neural/common` folder.

## Running the CNN

In order to run and train a model, change the directory to the model training
pipeline you would like to run (i.e. `cd neural/ionic` or `cd neural/system`).
Once you are in the desired directory, run the `run_cnn.py` script with the
`--help` command to learn more about the available arguments and what they do.

```bash
python run_cnn.py --help  # Print Off Command Line Arguments to Configure Clustering
```

The `help` command should log some output to the console looking like what is
below.

```bash
~ python run_cnn.py --help
usage: Run CNN on Given Spectra and Concentration Data [-h] [-i {lithium,tegdme}]
                                                       [--restrict {None,7,10,15,20,30,50,100,250,500,750,1000}] [-f] [--molarity]
                                                       [--wavenumber] [--min MIN] [--max MAX] [-t] [-m {interpolated,measured}]
                                                       [-s {0-100,20-80,30-70,50-50,70-30,80-20}] [-p] [-l] [-c]
                                                       [-b {1.00,2.33,3.00,all}] [-r RESULTS_PATH]

general:
  -i {lithium,tegdme}, --ion {lithium,tegdme}
                        The electrolyte system to model.
  --restrict {None,7,10,15,20,30,50,100,250,500,750,1000}
                        Set the maximum number of samples to train on.

focus:
  -f, --focus           Train on a dataset focused on wavenumber or molarity.
  --molarity            Create and train on a focused dataset on molarity.
  --wavenumber          Create and train on a focused dataset on wavenumber.
  --min MIN             Set the range minimum to focus the dataset on.
  --max MAX             Set the range maximum to focus the dataset on.

training:
  -t, --train           Train a new model on a dataset.
  -m {interpolated,measured}, --measure {interpolated,measured}
                        Train the model using the measured or interpolated dataset.
  -s {0-100,20-80,30-70,50-50,70-30,80-20}, --split {0-100,20-80,30-70,50-50,70-30,80-20}
                        The ratios of EC and EMC in the dataset. This only applies to lithium.

prediction:
  -p, --predict         Generate model predictions with a trained model on a battery dataset.
  -l, --latest          Run model predictions with the model from the latest training run.
  -c, --corrected       Run model predictions on the battery data corrected for baseline shifting.
  -b {1.00,2.33,3.00,all}, --battery {1.00,2.33,3.00,all}
                        The charging rate for the battery cycling data for model predictions.
  -r RESULTS_PATH, --results-path RESULTS_PATH
                        Path to run results folder for generating model predictions. This is required if --latest is not supplied.
```

## Model Training

Upon running the `run_cnn.py` script for the very first time, a folder called
`results` will be created. Inside of the `results` folder, another folder will
be created with the `--ion` argument specified (i.e. `results/lithium` or
`results/tegdme`). The `ion` folder will contain another folder with the
`--measure` argument specified (i.e. `results/lithium/interpolated` or
`results/lithium/measured`).

If training on the lithium ion dataset, the `measure` folder will contain another folder
with the EC-EMC split (only if the `lithium` ion was specified) (i.e.
`results/lithium/interpolated/50-50`), and finally, this folder will be divided
by the `--restrict` argument supplied (if any, i.e.
`results/lithium/interpolated/50-50/1000_samples`).

The research conducted forthis paper involved an in-depth model sensitivity and
overfitting analysis which is what drove this level of folder abtraction for the
training and prediction results.

Finally, the actual results for the current training run are stored in a folder
named from the timestamp of the initial execution of the `run_cnn.py` script.
The folder name follows the format `MMDDYYYY-T-HHMMSS`.

### Default Training

To run training on the full training dataset and the default configuration (30%
EC, 70% EMC), simply run the following command.

```bash
python run_cnn.py --train
```

### EC-EMC Split Training

To train on a specific split of EC-EMC, add the `--split` argument to the
command above. For example, to train on a 50/50 split of EC-EMC, run the
following command.

**Note**: As specified in the `data` repository `README.md`, this command
depends directly on the filenames of the datasets in the `data` repository.
Please make sure you follow the file naming convention outlined there to ensure
everything works correctly.

```bash
python run_cnn.py --train --split 5050
```

### Focused Dataset Training

The `run_cnn.py` script has the ability to allow you to focus a training dataset
either on a molarity range or by a wavenumber range. In order to run this
training, you must include the `--focus` argument, as well as the focus
parameter you would like to use (`--molarity` or `--wavenumber`), and finally,
the range of values you would like to focus the dataset between. Examples of
each focus parameter are shown below.

**Note**: When you run training with the `--focus` command, the focused dataset
created during the training run will be saved to the data repository. This way,
if you need to run the same training again, the dataset will be loaded directly
from file and won't need to be recreated from scratch.

```bash
# Focus the dataset and training on molarities between 0.75 and 2.75.
python run_cnn.py --train --focus --molarity --min 0.75 --max 2.75

# Focus the dataset and training on wavenumbers between 1000 and 2000.
python run_cnn.py --train --focus --wavenumber --min 1000 --max 2000
```

## Model Prediction

Once you have run the model training, the best trained model will be saved to a file
for use in prediction. The model is saved to the results folder from the
training run and is the restored weights from the best training epoch after all
model training callbacks have completed.

Model prediction will generate multiple new files in the results folder.

### Default Prediction

To generate predictions using the trained model on all original battery datasets
(i.e. uncorrected for baseline shifting) using the latest training run model, 
simply run the following command.

```bash
python run_cnn.py --predict --latest
```

### Prediction on a Specific Rate

To generate predictions on a specific set of battery data, use the `--battery`
argument, as shown below. This will only generate predictions for the specified
battery rate instead of all of the battery rates.

```bash
python run_cnn.py --predict --latest --battery 2.33
```
### Prediction for BYU MODES Lab Users

* Rename the spectra CSV file to `gitt_1.10c.csv` and upload it to the folder `Desktop/Machine_Learning/data/battery`.
* Create a voltage CSV file and rename to `gitt_1.10c_voltage.csv` and upload it to the folder `Desktop/Machine_Learning/data/battery`.
* Create a time CSV file with a single column of the time each spectrum was collected at and name it as `gitt_1.10c_time.csv` and upload it to the folder `Desktop/Machine_Learing/data/battery`.
* Ensure that there is a file called `gitt_1.10c_corrected.txt` in `Desktop/Machine_Learning/data/predictions` and that it has the same number of rows as the number of spectra in `gitt_1.10c.csv` (also the same as the rows in the time file).
* In the terminal, execute the command `python run_cnn.py --predict --latest --battery 1.10`.

### Prediction with a Different Model

If for whatever reason you would like to use a different model for predictions
on the battery data, you must specify the path to the results folder. An example
of this command is below.

```bash
python run_cnn.py --predict --results-path path/to/the/results/you/want/to/use
```

### Prediction on Corrected Data

To generate predictions on the battery data corrected for baseline shifting,
simply add the `--corrected` argument, as shown below.

```bash
python run_cnn.py --predict --latest --corrected
```

# Adjustments to the Machine Learning Code

* First off, you need to run it in Python Version 3.8. I was using Python 3.12 and nothing would work. There is a brief explanation for how to set up Python 3.8 for a virtual environment found in the part of the `README` that explains setting up a virtual environment. It explains how to use Python 3.8 for only the virtual environment so you can still use higher versions elsewhere. 

* I changed lines 107 and 116 in `neural/neural/common/electro_cnn.py`; below are the two original lines, and below that are the two updated lines. These changes are necessary to make sure that the .keras package can make sure that the files are the correct type. Make sure you adjust these before you make a virtual environment, otherwise the virtual environment will not update, and you will have to make a new one. 

Old Code:
```python
self.best_model_file = self.results_path / f"best_model.hdf5" # line 107

self.best_model_file, # line 116
```

New Code:
```python
self.best_model_file = str(self.results_path / f"best_model.hdf5") # line 107

str(self.best_model_file), # line 116
```

* Once I got the machine learning program running, I wanted to train it using data other than the default data. To change this, I had to change lines 21  and 35 of `run_cnn.py`. I changed `DATA_PATH` and `spectra_file` to be the full path of the file containing the data, which meant I also had to change a line or two in `neural/neural/ionic/utils.py`. In this file, I needed to change the lines shown below in whatever method I was using (i.e. `ratio`,`preprocess_data`,etc.). An example is shown below. `DATA_PATH` in `neural/neural/ionic/utils.py` also needs to be the full path to the data file, so I changed it to be the entire path name as well.

```python
dataset = pd.read_csv(f"{DATA_PATH}/{spectra_file}") # this is the old version
dataset = pd.read_csv(r"path_to_your_file_here") # this is the new version
```
* Predictions Adjustments
* Place the spectra CSV file in the Machining_Learning/battery/data folder. Title the file gitt_1.10c.csv. In the command prompt, type `python run_cnn.py --predict --latest --battery 1.10`.

# Common Problems 

### Can't activate Virtual Enviroment(Windows PowerShell) 

If you can't activate the virtual enviroment because running scripts is disabled on your system you can change that setting by running this on your PowerShell prompt: 

```cmd
Set-ExecutionPolicy Unrestricted -Scope Process

```
After you accept the Execution Policy Change you can continue and active your virtual enviroment (see Setting Up the Machine Learning Model). 

If the error says 
```
source : The term 'source' is not recognized as the name of a cmdlet, function, script file, or operable program.
Check the spelling of the name, or if a path was included, verify that the path is correct and try again.
At line:1 char:1
+ source neural-venv/Scripts/activate
+ ~~~~~~
    + CategoryInfo          : ObjectNotFound: (source:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
```
Delete the word source to activate the enviroment. 

```
neural-venv/Scripts/activate
```
Now you will see the active enviroment before the path in the command/WindowsPowerShell window. For example: 
```
(neural-venv) PS C:\Users\...
```
