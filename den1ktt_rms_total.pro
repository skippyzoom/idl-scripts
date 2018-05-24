;+
; Script for making a plot of summed theta-RMS den1(k,theta,t) from
; multiple directories.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare project path
proj_path = get_base_dir()+path_sep()+'parametric_wave/'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare save-file name
save_name = 'den1ktt_rms-meter_scale.sav'

;;==Declare runs
run = ['nue_2.0e4-amp_0.05-E0_9.0/', $
       'nue_3.0e4-amp_0.05-E0_9.0/', $
       'nue_3.0e4-amp_0.10-E0_9.0/', $
       'nue_4.0e4-amp_0.05-E0_9.0/']
nr = n_elements(run)

;;==Get information from first hash
path = expand_path(proj_path)+path_sep()+'nue_2.0e4-amp_0.05-E0_9.0/'
restore, expand_path(path)+path_sep()+save_name

;;==Get wavelengths
lambda = den1ktt_rms.keys()
lambda = lambda.sort()
nl = n_elements(lambda)

;;==Get number of time steps
nt = n_elements(den1ktt_rms[lambda[0]])

;;==Get input parameters
params = set_eppic_params(path=path)
nt_max = calc_timesteps(path=path)
params['nt_max'] = nt_max

;;==Build the summed RMS array
rms_total = build_rms_total(proj_path,run,save_name, $
                            data_name='den1ktt_rms')

;;==Set up colors and line styles
color = ['red','blue','blue','green']
linestyle = [0,0,2,0]

;;==Create plot frame
plt = objarr(nr)
for ir=0,nr-1 do $
   plt[ir] = plot(1e3*params.dt*time.index, $
                  rms_total[ir,*]/rms_total[ir,0], $
                  xstyle = 1, $
                  xtitle = 'Time [ms]', $
                  ytitle = '$\langle\delta n(k,t)/\delta n(k,0)\rangle$', $
                  overplot = (ir gt 0), $
                  color = color[ir], $
                  linestyle = linestyle[ir], $
                  /buffer)
                 
;;==Add time markers corresponding to images
image_times = 1e3*params.dt* $
              [5056, $
               15104, $
               params.nout*(2*(params.nt_max/2))]
nit = n_elements(image_times)
yrange = plt[0].yrange
for it=0,nit-1 do $
   plt = plot([image_times[it],image_times[it]], $
              [yrange[0],yrange[1]], $
              color = 'black', $
              linestyle = 0, $
              /overplot)
image_times = 1e3*params.dt* $
              [2048, $
               10048, $
               params.nout*(2*(params.nt_max/2))]
nit = n_elements(image_times)
yrange = plt[0].yrange
for it=0,nit-1 do $
   plt = plot([image_times[it],image_times[it]], $
              [yrange[0],yrange[1]], $
              color = 'black', $
              linestyle = 2, $
              /overplot)

;;==Add a path label
txt = text(0.0,0.005, $
           plot_path, $
           target = plt, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save plots
filename = expand_path(plot_path)+path_sep()+'frames'+ $
           path_sep()+strip_extension(save_name)+ $
           '.pdf'
frame_save, plt,filename=filename

;;==Free memory
den1ktt_rms = !NULL
rms_total = !NULL
