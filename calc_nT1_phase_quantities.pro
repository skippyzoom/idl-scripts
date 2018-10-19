;+
; Script for calculating the spectral phase of FFT(temp1)/FFT(den1)
; and of FFT(temp1)-FFT(den1), where temp1 and den1 are relative
; temperature and density perturbations.
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
nT1_rat = ftemp1/fden1
nT1_rat_r = real_part(nT1_rat)
nT1_rat_i = imaginary(nT1_rat)

;;==Compute the phase of the ratio
nT1_rat_arg = atan(nT1_rat_i,nT1_rat_r)

;;==Extract real and imaginary parts of difference
nT1_dif = ftemp1-fden1
nT1_dif_r = real_part(nT1_dif)
nT1_dif_i = imaginary(nT1_dif)

;;==Compute the phase of the difference
nT1_dif_arg = atan(nT1_dif_i,nT1_dif_r)

