;+
; Script for creating plots of mean Ex taken over y, where the axes
; correspond to a given plane (See Ex_images.pro or Ey_images.pro).
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare file type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare filename
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'efield_x-y_mean-mp'+ $
           '.'+get_extension(frame_type)

;;==Declare data scale
scale = 1e3

;;==Get array dimensions
fsize = size(Ex)
nx = fsize[1]
ny = fsize[2]
nt = fsize[3]

;;==Calculate the mean over y
Ex_ymean = mean(Ex,dim=2)

;;==Create plot objects
for it=0,nt-1 do $
   frm = plot(xdata,scale*Ex_ymean[*,it], $
              xstyle = 1, $
              yrange = [-0.04,+0.04]*scale, $
              xmajor = 5, $
              xminor = 3, $
              ymajor = 9, $
              yminor = 4, $
              xtitle = 'Zonal [m]', $
              ytitle = '$<E_x>_y$ [mV/m]', $
              font_name = 'Times', $
              font_size = 24.0, $
              name = time.stamp[it], $
              linestyle = (it mod 5), $
              overplot = (it gt 0), $
              /buffer)

;;==Add a path label to each plot
txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;; for it=0,nt-1 do $
;;    txt = text(1.0,1.0-0.05*it, $
;;               time.stamp[it], $
;;               alignment = 1.0, $
;;               vertical_alignment = 1.0, $
;;               target = frm, $
;;               font_name = 'Courier', $
;;               font_size = 10.0)

;;==Save individual images
frame_save, frm,filename=filename
