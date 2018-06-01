;+
; Script for making graphics of RMS spectrally interpolated Er
; data. See calc_Erktt_rms.pro. 
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Get available wavelengths
lambda = den1ktt_rms.keys()
nl = den1ktt_rms.count()
