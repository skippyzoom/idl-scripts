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

name = (params.ndim_space eq 2) ? '$T_{eH}$' : '$T_{e\parallel}$'
color = (params.ndim_space eq 2) ? 'blue' : 'green'
frm = plot(full_time*1e3, $
           moments.dist0.Tx, $
           ;; yrange = [T_min,T_max], $
           yrange = [200,800], $
           ;; yrange = [200,300], $
           xstyle = 1, $
           color = color, $
           linestyle = 0, $
           name = name, $
           /buffer)
name = '$T_{eP}$'
color = 'red'
!NULL = plot(full_time*1e3, $
             moments.dist0.Ty, $
             color = color, $
             linestyle = 0, $
             name = name, $
             /overplot)
name = (params.ndim_space eq 2) ? '$T_{e\parallel}$' : '$T_{eH}$'
color = (params.ndim_space eq 2) ? 'green' : 'blue'
!NULL = plot(full_time*1e3, $
             moments.dist0.Tz, $
             color = color, $
             linestyle = 0, $
             name = name, $
             /overplot)
name = (params.ndim_space eq 2) ? '$T_{iH}$' : '$T_{i\parallel}$'
color = (params.ndim_space eq 2) ? 'blue' : 'green'
!NULL = plot(full_time*1e3, $
             moments.dist1.Tx, $
             color = color, $
             linestyle = 1, $
             name = name, $
             /overplot)
name = '$T_{iP}$'
color = 'red'
!NULL = plot(full_time*1e3, $
             moments.dist1.Ty, $
             color = color, $
             linestyle = 1, $
             name = name, $
             /overplot)
name = (params.ndim_space eq 2) ? '$T_{i\parallel}$' : '$T_{iH}$'
color = (params.ndim_space eq 2) ? 'green' : 'blue'
!NULL = plot(full_time*1e3, $
             moments.dist1.Tz, $
             color = color, $
             linestyle = 1, $
             name = name, $
             /overplot)
xrange = frm.xrange
yrange = frm.yrange
leg = legend(font_name = 'Times', $
             font_size = 10, $
             position = [0.5*(xrange[1]-xrange[0]), $
                        yrange[1]+0.05*abs(yrange[1])], $
             /data, $
             orientation = 1, $
             horizontal_alignment = 'center', $
             vertical_alignment = 'bottom', $
             sample_width = 0.05, $
             /auto_text_color)

txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)
frame_save, frm,filename = filename
