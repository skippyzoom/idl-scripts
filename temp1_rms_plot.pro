;+
; Script for making plots of RMS temperature as a function of time
; from EPPIC data. 
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'temp1_rms'+ $
           '-'+axes+ $
           '-right_256'+ $
           '.'+get_extension(frame_type)

;;==Declare spatial RMS ranges
x0 = 3*nx/4-128
xf = 3*nx/4+128
y0 = ny/2-128
yf = ny/2+128
;; x0 = 0
;; xf = nx
;; y0 = 0
;; yf = ny

;;==Get the number of time steps
nt = n_elements(time.index)

;;==Preserve temp1
fdata = temp1

;;==Set up RMS vector
rms_fdata = fltarr(nt)

;;==Calculate spatial RMS
for it=0,nt-1 do rms_fdata[it] = rms(fdata[x0:xf-1,y0:yf-1,it])

;;==Create frame
frm = plot(float(time.stamp), $
           rms_fdata, $
           xstyle = 1, $
           yrange = [600,700], $
           xtitle = 'Time [ms]', $
           ytitle = 'Temperature [K]', $
           font_name = 'Times', $
           /buffer)

;;==Add a path label
txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save individual images
frame_save, frm,filename=filename

;;==Clear fdata
fdata = !NULL

