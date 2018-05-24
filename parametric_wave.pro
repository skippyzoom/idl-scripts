;+
; Script for parametric_wave project
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_3.0e4-amp_0.10-E0_9.0/'
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

subsample = 2
time = time_strings(subsample*params.nout* $
                    lindgen(params.nt_max/subsample+1), $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)
;; time = time_strings([params.nout, $
;;                      5*params.nout, $
;;                      10*params.nout, $
;;                      5056, $
;;                      15104, $
;;                      2048, $
;;                      10048, $
;;                      params.nout*(2*(params.nt_max/2))], $
;;                     dt=params.dt,scale=1e3,precision=2)
;; time = time_strings([0,params.nout], $
;;                     dt=params.dt,scale=1e3,precision=2)

;; rms_range = [[         0,  nt_max/4], $
;;              [  nt_max/4,  nt_max/2], $
;;              [  nt_max/2,3*nt_max/4], $
;;              [3*nt_max/4,2*(nt_max/2)]]

;; @analyze_moments
@get_den1_plane
;; @den1_movie
;; @calc_den1fft_t
;; @den1fft_t_movie
;; @calc_den1ktt_rms
;; save, time,den1ktt_rms, $
;;       filename=expand_path(path)+path_sep()+'den1ktt_rms-few_meter.sav'
;; @den1ktt_rms_plots
@calc_den1fft_w
@calc_den1ktw
;; @den1ktw_images
;; @den1ktw_rms_plots
;; @den1_ktt_frames
;; @den1_ktt_movie
;; @den1_fft_movie
;; @den1_kttrms_calc
;; @den1_kttrms_plots
;; @get_efield_plane
;; @save_efield_plane
;; @restore_efield_plane
;; @Ex_ymean_movie
;; @Ex_ymean_plots
;; @efield_init_plots
;; @den1_ktt_calc
;; @den1_ktt_frames
;; @den1_images
;; @efield_images
;; @Ex_mean_plots
;; @Ey_mean_plots
