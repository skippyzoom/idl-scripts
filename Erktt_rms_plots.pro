;+
; Script for making a plot of summed theta-RMS Er(k,theta,t) from
; multiple directories.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare project path
proj_path = get_base_dir()+path_sep()+'parametric_wave/'

;;==Declare save-file name for build_rms_total
save_name = 'Erktt_rms-02to05_meter-040to060_deg.sav'

;;==Declare whether to limit time range (See below, after
;;  build_rms_total)
limit_time_range = 1B

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare plot file name
filename = expand_path(plot_path)+path_sep()+'frames'+ $
           path_sep()+ $
           strip_extension(save_name)+ $
           '-norm'+ $
           '.'+get_extension(frame_type)

;;==Declare runs
run = ['nue_2.0e4-amp_0.05-E0_9.0-petsc_subcomm/', $
       'nue_2.0e4-amp_0.10-E0_9.0-petsc_subcomm/', $
       'nue_3.0e4-amp_0.05-E0_9.0-petsc_subcomm/', $
       'nue_3.0e4-amp_0.10-E0_9.0-petsc_subcomm/', $
       'nue_4.0e4-amp_0.05-E0_9.0-petsc_subcomm/', $
       'nue_4.0e4-amp_0.10-E0_9.0-petsc_subcomm/', $
       'nue_5.0e4-amp_0.05-E0_9.0-petsc_subcomm/', $
       'nue_5.0e4-amp_0.10-E0_9.0-petsc_subcomm/', $
       'nue_6.0e4-amp_0.05-E0_9.0-petsc_subcomm/', $
       'nue_6.0e4-amp_0.10-E0_9.0-petsc_subcomm/']
nr = n_elements(run)

;;==Declare index of parameter hash
iph = 2

;;==Declare line colors
color = ['magenta','magenta', $
         'blue','blue', $
         'green','green', $
         'black','black', $
         'red','red']
;; loadct, 39,rgb_table=ct
;; color = intarr(3,nr)
;; for ir=0,nr-1,2 do $
;;    color[*,ir:ir+1] = [[reform(ct[ir*(256/nr),*])], $
;;                        [reform(ct[ir*(256/nr),*])]]
;; color = transpose(color)

;;==Declare line styles
;; linestyle = [0,2,0,2,0,2,0,2,0,2]
linestyle = [1,0,1,0,1,0,1,0,1,0]

;;==Get common input parameters from one hash
path = expand_path(proj_path)+path_sep()+run[iph]
params = set_eppic_params(path=path)
s_obj = obj_new('IDL_Savefile',expand_path(path)+path_sep()+save_name)
s_obj->restore, 'time'

;;==Build the summed RMS array
rms_total = build_rms_total(proj_path, $
                            run, $
                            save_name, $
                            'Erktt_rms')

;;==Set the time-step interval
dt = 1e3*params.dt*(long(time.index[1])-long(time.index[0]))

;;==Get max number of time steps
max_nt = 0L
for ir=0,nr-1 do $
   max_nt = max([max_nt,n_elements(rms_total[run[ir]])])

;;==Limit time range
;;  This is useful for runs with non-physical start/end values (e.g.,
;;  the nue_2.0e4*petsc_subcomm runs in parametric_wave)
if keyword_set(limit_time_range) then $
   for ir=0,nr-1 do $
      rms_total[run[ir]] = rms_total[run[ir], $
                                     1:n_elements(rms_total[run[ir]])-2]

;;==Create object array for frame handles
frm = objarr(nr)

;;==Calculate a baseline value for each run
run_baseline = fltarr(nr)
for ir=0,nr-1 do $
   run_baseline[ir] = mean(rms_total[run[ir],0:9])

;;==Set up x-axis tick marks
xmajor = 5
xminor = 3
xtickvalues = (max_nt-1)*findgen(xmajor)/(xmajor-1)
xtickname = string(dt*xtickvalues,format='(f6.2)')
xtickname = strcompress(xtickname)

;;==Loop over runs
for ir=0,nr-1 do $
   frm[ir] = plot(rms_total[run[ir]]/run_baseline[ir], $
                  xstyle = 1, $
                  xtitle = 'Time [ms]', $
                  ytitle = '$\langle P(\delta E)\rangle/P(E_0)$', $
                  overplot = (ir gt 0), $
                  ;; color = color[ir], $
                  color = transpose(color[ir,*]), $
                  ;; xrange = [0,dt*(max_nt-1)], $
                  xrange = [0,512], $
                  yrange = [1,3], $
                  ystyle = 0, $
                  xmajor = xmajor, $
                  xminor = xminor, $
                  xtickvalues = xtickvalues, $
                  xtickname = xtickname, $
                  xtickfont_size = 16.0, $
                  ytickfont_size = 16.0, $
                  linestyle = linestyle[ir], $
                  font_name = 'Times', $
                  font_size = 16.0, $
                  /buffer)

;;==Extract y-axis range
yrange = frm[0].yrange

;;==Add time markers corresponding to images
;; image_times = 1e3*params.dt* $
;;               [2048, $
;;                4096, $
;;                24576]
image_times = [2048,4096,24576]/(long(time.index[1])-long(time.index[0]))
nit = n_elements(image_times)
for it=0,nit-1 do $
   frm = plot([image_times[it],image_times[it]], $
              [yrange[0],yrange[1]], $
              color = 'black', $
              linestyle = 2, $
              /overplot)

;;==Add a path label
txt = text(0.0,0.005, $
           plot_path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save plot
frame_save, frm,filename=filename

