;+
; Script for making a plot of summed theta-RMS Er(k,theta,t) from
; multiple directories.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare project path
proj_path = get_base_dir()+path_sep()+'parametric_wave/'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare runs
;; run = ['nue_2.0e4-amp_0.05-E0_9.0/', $
;;        'nue_3.0e4-amp_0.05-E0_9.0/', $
;;        'nue_3.0e4-amp_0.10-E0_9.0/', $
;;        'nue_4.0e4-amp_0.05-E0_9.0/']
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

;;==Declare up colors and line styles
color = ['cyan','cyan', $
         'blue','blue', $
         'green','green', $
         'red','red', $
         'black','black']
linestyle = [0,2,0,2,0,2,0,2,0,2]

;;==Declare save-file name for ktt_rms
save_name = 'Erktt_rms-02to05_meter-040to060_deg.sav'

;; ;;==Get information from first hash
;; path = expand_path(proj_path)+path_sep()+run[0]
;; restore, expand_path(path)+path_sep()+save_name

;; ;;==Get wavelengths
;; lambda = Erktt_rms.keys()
;; lambda = lambda.sort()
;; nl = n_elements(lambda)

;; ;;==Get number of time steps
;; nt = n_elements(Erktt_rms[lambda[0]])

;; ;;==Free hash memory
;; Erktt_rms = !NULL

;; ;;==Get input parameters
;; params = set_eppic_params(path=path)
;; nt_max = calc_timesteps(path=path)
;; params['nt_max'] = nt_max

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

;;==Get dimensions
rsize = size(rms_total)
nl = rsize[1]
nt = rsize[2]

;;==Create plot frame
frm = objarr(nr)
;; xdata = 1e3*params.dt*params.nout*findgen(nt)
xdata = 1e3*params.dt*time.index
ydata = fltarr(nr,nt)
for ir=0,nr-1 do $
   ydata[ir,*] = rms_total[ir,*]/mean(rms_total[ir,1:10])
for ir=0,nr-1 do $
   frm[ir] = plot(xdata, $
                  ydata[ir,*], $
                  ;; rms_total[ir,*], $
                  xstyle = 1, $
                  xtitle = 'Time [ms]', $
                  ;; ytitle = '$\langle\delta E(k,t)/E_0\rangle$', $
                  ytitle = '$\langle P(\delta E)\rangle/P(E_0)$', $
                  overplot = (ir gt 0), $
                  color = color[ir], $
                  yrange = [1,3], $
                  ;; yrange = [0,8e-4], $
                  ystyle = 0, $
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
;;               [5056, $
;;                15104, $
;;                params.nout*(2*(params.nt_max/2))]
image_times = 1e3*params.dt* $
              [2048, $
               4096, $
               25024]
nit = n_elements(image_times)
for it=0,nit-1 do $
   frm = plot([image_times[it],image_times[it]], $
              [yrange[0],yrange[1]], $
              color = 'black', $
              linestyle = 0, $
              /overplot)
;; image_times = 1e3*params.dt* $
;;               [2048, $
;;                10048, $
;;                params.nout*(2*(params.nt_max/2))]
;; nit = n_elements(image_times)
;; for it=0,nit-1 do $
;;    frm = plot([image_times[it],image_times[it]], $
;;               [yrange[0],yrange[1]], $
;;               color = 'black', $
;;               linestyle = 2, $
;;               /overplot)

;;==Add a path label
txt = text(0.0,0.005, $
           plot_path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)                

;;==Save plots
filename = expand_path(plot_path)+path_sep()+'frames'+ $
           path_sep()+ $
           strip_extension(save_name)+ $
           '-norm'+ $
           '.'+get_extension(frame_type)
frame_save, frm,filename=filename

;;==Free memory
;; rms_total = !NULL
