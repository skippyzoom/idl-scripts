;+
; Script for creating plots of mean den1 and Ex taken over y, in the
; style of Ex_ymean_plots.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare file type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare filename
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den1-efield_x-y_mean'+ $
           ;; '-shift'+ $
           '-'+time.index+ $           
           '.'+get_extension(frame_type)

;;==Get number of time steps
nt = n_elements(time.index)

;;==Calculate the mean of den1 over y
den1_ymean = mean(den1,dim=2)

;;==Calculate the mean of Ex over y
Ex_ymean = mean(Ex,dim=2)

;;==Set up object array for plot handles
frm = objarr(nt)

;;==Create plot objects
for it=0,nt-1 do $
   frm[it] = plot(xdata, $
                  Ex_ymean[*,it]/max(abs(Ex_ymean[*,it])), $
                  xstyle = 1, $
                  yrange = [-1,1], $
                  xmajor = 5, $
                  xminor = 3, $
                  ;; xtitle = '', $
                  ;; ytitle = '', $
                  font_name = 'Times', $
                  font_size = 24.0, $
                  /buffer)
for it=0,nt-1 do $
   !NULL = plot(xdata, $
                den1_ymean[*,it]/max(abs(den1_ymean[*,it])), $
                xmajor = 5, $
                xminor = 3, $
                ;; xtitle = '', $
                ;; ytitle = '', $
                color = 'blue', $
                overplot = frm[it], $
                /buffer)

;;==Add a path label to each plot
for it=0,nt-1 do $
   txt = text(0.0,0.005, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save individual images
for it=0,nt-1 do $
   frame_save, frm[it],filename=filename[it]
