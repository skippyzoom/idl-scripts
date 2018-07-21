;+
; Script for creating graphics from multi-run den1ktt hash. Assumes
; the user has run multirun_den1ktt_main
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare wavelengths of interest
lambda = sindgen(9,start=2.0,increment=0.5)
lambda = string(lambda,format='(f06.2)')

;;==Build the multi-run kttrms hash
mr_kttrms = build_multirun_kttrms(mr_den1ktt, $
                                  'den1ktt', $
                                  lambda=lambda)

;;==Create a plot of RMS-theta power
@multirun_den1ktt_rms_plot

