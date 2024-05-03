from setuptools import find_packages, setup

setup(
    name="Data_Tools",
    version="1.0",
    description="A repository containing neural network tools to analyze measured absorption spectra for various lithium ion salt concentration solutions.",
    author="ET",
    author_email="ethanlt6443.pie@gmail.com",
    package_dir={".": "."},
    packages=find_packages(),
    python_requires=">=3.6, <4",
    install_requires=[
        "matplotlib",
        "numpy",
        "pandas",
        "scikit-learn",
        "scipy",
        "spectrochempy"
    ],
)
