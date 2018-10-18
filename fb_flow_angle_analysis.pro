;+
; Script for fb_flow_angle project
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

if n_elements(path) eq 0 then $
   path = get_base_dir()+path_sep()+ $
          'fb_flow_angle/3D/h0-Ey0_050/'
if n_elements(lun) eq 0 then lun = -1
printf, lun, "[FB_FLOW_ANGLE] path = "+path
if n_elements(rotate) eq 0 then rotate = 0
if n_elements(axes) eq 0 then axes = 'xy'
if n_elements(path) eq 0 then path = './'
if n_elements(info_path) eq 0 then info_path = path
if n_elements(data_path) eq 0 then data_path = path+path_sep()+'parallel'
if n_elements(zero_point) eq 0 then zero_point = 0
params = set_eppic_params(path=path)
nt_max = calc_timesteps(path=path)
params['nt_max'] = nt_max
frame_type = '.pdf'
movie_type = '.mp4'
perp_plane = (params.ndim_space eq 2 and strcmp(axes,'xy')) || $
             (params.ndim_space eq 3 and strcmp(axes,'yz')) 

efield_save_name = expand_path(path)+path_sep()+ $
                   'efield_'+axes+ $
                   '.sav'

;;==All time steps from t0 to tf at subsample frequency
t0 = 0
tf = params.nt_max
subsample = 1
;; subsample = params.nvsqr_out_subcycle1
if params.ndim_space eq 2 then subsample *= 8L
timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))

;;==The zeroth time step, plus each quarter of the full run
;; timesteps = params.nout*[0, $
;;                          params.nt_max/4, $
;;                          params.nt_max/2, $
;;                          3*params.nt_max/4, $
;;                          params.nt_max-1]

;;==3-D RMS ranges (original runs)
;; timesteps = [5504, $                        ;3-D Linear stage start
;;              11776, $                       ;3-D Linear stage end
;;              17536, $                       ;3-D Transition stage start
;;              20992, $                       ;3-D Transition stage end
;;              20992, $                       ;3-D Saturated stage start
;;              params.nout*(params.nt_max-1)] ;3-D Saturated stage end
;; if params.ndim_space eq 2 then timesteps *= 8L

;;==3-D Snapshots (original runs)
;; timesteps = [8576, $            ;3-D Linear stage example
;;              23040]             ;3-D Saturated stage example
;; if params.ndim_space eq 2 then timesteps *= 8L

;;==2-D RMS ranges (original runs)
;; timesteps = 8L*[5504, $                        ;2-D Linear stage start
;;                 11776, $                       ;2-D Linear stage end
;;                 17536, $                       ;2-D Transition stage start
;;                 20992, $                       ;2-D Transition stage end
;;                 20992, $                       ;2-D Saturated stage start
;;                 params.nout*(params.nt_max-1)] ;2-D Saturated stage end

;;==2-D Snapshots (original runs)
;; timesteps = 8L*[8576, $            ;2-D Linear stage example
;;                 23040]             ;2-D Saturated stage example

;;==RMS ranges (full-output runs)
;; if params.ndim_space eq 2 then $
;;    timesteps = [22528, $                       ;2-D Growth stage start
;;                 62464, $                       ;2-D Growth stage end
;;                 159744, $                      ;2-D Saturated stage start
;;                 params.nout*(params.nt_max-1)] ;2-D Saturated stage end
;; if params.ndim_space eq 3 then $
;;    timesteps = [5760, $                        ;3-D Growth stage start
;;                 10368, $                       ;3-D Growth stage end
;;                 19968, $                       ;3-D Saturated stage start
;;                 params.nout*(params.nt_max-1)] ;3-D Saturated stage end

;;==Snapshots (full-output runs)
;; if params.ndim_space eq 2 then $
;; timesteps = [46080, $           ;2-D Growth stage example
;;              184320]            ;2-D Saturated stage example
;; if params.ndim_space eq 3 then $
;; timesteps = [8576, $            ;3-D Growth stage example
;;              23040]             ;3-D Saturated stage example

;;==Build the time dictionary
time = time_strings(long(timesteps), $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)
if n_elements(subsample) ne 0 then time.subsample = subsample
if params.ndim_space eq 2 then time_2D = time
if params.ndim_space eq 3 then time_3D = time

;+
; Analyze moment files (domain000/moments*.out)
;-
;; @analyze_moments

;+
; Make movies of den0 and den0fft_t
;-
;; rotate = 0
;; @get_den0_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den0))[3]-1 do $
;;       den0[*,*,it] = rotate(den0[*,*,it],1)
;; @den0_movie
;; @calc_den0fft_t
;; @den0fft_t_movie

;+
; Make movies of den1 and den1fft_t
;-
;; rotate = 0
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @den1_movie
;; @calc_den1fft_t
;; @den1fft_t_movie

;+
; Make images of den0 with centroid
;-
;; rotate = 0
;; @get_den0_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den0))[3]-1 do $
;;       den0[*,*,it] = rotate(den0[*,*,it],1)
;; @calc_den0fft_t
;; @calc_den0fft_t_moments
;; @den0fft_t_rms_images

;+
; Make images of den1 with centroid
;-
;; rotate = 0
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @calc_den1fft_t
;; @calc_den1fft_t_moments
;; @den1fft_t_rms_images

;; modes = fftfreq(nx,dx)
;; lambda = 1.0/modes[1:nx/2]
;; theta = [0,2*!pi]
;; @calc_den1rmsktt
;; @calc_cg_den1rmsktt

;; @calc_den1fft_t
;; ;; @calc_den1fft_t_rms
;; ;; ;; @den1fft_t_rms_images
;; ;; @den1fft_t_movie
;; @den1fft_t_rms_images

;+
; Build den1ktt and save it
;-
;; rotate = 0
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @calc_den1fft_t
;; modes = fftfreq(nx,dx)
;; lambda = 1.0/modes[1:nx/2]
;; theta = [0,2*!pi]
;; @calc_den1ktt
;; den1ktt_save_name = 'den1ktt'+ $
;;                     '-all_k'+ $
;;                     '-all_theta'+ $
;;                     '-subsample_'+strcompress(subsample,/remove_all)+ $
;;                     '.sav'
;; save, time,den1ktt, $
;;       filename=expand_path(path)+path_sep()+den1ktt_save_name

;; restore, filename=expand_path(path)+path_sep()+den1ktt_save_name,/verbose
;; @calc_cg_den1ktt
;; @den1ktt_rms_images

;; @calc_denft1_w
;; theta = [-90,+90]*!dtor
;; @calc_denft1ktw
;; @denft1ktw_images

;+
; Plot averaged temperatures (independent of axes)
;-
;; moments = read_moments(path=path)
;; @average_temperature_plot

;+
; Build temp0 and save it
;-
;; @get_den0_plane
;; @get_fluxx0_plane
;; @get_fluxy0_plane
;; @get_fluxz0_plane
;; @get_nvsqrx0_plane
;; @get_nvsqry0_plane
;; @get_nvsqrz0_plane
;; @build_temp0_from_fluxes
;; save, time,temp0, $
;;       filename=expand_path(path)+path_sep()+'temp0-'+axes+'.sav'

;+
; Restore and rotate temp0 and den0
; Calling get_den0_plane after restoring the save file ensures that
; get_den0_plane uses the appropriate time dictionary
;-
;; restore, filename=expand_path(path)+path_sep()+'temp0-'+axes+'.sav', $
;;          /verbose
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(temp0))[3]-1 do $
;;       temp0[*,*,it] = rotate(temp0[*,*,it],1)
;; @get_den0_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den0))[3]-1 do $
;;       den0[*,*,it] = rotate(den0[*,*,it],1)
;; @nT0_phase_plot
;; @nT0_gen_phase_plot
;; @nT0_ratio_phase

;+
; Build temp1 and save it
;-
;; @get_den1_plane
;; @get_fluxx1_plane
;; @get_fluxy1_plane
;; @get_fluxz1_plane
;; @get_nvsqrx1_plane
;; @get_nvsqry1_plane
;; @get_nvsqrz1_plane
;; @build_temp1_from_fluxes
;; save, time,temp1, $
;;       filename=expand_path(path)+path_sep()+'temp1-'+axes+'.sav'

;+
; Restore and rotate temp1 and den1
; Calling get_den1_plane after restoring the save file ensures that
; get_den1_plane uses the appropriate time dictionary
;-
;; restore, filename=expand_path(path)+path_sep()+'temp1-'+axes+'.sav', $
;;          /verbose
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(temp1))[3]-1 do $
;;       temp1[*,*,it] = rotate(temp1[*,*,it],1)
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @nT1_phase_plot
;; @nT1_gen_phase_plot
;; @nT1_ratio_phase


rotate = 0
restore, filename=expand_path(path)+path_sep()+'temp1-'+axes+'.sav', $
         /verbose
if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
   for it=0,(size(temp1))[3]-1 do $
      temp1[*,*,it] = rotate(temp1[*,*,it],1)
@get_den1_plane
if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
   for it=0,(size(den1))[3]-1 do $
      den1[*,*,it] = rotate(den1[*,*,it],1)
@calc_den1fft_t
@calc_den1fft_t_moments
@calc_nT1_ratio_phase

;;==Print a new line at the very end
print, ' '
