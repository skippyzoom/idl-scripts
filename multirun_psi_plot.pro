;+
; Script for plotting $\Psi_0$ from multiple runs. This script assumes
; that the user has run build_multirun_moments.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare file name
filename = expand_path(plot_path)+path_sep()+'frames'+ $
           path_sep()+ $
           'mr_psi'+ $
           '.'+get_extension(frame_type)

;;==Declare line parameters
color = ['magenta', $
         'blue', $
         'green', $
         'black', $
         'red']
linestyle = make_array(nr,value=0,/integer)
;; color = ['blue', $
;;          'green', $
;;          'red']
;; linestyle = [2,2,2,0,0,0]

;;==Get number of time steps in each run
mr_nt = lonarr(nr)
for ir=0,nr-1 do $
   mr_nt[ir] = n_elements(mr_moments[run[ir]].psi)

;;==Declare x and y data for ease of use
xdata = hash(run)
for ir=0,nr-1 do $
   xdata[run[ir]] = $
   1e3*mr_params[run[ir]].dt*mr_params[run[ir]].nout*findgen(mr_nt[ir])
ydata = hash(run)
for ir=0,nr-1 do $
   ydata[run[ir]] = mr_moments[run[ir]].psi

;;==Loop over runs to create frame
for ir=0,nr-1 do $
   frm = plot(xdata[run[ir]], $
              ydata[run[ir]], $
              color = color[ir], $
              linestyle = linestyle[ir], $
              xstyle = 1, $
              xtitle = 'Time [ms]', $
              ytitle = '$\Psi_0$', $
              yrange = [0,1.1], $
              ymajor = 12, $
              yminor = 3, $
              font_name = 'Times', $
              font_size = 16, $
              overplot = (ir gt 0), $
              /buffer)

;;==Extract bounds of frame y-axis
y0 = frm.yrange[0]
yf = frm.yrange[1]

;;==Create label strings
label = strarr(nr)
for ir=0,nr-1 do $
   label[ir] = string(ydata[run[ir], mr_nt[ir]-1])
label = strcompress(label,/remove_all)

;;==Add text label
for ir=0,nr-1 do $
   txt = text(xdata[run[ir], 0.8*mr_nt[ir]], $
              ydata[run[ir], 0.8*mr_nt[ir]]-0.05*(yf-y0), $
              label[ir], $
              /data, $
              alignment = 0.5, $
              target = frm, $
              color = color[ir], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Add a path label
txt = text(0.0,0.005, $
           proj_path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save the plot
frame_save, frm,filename=filename
