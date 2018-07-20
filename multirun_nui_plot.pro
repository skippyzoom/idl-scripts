;+
; Script for plotting $\nu_i$ (ion collision frequency) from multiple
; runs, within multirun_moments.
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
           'mr_nui'+ $
           '.'+get_extension(frame_type)

;;==Declare line colors
color = ['magenta', $
         'blue', $
         'green', $
         'black', $
         'red']

;;==Get number of time steps in each run
mr_nt = lonarr(nr)
for ir=0,nr-1 do $
   mr_nt[ir] = n_elements(mr_moments[run[ir]].dist1.nu)

;;==Declare x and y data for ease of use
xdata = hash(run)
for ir=0,nr-1 do $
   xdata[run[ir]] = 1e3*mr_params[run[ir]].dt*findgen(mr_nt[ir])
ydata = hash(run)
for ir=0,nr-1 do $
   ydata[run[ir]] = mr_moments[run[ir]].dist1.nu

;;==Loop over runs to create frame
for ir=0,nr-1 do $
   frm = plot(xdata[run[ir]], $
              ydata[run[ir]], $
              color = color[ir], $
              xstyle = 1, $
              xtitle = 'Time [ms]', $
              ytitle = '$\nu_i$ [s$^{-1}$]', $
              yrange = [2e3,6e3], $
              ymajor = 5, $
              yminor = 4, $
              font_name = 'Times', $
              font_size = 16, $
              overplot = (ir gt 0), $
              /buffer)

;;==Extract bounds of frame y-axis
y0 = frm.yrange[0]
yf = frm.yrange[1]

;;==Create label strings
label = strarr(nr)
for ir=0,nr-1 do $
   label[ir] = string(ydata[run[ir], mr_nt[ir]-1])
label = strcompress(label,/remove_all)

;;==Add text label
for ir=0,nr-1 do $
   txt = text(xdata[run[ir], 0.8*mr_nt[ir]], $
              ydata[run[ir], 0.8*mr_nt[ir]]-0.05*(yf-y0), $
              label[ir], $
              /data, $
              alignment = 0.5, $
              target = frm, $
              color = color[ir], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save the plot
frame_save, frm,filename=filename
