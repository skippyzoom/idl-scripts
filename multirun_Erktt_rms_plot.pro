;+
; Script for making a plot of summed theta-RMS Er(k,theta,t) from
; multiple directories. This script assumes that the user has run
; multirun_Erktt_main.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare plot file name
filename = expand_path(plot_path)+path_sep()+'frames'+ $
           path_sep()+ $
           strip_extension(save_name)+ $
           '-TEST2'+ $
           '.'+get_extension(frame_type)

;;==Declare index of parameter hash
iph = 2

;;==Get common parameters from one hash
path = expand_path(proj_path)+path_sep()+run[iph]
params = set_eppic_params(path=path)
s_obj = obj_new('IDL_Savefile',expand_path(path)+path_sep()+save_name)
s_obj->restore, 'time'

;;==Declare line colors
color = ['magenta','magenta', $
         'blue','blue', $
         'green','green', $
         'black','black', $
         'red','red']

;;==Declare line styles
linestyle = [1,0, $
             1,0, $
             1,0, $
             1,0, $
             1,0]

;;==Get number of time steps in each run
mr_nt = lonarr(nr)
for ir=0,nr-1 do $
   mr_nt[ir] = n_elements(mr_kttrms[run[ir]])

;;==Declare reference vector of time steps
timesteps = float(time.stamp)

;;==Create plot frame
for ir=0,nr-1 do $
   frm = plot(timesteps[0:mr_nt[ir]-1], $
              mr_kttrms[run[ir],1:*]/mr_kttrms[run[ir],1], $
              xstyle = 1, $
              xtitle = 'Time [ms]', $
              ytitle = '$\langle P(\delta E)\rangle/P(E_0)$', $
              yrange = [0,4], $
              ystyle = 0, $
              color = color[ir], $
              linestyle = linestyle[ir], $
              xtickfont_size = 16.0, $
              ytickfont_size = 16.0, $
              font_name = 'Times', $
              font_size = 16.0, $
              overplot = (ir gt 0), $
              /buffer)

;;==Extract y-axis range
yrange = frm[0].yrange

;;==Add time markers corresponding to images
;; image_times = [2048,4096,24576]
;; nit = n_elements(image_times)
;; for it=0,nit-1 do $
;;    frm = plot([image_times[it],image_times[it]], $
;;               [yrange[0],yrange[1]], $
;;               color = 'black', $
;;               linestyle = 2, $
;;               /overplot)

;;==Add a path label
txt = text(0.0,0.005, $
           plot_path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save plot
frame_save, frm,filename=filename

