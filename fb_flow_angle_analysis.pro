;+
; Script for fb_flow_angle project
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

if n_elements(path) eq 0 then $
   path = get_base_dir()+path_sep()+ $
          'fb_flow_angle/3D/h1-Ey0_050/'
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
subsample = 1
;;--"growth"
;; t0 = 0
;; tf = 11776/params.nout
;;--"post_growth"
;; t0 = 11776/params.nout
;; tf = params.nt_max
;;--"first_half"
;; t0 = 0
;; tf = params.nt_max/2
;;--"second_half"
t0 = params.nt_max/2
tf = params.nt_max
;;--"linear"
;; t0 = 5504/params.nout
;; tf = 11776/params.nout
;;--"transition"
;; t0 = 17536/params.nout
;; tf = 20992/params.nout
;;--"saturated"
;; t0 = 20992/params.nout
;; tf = params.nt_max
;;--Entire run
;; t0 = 0
;; tf = params.nt_max
timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))

;; timesteps = params.nout*[0,nt_max/4,nt_max/2,3*nt_max/4,nt_max-1]

;; timesteps = [5504, $                        ;Linear stage start
;;              11776, $                       ;Linear stage end
;;              17536, $                       ;Transition stage start
;;              20992, $                       ;Transition stage end
;;              20992, $                       ;Saturated stage start
;;              params.nout*(params.nt_max-1)] ;Saturated stage end

time = time_strings(timesteps, $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)

;; @analyze_moments

;; @get_denft0_plane
;; if rotate ne 0 then $
;;    for it=0,(size(denft0))[3]-1 do $
;;       denft0[*,*,it] = rotate(denft0[*,*,it],rotate)
;; for it=0,(size(denft0))[3]-1 do $
;;    denft0[nx/2:*,*,it] = rotate(denft0[0:nx/2-1,*,it],2)

;; ;; @denft0_rms_images
;; den0 = arr_from_arrft(denft0)
;; @den0_images

@get_denft1_plane
if rotate ne 0 then $
   for it=0,(size(denft1))[3]-1 do $
      denft1[*,*,it] = rotate(denft1[*,*,it],rotate)
for it=0,(size(denft1))[3]-1 do $
   denft1[nx/2:*,*,it] = rotate(denft1[0:nx/2-1,*,it],2)

;; ;; @denft1_rms_images
;; den1 = arr_from_arrft(denft1)
;; @den1_images

@calc_denft1_w
theta = [-90,+90]*!dtor
@calc_denft1ktw
@denft1ktw_images

;; @denft1_ktt

