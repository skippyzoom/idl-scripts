;+
; Script to create an array of equally sized RMS den1(k,theta,t)
; k (wavelength) subarrays by resizing each subarray's theta
; dimension to match the maximum size. This script assumes that the
; user has built den1rmsktt (e.g., via calc_den1rmsktt.pro)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Extract wavelength keys
l_keys = (den1rmsktt.keys()).sort()
l_keys.reverse

;;==Convert wavelength keys to array
lambda = l_keys.toarray()

;;==Extract number of wavelengths
nl = den1rmsktt.count()

;;==Find the largest array (always the smallest wavelength?)
max_t = n_elements(den1rmsktt[l_keys[0]].t_interp)
for il=1,nl-1 do $
   max_t = max([max_t,n_elements(den1rmsktt[l_keys[il]].t_interp)])

;;==Create the array of resized spectra
cg_den1rmsktt = fltarr(nl,max_t,n_rms)
for it=0,n_rms-1 do $
   for il=0,nl-1 do $
      cg_den1rmsktt[il,*,it] = congrid(den1rmsktt[l_keys[il]].f_interp[*,it], $
                                       max_t)
