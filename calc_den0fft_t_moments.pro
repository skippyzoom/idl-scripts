;+
; Calculate the centroid of a section of den0fft_t array. This script
; assumes that the user has called calc_den0fft_t.pro after loading
; den0 into memory (e.g., via get_den0_plane.pro)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare shifted domain for centroid
x0 = nkx/2
xf = nkx
y0 = nky/2-nky/4
yf = nky/2+nky/4

;;==Get RMS times from available time steps
rms_time = get_rms_time(path,time)
rms_time = transpose(rms_time)
n_rms = (size(rms_time))[1]

;;==Preserve raw FFT
fdata = den0fft_t

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Compute RMS values
fdata_rms = fltarr(nkx,nky,n_rms)
for it=0,n_rms-1 do $
   fdata_rms[*,*,it] = rms(fdata[*,*,rms_time[it,0]:rms_time[it,1]],dim=3)

;;==Shift FFT
fdata_rms = shift(fdata_rms,nkx/2,nky/2,0)

;;==Suppress lowest frequencies
dc_width = {xn:0, xp:0, $
            yn:0, yp:0}
fdata_rms[nkx/2-dc_width.xn:nkx/2+dc_width.xp, $
          nky/2-dc_width.yn:nky/2+dc_width.yp,*] = min(fdata_rms)

;;==Set non-finite values to smallest finite value
fdata_rms[where(~finite(fdata_rms))] = min(fdata_rms[where(finite(fdata_rms))])

;;==Find centroid and variance of each image
im = list()
for it=0,n_rms-1 do $
   im.add, find_image_moments(fdata_rms[x0:xf-1,y0:yf-1,it], $
                              mask_threshold = 1e-1, $
                              mask_value = 0.0, $
                              mask_type = 'relative_max')

;;==Extract centroids
rcm = fltarr(2,n_rms)
for it=0,n_rms-1 do $
   rcm[*,it] = im[it].centroid

;;==Extract variance
vcm = fltarr(2,n_rms)
for it=0,n_rms-1 do $
   vcm[*,it] = im[it].variance

;;==Shift centroid coordinates to image center
rcm_ctr = fltarr(2,n_rms)
for it=0,n_rms-1 do $
   rcm_ctr[*,it] = rcm[*,it] + [x0-nkx/2,y0-nky/2]

;;==Shift centroid coordinates by half a pixel
rcm_ctr += 0.5

;;==Calculate wavelength and angle corresponding to centroid
rcm_lambda = fltarr(n_rms)
for it=0,n_rms-1 do $ 
   rcm_lambda[it] = 2*!pi/sqrt((dx*rcm_ctr[0,it])^2+(dy*rcm_ctr[1,it])^2)
rcm_theta = fltarr(n_rms)
for it=0,n_rms-1 do $
   rcm_theta[it] = atan(rcm_ctr[1,it],rcm_ctr[0,it])

;;==Calculate error in centroid angle
dev_x = 1
dev_y = 1
dth_dx = fltarr(n_rms)
for it=0,n_rms-1 do $
   dth_dx[it] = -rcm_ctr[1,it]/(rcm_ctr[0,it]^2 + rcm_ctr[1,it]^2)
dth_dy = fltarr(n_rms)
for it=0,n_rms-1 do $
   dth_dy[it] = +rcm_ctr[0,it]/(rcm_ctr[0,it]^2 + rcm_ctr[1,it]^2)
dev_rcm_theta = fltarr(n_rms)
for it=0,n_rms-1 do $
   dev_rcm_theta[it] = sqrt((dev_x*dth_dx[it])^2 + (dev_y*dth_dy[it])^2)
   
