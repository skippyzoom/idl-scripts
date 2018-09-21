;+
; Script to create and array of equally sized den1(k,theta,t)
; k (wavelength) subarrays by resizing each subarray's theta
; dimension to match the maximum size.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get the number of time steps
if time.haskey('nt') then nt = time.nt $
else nt = n_elements(time.index)

;;==Extract wavelength keys
l_keys = (den1ktt.keys()).sort()
l_keys.reverse

;;==Convert wavelength keys to array
lambda = l_keys.toarray()

;;==Extract number of wavelengths
nl = den1ktt.count()

;;==Find the largest array (always the smallest wavelength?)
max_t = n_elements(den1ktt[l_keys[0]].t_interp)
for il=1,nl-1 do $
   max_t = max([max_t,n_elements(den1ktt[l_keys[il]].t_interp)])

;;==Create the array of resized spectra
cg_den1ktt = fltarr(nl,max_t,nt)
for it=0,nt-1 do $
   for il=0,nl-1 do $
      cg_den1ktt[il,*,it] = congrid(den1ktt[l_keys[il]].f_interp[*,it],max_t)
