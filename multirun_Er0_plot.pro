;+
; Script for plotting Er0 from multiple runs. See multirun_Ert0_main.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default plot type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name
filename = expand_path(plot_path)+path_sep()+ $
           'frames'+path_sep()+ $
           'Er0-init_multi'+ $
           '.'+get_extension(frame_type)

;;==Declare the array index of the "initial" time step
it0 = 1

;;==Get keys
keys = Er0_hash.keys()

;;==Get number of plots
np = Er0_hash.count()

;;==Plot Er0 from each run
for ip=0,np-1 do $
   frm = plot(xdata,mean(Er0_hash[keys[ip],*,*,it0],dim=2)*1e3, $
              xstyle = 1, $
              xtitle = 'Zonal Distance [m]', $
              ystyle = 1, $
              yrange = [0,40], $
              ytitle = '$|E_{total}|$ [mV/m]', $
              xmajor = 5, $
              xminor = 3, $
              ymajor = 5, $
              yminor = 9, $
              color = color[keys[ip]], $
              linestyle = linestyle[keys[ip]], $
              font_name = 'Times', $
              font_size = 14, $
              overplot = (ip gt 0), $
              /buffer)

;;==Save the plot
frame_save, frm,filename=filename
