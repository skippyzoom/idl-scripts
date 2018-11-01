;+
; Script for making survey images from calc_nT0_phase_quantities
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare file name
;;  Multi-paging only works with .pdf and .gif
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den0_temp0_rat_phase','pdf', $
                          path = filepath, $
                          additions = [axes, $
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

;;==Preserve raw data
fdata = nT0_rat_arg/!dtor

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Declare image ranges
x0 = params.ndim_space eq 2 ? nkx/2-nkx/8 : nkx/2-nkx/4
xf = params.ndim_space eq 2 ? nkx/2+nkx/8 : nkx/2+nkx/4
y0 = params.ndim_space eq 2 ? nky/2-nky/8 : nky/2-nky/4
yf = params.ndim_space eq 2 ? nky/2+nky/8 : nky/2+nky/4

;;==Set non-finite values to 0.0
fdata[where(~finite(fdata))] = 0.0

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Load custom color table
ct = get_custom_ct(2)

;;==Create survey frame
frm = objarr(n_pages,n_per_page)
for it=0,n_mask-1 do $
   frm[(it/n_per_page), $
       (it mod n_per_page)] = image(fdata[x0:xf-1,y0:yf-1,ind_mask[it]], $
                                    kxdata[x0:xf-1],kydata[y0:yf-1], $
                                    axis_style = 1, $
                                    min_value = -180, $
                                    max_value = +180, $
                                    rgb_table = [[ct.r],[ct.g],[ct.b]], $
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
                  title = 'arg($\tau_e/\eta_e$) [deg.]', $
                  major = 13, $
                  minor = 3, $
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
