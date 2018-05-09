;+
; Script for creating a movie of mean Ex taken over y, where the axes
; correspond to a given plane (See Ex_images.pro or Ey_images.pro).
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare frame type
if n_elements(movie_type) eq 0 then movie_type = '.mp4'

;;==Declare data scale
scale = 1e3

;;==Load graphics keywords for Ex
plot_kw = dictionary()
plot_kw['xstyle'] = 1
plot_kw['yrange'] = [-0.03,+0.03]*scale
plot_kw['color'] = 'black'
plot_kw['xtitle'] = 'Zonal [m]'
plot_kw['ytitle'] = '${\langle E_x \rangle}_y$ [mV/m]'
plot_kw['font_name'] = 'Times'
plot_kw['title'] = 'it = '+time.index
plot_kw['font_size'] = 24.0

;;==Calculate the mean over y
Ex_ymean = mean(Ex,dim=2)

;;==Create movie
filename = expand_path(path+path_sep()+'movies')+ $
           path_sep()+'efield_x-y_mean'+ $
           '.'+get_extension(movie_type)
data_graphics, xdata,scale*Ex_ymean, $
               /make_movie, $
               plot_kw = plot_kw, $
               filename = filename
