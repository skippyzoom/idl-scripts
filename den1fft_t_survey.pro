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
                                       'self_norm', $
                                       '20dB', $
                                       'zoom', $
                                       'single_page', $
                                       'survey'])

;;==Declare global image title
;;  To suppress this, comment out the following line or set
;;  global_title = !NULL
global_title = get_run_label(path)

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
                                    xtickvalues = [-2*!pi,0,+2*!pi], $
                                    ytickvalues = [-2*!pi,0,+2*!pi], $
                                    xtickname = ['$-2\pi$','0','$+2\pi$'], $
                                    ytickname = ['$-2\pi$','0','$+2\pi$'], $
                                    font_name = 'Times', $
                                    font_size = 10.0, $
                                    xshowtext = (((it mod n_per_page)  /  nc) $
                                                 eq nc-1), $
                                    yshowtext = (((it mod n_per_page) mod nc) $
                                                 eq 0), $
                                    current = ((it mod n_per_page) gt 0), $
                                    /buffer)

;;==Add global color bar
for ip=0,n_pages-1 do $
   clr = colorbar(target = frm[ip,0], $
                  title = '$P(\delta n_i/n_I)$ [dB]', $
                  major = 5, $
                  minor = 4, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [0.90,0.20,0.91,0.80], $
                  font_size = 10.0, $
                  font_name = 'Times', $
                  hide = 0)

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
