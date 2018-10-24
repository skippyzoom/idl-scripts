;+
; Script for making a plot of summed theta-RMS den1(k,theta,t) from
; multiple directories. This script assumes that the user has run
; build_multirun_den1ktt_rms.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare line colors
color = ['blue', $
         'green', $
         'red']

;;==Declare line styles
linestyle = [1,0, $
             1,0, $
             1,0]

;;==Declare reference vector of time steps
timesteps = float(time.stamp)
max_nt = n_elements(timesteps)

;;==Declare initial step
it0 = params.ndim_space eq 2 ? 4 : 16

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Set default file-name note
if n_elements(filename_note) eq 0 then $
   filename_note = ''

;;==Declare plot file name
filepath = expand_path(plot_path)+path_sep()+'frames'
filename = build_filename('mr_den1ktt','pdf', $
                          path = filepath, $
                          additions = ['meter_and_decameter', $
                                       'all_theta', $
                                       'it0_10', $
                                       filename_note])

;;==Find maximum initial value across all sets and runs
max_it0 = 0.0
for is=0,ns-1 do $
   for ir=0,nr-1 do $
      max_it0 = max([max_it0,(mr_kttrms[is])[run[ir],it0]])

;;==Find maximum value of each set and run
max_val = make_array(ns,nr,value=0,/float)
for is=0,ns-1 do $
   for ir=0,nr-1 do $
      max_val[is,ir] = max((mr_kttrms[is])[run[ir]])

;;==Preset some graphical parameters
xmajor = 5
;; xtickvalues = timesteps[max_nt-1]*findgen(xmajor)/(xmajor-1)
xtickvalues = 100*findgen(xmajor)/(xmajor-1)
if params.ndim_space eq 2 then xtickvalues *= 4
xtickname = string(xtickvalues,format='(f6.2)')
xtickname = strcompress(xtickname,/remove_all)

;;==Create plot frame
for is=0,ns-1 do $
   for ir=0,nr-1 do $
      frm = plot(timesteps[0:mr_nt[ir]-1], $
                 ;; (mr_kttrms[is])[run[ir],it0:*]/ $
                 ;; (mr_kttrms[is])[run[ir],it0], $
                 (mr_kttrms[is])[run[ir]]/ $
                 (mr_kttrms[is])[run[ir],it0], $
                 ;; (mr_kttrms[is])[run[ir],it0:*]/max_it0, $
                 ;; (mr_kttrms[is])[run[ir],it0:*]/max_val[is,ir], $
                 axis_style = 2, $
                 xstyle = 1, $
                 position = [0.2,0.2,0.8,0.8], $
                 xtitle = 'Time [ms]', $
                 ytitle = '$\langle P(\delta n)\rangle/P(n_I)$', $
                 /ylog, $
                 ;; yrange = [1e0,1e3], $
                 yrange = [1e0,1e1], $
                 ystyle = 0, $
                 color = color[ir], $
                 ;; linestyle = linestyle[ir], $
                 linestyle = is, $
                 ;; xmajor = xmajor, $
                 ;; xtickvalues = xtickvalues, $
                 ;; xtickname = xtickname, $
                 xmajor = 6, $
                 xminor = 3, $
                 xtickvalues = [20,40,60,80,100], $
                 xtickfont_size = 16.0, $
                 ytickfont_size = 16.0, $
                 xticklen = 0.04, $
                 yticklen = 0.02, $
                 font_name = 'Times', $
                 font_size = 16.0, $
                 overplot = (ir+is gt 0), $
                 /buffer)

;;==Extract y-axis range
yrange = frm[0].yrange

;;==Add wavelength labels
for is=0,ns-1 do $
   txt = text(0.0,0.90-is*0.03, $
              '$\lambda$ = ['+ $
              string(lam_lo[is],format='(f06.2)')+' m, '+ $
              string(lam_hi[is],format='(f06.2)')+' m]'+ $
              ' (linestyle ='+strcompress(is)+')', $
              target = frm, $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Add a path label
txt = text(0.0,0.005, $
           proj_path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Add save-file label
txt = text(0.0,0.955, $
           'original file: '+den1ktt_save_name, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Declare default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare default plot path
if n_elements(plot_path) eq 0 then plot_path = expand_path(proj_path)

;;==Set default file name
if n_elements(filename) eq 0 then $
   filename = expand_path(plot_path)+path_sep()+'frames'+ $
              path_sep()+ $
              strip_extension(den1ktt_save_name)+ $
              '.'+get_extension(frame_type)

;;==Save plot
frame_save, frm,filename=filename

