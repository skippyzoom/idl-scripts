;+
; Plot the direction of total ExB. Written for parametric wave runs,
; which have a vertical background field and a variable, mostly zonal,
; wave polarization field.
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'ExB_angle'+ $
           '-right_256'+ $
           '-'+axes+ $
           '.'+get_extension(frame_type)

;;==Declare image ranges
x0 = 3*nx/4-128
xf = 3*nx/4+128
y0 = ny/2-128
yf = ny/2+128
;; x0 = 0
;; xf = nx
;; y0 = 0
;; yf = ny

;;==Preserve data
fdata = Ex

;;==Get dimensions of data
fsize = size(fdata)
ndim = fsize[0]
nx = fsize[1]
ny = fsize[2]

;;==Get the number of time steps
nt = n_elements(time.index)

;;==Create vector of mean values
fdata_mean = fltarr(nt)
for it=0,nt-1 do $
   fdata_mean[it] = mean(Ex[x0:xf-1,y0:yf-1,it])

;;==Create plot
frm = plot(float(time.stamp), $
           atan(pp.Ey0,fdata_mean)/!dtor-90, $
           xstyle = 1, $
           yrange = [0,90], $
           xtitle = 'Time [ms]', $
           ytitle = '$E\timesB_0$ angle [deg]', $
           font_name = 'Times', $
           /buffer)

;;==Add a path label
txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save frame
frame_save, frm,filename=filename
