;+
; Script for making movies from a plane of EPPIC den1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare file type
if n_elements(movie_type) eq 0 then movie_type = '.mp4'

;;==Add a description to the file name
;;  (e.g., 'full', 'center512', 'right_half' to distinguish different
;;  sets of ranges)
file_description = 'center512'

;;==Declare graphics ranges wrt current plane
x0 = nx/2-256
xf = nx/2+256
y0 = ny/2-256
yf = ny/2+256

;;==Load graphics keywords for den1
@default_image_kw
dsize = size(den1)
nx = dsize[1]
ny = dsize[2]
data_aspect = float(yf-y0)/(xf-x0)
image_kw['min_value'] = -max(abs(den1[x0:xf-1,y0:yf-1,1:*]))
image_kw['max_value'] = +max(abs(den1[x0:xf-1,y0:yf-1,1:*]))
image_kw['rgb_table'] = 5
image_kw['xtitle'] = 'Zonal [m]'
image_kw['ytitle'] = 'Vertical [m]'
image_kw['xticklen'] = 0.02
image_kw['yticklen'] = 0.02*data_aspect
image_kw['title'] = 'it = '+time.index
image_kw['xmajor'] = 5
image_kw['xminor'] = 3
image_kw['ymajor'] = 5
image_kw['yminor'] = 3
image_kw['font_size'] = 18
image_kw['font_name'] = 'Times'
colorbar_kw['title'] = '$\delta n/n_0$'
colorbar_kw['font_size'] = 18
colorbar_kw['font_name'] = 'Times'
colorbar_kw['major'] = 5

;;==Create movie
if n_elements(file_description) eq 0 then $
   file_description = ''
filename = expand_path(path+path_sep()+'movies')+ $
           path_sep()+'den1'+ $
           '-'+file_description+ $
           '.'+get_extension(movie_type)
data_graphics, den1[x0:xf-1,y0:yf-1,*], $
               xdata[x0:xf-1],ydata[y0:yf-1], $
               /make_movie, $
               filename = filename, $
               image_kw = image_kw, $
               colorbar_kw = colorbar_kw
