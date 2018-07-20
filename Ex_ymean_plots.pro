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
           path_sep()+'efield_x-y_mean'+ $
           ;; '-shift'+ $
           '-'+time.index+ $           
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

;;==Set up object array for plot handles
frm = objarr(nt)

;;==Set up color array
loadct, 42,rgb_table=rgb_table
clr = 256*indgen(nt)/(nt-1)
color = rgb_table[clr,*]

;;==Create plot objects
for it=0,nt-1 do $
   frm[it] = plot(xdata,scale*Ex_ymean[*,it], $
                  xstyle = 1, $
                  yrange = [-0.03,+0.03]*scale, $
                  xmajor = 5, $
                  xminor = 3, $
                  xtitle = 'Zonal [m]', $
                  ytitle = '$<E_x>_y$ [mV/m]', $
                  font_name = 'Times', $
                  font_size = 24.0, $
                  ;; color = transpose(color[it,*]), $
                  name = time.stamp[it], $
                  ;; overplot = (it gt 0), $
                  /buffer)

;;==Add a path label to each plot
for it=0,nt-1 do $
   txt = text(0.0,0.005, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)

;; tmp = frm[0]
;; leg = legend(target = frm, $
;;              /auto_text_color, $
;;              position = [0.5*(tmp.xrange[1]-tmp.xrange[0]), $
;;                          tmp.yrange[1]], $
;;              /data, $
;;              vertical_alignment = 'top', $
;;              horizontal_alignment = 'center')

;;==Save individual images
for it=0,nt-1 do $
   frame_save, frm[it],filename=filename[it]
