;+
; Script for making a movie of interpolated den1 FFT data. See den1_ktt_calc.pro.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-
plot_kw = dictionary()
plot_kw['xstyle'] = 1
plot_kw['title'] = "it = "+time.index
if keyword_set(to_dB) then plot_kw['yrange'] = [-30,0]
plot_kw['font_name'] = 'Times'
plot_kw['font_size'] = 18
plot_kw['xtitle'] = 'Angle from Zenith [deg.]'
plot_kw['ytitle'] = 'Power [dB]'

filebase = expand_path(path+path_sep()+'movies')+ $
           path_sep()+'den1-rms_xy2kt'
xy2kt_movie, xy2kt, $
             /data_isdB, $
             plot_kw = plot_kw, $
             filebase = filebase, $
             filetype = '.mp4'

