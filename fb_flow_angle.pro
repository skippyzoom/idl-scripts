;+
; Script for fb_flow_angle project
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h0-Ey0_050/'
if n_elements(rotate) eq 0 then rotate = 0
if n_elements(axes) eq 0 then axes = 'xy'
if n_elements(path) eq 0 then path = './'
if n_elements(info_path) eq 0 then info_path = path
if n_elements(data_path) eq 0 then data_path = path+path_sep()+'parallel'
if n_elements(zero_point) eq 0 then zero_point = 0
nt_max = calc_timesteps(path=path)
params = set_eppic_params(path=path)
;; @analyze_moments

;; nt = (nt_max-1)*params.nout/params.full_array_nout
;; nt_cycle = 4
;; time = time_strings(nt_cycle*params.full_array_nout* $
;;                     lindgen(nt/nt_cycle+1), $
;;                     dt=params.dt,scale=1e3,precision=2)

;; @get_denft1_plane
;; @denft1_raw_frames


;; @get_den0_plane
;; @den0_raw_frames
;; @get_den1_plane
;; @den1_raw_frames
;; @get_phi_plane
;; @phi_raw_frames
;; @get_efield_plane
;; @efield_raw_frames

time = time_strings(params.nout*lindgen(nt_max), $
                    dt=params.dt,scale=1e3,precision=2)
;; @get_phift_plane
;; phi = arr_from_arrft(phift,rotate=rotate)
;; @phi_raw_movies
;; @get_denft1_plane
;; den1 = arr_from_arrft(denft1,rotate=rotate)
;; @den1_raw_movies

@get_denft1_plane
;; if rotate ne 0 then $
;;    for it=0,(size(denft1))[3]-1 do denft1[*,*,it] = rotate(denft1[*,*,it],rotate)
;; if params.ndim_space eq 3 && strcmp(axes,'yz') then $
;;    denft1 = transpose(denft1,[1,0,2])
;; @denft1_raw_movies
;; den1 = arr_from_arrft(denft1,rotate=rotate)
;; @den1_raw_movies
@denft1_rms_frames
;; @denft1_ktt

;; @get_denft1_plane
;; @denft1_raw_movies
;; @get_den0_plane
;; @den0_raw_movies
;; @get_den1_plane
;; @get_denft1_plane
;; @den1_from_denft1
;; @den1_raw_movies
;; @get_phi_plane
;; @phi_raw_movies
;; @get_efield_plane
;; @efield_raw_movies

