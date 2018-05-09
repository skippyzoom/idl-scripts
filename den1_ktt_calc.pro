;+
; Script for interpolating den1 FFT from (x,y,t) to (k,theta,t)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Add a description to the file name
;;  (e.g., 'full', 'center512', 'right_half' to distinguish different
;;  sets of ranges)
file_description = 'full'

;;==Select a subarray of which to calculate the FFT
x0 = 0
xf = nx
y0 = 0
yf = ny

;;==Calculate the spatial FFT of the den1 plane
fdata = make_array(size(den1[x0:xf-1,y0:yf-1,*],/dim),type=6,value=0)
nt = n_elements(time.index)
for it=0,nt-1 do $
   fdata[*,*,it] = fft(den1[x0:xf-1,y0:yf-1,it])

;;==Calculate the RMS over a set of time ranges
if n_elements(rms_range) ne 0 then $
   fdata = rms_over_time(fdata,rms_range)

;;==Get updated dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]
ntf = fsize[3]

;;==Condition the data
to_dB = 1B
fdata = condition_fft(fdata, $
                      /magnitude, $
                      to_dB = to_dB, $
                      shift = [nkx/2,nky/2,0])

;;==Interpolate Cartesian to polar at specified radii (lambda)
xy2kt = interp_xy2kt(fdata, $
                     lambda = [2.0,3.0,4.0,5.0,6.0,10.0], $
                     ;; lambda = 3.0, $
                     ;; lambda = findgen(11,start=2.0,increment=0.1), $
                     theta = [-!pi/2,+!pi/2], $
                     nkx = nx, $
                     nky = ny, $
                     dx = dx, $
                     dy = dy)
