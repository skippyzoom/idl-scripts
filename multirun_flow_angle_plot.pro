;+
; Script for plotting mean flow angle from multiple runs, within
; multirun_moments.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare file name
filename = expand_path(plot_path)+path_sep()+'frames'+ $
           path_sep()+ $
           'mr_flow_angle'+ $
           '.'+get_extension(frame_type)

;;==Declare line colors
color = ['blue', $
         'green', $
         'red']

;;==Get number of time steps in each run
mr_nt = lonarr(nr)
for ir=0,nr-1 do $
   mr_nt[ir] = n_elements(mr_moments[run[ir]].psi)

;;==Build common x data
xdata = hash(run)
for ir=0,nr-1 do $
   xdata[run[ir]] = $
   1e3*mr_params[run[ir]].dt*mr_params[run[ir]].nout*findgen(mr_nt[ir])

;;==Build components of relative velocity in simulation coordinates
vx_rel = hash(run)
for ir=0,nr-1 do $
   vx_rel[run[ir]] = $
   mr_moments[run[ir]].dist0.vx_m1-mr_moments[run[ir]].dist1.vx_m1
vy_rel = hash(run)
for ir=0,nr-1 do $
   vy_rel[run[ir]] = $
   mr_moments[run[ir]].dist0.vy_m1-mr_moments[run[ir]].dist1.vy_m1
vz_rel = hash(run)
for ir=0,nr-1 do $
   vz_rel[run[ir]] = $
   mr_moments[run[ir]].dist0.vz_m1-mr_moments[run[ir]].dist1.vz_m1

;;==Calculate flow angle in physical coordinates
flow_angle = hash(run)
for ir=0,nr-1 do $
   flow_angle[run[ir]] = atan(vy_rel[run[ir]]/(-vz_rel[run[ir]]))

;;==Loop over runs to create frame
for ir=0,nr-1 do $
   frm = plot(xdata[run[ir]], $
              flow_angle[run[ir]]/!dtor, $
              color = color[ir], $
              xstyle = 1, $
              xtitle = 'Time [ms]', $
              ytitle = '$\theta$ [deg]', $
              yrange = [-40,0], $
              ymajor = 5, $
              yminor = 9, $
              font_name = 'Times', $
              font_size = 16, $
              overplot = (ir gt 0), $
              /buffer)

;;==Save the plot
frame_save, frm,filename=filename
