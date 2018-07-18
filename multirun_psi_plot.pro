;+
; Script for plotting Psi_0 from multiple runs, within
; multirun_moments.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

for ir=0,nr-1 do $
   frm = plot(1e3*all_params[run[ir]].dt* $
              findgen(n_elements(all_moments[run[ir]].psi)), $
              all_moments[run[ir]].psi, $
              color = (list('cyan', $
                            'blue', $
                            'green', $
                            'red', $
                            'black'))[ir], $
              xstyle = 1, $
              xtitle = 'Time [ms]', $
              ytitle = '$\Psi_0$', $
              yrange = [0,1.1], $
              ymajor = 12, $
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
