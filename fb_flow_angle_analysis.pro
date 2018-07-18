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
t0 = 0
tf = params.nt_max
timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))

time = time_strings(timesteps, $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)

;; @analyze_moments
@get_denft1_plane
if rotate ne 0 then $
   for it=0,(size(denft1))[3]-1 do $
      denft1[*,*,it] = rotate(denft1[*,*,it],rotate)
for it=0,(size(denft1))[3]-1 do $
   denft1[nx/2:*,*,it] = rotate(denft1[0:nx/2-1,*,it],2)
@calc_denft1_w
@calc_denft1ktw
;; @denft1ktw_images

;; den1 = arr_from_arrft(denft1)
;; @denft1_rms_frames
;; @denft1_ktt

