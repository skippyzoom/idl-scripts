;+
; Script to build RMS over time of den1fft_t, then interpolate from
; (kx,ky,t) to (k,theta,t) 
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare wavelengths of interest, in meters
if n_elements(lambda) eq 0 then $
   lambda = 1.0 + findgen(10)

;;==Declare angles of interest, in radians
if n_elements(theta) eq 0 then $
   theta = [0,2*!pi]

;;==Get RMS times from available time steps
rms_time = get_rms_time(path,time)
rms_time = transpose(rms_time)
n_rms = (size(rms_time))[1]

;;==Preserve raw FFT
fdata = den1fft_t

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Compute RMS values
fdata_rms = fltarr(nx,ny,n_rms)
for it=0,n_rms-1 do $
   fdata_rms[*,*,it] = rms(fdata[*,*,rms_time[it,0]:rms_time[it,1]],dim=3)

;;==Shift FFT
fdata_rms = shift(fdata_rms,nkx/2,nky/2,0)

;;==Interpolate the FFT
den1rmsktt = interp_xy2kt(fdata_rms, $
                          lambda = lambda, $
                          theta = theta, $
                          dx = dx, $
                          dy = dy)
