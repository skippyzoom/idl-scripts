;+
; Script for calculating the spectral phase of FFT(temp0)/FFT(den0)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Compute FFT of den0
fden0 = make_array(size(den0,/dim),/complex)
for it=0,time.nt-1 do $
   fden0[*,*,it] = fft(den0[*,*,it],/center)

;;==Construct relative perturbed temperature
delT1 = temp0*0.0
for it=0,time.nt-1 do $
   delT1[*,*,it] = (temp0[*,*,it]-mean(temp0[*,*,it]))/mean(temp0[*,*,it])

;;==Compute FFT of delT1
ftemp0 = make_array(size(delT1,/dim),/complex)
for it=0,time.nt-1 do $
   ftemp0[*,*,it] = fft(delT1[*,*,it],/center)

;;==Extract real and imaginary parts of ratio
ratio = ftemp0/fden0
ratio_r = real_part(ratio)
ratio_i = imaginary(ratio)

;;==Compute the phase (argument)
ratio_arg = atan(ratio_i,ratio_r)

;-->Not sure if this is useful
;; rcm_phase = fltarr(n_rms,time.nt)
;; if n_elements(rcm_abs) ne 0 then $
;;    for ir=0,n_rms-1 do $
;;       for it=0,time.nt-1 do $ 
;;          rcm_phase[ir,it] = interpolate(ratio_arg[*,*,it], $
;;                                         rcm_abs[0,ir],rcm_abs[1,ir])
