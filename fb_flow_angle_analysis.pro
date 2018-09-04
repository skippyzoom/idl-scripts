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
if params.ndim_space eq 2 then subsample *= 8L
timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))

;; timesteps = params.nout*[0,nt_max/4,nt_max/2,3*nt_max/4,nt_max-1]

;; timesteps = [5504, $                        ;3-D Linear stage start
;;              11776, $                       ;3-D Linear stage end
;;              17536, $                       ;3-D Transition stage start
;;              20992, $                       ;3-D Transition stage end
;;              20992, $                       ;3-D Saturated stage start
;;              params.nout*(params.nt_max-1)] ;3-D Saturated stage end
;; if params.ndim_space eq 2 then timesteps *= 8L

;; ;; timesteps = [8576, $            ;3-D Linear stage example
;; ;;              23040]             ;3-D Saturated stage example
;; timesteps = [7168, $            ;3-D Linear stage example
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

time = time_strings(timesteps, $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)

;; @get_den1_plane

;; @analyze_moments

;; rotate = 0
;; @get_denft0_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(denft0))[3]-1 do $
;;       denft0[*,*,it] = rotate(denft0[*,*,it],3)
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(denft0))[3]-1 do $
;;       denft0[nx/2:*,*,it] = rotate(denft0[0:nx/2-1,*,it],2)
;; if (params.ndim_space eq 2 && strcmp(axes,'xy')) then $
;;    for it=0,(size(denft0))[3]-1 do $
;;       denft0[*,ny/2:*,it] = rotate(denft0[*,0:ny/2-1,it],2)

;; @denft0_rms_images

;; den0 = arr_from_arrft(denft0)
;; @den0_images

rotate = 0
@get_denft1_plane
if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
   for it=0,(size(denft1))[3]-1 do $
      denft1[*,*,it] = rotate(denft1[*,*,it],3)
if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
   for it=0,(size(denft1))[3]-1 do $
      denft1[nx/2:*,*,it] = rotate(denft1[0:nx/2-1,*,it],2)
if (params.ndim_space eq 2 && strcmp(axes,'xy')) then $
   for it=0,(size(denft1))[3]-1 do $
      denft1[*,ny/2:*,it] = rotate(denft1[*,0:ny/2-1,it],2)

;; @denft1_rms_images

;; den1 = arr_from_arrft(denft1)
;; @den1_images

;; @denft1_movie

;; rotate = 0
;; @get_denft1_plane
;; ;; for it=0,(size(denft1))[3]-1 do $
;; ;;    denft1[*,*,it] = rotate(denft1[*,*,it],3)
;; ;; for it=0,(size(denft1))[3]-1 do $
;; ;;    denft1[nx/2:*,*,it] = rotate(denft1[0:nx/2-1,*,it],2)
;; ;; theta = [-90,+90]*!dtor
;; theta = [0,360]*!dtor
;; lambda = 1.0+findgen(5)
;; denft1ktt_save_name = 'denft1ktt'+ $
;;                       '-'+ $
;;                       string(lambda[0],format='(f05.1)')+ $
;;                       '_'+ $
;;                       string(lambda[n_elements(lambda)-1], $
;;                              format='(f05.1)')+ $
;;                       '_m'+ $
;;                       ;; '-kx_gt_0'+ $
;;                       '-all_theta'+ $
;;                       ;; '-'+ $
;;                       ;; string(theta[0]/!dtor,format='(f05.1)')+ $
;;                       ;; '_'+ $
;;                       ;; string(theta[1]/!dtor,format='(f05.1)')+ $
;;                       ;; '_deg'+ $
;;                       '.sav'
;; @calc_denft1ktt
;; save, time,denft1ktt, $
;;       filename=expand_path(path)+path_sep()+denft1ktt_save_name
;; ;; @denft1ktt_rms

;; @calc_denft1_w
;; theta = [-90,+90]*!dtor
;; @calc_denft1ktw
;; @denft1ktw_images

;; @denft1_ktt

;; @get_den0_plane

;; ;; @get_fluxx0_plane
;; ;; @get_fluxy0_plane
;; ;; @get_fluxz0_plane

;; @get_nvsqrx0_plane
;; @get_nvsqry0_plane
;; @get_nvsqrz0_plane

;; @get_den1_plane

;; ;; @get_fluxx1_plane
;; ;; @get_fluxy1_plane
;; ;; @get_fluxz1_plane

;; @get_nvsqrx1_plane
;; @get_nvsqry1_plane
;; @get_nvsqrz1_plane

;; ;; moments = read_moments(path=path)
;; ;; @average_temperature_plot

;; @thermal_instability

;;==Print a new line at the very end
print, ' '
