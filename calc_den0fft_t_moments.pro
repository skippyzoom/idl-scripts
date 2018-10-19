;+
; Calculate the centroid of a section of den0fft_t array. This
; script assumes that the user has called calc_den0fft_t.pro after
; loading den0 into memory (e.g., via get_den0_plane.pro)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare image domain over which to find centroid, relative to shift
x0 = nkx/2
xf = nkx/2+nkx/4
y0 = nky/2-nky/8
yf = nky/2+nky/8

;;==Get RMS times from available time steps
rms_ind = get_rms_indices(path,time)
rms_ind = transpose(rms_ind)
n_rms = (size(rms_ind))[1]

;;==Preserve raw FFT
fdata = den0fft_t

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Shift FFT
fdata = shift(fdata,nkx/2,nky/2,0)

;;==Suppress lowest frequencies
dc_width = {xn:0, xp:0, $
            yn:0, yp:0}
fdata[nkx/2-dc_width.xn:nkx/2+dc_width.xp, $
          nky/2-dc_width.yn:nky/2+dc_width.yp,*] = min(fdata)

;;==Set non-finite values to smallest finite value
fdata[where(~finite(fdata))] = min(fdata[where(finite(fdata))])

;;==Find centroid and variance of each image
rcm = fltarr(2,time.nt)
for it=0,time.nt-1 do $
   rcm[*,it] = find_image_centroid(fdata[x0:xf-1,y0:yf-1,it], $
                                   mask_threshold = 1e-1, $
                                   mask_value = 0.0, $
                                   mask_type = 'relative_max')

;;==Shift centroid coordinates to image center
rcm_ctr = fltarr(2,time.nt)
for it=0,time.nt-1 do $
   rcm_ctr[*,it] = rcm[*,it] + [x0-nkx/2,y0-nky/2]

;;==Compute absolute coordinates
rcm_abs = fltarr(2,time.nt)
for it=0,time.nt-1 do $
   rcm_abs[*,it] = rcm[*,it] + [x0,y0]

;;==Shift centroid coordinates to center of pixel
rcm_ctr += 0.5

;;==Calculate wavelength and angle corresponding to centroid
dkx = 2*!pi/(nkx*dx)
dky = 2*!pi/(nky*dy)
rcm_lambda = 2*!pi/sqrt((dkx*rcm_ctr[0,*])^2+(dky*rcm_ctr[1,*])^2)
rcm_theta = atan(dky*rcm_ctr[1,*],dkx*rcm_ctr[0,*])
