;+
; Script for plotting $V_d \equiv v_e-v_i$ from multiple runs. This
; script assumes that the user has run build_multirun_moments.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare line colors
color = ['blue', $
         'green', $
         'red']

;;==Get number of time steps in each run
mr_nt = lonarr(nr)
for ir=0,nr-1 do $
   mr_nt[ir] = n_elements(mr_moments[run[ir]].psi)

;;==Build multi-run drift velocity
mr_vd = hash(run)
for ir=0,nr-1 do $
   mr_vd[run[ir]] = build_drift_velocity(mr_moments[run[ir]].dist0, $
                                         mr_moments[run[ir]].dist1, $
                                         mr_params[run[ir]].ndim_space)

;;==Declare x data for convenience
xdata = hash(run)
for ir=0,nr-1 do $
   xdata[run[ir]] = $
   1e3*mr_params[run[ir]].dt*mr_params[run[ir]].nout*findgen(mr_nt[ir])

;;==Prefix existing file-name note with dash
;; if n_elements(filename_note) ne 0 then $
;;    if ~strcmp(strmid(filename_note,0,1),'-') then $
;;       filename_note = '-'+filename_note

;;==Set default file-name note
if n_elements(filename_note) eq 0 then $
   filename_note = ''

;;------------------;;
;; Radial component ;;
;;------------------;;

;;==Declare y data for convenience
ydata = hash(run)
for ir=0,nr-1 do $
   ydata[run[ir]] = mr_vd[run[ir]].r

;;==Find global min and max
ymin = min(ydata[run[0],mr_nt[0]/4:*])
for ir=1,nr-1 do $
   ymin = min([ymin,min(ydata[run[ir],mr_nt[ir]/4:*])])
ymax = max(ydata[run[0],mr_nt[0]/4:*])
for ir=1,nr-1 do $
   ymax = max([ymax,max(ydata[run[ir],mr_nt[ir]/4:*])])

;;==Loop over runs to create frame
for ir=0,nr-1 do $
   frm = plot(xdata[run[ir]], $
              mr_vd[run[ir]].r, $
              color = color[ir], $
              ;; linestyle = linestyle[ir], $
              xstyle = 1, $
              xtitle = 'Time [ms]', $
              ytitle = '$|V_d|$', $
              ;; yrange = [0,300], $
              yrange = [ymin,ymax], $
              font_name = 'Times', $
              font_size = 16, $
              overplot = (ir gt 0), $
              /buffer)

;;==Add a path label
txt = text(0.0,0.005, $
           proj_path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Declare file name
;; filename = expand_path(plot_path)+path_sep()+'frames'+ $
;;            path_sep()+ $
;;            'mr_vdr'+ $
;;            filename_note+ $
;;            '.'+get_extension(frame_type)
filepath = expand_path(plot_path)+path_sep()+'frames'
filename = build_filename('mr_vdr','pdf', $
                          path = filepath, $
                          additions = filename_note)

;;==Save the plot
frame_save, frm,filename=filename

;;---------------------;;
;; Azimuthal component ;;
;;---------------------;;

;;==Declare y data for convenience
ydata = hash(run)
for ir=0,nr-1 do $
   ydata[run[ir]] = mr_vd[run[ir]].t/!dtor

;;==Find global min and max
ymin = min(ydata[run[0],mr_nt[0]/4:*])
for ir=1,nr-1 do $
   ymin = min([ymin,min(ydata[run[ir],mr_nt[ir]/4:*])])
ymax = max(ydata[run[0],mr_nt[0]/4:*])
for ir=1,nr-1 do $
   ymax = max([ymax,max(ydata[run[ir],mr_nt[ir]/4:*])])

;;==Loop over runs to create frame
for ir=0,nr-1 do $
   frm = plot(xdata[run[ir]], $
              mr_vd[run[ir]].t/!dtor, $
              color = color[ir], $
              ;; linestyle = linestyle[ir], $
              xstyle = 1, $
              xtitle = 'Time [ms]', $
              ytitle = '$\theta(V_d)$', $
              ;; yrange = [-30,0], $
              yrange = [ymin,ymax], $
              font_name = 'Times', $
              font_size = 16, $
              overplot = (ir gt 0), $
              /buffer)

;;==Add a path label
txt = text(0.0,0.005, $
           proj_path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Declare file name
;; filename = expand_path(plot_path)+path_sep()+'frames'+ $
;;            path_sep()+ $
;;            'mr_vdt'+ $
;;            filename_note+ $
;;            '.'+get_extension(frame_type)
filepath = expand_path(plot_path)+path_sep()+'frames'
filename = build_filename('mr_vdt','pdf', $
                          path = filepath, $
                          additions = filename_note)

;;==Save the plot
frame_save, frm,filename=filename

;;-----------------;;
;; Polar component ;;
;;-----------------;;

;;==Declare y data for convenience
ydata = hash(run)
for ir=0,nr-1 do $
   ydata[run[ir]] = mr_vd[run[ir]].p/!dtor

;;==Find global min and max
ymin = min(ydata[run[0],mr_nt[0]/4:*])
for ir=1,nr-1 do $
   ymin = min([ymin,min(ydata[run[ir],mr_nt[ir]/4:*])])
ymax = max(ydata[run[0],mr_nt[0]/4:*])
for ir=1,nr-1 do $
   ymax = max([ymax,max(ydata[run[ir],mr_nt[ir]/4:*])])

;;==Loop over runs to create frame
for ir=0,nr-1 do $
   frm = plot(xdata[run[ir]], $
              mr_vd[run[ir]].p/!dtor, $
              color = color[ir], $
              ;; linestyle = linestyle[ir], $
              xstyle = 1, $
              xtitle = 'Time [ms]', $
              ytitle = '$\phi(V_d)$', $
              ;; yrange = [-1,1], $
              yrange = [ymin,ymax], $
              font_name = 'Times', $
              font_size = 16, $
              overplot = (ir gt 0), $
              /buffer)

;;==Add a path label
txt = text(0.0,0.005, $
           proj_path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Declare file name
;; filename = expand_path(plot_path)+path_sep()+'frames'+ $
;;            path_sep()+ $
;;            'mr_vdp'+ $
;;            filename_note+ $
;;            '.'+get_extension(frame_type)
filepath = expand_path(plot_path)+path_sep()+'frames'
filename = build_filename('mr_vdp','pdf', $
                          path = filepath, $
                          additions = filename_note)

;;==Save the plot
frame_save, frm,filename=filename

