;+
; Script for creating a movie of mean Ex taken over y, where the axes
; correspond to a given plane (See Ex_images.pro or Ey_images.pro).
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default file type
if n_elements(movie_type) eq 0 then movie_type = '.mp4'

;;==Declare file name
filename = expand_path(path+path_sep()+'movies')+ $
           path_sep()+'efield_x-y_mean'+ $
           '.'+get_extension(movie_type)

;;==Declare data scale
scale = 1e3

;;==Load graphics keywords for Ex
plot_kw = dictionary()
plot_kw['xstyle'] = 1
plot_kw['yrange'] = [-0.03,+0.03]*scale
plot_kw['color'] = 'black'
;; plot_kw['xtitle'] = 'Zonal [m]'
;; plot_kw['ytitle'] = '${\langle E_x \rangle}_y$ [mV/m]'
plot_kw['font_name'] = 'Times'
;; plot_kw['title'] = 'it = '+time.index
plot_kw['title'] = 't = '+time.stamp
plot_kw['thick'] = 2
plot_kw['dimensions'] = [1024,1024]
;; plot_kw['position'] = [0.2,0.2,0.8,0.8]
plot_kw['axis_style'] = 2
;; plot_kw['font_size'] = 12.0
;; plot_kw['xshowtext'] = 1
;; plot_kw['yshowtext'] = 1

;;==Calculate the mean over y
Ex_ymean = mean(Ex,dim=2)

;;==Create movie
data_graphics, xdata,scale*Ex_ymean, $
               /make_movie, $
               plot_kw = plot_kw, $
               filename = filename
