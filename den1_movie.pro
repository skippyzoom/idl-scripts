;+
; Script for making movies from a plane of EPPIC den1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default movie type
if n_elements(movie_type) eq 0 then movie_type = '.mp4'

;;==Declare file name
filename = expand_path(path+path_sep()+'movies')+ $
           path_sep()+'den1'+ $
           '-'+axes+ $
           ;; '-filtered'+ $
           ;; '-full_shift'+ $
           ;; '-from_denft1'+ $
           ;; '-reset_TEST'+ $
           '.'+get_extension(movie_type)

fdata = den1

;;==Declare graphics ranges wrt current plane
;; x0 = nx/4-128
;; xf = nx/4+128
;; y0 = ny/4-128
;; yf = ny/4+128
x0 = 0
xf = nx
y0 = 0
yf = ny

;;==Load graphics keywords for den1
;; @default_image_kw
img_pos = [0.10,0.10,0.80,0.80]
clr_pos = [0.82,0.10,0.84,0.80]

image_kw = dictionary('axis_style', 1, $
                      'position', img_pos, $
                      'xmajor', 5, $
                      'xminor', 1, $
                      'ymajor', 5, $
                      'yminor', 1, $
                      'xstyle', 1, $
                      'ystyle', 1, $
                      'xsubticklen', 0.5, $
                      'ysubticklen', 0.5, $
                      'xtickdir', 1, $
                      'ytickdir', 1, $
                      'font_name', 'Times')
colorbar_kw = dictionary('orientation', 1, $
                         'textpos', 1, $
                         'font_name', 'Times', $
                         'position', clr_pos)
text_kw = dictionary('font_name', 'Times', $
                     'font_size', 24, $
                     'font_color', 'black', $
                     'normal', 1B, $
                     'alignment', 0.0, $
                     'vertical_alignment', 0.0, $
                     'fill_background', 1B, $
                     'fill_color', 'white')
dsize = size(fdata)
nx = dsize[1]
ny = dsize[2]
data_aspect = float(yf-y0)/(xf-x0)
;; image_kw['min_value'] = -max(abs(fdata[x0:xf-1,y0:yf-1,1:*]))
;; image_kw['max_value'] = +max(abs(fdata[x0:xf-1,y0:yf-1,1:*]))
image_kw['min_value'] = -0.2
image_kw['max_value'] = +0.2
image_kw['axis_style'] = 2
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
;; image_kw['dimensions'] = [1024,256]
;; image_kw['image_dimensions'] = [1024,256]
image_kw['dimensions'] = [512,512]
image_kw['image_dimensions'] = [512,512]
colorbar_kw['title'] = '$\delta n/n_0$'
colorbar_kw['font_size'] = 18
colorbar_kw['font_name'] = 'Times'
colorbar_kw['major'] = 5
;; text_string = path
;; text_xyz = [0.0,0.995]
;; text_kw = dictionary('font_name', 'Courier', $
;;                      'font_size', 10)

;;==Create movie
data_graphics, fdata[x0:xf-1,y0:yf-1,*], $
               xdata[x0:xf-1],ydata[y0:yf-1], $
               /make_movie, $
               filename = filename, $
               image_kw = image_kw, $
               colorbar_kw = colorbar_kw, $
               text_string = text_string, $
               text_xyz = text_xyz, $
               text_kw = text_kw
