;+
; Script for plotting hashes for multirun_Ert0_main, wrapped by
; nx/2. This is useful for showing the initialy asymmetry in Er in the
; parametric_wave project.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default plot type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare the file name
filename = expand_path(plot_path)+path_sep()+ $
           'frames'+path_sep()+ $
           'Er0-init_multi_wrap'+ $
           '.pdf'

;;==Declare the array index of the "initial" time step
it0 = 1

;;==Get keys
keys = Er0_hash.keys()

;;==Get number of plots
np = Er0_hash.count()

;;==Set up position array
position = multi_position([1,np], $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffers = [0.0,0.1])

;;==Plot Er0 from each run
frm = objarr(np)
for ip=0,np-1 do $
   frm[ip] = plot(xdata[0:nx/2-1], $
                  (shift(mean(Er0_hash[keys[ip],*,*,it0],dim=2),-nx/4))[0:nx/2-1]*1e3- $
                  (shift(mean(Er0_hash[keys[ip],*,*,it0],dim=2),-nx/4))[nx/2:*]*1e3, $
                  xstyle = 1, $
                  xtitle = 'Zonal Distance mod nx/2 [m]', $
                  xmajor = 3, $
                  xminor = 3, $
                  xtickfont_size = 8, $
                  ystyle = 1, $
                  ytitle = '$\Delta|E_{total}|$ [mV/m]', $
                  ymajor = 5, $
                  yminor = 0, $
                  ;; yrange = [-2,+2], $
                  ytickfont_size = 8, $
                  xshowtext = 0, $
                  linestyle = 0, $
                  title = keys[ip], $
                  font_name = 'Times', $
                  font_size = 10, $
                  position = position[*,ip], $
                  current = (ip gt 0), $
                  /buffer)

;;==Adjust y-axis range
max_abs = fltarr(np)
for ip=0,np-1 do $
   max_abs[ip] = max(abs(frm[ip].yrange))
for ip=0,np-1 do $
   frm[ip].yrange = [-max_abs[ip],+max_abs[ip]]

;;==Save the plot
frame_save, frm,filename=filename
