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
           '-full_shift'+ $
           '.'+get_extension(movie_type)

;;==Declare data scale
scale = 1e3

;;==Declare time range
t0 = 0
tf = time.nt

;;==Load graphics keywords for Ex
plot_kw = dictionary()
plot_kw['xstyle'] = 1
plot_kw['yrange'] = [-0.03,+0.03]*scale
plot_kw['xmajor'] = 5
plot_kw['xminor'] = 3
plot_kw['color'] = 'black'
;; plot_kw['xtitle'] = 'Zonal [m]'
;; plot_kw['ytitle'] = '${\langle E_x \rangle}_y$ [mV/m]'
plot_kw['font_name'] = 'Times'
;; plot_kw['title'] = 'it = '+time.index
plot_kw['title'] = 't = '+time.stamp[t0:tf-1]
plot_kw['thick'] = 2
plot_kw['dimensions'] = [1024,1024]
;; plot_kw['position'] = [0.2,0.2,0.8,0.8]
plot_kw['axis_style'] = 2
plot_kw['font_size'] = 24
plot_kw['xshowtext'] = 0
plot_kw['yshowtext'] = 0

;;==Calculate the mean over y
Ex_ymean = mean(Ex[*,*,t0:tf-1],dim=2)

;;==Create movie
data_graphics, xdata,scale*Ex_ymean, $
               /make_movie, $
               plot_kw = plot_kw, $
               filename = filename
