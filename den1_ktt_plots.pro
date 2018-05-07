;+
; Script for plotting interpolated den1 FFT data. See den1_ktt_calc.pro.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare file type
frame_type = '.pdf'

;;==Load graphics keywords for interpolated FFT plots
plot_kw = dictionary()
plot_kw['xstyle'] = 1
plot_kw['title'] = "t = "+time.stamp
if keyword_set(to_dB) then plot_kw['yrange'] = [-30,0]
plot_kw['font_name'] = 'Times'
plot_kw['font_size'] = 18
plot_kw['xtitle'] = 'Angle from Zenith [deg.]'
plot_kw['ytitle'] = 'Power [dB]'

;;==Set up file name(s)
if n_elements(file_description) eq 0 then $
   file_description = ''
if keyword_set(rms_range) then $
   filebase = expand_path(path+path_sep()+'frames')+ $
              path_sep()+'den1-xy2kt'+ $
              '-'+file_description+ $
              '-rms_'+ $
              string(params.nout*rms_range[0,*],format='(i06)')+ $
              '_'+ $
              string(params.nout*rms_range[1,*],format='(i06)') $
else $
   filebase = expand_path(path+path_sep()+'frames')+ $
              path_sep()+'den1-xy2kt'+ $
              '-'+file_description+ $
              '-'+time.index
xy2kt_plots, xy2kt, $
             data_isdB = to_dB, $
             plot_kw = plot_kw, $
             filebase = filebase, $
             filetype = frame_type
