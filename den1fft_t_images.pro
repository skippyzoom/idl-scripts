;+
; Script for making frames from a plane of EPPIC den1fft_t data (i.e.,
; den1 data after spectral transform in space only). See calc_den1fft_t.pro
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Get frame indices
frm_ind = get_frm_indices(path,time)

;;==Get the number of time steps
n_frm = n_elements(frm_ind)

;;==Declare file name(s)
filepath = expand_path(path)+path_sep()+'frames'
str_step = strcompress(time.index[frm_ind])
filename = strarr(n_frm)
for it=0,n_frm-1 do $
   filename[it] = build_filename('den1fft_t',frame_type, $
                                 path = filepath, $
                                 additions = [axes, $
                                              str_step[it], $
                                              'self_norm', $
                                              '20dB', $
                                              'centroid', $
                                              'zoom'])

;;==Preserve raw data
fdata = den1fft_t[*,*,frm_ind]

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

;;==Shift FFT
fdata = shift(fdata,nkx/2,nky/2,0)

;;==Suppress lowest frequencies
dc_width = {xn:0, xp:0, $
            yn:0, yp:0}
fdata[nkx/2-dc_width.xn:nkx/2+dc_width.xp, $
      nky/2-dc_width.yn:nky/2+dc_width.yp,*] = min(fdata)

;;==Covert to decibels
fdata = 10*alog10(fdata^2)

;;==Set non-finite values to smallest finite value
fdata[where(~finite(fdata))] = min(fdata[where(finite(fdata))])

;;==Normalize to 0 (i.e., logarithm of 1)
;; fdata -= max(fdata)
for it=0,n_frm-1 do $
   fdata[*,*,it] -= max(fdata[*,*,it])

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Set axes-specific keywords
xrange = perp_plane ? [0,+2*!pi] : [-!pi/4,+!pi/4]
yrange = perp_plane ? [-!pi,+!pi] : [0,+2*!pi]
xminor = perp_plane ? 3 : 1

;;==Declare an array of image handles
frm = objarr(n_frm)

;;==Create image frames
for it=0,n_frm-1 do $
   frm[it] = image(fdata[x0:xf-1,y0:yf-1,it], $
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
                   yticklen = 0.02, $
                   xshowtext = 1, $
                   yshowtext = 1, $
                   xtickfont_size = 12.0, $
                   ytickfont_size = 12.0, $
                   font_name = 'Times', $
                   font_size = 18.0, $
                   /buffer)

;;==Add a colorbar to each image
for it=0,n_frm-1 do $
   clr = colorbar(target = frm[it], $
                  title = '$P(\delta n/n_I)$', $
                  major = 5, $
                  minor = 4, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [0.82,0.10,0.84,0.80], $
                  font_size = 12.0, $
                  font_name = 'Times', $
                  hide = 0)

;;==Add radius and angle markers
r_overlay = 2*!pi/(1+findgen(10))
theta_overlay = 10*findgen(36)
if perp_plane then $
   for it=0,n_frm-1 do $
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
      for it=0,n_frm-1 do $
         frm[it] = overlay_rtheta(frm[it], $
                                  r_overlay[0], $
                                  rcm_theta[frm_ind[it]], $
                                  r_color = 'white', $
                                  r_thick = 2, $
                                  r_linestyle = 'none', $
                                  theta_color = 'white', $
                                  theta_thick = 2, $
                                  theta_linestyle = 'solid_line')

;;==Add lines at +/- one standard deviation of centroid
if n_elements(rcm_theta) ne 0 then $
   if perp_plane then $
      for it=0,n_frm-1 do $
         frm[it] = overlay_rtheta(frm[it], $
                                  r_overlay[0], $
                                  rcm_theta[frm_ind[it]]+ $
                                  dev_rcm_theta[frm_ind[it]], $
                                  r_color = 'white', $
                                  r_thick = 2, $
                                  r_linestyle = 'none', $
                                  theta_color = 'white', $
                                  theta_thick = 2, $
                                  theta_linestyle = 'solid_line')
if n_elements(rcm_theta) ne 0 then $
   if perp_plane then $
      for it=0,n_frm-1 do $
         frm[it] = overlay_rtheta(frm[it], $
                                  r_overlay[0], $
                                  rcm_theta[frm_ind[it]]- $
                                  dev_rcm_theta[frm_ind[it]], $
                                  r_color = 'white', $
                                  r_thick = 2, $
                                  r_linestyle = 'none', $
                                  theta_color = 'white', $
                                  theta_thick = 2, $
                                  theta_linestyle = 'solid_line')

;;==Add angle of drift velocity
if perp_plane then $
   for it=0,n_frm-1 do $
      frm[it] = overlay_rtheta(frm[it], $
                               r_overlay[0], $
                               fbfa_vd_angle(path), $
                               r_color = 'magenta', $
                               r_thick = 2, $
                               r_linestyle = 'none', $
                               theta_color = 'magenta', $
                               theta_thick = 2, $
                               theta_linestyle = 'dot')

;;==Print wavelength and angle of centroid on image frame
for it=0,n_frm-1 do $
   txt = text(0.0,0.01, $
              "Centroid $\lambda$ = "+ $
              strcompress(string(rcm_lambda[frm_ind[it]]),/remove_all)+ $
              " m       "+ $
              "Centroid $\theta$ = "+ $
              strcompress(string(rcm_theta[frm_ind[it]]/!dtor),/remove_all)+ $
              " deg", $
              target = frm[it], $
              font_name = 'Times', $
              font_size = 10.0)

;;==Add a path label
for it=0,n_frm-1 do $
   txt = text(0.0,0.90, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save individual images
for it=0,n_frm-1 do $
   frame_save, frm[it],filename=filename[it]
