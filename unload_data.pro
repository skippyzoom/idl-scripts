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
   den0fft_t, $
   den1fft_t, $
   den0fft_w, $
   den1fft_w, $
   phifft_t, $
   phifft_w, $
   den0ktt, $
   den1ktt, $
   phiktt, $
   den0ktw, $
   den1ktw, $
   phiktw
