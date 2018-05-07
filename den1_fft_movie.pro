;+
; Script for making a movie from the FFT of a plane of EPPIC den1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;                                   **NOTES**
; -- Passing x and y vectors (e.g., xdata and ydata) to image() via
;    data_graphics.pro appears to slow down image() to the point that
;    making a movie of a long run can take prohibitively long.
;-
;;==Declare file type
movie_type = '.mp4'

;;==Add a description to the file name
;;  (e.g., 'full', 'center512', 'right_half' to distinguish different
;;  sets of ranges)
file_description = 'center512'

;;==Declare image ranges
x0 = nx/2-256
xf = nx/2+256
y0 = ny/2-256
yf = ny/2+256

;;==Load graphics keywords for FFT images
@default_image_kw
dsize = size(fdata)
nx = dsize[1]
ny = dsize[2]
data_aspect = float(ny)/nx
image_kw['min_value'] = -50
image_kw['max_value'] = -20
image_kw['rgb_table'] = 39
image_kw['xtitle'] = '$k_{Zon}$ [m$^{-1}$]'
image_kw['ytitle'] = '$k_{Ver}$ [m$^{-1}$]'
image_kw['xticklen'] = 0.02
image_kw['yticklen'] = 0.02
image_kw['xmajor'] = 5
image_kw['xminor'] = 3
image_kw['ymajor'] = 5
image_kw['yminor'] = 3
image_kw['xtickname'] = ['$-\pi$','$-\pi/2$','0','$+\pi$','$+\pi/2$']
image_kw['ytickname'] = ['$-\pi$','$-\pi/2$','0','$+\pi$','$+\pi/2$']
image_kw['font_size'] = 18
image_kw['font_name'] = 'Times'
image_kw['dimensions'] = [2000,2000]
max_dim = max([dx*nx,dy*ny])
image_kw['image_dimensions'] = [max_dim,max_dim]
image_kw['title'] = 'it = '+time.index
colorbar_kw['title'] = 'Power [dB]'
colorbar_kw['font_size'] = 18
colorbar_kw['font_name'] = 'Times'
colorbar_kw['major'] = 7

;;==Create image movie of den1 spatial FFT
filename = expand_path(path+path_sep()+'movies')+ $
           path_sep()+'den1_fft'+ $
           '.'+get_extension(movie_type)
data_graphics, fdata, $
               /make_movie, $
               filename = filename, $
               image_kw = image_kw, $
               colorbar_kw = colorbar_kw
