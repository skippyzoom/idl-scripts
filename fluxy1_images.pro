;+
; Script for making frames from a plane of EPPIC fluxy1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'fluxy1'+ $
           '-'+time.index+ $
           '.'+get_extension(frame_type)

;;==Declare image ranges
;; x0 = 3*nx/4-128
;; xf = 3*nx/4+128
;; y0 = ny/2-128
;; yf = ny/2+128
x0 = 0
xf = nx
y0 = 0
yf = ny

;;==Get dimensions of fluxy1
dsize = size(fluxy1)
ndim = dsize[0]
nx = dsize[1]
ny = dsize[2]

;;==Get the number of time steps
nt = n_elements(time.index)

;;==Preserve fluxy1
fdata = fluxy1

;;==Optionally smooth
;; sw = [10.0/dx,10.0/dy]
sw = [1,1]
for isw=n_elements(sw),ndim-1 do $
   sw = [sw,0]
if total(sw) gt ndim then $
   fdata = smooth(fdata,sw,/edge_wrap)

;;==Calculate the height-to-width aspect ratio
data_aspect = float(yf-y0)/(xf-x0)

;;==Declare an array of image handles
frm = objarr(nt)

;;==Create image frames
for it=0,nt-1 do $
   frm[it] = image(fdata[x0:xf-1,y0:yf-1,it], $
                   xdata[x0:xf-1],ydata[y0:yf-1], $
                   ;; min_value = min(fdata[nx/2:*,*,*]), $
                   ;; max_value = max(fdata[nx/2:*,*,*]), $
                   min_value = -6e11, $
                   max_value = +6e11, $
                   rgb_table = 39, $
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
                   xtitle = 'Zonal [m]', $
                   ytitle = 'Vertical [m]', $
                   xticklen = 0.02, $
                   yticklen = 0.02*data_aspect, $
                   xshowtext = 0, $
                   yshowtext = 0, $
                   font_name = 'Times', $
                   font_size = 18.0, $
                   /buffer)

;;==Add a colorbar to each image
for it=0,nt-1 do $
   clr = colorbar(target = frm[it], $
                  title = '$\Gamma_{iy}$', $
                  major = 11, $
                  minor = 1, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [0.82,0.10,0.84,0.80], $
                  font_size = 12.0, $
                  font_name = 'Times', $
                  hide = 0)

;;==Add a box
for it=0,nt-1 do $
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
for it=0,nt-1 do $
   txt = text(0.0,0.005, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save individual images
for it=0,nt-1 do $
   frame_save, frm[it],filename=filename[it]

;;==Clear fdata
fdata = !NULL
