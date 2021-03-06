;+
; Script for making frames from a plane of EPPIC den1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filepath = expand_path(path)+path_sep()+'frames'
str_step = strcompress(time.index)
filename = strarr(time.nt)
for it=0,time.nt-1 do $
   filename[it] = build_filename('den1',frame_type, $
                                 path = filepath, $
                                 additions = [axes, $
                                              str_step[it]])

;;==Preserve raw data
fdata = den1

;;==Get dimensions
fsize = size(fdata)
nx = fsize[1]
ny = fsize[2]

;;==Declare image ranges
x0 = 0
xf = nx
y0 = 0
yf = ny

;;==Optionally smooth
;; sw = [10.0/dx,10.0/dy,1]
sw = [1,1,1]
fdata = smooth(fdata,sw,/edge_wrap)

;;==Calculate the height-to-width aspect ratio
data_aspect = float(yf-y0)/(xf-x0)

;;==Declare an array of image handles
frm = objarr(time.nt)

;;==Create image frames
for it=0,time.nt-1 do $
   frm[it] = image(fdata[x0:xf-1,y0:yf-1,it], $
                   xdata[x0:xf-1],ydata[y0:yf-1], $
                   ;; min_value = -max(abs(fdata[*,*,1:*])), $
                   ;; max_value = +max(abs(fdata[*,*,1:*])), $
                   min_value = -0.2, $
                   max_value = +0.2, $
                   rgb_table = 5, $
                   axis_style = 1, $
                   position = [0.10,0.10,0.80,0.80], $
                   xmajor = 5, $
                   xminor = 1, $
                   ymajor = 5, $
                   yminor = 1, $
                   xstyle = 1, $
                   ystyle = 1, $
                   xsubticklen = 0.5, $
                   ysubticklen = 0.5, $
                   xtickdir = 1, $
                   ytickdir = 1, $
                   xticklen = 0.02, $
                   yticklen = 0.02*data_aspect, $
                   xshowtext = 0, $
                   yshowtext = 0, $
                   font_name = 'Times', $
                   font_size = 18.0, $
                   /buffer)

;;==Add a colorbar to each image
for it=0,time.nt-1 do $
   clr = colorbar(target = frm[it], $
                  title = '$\delta n/n_0$', $
                  major = 5, $
                  minor = 3, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [0.82,0.10,0.84,0.80], $
                  font_size = 12.0, $
                  font_name = 'Times', $
                  hide = 0)

;;==Add a box
for it=0,time.nt-1 do $
   ply = polygon(dx*[nx/2-128,nx/2+128,nx/2+128,nx/2-128], $
                 dy*[ny/2-128,ny/2-128,ny/2+128,ny/2+128], $
                 /data, $
                 target = frm[it], $
                 color = 'white', $
                 fill_background = 0, $
                 linestyle = 0, $
                 thick = 1, $
                 hide = 1)

;;==Add a path label
for it=0,time.nt-1 do $
   txt = text(0.0,0.90, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save individual images
for it=0,time.nt-1 do $
   frame_save, frm[it],filename=filename[it]
