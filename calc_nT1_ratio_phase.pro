;+
; Script for calculating the spectral phase of FFT(temp1)/FFT(den1)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Compute FFT of den1
fden1 = make_array(size(den1,/dim),/complex)
for it=0,time.nt-1 do $
   fden1[*,*,it] = fft(den1[*,*,it],/center)

;;==Construct relative perturbed temperature
delT1 = temp1*0.0
for it=0,time.nt-1 do $
   delT1[*,*,it] = (temp1[*,*,it]-mean(temp1[*,*,it]))/mean(temp1[*,*,it])

;;==Compute FFT of delT1
ftemp1 = make_array(size(delT1,/dim),/complex)
for it=0,time.nt-1 do $
   ftemp1[*,*,it] = fft(delT1[*,*,it],/center)

;;==Extract real and imaginary parts of ratio
ratio = ftemp1/fden1
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
