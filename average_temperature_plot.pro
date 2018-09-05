if n_elements(frame_type) eq 0 then frame_type = '.pdf'

filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'T0_T1-avg'+ $
           '.'+get_extension(frame_type)
T_min = min([moments.dist0.Tx, $
             moments.dist0.Ty, $
             moments.dist0.Tz, $
             moments.dist1.Tx, $
             moments.dist1.Ty, $
             moments.dist1.Tz])
T_max = max([moments.dist0.Tx, $
             moments.dist0.Ty, $
             moments.dist0.Tz, $
             moments.dist1.Tx, $
             moments.dist1.Ty, $
             moments.dist1.Tz])
full_time = findgen(params.nt_max)*params.dt*params.nout
frm = plot(full_time*1e3, $
           moments.dist0.Tx, $
           ;; yrange = [T_min,T_max], $
           ;; yrange = [200,800], $
           yrange = [200,300], $
           xstyle = 1, $
           color = 'blue', $
           linestyle = 0, $
           name = '$T_{ex}$', $
           /buffer)
!NULL = plot(full_time*1e3, $
             moments.dist0.Ty, $
             color = 'red', $
             linestyle = 0, $
             name = '$T_{ey}$', $
             /overplot)
!NULL = plot(full_time*1e3, $
             moments.dist0.Tz, $
             color = 'green', $
             linestyle = 0, $
             name = '$T_{ez}$', $
             /overplot)
!NULL = plot(full_time*1e3, $
             moments.dist1.Tx, $
             color = 'blue', $
             linestyle = 1, $
             name = '$T_{ix}$', $
             /overplot)
!NULL = plot(full_time*1e3, $
             moments.dist1.Ty, $
             color = 'red', $
             linestyle = 1, $
             name = '$T_{iy}$', $
             /overplot)
!NULL = plot(full_time*1e3, $
             moments.dist1.Tz, $
             color = 'green', $
             linestyle = 1, $
             name = '$T_{iz}$', $
             /overplot)
leg = legend()
txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)
frame_save, frm,filename = filename
