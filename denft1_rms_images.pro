;+
; Script for making frames from a plane of EPPIC denft1 data after RMS
; over time.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'denft1_rms'+ $
           ;; '-self_norm'+ $
           '-'+time.index+ $
           '.'+get_extension(frame_type)

;;==Get the number of time steps
nt = n_elements(time.index)

;;==Declare RMS time ranges
rms_time = [[0,nt/4], $
            [nt/4,nt/2], $
            [nt/2,3*nt/4], $
            [3*nt/4,nt-1]]
rms_time = transpose(rms_time)
n_rms = (size(rms_time))[1]

;;==Preserve raw FFT
fdata = denft1

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;--DEV
fdata_rms = fltarr(nx,ny,n_rms)
for it=0,n_rms-1 do $
   fdata_rms[*,*,it] = rms(fdata[*,*,rms_time[it,0]:rms_time[it,1]],dim=3)

;;==Shift FFT
fdata_rms = shift(fdata_rms,nkx/2,nky/2,0)

;;==Suppress lowest frequencies
dc_width = {xn:0, xp:0, $
            yn:0, yp:0}
fdata_rms[nkx/2-dc_width.xn:nkx/2+dc_width.xp, $
          nky/2-dc_width.yn:nky/2+dc_width.yp,*] = min(fdata_rms)

;;==Covert to decibels
fdata_rms = 10*alog10(fdata_rms^2)

;;==Set non-finite values to smallest finite value
fdata_rms[where(~finite(fdata_rms))] = min(fdata_rms[where(finite(fdata_rms))])

;;==Normalize to 0 (i.e., logarithm of 1)
fdata_rms -= max(fdata_rms)
;; for it=0,nt-1 do $
;;    fdata_rms[*,*,it] -= max(fdata_rms[*,*,it])

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)
