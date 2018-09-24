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

;;--3-D "growth"
;; t0 = 0
;; tf = 11776/params.nout
;;--3-D "post_growth"
;; t0 = 11776/params.nout
;; tf = params.nt_max
;;--3-D "first_half"
;; t0 = 0
;; tf = params.nt_max/2
;;--3-D "second_half"
;; t0 = params.nt_max/2
;; tf = params.nt_max
;;--3-D "linear"
;; t0 = 5504/params.nout
;; tf = 11776/params.nout
;;--3-D "transition"
;; t0 = 17536/params.nout
;; tf = 20992/params.nout
;;--3-D "saturated"
;; t0 = 20992/params.nout
;; tf = params.nt_max
;;--Entire run
t0 = 0
tf = params.nt_max

;; subsample = params.nt_max/params.nvsqr_out_subcycle1
;; subsample = params.nvsqr_out_subcycle1
subsample = 1
;; subsample = params.full_array_nout/params.nout
if params.ndim_space eq 2 then subsample *= 8L
timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))

;; timesteps = params.nout*[0, $
;;                          params.nt_max/4, $
;;                          params.nt_max/2, $
;;                          3*params.nt_max/4, $
;;                          params.nt_max-1]

;---------------;
; ORIGINAL RUNS ;
;---------------;
;; timesteps = [5504, $                        ;3-D Linear stage start
;;              11776, $                       ;3-D Linear stage end
;;              17536, $                       ;3-D Transition stage start
;;              20992, $                       ;3-D Transition stage end
;;              20992, $                       ;3-D Saturated stage start
;;              params.nout*(params.nt_max-1)] ;3-D Saturated stage end
;; if params.ndim_space eq 2 then timesteps *= 8L

;; timesteps = [8576, $            ;3-D Linear stage example
;;              23040]             ;3-D Saturated stage example
;; if params.ndim_space eq 2 then timesteps *= 8L

;; timesteps = 8L*[5504, $                        ;2-D Linear stage start
;;                 11776, $                       ;2-D Linear stage end
;;                 17536, $                       ;2-D Transition stage start
;;                 20992, $                       ;2-D Transition stage end
;;                 20992, $                       ;2-D Saturated stage start
;;                 params.nout*(params.nt_max-1)] ;2-D Saturated stage end

;; timesteps = 8L*[8576, $            ;2-D Linear stage example
;;                 23040]             ;2-D Saturated stage example

;------------------;
; FULL-OUTPUT RUNS ;
;------------------;
;; ;;==RMS ranges
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

;;==Snapshots
;; if params.ndim_space eq 2 then $
;; timesteps = [46080, $           ;2-D Growth stage example
;;              184320]            ;2-D Saturated stage example
;; if params.ndim_space eq 3 then $
;; timesteps = [8576, $            ;3-D Growth stage example
;;              23040]             ;3-D Saturated stage example

time = time_strings(long(timesteps), $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)
if n_elements(subsample) ne 0 then time.subsample = subsample
;; if params.ndim_space eq 2 then time_2D = time
;; if params.ndim_space eq 3 then time_3D = time

;; @analyze_moments

;; rotate = 0
;; @get_den0_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den0))[3]-1 do $
;;       den0[*,*,it] = rotate(den0[*,*,it],1)
;; ;; @den0_images
;; ;; @den0_movie
;; @calc_den0fft_t
;; ;; ;; @den0fft_t_rms_images
;; ;; @den0fft_t_movie
;; @den0fft_t_rms_images

rotate = 0
@get_den1_plane
if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
   for it=0,(size(den1))[3]-1 do $
      den1[*,*,it] = rotate(den1[*,*,it],1)
;; @calc_den1fft_t
;; den1fft_t_raw = den1fft_t
;; den1 = spectral_filter(den1,threshold=5e-2,/relative)
;; @calc_den1fft_t
;; @den1_spectral_filter
;; @den1_images
;; @den1_movie

@calc_den1fft_t
;; @calc_den1fft_t_rms
;; ;; @den1fft_t_rms_images
;; @den1fft_t_movie
@den1fft_t_rms_images

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
;; ;; restore, filename=expand_path(path)+path_sep()+den1ktt_save_name,/verbose
;; ;; @calc_cg_den1ktt
;; ;; @den1ktt_rms_images

;; rotate = 0
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @calc_den1fft_t
;; theta = [0,360]*!dtor
;; ;; lambda = 1.0+findgen(5)
;; ;; lambda = 10.0
;; lambda = 1.0+findgen(10)
;; den1ktt_save_name = 'den1ktt'+ $
;;                       '-'+ $
;;                       string(lambda[0],format='(f05.1)')+ $
;;                       '_'+ $
;;                       string(lambda[n_elements(lambda)-1], $
;;                              format='(f05.1)')+ $
;;                       '_m'+ $
;;                       '-all_theta'+ $
;;                       ;; '-'+ $
;;                       ;; string(theta[0]/!dtor,format='(f05.1)')+ $
;;                       ;; '_'+ $
;;                       ;; string(theta[1]/!dtor,format='(f05.1)')+ $
;;                       ;; '_deg'+ $
;;                       '.sav'
;; @calc_den1ktt
;; save, time,den1ktt, $
;;       filename=expand_path(path)+path_sep()+den1ktt_save_name

;; @calc_denft1_w
;; theta = [-90,+90]*!dtor
;; @calc_denft1ktw
;; @denft1ktw_images

;; @get_den0_plane

;; @get_fluxx0_plane
;; @get_fluxy0_plane
;; @get_fluxz0_plane

;; @get_nvsqrx0_plane
;; @get_nvsqry0_plane
;; @get_nvsqrz0_plane

;; @get_den1_plane

;; @get_fluxx1_plane
;; @get_fluxy1_plane
;; @get_fluxz1_plane

;; @get_nvsqrx1_plane
;; @get_nvsqry1_plane
;; @get_nvsqrz1_plane

;; moments = read_moments(path=path)
;; @average_temperature_plot

;; ;; @build_temp0_from_moments
;; ;; @build_temp1_from_moments
;; @build_temp0_from_flux
;; @build_temp1_from_flux

;; save, time,temp0, $
;;       filename=expand_path(path)+path_sep()+'temp0.sav'
;; save, time,temp1, $
;;       filename=expand_path(path)+path_sep()+'temp1.sav'


;; @thermal_instability

;;==Print a new line at the very end
print, ' '
