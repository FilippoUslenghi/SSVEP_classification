# SSVEP_classification

This repo contains five main scripts:
1. `FFT_plots.m`
2. `ROC_curves.m`
3. `SSVEP_classification.m`
4. `AVI_SSVEP_classification.m`

The first one shows the DFT of the signal collected by me, just for exploratory reasons.\
`ROC_curves.m` computes the ROC curve for the target frequency 6 and 7.4 Hz, considering every combination of window length and frequency range for the search of the maximum.\
`SSVEP_classification.m` classifies the signals stored in my dataset, considering every combination of window length and frequency range.\
`AVI_SSVEP_classification.m` does the same of `SSVEP_classification.m` but using the AVI SSVEP dataset available [here](https://www.setzner.com/avi-ssvep-dataset/).
