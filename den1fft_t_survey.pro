;+
; Script for making survey images from calc_den1fft_t
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare file name
;;  Multi-paging only works with .pdf and .gif
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den1fft_t','pdf', $
                          path = filepath, $
                          additions = [axes, $
                                       'B_rms', $
                                       'self_norm', $
                                       '20dB', $
                                       'zoom', $
                                       'single_page', $
                                       'survey'])

;;==Declare global image title
;;  To suppress this, comment out the following line or set
;;  global_title = !NULL
global_title = get_run_label(path)

;;==Calculate drift angle
;;  To suppress overlaying these angles on the FFT images, comment
;;  them out or set them to !NULL after using them.
vd_angle = fbfa_vd_angle(path)

;;==Declare page layout
;;  More than 16 panels per page may get crowded
nc = 4
nr = 4
n_per_page = nc*nr

;;==Create default index mask
if n_elements(ind_mask) eq 0 then $
   ind_mask = indgen(time.nt)
n_mask = n_elements(ind_mask)

;;==Calculate number of pages
n_pages = n_mask/n_per_page + (n_mask mod n_per_page gt 0)

;;==Set up position array for subframes
position = multi_position(nc*nr, $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffer = [-0.15,0.01])

;;==Preserve raw FFT
fdata = den1fft_t

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Declare image ranges
x0 = params.ndim_space eq 2 ? nkx/2-nkx/8 : nkx/2-nkx/4
xf = params.ndim_space eq 2 ? nkx/2+nkx/8 : nkx/2+nkx/4
y0 = params.ndim_space eq 2 ? nky/2-nky/8 : nky/2-nky/4
yf = params.ndim_space eq 2 ? nky/2+nky/8 : nky/2+nky/4
;; x0 = params.ndim_space eq 2 ? nkx/2-nkx/16 : nkx/2-nkx/8
;; xf = params.ndim_space eq 2 ? nkx/2+nkx/16 : nkx/2+nkx/8
;; y0 = params.ndim_space eq 2 ? nky/2-nky/16 : nky/2-nky/8
;; yf = params.ndim_space eq 2 ? nky/2+nky/16 : nky/2+nky/8

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
for it=0,time.nt-1 do $
   fdata[*,*,it] -= max(fdata[*,*,it])

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Declare an array of image handles
frm = objarr(n_per_page)

;;==Create survey frame
frm = objarr(n_pages,n_per_page)
;; xshowtext = (((indgen(n_mask) mod n_per_page)  /  nc) eq nc-1)
;; yshowtext = (((indgen(n_mask) mod n_per_page) mod nc) eq nc-1)
xshowtext = 0
yshowtext = 0
;; xrange = [-!pi,+!pi]
;; yrange = [-!pi,+!pi]
for it=0,n_mask-1 do $
   frm[(it/n_per_page), $
       (it mod n_per_page)] = image(fdata[x0:xf-1,y0:yf-1,ind_mask[it]], $
                                    kxdata[x0:xf-1],kydata[y0:yf-1], $
                                    axis_style = 1, $
                                    min_value = -20, $
                                    max_value = 0, $
                                    rgb_table = 39, $
                                    position = position[*,it mod n_per_page], $
                                    xtickdir = 1, $
                                    ytickdir = 1, $
                                    xminor = 1, $
                                    yminor = 1, $
                                    xticklen = 0.02, $
                                    yticklen = 0.02, $
                                    xrange = [-!pi,+!pi], $
                                    yrange = [-!pi,+!pi], $
                                    xtickvalues = [-!pi,0,+!pi], $
                                    ytickvalues = [-!pi,0,+!pi], $
                                    xtickname = ['$- \pi$','0','$+ \pi$'], $
                                    ytickname = ['$- \pi$','0','$+ \pi$'], $
                                    xtitle = '$k_x$ [m$^{-1}$]', $
                                    ytitle = '$k_y$ [m$^{-1}$]', $
                                    font_name = 'Times', $
                                    font_size = 10.0, $
                                    xshowtext = xshowtext, $
                                    yshowtext = yshowtext, $
                                    current = ((it mod n_per_page) gt 0), $
                                    /buffer)

;;==Add global color bar
right_edge = frm[nc-1].position[2]+0.01
width = 0.02
for ip=0,n_pages-1 do $
   clr = colorbar(target = frm[ip,0], $
                  title = '$P(\delta n_i/n_I)$ [dB]', $
                  major = 5, $
                  minor = 4, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [right_edge,0.20,right_edge+width,0.80], $
                  font_size = 10.0, $
                  font_name = 'Times', $
                  hide = 0)

;;==Set drift-velocity radius to extend to frame edge
if (vd_angle ge -0.25*!pi) && (vd_angle lt +0.25*!pi) then $
   vd_radius = frm[0].xrange[1]/sqrt(1-sin(vd_angle)^2) $
else vd_radius = 0.0 ;;DEV

;;==Add angle of +/- drift velocity
if n_elements(vd_angle) ne 0 then $
   if perp_plane then $
      for it=0,n_mask-1 do $
         frm[it] = overlay_rtheta(frm[it], $
                                  vd_radius, $
                                  vd_angle, $
                                  r_color = 'white', $
                                  r_thick = 1, $
                                  r_linestyle = 'none', $
                                  theta_color = 'magenta', $
                                  theta_thick = 2, $
                                  theta_linestyle = 'solid_line')
if n_elements(vd_angle) ne 0 then $
   if perp_plane then $
      for it=0,n_mask-1 do $
         frm[it] = overlay_rtheta(frm[it], $
                                  vd_radius, $
                                  vd_angle+!pi, $
                                  r_color = 'white', $
                                  r_thick = 1, $
                                  r_linestyle = 'none', $
                                  theta_color = 'magenta', $
                                  theta_thick = 2, $
                                  theta_linestyle = 'solid_line')

;;==Add time stamp on each panel
for it=0,n_mask-1 do $
   txt = text(kxdata[x0],kydata[yf-1], $
              time.stamp[ind_mask[it]], $
              /data, $
              vertical_alignment = 1.0, $
              target = frm[(it/n_per_page),(it mod n_per_page)], $
              color = 'black', $
              fill_background = 1, $
              fill_color = 'white', $
              font_name = 'Courier', $
              font_size = 8.0)

;;==Add a nice label
if n_elements(global_title) ne 0 then $
   for ip=0,n_pages-1 do $
      txt = text(0.5,0.92, $
                 get_run_label(path), $
                 target = frm[ip,0], $
                 alignment = 0.5, $
                 /normal, $
                 font_name = 'Courier', $
                 font_size = 14.0) $
else $
;;==Add a path label
for ip=0,n_pages-1 do $
   txt = text(0.0,0.95, $
              path, $
              target = frm[ip,0], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save the frame
frame_save, frm[*,0],filename=filename
