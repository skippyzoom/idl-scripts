;+
; Script for parametric_wave project
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

if n_elements(path) eq 0 then $
   path = get_base_dir()+path_sep()+ $
          ;; 'parametric_wave/nue_3.0e4-amp_0.10-E0_9.0/'
          ;; 'parametric_wave/nue_3.0e4-amp_0.10-E0_9.0-doubled/'
          'parametric_wave/nue_3.0e4-amp_0.05-E0_9.0-petsc_subcomm/'
if n_elements(lun) eq 0 then lun = -1
printf, lun, "[PARAMETRIC_WAVE] path = "+path
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
                   '-subsample_2'+ $
                   ;; '-initial_five_steps'+ $
                   '.sav'
subsample = 2
t0 = 0
tf = params.nt_max
timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))

;; timesteps = params.nout*[1,params.nt_max-1]

;; timesteps = [params.nout, $
;;              5*params.nout, $
;;              10*params.nout, $
;;              5056, $
;;              15104, $
;;              2048, $
;;              10048, $
;;              params.nout*(2*(params.nt_max/2))]

;; nt = 5
;; timesteps = params.nout*lindgen(nt)

time = time_strings(timesteps, $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)

;; @analyze_moments

;; @get_nvsqrx1_plane
;; @get_nvsqry1_plane

;; @get_fluxx1_plane
;; @get_fluxy1_plane
;; fluxx1 = shift(fluxx1,[nx/4,0,0])
;; fluxy1 = shift(fluxy1,[nx/4,0,0])

@get_den1_plane
den1 = shift(den1,[nx/4,0,0])
;; @den1_images

@den1_movie
;; @calc_den1fft_t
;; @den1fft_t_movie
;; @calc_den1ktt
;; @den1ktt_movie
;; @calc_den1ktt_rms
;; save, time,den1ktt_rms, $
;;       filename=expand_path(path)+path_sep()+ $
;;       'den1ktt_rms-02to05_meter-044to046_deg.sav'
;; @den1ktt_rms_plots

;; @calc_den1fft_w
;; @calc_den1ktw
;; @den1ktw_images
;; @den1ktw_rms_plots

;; @den1_ktt_frames
;; @den1_ktt_movie
;; @den1_fft_movie
;; @den1_kttrms_calc
;; @den1_kttrms_plots

;; @get_efield_plane
;; save, time,efield,filename=efield_save_name

;; @get_efield_plane
;; @build_efield_components
;; shifts = [nx/4,0,0]
;; Ex = shift(Ex,shifts)
;; Ey = shift(Ey,shifts)
;; Er = shift(Er,shifts)
;; Et = shift(Et,shifts)

;; @calc_Erfft_t
;; save, time,Erfft_t, $
;;       filename=expand_path(path)+path_sep()+'Erfft_t.sav'

;; restore, filename=efield_save_name,/verbose
;; @load_plane_params
;; @build_efield_components
;; shifts = [nx/4,0,0]
;; Ex = shift(Ex,shifts)
;; Ey = shift(Ey,shifts)
;; Er = shift(Er,shifts)
;; Et = shift(Et,shifts)

;; @calc_Erfft_t
;; save, time,Erfft_t, $
;;       filename=expand_path(path)+path_sep()+'Erfft_t.sav'

;; @calc_Erktt

;; @calc_Erfft_t
;; theta = [44,46]*!dtor
;; ;; lambda = [3.0,10.6]
;; lam0 = 2.0
;; lamf = 5.0
;; dlam = 0.1
;; lambda = [2.0+dlam*findgen((lamf-lam0)/dlam + 1)]
;; @calc_Erktt_rms
;; save, time,Erktt_rms, $
;;       filename=expand_path(path)+path_sep()+ $
;;       'Erktt_rms-02to05_meter-044to046_deg.sav'
;; lambda = 50.0
;; @calc_Erktt_rms
;; save, time,Erktt_rms, $
;;       filename=expand_path(path)+path_sep()+ $
;;       'Erktt_rms-50_meter-044to046_deg.sav'

;; @Ex_ymean_movie
;; @Ex_ymean_plots
;; @efield_init_plots
;; @den1_ktt_calc
;; @den1_ktt_frames
;; @den1_images
;; @efield_images
;; @Ex_mean_plots
;; @Ey_mean_plots
