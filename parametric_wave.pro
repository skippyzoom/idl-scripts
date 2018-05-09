;+
; Script for parametric_wave project
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

path = get_base_dir()+path_sep()+'parametric_wave/run018/'
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

time = time_strings(params.nout*lindgen(params.nt_max), $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)
;; time = time_strings(params.nout* $
;;                     [1,5,10, $
;;                      params.nt_max/4, $
;;                      params.nt_max/2, $
;;                      3*params.nt_max/4, $
;;                      params.nt_max-1], $
;;                     dt=params.dt,scale=1e3,precision=2)
;; time = time_strings([params.nout, $
;;                      5*params.nout, $
;;                      10*params.nout, $
;;                      1152, $
;;                      3232, $
;;                      params.nout*(2*(params.nt_max/2))], $
;;                     dt=params.dt,scale=1e3,precision=2)
;; time = time_strings([0,params.nout], $
;;                     dt=params.dt,scale=1e3,precision=2)

;; @analyze_moments
;; @get_den1_plane
;; rms_range = [[         0,  nt_max/4], $
;;              [  nt_max/4,  nt_max/2], $
;;              [  nt_max/2,3*nt_max/4], $
;;              [3*nt_max/4,2*(nt_max/2)]]
;; @den1_ktt_calc
;; @den1_ktt_frames
;; @den1_ktt_movie
;; @den1_movie
;; @den1_fft_calc
;; @den1_fft_movie
;; @den1_kttrms_calc
;; @den1_kttrms_frames
;; @get_efield_plane
;; @save_efield_plane
;; @restore_efield_plane
;; @Ex_ymean_movie
;; @efield_init_plots
;; @get_den1_plane
;; @den1_ktt_calc
;; @den1_ktt_frames
;; @den1_images
;; @efield_images
;; @Ex_mean_plots
;; @Ey_mean_plots
