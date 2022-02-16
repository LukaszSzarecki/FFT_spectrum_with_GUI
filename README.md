# FFT_spectrum_with_GUI
In this repository I worked on basic FFT analyser, which plot FFT spectrum in time.

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Code Examples](#code-Examples)
* [Setup](#setup)

## General info


**System Parameters:**
 - Sampling frequency
 - sound = y (signal)


**Equations:**
**Decimation in time (DIT) FFT**
![image](https://user-images.githubusercontent.com/61761700/154257850-83140ec6-2b14-46dc-aa5d-2801400d6045.png)

> Source: Algorithms for programmers ideas and source code -  Jorg Arndt - 26, 2002

**Model:**
- 

## Technologies
Project is created with:
- MATLAB R2021b
- Signal_Toolbox

## Code Examples
Install matlab app file named fft_analyser_v3_.mlapp


1. Example
 * sound: 100_200_500_1000_Hz

![image](https://user-images.githubusercontent.com/61761700/154258755-cbaa688e-eb7f-4657-a36d-46352712c9eb.png)
![image](https://user-images.githubusercontent.com/61761700/154258780-b7c09eb0-d301-481d-8e5a-fb435a773cda.png)

In this example the frequencies change as follows 100 Hz , 200 Hz, 500 Hz and 1 kHz.

**2. Example**
 * sound: 440Hz_44100Hz_16bit_05sec

![image](https://user-images.githubusercontent.com/61761700/154259338-0cc9948a-001a-4dbc-befc-607b9a6150b1.png)

This example shows only one frequency - 440 Hz.

**3. Example**
 * sound: song_WAV_1MG
 * app switch: Song

![image](https://user-images.githubusercontent.com/61761700/154259823-9b8a4bfb-84fc-4a0b-8780-38e1710d219f.png)

It is a 30-second track with the guitar as the dominant instrument. Therefore, we can mainly notice frequencies from 100 to 300 Hz.

![image](https://user-images.githubusercontent.com/61761700/154260358-af147ec4-330b-438f-bea5-221d4f802a79.png)
> Source: wikipedia - Guitar tunings

## Setup (in-built)
To run this project...
