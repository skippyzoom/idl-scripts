;+
; Script for creating graphics from multi-run Erktt hash. Assumes
; the user has run multirun_Erktt_main
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare wavelengths of interest
lambda = sindgen(7,start=2.0,increment=0.5)
lambda = string(lambda,format='(f06.2)')

;;==Build the multi-run kttrms hash
mr_kttrms = build_multirun_kttrms(mr_Erktt, $
                                  'Erktt', $
                                  lambda=lambda)

;;==Create a plot of RMS-theta power
@multirun_Erktt_rms_plot

;;==Declare wavelengths of interest
lambda = sindgen(7,start=3.0,increment=0.5)
lambda = string(lambda,format='(f06.2)')

;;==Build the multi-run kttrms hash
mr_kttrms = build_multirun_kttrms(mr_Erktt, $
                                  'Erktt', $
                                  lambda=lambda)

;;==Create a plot of RMS-theta power
@multirun_Erktt_rms_plot

;;==Declare wavelengths of interest
lambda = sindgen(21,start=10.0,increment=0.5)
lambda = string(lambda,format='(f06.2)')

;;==Build the multi-run kttrms hash
mr_kttrms = build_multirun_kttrms(mr_Erktt, $
                                  'Erktt', $
                                  lambda=lambda)

;;==Create a plot of RMS-theta power
@multirun_Erktt_rms_plot
