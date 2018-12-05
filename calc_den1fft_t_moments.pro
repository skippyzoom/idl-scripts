;+
; Calculate the centroid of a section of den1fft_t array. This
; script assumes that the user has called calc_den1fft_t.pro after
; loading den1 into memory (e.g., via get_den1_plane.pro)
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare image domain over which to find centroid, relative to shift
x0 = nkx/2
xf = nkx/2+nkx/8
y0 = nky/2-nky/8
yf = nky/2+nky/8

;;==Preserve raw FFT
fdata = den1fft_t

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

;;==Optionally sum bins to improve variance
;;  BW is the bin width. Setting it to 1 causes bin_sum to return
;;  fdata untouched. The function bin_sum.pro accepts different bin
;;  widths in each direction but that doesn't make sense here.
bw = 1
x0b = x0/bw
xfb = xf/bw
nkxb = nkx/bw
y0b = y0/bw
yfb = yf/bw
nkyb = nky/bw
fdata_b = fltarr(nkxb,nkyb,time.nt)
for it=0,time.nt-1 do $
   fdata_b[*,*,it] = bin_sum(fdata[*,*,it],bw,bw)

;;==Find centroid and variance of each image
im = list()
for it=0,time.nt-1 do $
   im.add, find_image_moments(fdata_b[x0b:xfb-1,y0b:yfb-1,it], $
                              mask_threshold = 1e-1, $
                              mask_value = 0.0, $
                              mask_type = 'relative_max')

;;==Extract centroids and correct for binning
rcm = fltarr(2,time.nt)
for it=0,time.nt-1 do $
   rcm[*,it] = im[it].centroid*[bw,bw]+[bw/2,bw/2]

;;==Extract variance
vcm = fltarr(2,time.nt)
for it=0,time.nt-1 do $
   vcm[*,it] = im[it].variance

;;==Shift centroid coordinates to image center
rcm_ctr = fltarr(2,time.nt)
for it=0,time.nt-1 do $
   rcm_ctr[*,it] = rcm[*,it] + [x0-nkx/2,y0-nky/2]

;;==Estimate uncertainty in centroid coordinates
dev_xy = fltarr(2,time.nt)
for it=0,time.nt-1 do $
   dev_xy[*,it] = centroid_uncertainty(fdata_b[x0b:xfb-1,y0b:yfb-1,it], $
                                       rcm_ctr[0,it]/bw, $
                                       rcm_ctr[1,it]/bw, $
                                       /prop_to_f)
dev_x = dev_xy[0,*]/sqrt(bw)
dev_y = dev_xy[1,*]/sqrt(bw)

;;==Compute absolute coordinates, for reference
rcm_abs = fltarr(2,time.nt)
for it=0,time.nt-1 do $
   rcm_abs[*,it] = rcm[*,it] + [x0,y0]

;;==Calculate wavelength and angle corresponding to centroid
dkx = 2*!pi/(nkx*dx)
dky = 2*!pi/(nky*dy)
rcm_lambda = 2*!pi/sqrt((dkx*rcm_ctr[0,*])^2+(dky*rcm_ctr[1,*])^2)
rcm_lambda = reform(rcm_lambda)
rcm_theta = atan(dky*rcm_ctr[1,*],dkx*rcm_ctr[0,*])
rcm_theta = reform(rcm_theta)

;;==Calculate uncertainty in centroid angle
dth_dx = fltarr(time.nt)
for it=0,time.nt-1 do $
   dth_dx[it] = -rcm_ctr[1,it]/(rcm_ctr[0,it]^2 + rcm_ctr[1,it]^2)
dth_dy = fltarr(time.nt)
for it=0,time.nt-1 do $
   dth_dy[it] = +rcm_ctr[0,it]/(rcm_ctr[0,it]^2 + rcm_ctr[1,it]^2)
dev_rcm_theta = fltarr(time.nt)
for it=0,time.nt-1 do $
   dev_rcm_theta[it] = sqrt((dev_x[it]*dth_dx[it])^2 + $
                            (dev_y[it]*dth_dy[it])^2)
