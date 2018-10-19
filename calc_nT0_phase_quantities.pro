;+
; Script for calculating the spectral phase of FFT(temp0)/FFT(den0)
; and of FFT(temp0)-FFT(den0), where temp0 and den0 are relative
; temperature and density perturbations.
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
nT0_rat = ftemp0/fden0
nT0_rat_r = real_part(nT0_rat)
nT0_rat_i = imaginary(nT0_rat)

;;==Compute the phase of the ratio
nT0_rat_arg = atan(nT0_rat_i,nT0_rat_r)

;;==Extract real and imaginary parts of difference
nT0_dif = ftemp0-fden0
nT0_dif_r = real_part(nT0_dif)
nT0_dif_i = imaginary(nT0_dif)

;;==Compute the phase of the difference
nT0_dif_arg = atan(nT0_dif_i,nT0_dif_r)

