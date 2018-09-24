;+
; Script for making a plot of theta-RMS den1(k,theta,t) from
; multiple runs.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare project path
proj_path = get_base_dir()+path_sep()+'fb_flow_angle/2D/'

;;==Declare name of save file
;; save_name = 'den1ktt-001.0_005.0_m-all_theta.sav'
;; save_name = 'den1ktt-010.0_m-all_theta.sav'
save_name = 'den1ktt-001.0_010.0_m-all_theta.sav'

;;==Declare runs
run = ['h0-Ey0_050-full_output', $
       'h1-Ey0_050-full_output', $
       'h2-Ey0_050-full_output']
nr = n_elements(run)

;;==Declare initial step
it0 = 0

;;==Declare frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare plot file name
lambda = [2.0,3.0,4.0]
filename = expand_path(plot_path)+path_sep()+'frames'+ $
           path_sep()+ $
           'mr_'+ $
           ;; strip_extension(save_name)+ $
           'den1ktt'+ $
           '-'+ $
           string(lambda[0],format='(f05.1)')+ $
           '_'+ $
           string(lambda[n_elements(lambda)-1], $
                  format='(f05.1)')+ $
           '_m'+ $
           '-all_theta'+ $
           '.'+get_extension(frame_type)

;;==Declare line colors
color = ['blue', $
         'green', $
         'red']

;;==Declare line styles
linestyle = [0, $
             0, $
             0]

;;==Declare index of parameter hash
iph = 0

;;==Get common parameters from one directory
path = expand_path(proj_path)+path_sep()+run[iph]
params = set_eppic_params(path=path)
restore, expand_path(path)+path_sep()+save_name

;;==Get wavelengths
if n_elements(lambda) eq 0 then lambda = den1ktt.keys()
lambda = lambda.sort()
nl = den1ktt.count()

;;==Get number of time steps
nt = n_elements(time.index)

;;==Build the multi-run ktt hash
mr_den1ktt = build_multirun_hash(proj_path, $
                                   run, $
                                   save_name, $
                                   data_name)

;;==Build the multi-run kttrms hash
mr_kttrms = build_multirun_kttrms(mr_den1ktt, $
                                  'den1ktt', $
                                  lambda=lambda)

;;==Get number of time steps in each run
mr_nt = lonarr(nr)
for ir=0,nr-1 do $
   mr_nt[ir] = n_elements(mr_kttrms[run[ir]])

;;==Declare reference vector of time steps
timesteps = float(time.stamp)
max_nt = n_elements(timesteps)

;;==Preset some graphical parameters
xmajor = 8
xtickvalues = timesteps[max_nt-1]*findgen(xmajor)/(xmajor-1)
xtickname = string(xtickvalues,format='(f6.2)')
xtickname = strcompress(xtickname,/remove_all)
yrange = (params.ndim_space eq 2) ? [1e3,1e6] : [1e0,1e3]

;;==Create plot frame
for ir=0,nr-1 do $
   frm = plot(timesteps[it0:mr_nt[ir]-1], $
              mr_kttrms[run[ir],it0:*]/mr_kttrms[run[ir],it0], $
              axis_style = 2, $
              ;; aspect_ratio = 10, $
              position = [0.2,0.2,0.8,0.8], $
              xstyle = 1, $
              xtitle = 'Time [ms]', $
              ytitle = '$\langle P(\delta n)\rangle/P(n_I)$', $
              /ylog, $
              yrange = yrange, $
              ystyle = 0, $
              color = color[ir], $
              linestyle = linestyle[ir], $
              ;; xmajor = xmajor, $
              ;; xminor = 3, $
              ;; xtickvalues = xtickvalues, $
              ;; xtickname = xtickname, $
              xtickfont_size = 16.0, $
              ytickfont_size = 16.0, $
              xticklen = 0.04, $
              yticklen = 0.02, $
              font_name = 'Times', $
              font_size = 16.0, $
              overplot = (ir gt 0), $
              /buffer)

;;==Extract y-axis range
yrange = frm[0].yrange

;;==Add time markers corresponding to RMS growth range
image_times = (params.ndim_space eq 2) ? $
              [time.stamp[22],time.stamp[61]] : $
              [time.stamp[45],time.stamp[81]]
image_times = float(image_times)
nit = n_elements(image_times)
for it=0,nit-1 do $
   frm = plot([image_times[it],image_times[it]], $
              [yrange[0],yrange[1]], $
              color = 'black', $
              linestyle = 0, $
              /overplot)

;;==Add time markers corresponding to RMS saturated range
image_times = [time.stamp[156],time.stamp[max_nt-1]]
image_times = float(image_times)
nit = n_elements(image_times)
for it=0,nit-1 do $
   frm = plot([image_times[it],image_times[it]], $
              [yrange[0],yrange[1]], $
              color = 'black', $
              linestyle = 0, $
              /overplot)

;;==Add time markers corresponding to images
image_times = (params.ndim_space eq 2) ? $
              [time.stamp[45],time.stamp[180]] : $
              [time.stamp[67],time.stamp[180]]
image_times = float(image_times)
nit = n_elements(image_times)
for it=0,nit-1 do $
   frm = plot([image_times[it],image_times[it]], $
              [yrange[0],yrange[1]], $
              color = 'black', $
              linestyle = 2, $
              /overplot)

;;==Add a path label
txt = text(0.0,0.005, $
           proj_path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)
;;==Add save-file label
txt = text(0.0,0.955, $
           'original file: '+save_name, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save plot
frame_save, frm,filename=filename

