;+
; Script for making survey images from den1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare file name
;;  Multi-paging only works with .pdf and .gif
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den1','pdf', $
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

;;==Get dimensions
fsize = size(den1)
nx = fsize[1]
ny = fsize[2]

;;==Declare image ranges
x0 = 0
xf = nx
y0 = 0
yf = ny

;;==Create survey frame
frm = objarr(n_pages,n_per_page)
for it=0,n_mask-1 do $
   frm[(it/n_per_page), $
       (it mod n_per_page)] = image(den1[x0:xf-1,y0:yf-1,ind_mask[it]], $
                                    xdata[x0:xf-1],ydata[y0:yf-1], $
                                    axis_style = 1, $
                                    min_value = -0.2, $
                                    max_value = +0.2, $
                                    rgb_table = 5, $
                                    position = position[*,it mod n_per_page], $
                                    xtickdir = 1, $
                                    ytickdir = 1, $
                                    xticklen = 0.02, $
                                    yticklen = 0.02, $
                                    xtickvalues = dx*[0,nx/2,nx], $
                                    ytickvalues = dy*[0,nx/2,nx], $
                                    xtickname = ['','$L_x/2$','$L_x$'], $
                                    ytickname = ['','$L_y/2$','$L_y$'], $
                                    font_name = 'Times', $
                                    font_size = 10.0, $
                                    xshowtext = (((it mod n_per_page)  /  nc) $
                                                 eq nc-1), $
                                    yshowtext = (((it mod n_per_page) mod nc) $
                                                 eq 0), $
                                    current = ((it mod n_per_page) gt 0), $
                                    /buffer)

;;==Add global color bar
right_edge = frm[nc-1].position[2]+0.01
width = 0.02
for ip=0,n_pages-1 do $
   clr = colorbar(target = frm[ip,0], $
                  title = '$\delta n_i/n_0$', $
                  major = 5, $
                  minor = 3, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [right_edge,0.20,right_edge+width,0.80], $
                  font_size = 10.0, $
                  font_name = 'Times', $
                  hide = 0)

;;==Add time stamp on each panel
for it=0,n_mask-1 do $
   txt = text(xdata[x0],ydata[yf-1], $
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
