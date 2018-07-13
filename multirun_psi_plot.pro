;+
; Script for plotting Psi_0 from multiple runs, within
; multirun_moments.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

xdata = 1e3*params.dt* $
        findgen(n_elements(reform(all_moments[run[0]].psi)))
for ir=0,nr-1 do $
   frm = plot(xdata, $
              all_moments[run[ir]].psi, $
              color = (list('black', $
                            'blue', $
                            'green', $
                            'red'))[ir], $
              xstyle = 1, $
              xtitle = 'Time [ms]', $
              ytitle = '$\Psi_0$', $
              yrange = [0,1], $
              ymajor = 11, $
              yminor = 3, $
              font_name = 'Times', $
              font_size = 16, $
              overplot = (ir gt 0), $
              /buffer)

filename = expand_path(plot_path)+path_sep()+'frames'+ $
           path_sep()+ $
           'all_psi'+ $
           '.'+get_extension(frame_type)
frame_save, frm,filename=filename
