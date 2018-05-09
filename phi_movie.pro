;+
; Script for making movies from a plane of EPPIC phi data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare file type
if n_elements(movie_type) eq 0 then movie_type = '.mp4'

;;==Add a description to the file name
;;  (e.g., 'full', 'center512', 'right_half' to distinguish different
;;  sets of ranges)
file_description = 'full'

;;==Declare graphics ranges
x0 = 0
xf = nx
y0 = 0
yf = ny

;;==Load graphics keywords for phi
@default_image_kw
dsize = size(phi)
nx = dsize[1]
ny = dsize[2]
data_aspect = float(yf-y0)/(xf-x0)
image_kw['min_value'] = -max(abs(phi[*,*,1:*]))
image_kw['max_value'] = +max(abs(phi[*,*,1:*]))
ct = get_custom_ct(1)
image_kw['rgb_table'] = [[ct.r],[ct.g],[ct.b]]
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
colorbar_kw['title'] = '$\phi$ [V]'
colorbar_kw['font_size'] = 18
colorbar_kw['font_name'] = 'Times'
colorbar_kw['major'] = 5

;;==Create movie
filename = expand_path(path+path_sep()+'movies'+ $
           path_sep()+'phi')+ $
           '.'+get_extension(movie_type)
data_graphics, phi[x0:xf-1,y0:yf-1,*], $
               xdata[x0:xf-1],ydata[y0:yf-1], $
               /make_movie, $
               filename = filename, $
               image_kw = image_kw, $
               colorbar_kw = colorbar_kw
