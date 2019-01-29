;+
; Batch script for last-minute dissertation stuff
;-

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_050/'
;; ;; ;; rotate = 0
;; ;; ;; axes = 'xy'
;; @fb_flow_angle_analysis
;; ;; ;; @calc_den1fft_t_theta
;; ;; .r hybrid_disp_rel_plot


;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_050/'
;; @defaults_and_time
;; .r fbfa_varphi1_3D_images

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_050/'
;; @defaults_and_time
;; .r fbfa_varphi1_3D_images

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_050/'
;; @defaults_and_time
;; .r fbfa_varphi1_3D_images

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h0-Ey0_050/'
@defaults_and_time
;; .r fbfa_build_temp1_2D
;; .r fbfa_build_varphi1_2D
;; .r fbfa_varphi1_2D_images
;; .r fbfa_den1fft_t_rms_2D_images
.r fbfa_build_k_spectrum
.r fbfa_plot_k_spectrum

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h1-Ey0_050/'
;; @defaults_and_time
;; ;; .r fbfa_build_temp1_2D
;; ;; .r fbfa_build_varphi1_2D
;; ;; .r fbfa_varphi1_2D_images
;; ;; .r fbfa_den1fft_t_rms_2D_images
;; .r fbfa_build_k_spectrum
;; .r fbfa_plot_k_spectrum

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h2-Ey0_050/'
;; @defaults_and_time
;; ;; .r fbfa_build_temp1_2D
;; ;; .r fbfa_build_varphi1_2D
;; ;; .r fbfa_varphi1_2D_images
;; ;; .r fbfa_den1fft_t_rms_2D_images
;; .r fbfa_build_k_spectrum
;; .r fbfa_plot_k_spectrum

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_050/'
;; @defaults_and_time
;; ;; .r fbfa_build_temp1_3D
;; ;; .r fbfa_build_varphi1_3D
;; ;; .r fbfa_varphi1_3D_images
;; ;; .r fbfa_varphi1_2D_images
;; ;; .r fbfa_build_den1fft_t_3D
;; ;; .r fbfa_den1fft_t_rms_3D_images
;; ;; .r fbfa_den1fft_t_3D_images
;; ;; .r fbfa_build_k_spectrum.pro
;; ;; .r fbfa_plot_k_spectrum

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_050/'
;; @defaults_and_time
;; ;; .r fbfa_build_temp1_3D
;; ;; .r fbfa_build_varphi1_3D
;; ;; .r fbfa_varphi1_3D_images
;; ;; .r fbfa_varphi1_2D_images
;; ;; .r fbfa_build_den1fft_t_3D
;; ;; .r fbfa_den1fft_t_rms_3D_images
;; ;; .r fbfa_den1fft_t_3D_images
;; ;; .r fbfa_build_k_spectrum.pro
;; ;; .r fbfa_plot_k_spectrum

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_050/'
;; @defaults_and_time
;; ;; .r fbfa_build_temp1_3D
;; ;; .r fbfa_build_varphi1_3D
;; ;; .r fbfa_varphi1_3D_images
;; ;; .r fbfa_varphi1_2D_images
;; ;; .r fbfa_build_den1fft_t_3D
;; ;; .r fbfa_den1fft_t_rms_3D_images
;; ;; .r fbfa_den1fft_t_3D_images
;; ;; .r fbfa_build_k_spectrum.pro
;; ;; .r fbfa_plot_k_spectrum
