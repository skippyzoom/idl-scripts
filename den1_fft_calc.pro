;+
; Script for calculating the FFT of a plane of EPPIC den1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Add a description to the file name
;;  (e.g., 'full', 'center512', 'right_half' to distinguish different
;;  sets of ranges)
file_description = 'full'

;;==Select a subarray
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
dc_mask = 3
mask_index = [[nkx/2-dc_mask,nkx/2+dc_mask], $
              [nky/2-dc_mask,nky/2+dc_mask], $
              [0,ntf]]
fdata = condition_fft(fdata, $
                      /magnitude, $
                      shift = [nkx/2,nky/2,0], $
                      mask_index = mask_index, $
                      missing = 1e-6, $
                      /finite, $
                      /normalize, $
                      /to_dB)

;;==Set up kx and ky vectors for images
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(xdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(ydata,nky/2)
