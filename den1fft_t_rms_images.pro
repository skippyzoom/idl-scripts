;+
; Script for making frames from a plane of EPPIC den1fft_t data after RMS
; over time.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Get RMS times from available time steps
rms_ind = get_rms_indices(path,time)
rms_ind = transpose(rms_ind)
n_rms = (size(rms_ind))[1]

;;==Get subsample frequency
if time.haskey('subsample') then subsample = time.subsample $
else subsample = 1

;;==Declare file name(s)
str_rms_ind = string(rms_ind*params.nout*subsample, $
                     format='(i06)')
filename = strarr(n_rms)
for it=0,n_rms-1 do $
   filename[it] = expand_path(path+path_sep()+'frames')+ $
   path_sep()+'den1fft_t_rms'+ $
   '-'+axes+ $
   '-'+str_rms_ind[it]+ $
   '-'+str_rms_ind[it+n_rms]+ $
   '-self_norm'+ $
   '-20dB'+ $
   '-centroid'+ $
   '-zoom'+ $
   '.'+get_extension(frame_type)

;;==Preserve raw FFT
fdata = den1fft_t

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Declare ranges to show
x0 = perp_plane ? nkx/2 : nkx/2-nkx/4
xf = perp_plane ? nkx/2+nkx/4 : nkx/2+nkx/4
y0 = perp_plane ? nky/2-nky/4 : nky/2
yf = perp_plane ? nky/2+nky/4 : nky/2+nky/4

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Compute RMS values
fdata_rms = fltarr(nx,ny,n_rms)
for it=0,n_rms-1 do $
   fdata_rms[*,*,it] = rms(fdata[*,*,rms_ind[it,0]:rms_ind[it,1]],dim=3)

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
;; fdata_rms -= max(fdata_rms)
for it=0,n_rms-1 do $
   fdata_rms[*,*,it] -= max(fdata_rms[*,*,it])

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Set axes-specific keywords
xrange = perp_plane ? [0,+!pi] : [-!pi/4,+!pi/4]
yrange = perp_plane ? [-!pi,+!pi] : [0,+2*!pi]
xminor = perp_plane ? 3 : 1

;;==Declare an array of image handles
frm = objarr(n_rms)

;;==Create image frames
for it=0,n_rms-1 do $
   frm[it] = image(fdata_rms[x0:xf-1,y0:yf-1,it], $
                   kxdata[x0:xf-1],kydata[y0:yf-1], $
                   min_value = -20, $
                   max_value = 0, $
                   rgb_table = 39, $
                   axis_style = 1, $
                   position = [0.10,0.10,0.80,0.80], $
                   xrange = xrange, $
                   yrange = yrange, $
                   xmajor = 3, $
                   xminor = xminor, $
                   ymajor = 3, $
                   yminor = 3, $
                   xstyle = 1, $
                   ystyle = 1, $
                   xsubticklen = 0.5, $
                   ysubticklen = 0.5, $
                   xtickdir = 1, $
                   ytickdir = 1, $
                   xticklen = 0.02, $
                   yticklen = 0.04, $
                   xshowtext = 1, $
                   yshowtext = 1, $
                   xtickfont_size = 12.0, $
                   ytickfont_size = 12.0, $
                   font_name = 'Times', $
                   font_size = 18.0, $
                   /buffer)

;;==Add a colorbar to each image
for it=0,n_rms-1 do $
   clr = colorbar(target = frm[it], $
                  title = '$P(\delta n/n_I)$', $
                  major = 1+(frm[it].max_value-frm[it].min_value)/5, $
                  minor = 3, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [0.84,0.10,0.86,0.80], $
                  font_size = 12.0, $
                  font_name = 'Times', $
                  hide = 0)

;;==Add radius and angle markers
;; r_overlay = 2*!pi/(2+findgen(9))
r_overlay = 2*!pi/(1+findgen(10))
theta_overlay = 10*findgen(36)
if perp_plane then $
   for it=0,n_rms-1 do $
      frm[it] = overlay_rtheta(frm[it], $
                               r_overlay, $
                               theta_overlay, $
                               /degrees, $
                               r_color = 'white', $
                               r_thick = 1, $
                               r_linestyle = 'dot', $
                               theta_color = 'white', $
                               theta_thick = 1, $
                               theta_linestyle = 'dot')

;;==Add angle of centroid
if n_elements(rcm_theta) ne 0 then $
   if perp_plane then $
      for it=0,n_rms-1 do $
         frm[it] = overlay_rtheta(frm[it], $
                                  2*!pi/sqrt(dx^2+dy^2), $
                                  rcm_theta[it], $
                                  r_color = 'white', $
                                  r_thick = 2, $
                                  r_linestyle = 'none', $
                                  theta_color = 'white', $
                                  theta_thick = 2, $
                                  theta_linestyle = 'solid_line')

;;==Add lines at +/- one standard deviation of centroid
if n_elements(rcm_theta) ne 0 then $
   if perp_plane then $
      for it=0,n_rms-1 do $
         frm[it] = overlay_rtheta(frm[it], $
                                  2*!pi/sqrt(dx^2+dy^2), $
                                  rcm_theta[it]+dev_rcm_theta[it], $
                                  r_color = 'white', $
                                  r_thick = 2, $
                                  r_linestyle = 'none', $
                                  theta_color = 'white', $
                                  theta_thick = 2, $
                                  theta_linestyle = 'solid_line')
if n_elements(rcm_theta) ne 0 then $
   if perp_plane then $
      for it=0,n_rms-1 do $
         frm[it] = overlay_rtheta(frm[it], $
                                  2*!pi/sqrt(dx^2+dy^2), $
                                  rcm_theta[it]-dev_rcm_theta[it], $
                                  r_color = 'white', $
                                  r_thick = 2, $
                                  r_linestyle = 'none', $
                                  theta_color = 'white', $
                                  theta_thick = 2, $
                                  theta_linestyle = 'solid_line')


;;==Print wavelength and angle of centroid on image frame
for it=0,n_rms-1 do $
   txt = text(0.0,0.01, $
              "Centroid $\lambda$ = "+ $
              strcompress(string(rcm_lambda[it]),/remove_all)+ $
              " m       "+ $
              "Centroid $\theta$ = "+ $
              strcompress(string(rcm_theta[it]/!dtor),/remove_all)+ $
              " deg", $
              target = frm[it], $
              font_name = 'Times', $
              font_size = 10.0)

;;==Find location of max pixel in growth image
imax2d = array_indices(fdata_rms[x0:xf-1,y0:yf-1,0], $
                       where(fdata_rms[x0:xf-1,y0:yf-1,0] eq $
                             max(fdata_rms[x0:xf-1,y0:yf-1,0])))
ikx = x0+imax2d[0]
iky = y0+imax2d[1]
peak_lambda = 2*!pi/sqrt(kxdata[ikx]^2 + kydata[iky]^2)
peak_theta = atan(kydata[iky],kxdata[ikx])/!dtor

;;==Print wavelength and angle of max pixel on image frame
txt = text(0.5,0.01, $
           "Peak $\lambda$ = "+ $
           strcompress(string(peak_lambda),/remove_all)+ $
           " m       "+ $
           "Peak $\theta$ = "+ $
           strcompress(string(peak_theta),/remove_all)+ $
           " deg", $
           target = frm[0], $
           font_name = 'Times', $
           font_size = 10.0)

;;==Add a path label
for it=0,n_rms-1 do $
   txt = text(0.0,0.90, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save individual images
for it=0,n_rms-1 do $
   frame_save, frm[it],filename=filename[it]

;;==Clear fdata
;; fdata = !NULL
