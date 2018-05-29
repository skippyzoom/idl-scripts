;+
; Script for making movies of interpolated den1 FFT data. See
; calc_den1ktt.pro
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare file type
if n_elements(movie_type) eq 0 then movie_type = '.mp4'

;;==Load graphics keywords for interpolated FFT plots
plot_kw = dictionary()
plot_kw['xstyle'] = 1
plot_kw['title'] = "t = "+time.stamp
plot_kw['yrange'] = [-30,0]
plot_kw['font_name'] = 'Times'
plot_kw['font_size'] = 18
plot_kw['xtitle'] = 'Angle from Zenith [deg.]'
plot_kw['ytitle'] = 'Power [dB]'

;;-->DEV
;;==Hardcode wavelength
l_want = '003.00'
;;<--

;;==Preserve den1ktt
xdata = den1ktt[l_want].t_interp
fdata = den1ktt[l_want].f_interp

;;==Condition data
xdata /= !dtor
fdata = 10*alog10(fdata^2)
fdata -= max(fdata)

;;==Set up file name
filename = expand_path(path+path_sep()+'movies')+ $
           path_sep()+'den1ktt'+ $
           '-'+l_want+'m'+ $
           '.'+get_extension(movie_type)

;;==Make movie
data_graphics, xdata, $
               fdata, $
               plot_kw = plot_kw, $
               filename = filename, $
               /make_movie
