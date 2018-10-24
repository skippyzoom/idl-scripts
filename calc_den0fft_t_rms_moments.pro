;+
; Calculate the centroid of a section of RMS den0fft_t array. This
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
;; rms_ind = get_rms_indices(path,time,/from_frm_indices,delta=4)
rms_ind = get_rms_indices(path,time)
rms_ind = transpose(rms_ind)
n_rms = (size(rms_ind))[1]

;;==Preserve raw FFT
fdata = den0fft_t

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Compute RMS values
fdata_rms = fltarr(nkx,nky,n_rms)
for it=0,n_rms-1 do $
   fdata_rms[*,*,it] = rms(fdata[*,*,rms_ind[it,0]:rms_ind[it,1]],dim=3)

;;==Shift FFT
fdata_rms = shift(fdata_rms,nkx/2,nky/2,0)

;;==Suppress lowest frequencies
dc_width = {xn:0, xp:0, $
            yn:0, yp:0}
fdata_rms[nkx/2-dc_width.xn:nkx/2+dc_width.xp, $
          nky/2-dc_width.yn:nky/2+dc_width.yp,*] = min(fdata_rms)

;;==Set non-finite values to smallest finite value
fdata_rms[where(~finite(fdata_rms))] = min(fdata_rms[where(finite(fdata_rms))])

;;==Optionally sum bins to improve variance
;;  XBW and YBW are the bin widths. Setting either to 1 has the effect
;;  of skipping the sum in that dimension. Setting both to 1 causes
;;  bin_sum to return fdata untouched.
xbw = 1
ybw = 1
x0b = x0/xbw
xfb = xf/xbw
nkxb = nkx/xbw
y0b = y0/ybw
yfb = yf/ybw
nkyb = nky/ybw
fdata_b = fltarr(nkxb,nkyb,n_rms)
for it=0,n_rms-1 do $
   fdata_b[*,*,it] = bin_sum(fdata_rms[*,*,it],ybw,xbw)

;;==Find centroid and variance of each image
im = list()
for it=0,n_rms-1 do $
   im.add, find_image_moments(fdata_b[x0b:xfb-1,y0b:yfb-1,it], $
                              mask_threshold = 1e-1, $
                              mask_value = 0.0, $
                              mask_type = 'relative_max')

;;==Extract centroids and correct for binning
rcm = fltarr(2,n_rms)
for it=0,n_rms-1 do $
   rcm[*,it] = im[it].centroid*[xbw,ybw]+[xbw/2,ybw/2]

;;==Extract variance
vcm = fltarr(2,n_rms)
for it=0,n_rms-1 do $
   vcm[*,it] = im[it].variance

;;==Shift centroid coordinates to image center
rcm_ctr = fltarr(2,n_rms)
for it=0,n_rms-1 do $
   rcm_ctr[*,it] = rcm[*,it] + [x0-nkx/2,y0-nky/2]

;;==Estimate uncertainty in centroid coordinates
dev_xy = fltarr(2,n_rms)
for it=0,n_rms-1 do $
   dev_xy[*,it] = centroid_uncertainty(fdata_b[x0b:xfb-1,y0b:yfb-1,it], $
                                       rcm_ctr[0,it]/xbw, $
                                       rcm_ctr[1,it]/ybw, $
                                       /prop_to_f)
dev_x = dev_xy[0,*]/sqrt(xbw)
dev_y = dev_xy[1,*]/sqrt(ybw)

;;==Compute absolute coordinates
rcm_abs = fltarr(2,n_rms)
for it=0,n_rms-1 do $
   rcm_abs[*,it] = rcm[*,it] + [x0,y0]

;;==Calculate wavelength and angle corresponding to centroid
dkx = 2*!pi/(nkx*dx)
dky = 2*!pi/(nky*dy)
rcm_lambda = 2*!pi/sqrt((dkx*rcm_ctr[0,*])^2+(dky*rcm_ctr[1,*])^2)
rcm_theta = atan(dky*rcm_ctr[1,*],dkx*rcm_ctr[0,*])

;;==Calculate uncertainty in centroid angle
dth_dx = fltarr(n_rms)
for it=0,n_rms-1 do $
   dth_dx[it] = -rcm_ctr[1,it]/(rcm_ctr[0,it]^2 + rcm_ctr[1,it]^2)
dth_dy = fltarr(n_rms)
for it=0,n_rms-1 do $
   dth_dy[it] = +rcm_ctr[0,it]/(rcm_ctr[0,it]^2 + rcm_ctr[1,it]^2)
dev_rcm_theta = fltarr(n_rms)
for it=0,n_rms-1 do $
   dev_rcm_theta[it] = sqrt((dev_x[it]*dth_dx[it])^2 + $
                            (dev_y[it]*dth_dy[it])^2)
