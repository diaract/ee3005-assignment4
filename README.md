# EE3005 Image Processing - Frequency Domain Analysis

This repository contains the MATLAB implementation for **Assignment 4: Fourier Transform and Frequency Domain Analysis** for the EE3005 Image Processing course. 

The objective of this project is to explore the 2D Fourier Transform (2D FFT), analyze the distinct roles of magnitude and phase in image reconstruction, and evaluate the behavioral outcomes of frequency filtering techniques.

## 📌 Implemented Tasks
The main MATLAB script covers the following experimental tasks using the classic "Barbara" test image:

* **Task 1 & 6: Manual Frequency & Log Scaling Analysis**
  * Computation of 2D FFT.
  * Visualization of Raw Magnitude, Log-Scaled Magnitude, and Phase spectrums.
  * Analysis of dynamic range compression and the necessity of log scaling.
* **Task 2: Magnitude vs. Phase Experiment**
  * Image reconstruction using *only magnitude* and *only phase* to demonstrate how phase preserves structural information.
* **Task 3 & 4: Frequency Interpretation and Filtering**
  * Application of Ideal Low-Pass Filter (LPF) and High-Pass Filter (HPF) in the frequency domain.
  * Visualizing the resulting blur and edge enhancement effects.
* **Task 5: Failure Case Design**
  * Demonstrating the limitations of frequency-domain filtering when dealing with both high-frequency periodic patterns and wide-band noise.
  * Implementing a Spatial Median Filter as an improvement over the frequency domain approach.

## 🚀 How to Run
1. Ensure you have MATLAB installed (Image Processing Toolbox is recommended).
2. Clone this repository to your local machine.
3. Make sure the test image (`Barbara.png`) is located in the same directory as the script.
4. Run the main MATLAB script. The code is organized into sections (`%%`) and will automatically generate all the required figures and console statistics.
