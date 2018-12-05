;+
; Script for making a plot of den1ktt_rms and rcm_theta.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den1ktt_rms_theta',frame_type, $
                          path = filepath, $
                          additions = axes)

;;==Set some graphics parameters
xmajor = params.ndim_space eq 2 ? 5 : 6
xminor = params.ndim_space eq 2 ? 4 : 3
xtickvalues = params.ndim_space eq 2 ? $
              [0,100,200,300,400] : [0,20,40,60,80,100]
trange = [-30,0]
;; drange = params.ndim_space eq 2 ? [0,2e4] : [0,1e2]
drange = [0,1]

;;==Create plot
plt_data = rcm_theta/!dtor
frm = plot(float(time.stamp), $
           plt_data, $
           axis_style = 1, $
           xstyle = 1, $
           position = [0.2,0.2,0.8,0.8], $
           xtitle = 'Time [ms]', $
           ytitle = '$\langle\theta\rangle$ [deg.]', $
           yrange = trange, $
           ystyle = 0, $
           xmajor = xmajor, $
           xminor = xminor, $
           xtickvalues = xtickvalues, $
           xtickfont_size = 16.0, $
           ytickfont_size = 16.0, $
           font_name = 'Times', $
           font_size = 16.0, $
           /buffer)           
yrange = frm.yrange
;; opl_data = (den1ktt_rms[0]/den1ktt_rms[0,0])
opl_data = den1ktt_rms[0]/max(den1ktt_rms[0]) - min(den1ktt_rms[0])
axis_const = drange[1]-drange[0]
axis_scale = (drange[1]-drange[0])/(yrange[1]-yrange[0])
opl = plot(float(time.stamp), $
           (opl_data-axis_const)/axis_scale, $
           linestyle = 1, $
           overplot = frm)
yax = axis('y', $
           target = opl, $
           location = 'right', $
           color = 'black', $
           title = 'Norm. $\langle P(\delta n)\rangle$', $
           coord_transform = [axis_const, $
                              axis_scale], $
           ;; axis_range = drange, $
           tickfont_name = 'Times', $
           tickfont_size = 16.0)

;;==Add a path label
txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save plot
frame_save, frm,filename=filename
