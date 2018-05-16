;+
; Script to unload simulation data  between runs. Separated from
; unload_defaults.pro for modularity.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-
delvar, $
   den0, $
   den1, $
   phi, $
   efield, $
   Ex, $
   Ey, $
   Er, $
   Et, $
   Ex0, $
   Ey0, $
   Er0, $
   Et0, $
   fluxx0, $
   fluxy0, $
   fluxz0, $
   fluxx1, $
   fluxy1, $
   fluxz1, $
   denft0, $
   denft1, $
   phift, $
   fdata, $
   den0fft, $
   den1fft, $
   phifft, $
   den0ktt, $
   den1ktt, $
   phiktt, $
   den0ktw, $
   den1ktw, $
   phiktw
