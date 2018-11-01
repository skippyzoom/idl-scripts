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

;+
; Build a reference time dictionary.
; This can be useful for debugging or for using a lookup hash to build
; a new time dictionary out of a subset of all available time
; steps. There are a few options shown below, but the essential part
; is an array of time steps to pass to time_strings. This takes so
; little time that there is probably no reason to comment it out.
;-
;;==Evenly spaced steps from T0 to TF at frequency SUBSAMPLE
t0 = 0
tf = nt_max
subsample = 1
;; subsample = params.nvsqr_out_subcycle1
if params.ndim_space eq 2 then subsample *= 8L
timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;;==Specific steps
;; timesteps = params.nout*[0, $
;;                          nt_max/4, $
;;                          nt_max/2, $
;;                          3*nt_max/4, $
;;                          nt_max-1]
;;==Construct dictionary
time_ref = time_strings(long(timesteps), $
                        dt = params.dt, $
                        scale = 1e3, $
                        precision = 2)
if n_elements(subsample) ne 0 then time_ref.subsample = subsample $
else time_ref.subsample = 1

;;==Preserve reference dictionary for comparing 2D/3D
;; if params.ndim_space eq 2 then time_2D = time_ref[*]
;; if params.ndim_space eq 3 then time_3D = time_ref[*]

;+
; Analyze moment files (domain000/moments*.out).
; This does not require a time dictionary because it always reads all
; available steps.
;-
;; @analyze_moments

;+
; Make movies of den0 and den0fft_t
;-
;; t0 = 0
;; tf = nt_max
;; subsample = 1
;; if params.ndim_space eq 2 then subsample *= 8L
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; if n_elements(subsample) ne 0 then time.subsample = subsample $
;; else time.subsample = 1
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
;; t0 = 0
;; tf = nt_max
;; subsample = 1
;; if params.ndim_space eq 2 then subsample *= 8L
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; if n_elements(subsample) ne 0 then time.subsample = subsample $
;; else time.subsample = 1
;; rotate = 0
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @den1_movie
;; @calc_den1fft_t
;; @den1fft_t_movie

;+
; Make single images of den0fft_t with centroid
;-
;; timesteps = params.nout*get_frm_indices(path,time_ref)
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; rotate = 0
;; @get_den0_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den0))[3]-1 do $
;;       den0[*,*,it] = rotate(den0[*,*,it],1)
;; @den0_images
;; @calc_den0fft_t
;; @calc_den0fft_t_moments
;; @den0fft_t_images

;+
; Make single images of den1fft_t with centroid
;-
;; timesteps = params.nout*get_frm_indices(path,time_ref)
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; rotate = 0
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @den1_images
;; @calc_den1fft_t
;; @calc_den1fft_t_moments
;; @den1fft_t_images

;+
; Make survey images of den0 and den0fft_t
; If creating den0/temp1 surveys below, it's more efficient to
; created the den0 and den1fft_t surveys there.
;-
;; t0 = 0
;; tf = nt_max
;; subsample = params.nvsqr_out_subcycle1
;; if params.ndim_space eq 2 then subsample *= 8L
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; if n_elements(subsample) ne 0 then time.subsample = subsample $
;; else time.subsample = 1
;; rotate = 0
;; @get_den0_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den0))[3]-1 do $
;;       den0[*,*,it] = rotate(den0[*,*,it],1)
;; @den0_survey
;; @calc_den0fft_t
;; @den0fft_t_survey

;+
; Make survey images of den1 and den1fft_t.
; If creating den1/temp1 surveys below, it's more efficient to
; created the den1 and den1fft_t surveys there.
;-
;; t0 = 0
;; tf = nt_max
;; subsample = params.nvsqr_out_subcycle1
;; if params.ndim_space eq 2 then subsample *= 8L
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; if n_elements(subsample) ne 0 then time.subsample = subsample $
;; else time.subsample = 1
;; rotate = 0
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @den1_survey
;; @calc_den1fft_t
;; @den1fft_t_survey

;+
; Make images and plots of RMS or full-time den0fft_t with centroid
;-
;; t0 = 0
;; tf = nt_max
;; subsample = 1
;; if params.ndim_space eq 2 then subsample *= 8L
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; if n_elements(subsample) ne 0 then time.subsample = subsample $
;; else time.subsample = 1
;; rotate = 0
;; @get_den0_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den0))[3]-1 do $
;;       den0[*,*,it] = rotate(den0[*,*,it],1)
;; @calc_den0fft_t
;; @calc_den0fft_t_moments
;; @den0fft_t_rcm_theta_plot
;; @calc_den0fft_t_rms_moments
;; @den0fft_t_rms_images

;+
; Make images and plots of RMS or full-time den1fft_t with centroid
;-
;; t0 = 0
;; tf = nt_max
;; subsample = 1
;; if params.ndim_space eq 2 then subsample *= 8L
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; if n_elements(subsample) ne 0 then time.subsample = subsample $
;; else time.subsample = 1
;; rotate = 0
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @calc_den1fft_t
;; @calc_den1fft_t_moments
;; @den1fft_t_rcm_theta_plot
;; @calc_den1fft_t_rms_moments
;; @den1fft_t_rms_images

;; modes = fftfreq(nx,dx)
;; lambda = 1.0/modes[1:nx/2]
;; theta = [0,2*!pi]
;; @calc_den1rmsktt
;; @calc_cg_den1rmsktt

;+
; Build den1ktt and save it
;-
;; t0 = 0
;; tf = nt_max
;; subsample = 1
;; if params.ndim_space eq 2 then subsample *= 8L
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; if n_elements(subsample) ne 0 then time.subsample = subsample $
;; else time.subsample = 1
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

;+
; Restore den1ktt and make an image
;-
;; restore, filename=expand_path(path)+path_sep()+den1ktt_save_name,/verbose
;; @calc_cg_den1ktt
;; @den1ktt_rms_images

;+
; Build den1ktw and make images
;-
;; t0 = 0
;; tf = nt_max
;; subsample = 1
;; if params.ndim_space eq 2 then subsample *= 2L
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; if n_elements(subsample) ne 0 then time.subsample = subsample $
;; else time.subsample = 1
;; rotate = 0
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @calc_den1fft_w
;; theta = [-90,+90]*!dtor
;; lambda = [3.0,5.0,10.0]
;; @calc_den1ktw
;; moments = read_moments(path=path)
;; Cs_rms = rms(moments.Cs[nt_max/2:*])
;; @den1ktw_images

;+
; Plot averaged temperatures (independent of axes)
; These do not require a time dictionary.
;-
;; moments = read_moments(path=path)
;; @average_temperature_plot

;+
; Make images of theoretical temperature/density ratio given by
; Equation 40 in Dimant & Oppenheim (2004)
;-
;; @fbfa_do2004_eqn40_images

;+
; Build temp0 and save it
;-
;; t0 = 0
;; tf = nt_max
;; subsample = params.nvsqr_out_subcycle0
;; if params.ndim_space eq 2 then subsample *= 8L
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; if n_elements(subsample) ne 0 then time.subsample = subsample $
;; else time.subsample = 1
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
; Make single frames of temp0 and den0
; Calling get_den0_plane after restoring the save file ensures that
; get_den0_plane uses the appropriate time dictionary
;-
;; restore, filename=expand_path(path)+path_sep()+'temp0-'+axes+'.sav', $
;;          /verbose
;; timesteps = params.nout*get_frm_indices(path,time_ref)
;; if params.ndim_space eq 2 then timesteps *= 8L
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; temp0 = temp0[*,*, $
;;               get_frm_indices(path,time_ref)/params.nvsqr_out_subcycle0]
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(temp0))[3]-1 do $
;;       temp0[*,*,it] = rotate(temp0[*,*,it],1)
;; @get_den0_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den0))[3]-1 do $
;;       den0[*,*,it] = rotate(den0[*,*,it],1)
;; @den0_images
;; @calc_den0fft_t
;; ;; @calc_den0fft_t_moments
;; @den0fft_t_images
;; @calc_nT0_phase_quantities
;; @nT0_rat_phase_images

;+
; Make survey frames of temp0 and den0
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
;; @den0_survey
;; @calc_den0fft_t
;; ;; @calc_den0fft_t_moments
;; @den0fft_t_survey
;; ;; @nT0_phase_plot
;; ;; @nT0_gen_phase_plot
;; @calc_nT0_phase_quantities
;; @nT0_rat_phase_survey
;; ;; @nT0_dif_phase_survey

;+
; Build temp1 and save it
;-
;; t0 = 0
;; tf = nt_max
;; subsample = params.nvsqr_out_subcycle1
;; if params.ndim_space eq 2 then subsample *= 8L
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; if n_elements(subsample) ne 0 then time.subsample = subsample $
;; else time.subsample = 1
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
; Make single frames of temp1 and den1
; Calling get_den1_plane after restoring the save file ensures that
; get_den1_plane uses the appropriate time dictionary
;-
;; restore, filename=expand_path(path)+path_sep()+'temp1-'+axes+'.sav', $
;;          /verbose
;; timesteps = params.nout*get_frm_indices(path,time_ref)
;; if params.ndim_space eq 2 then timesteps *= 8L
;; time = time_strings(long(timesteps), $
;;                     dt = params.dt, $
;;                     scale = 1e3, $
;;                     precision = 2)
;; temp1 = temp1[*,*, $
;;               get_frm_indices(path,time_ref)/params.nvsqr_out_subcycle1]
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(temp1))[3]-1 do $
;;       temp1[*,*,it] = rotate(temp1[*,*,it],1)
;; @get_den1_plane
;; if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
;;    for it=0,(size(den1))[3]-1 do $
;;       den1[*,*,it] = rotate(den1[*,*,it],1)
;; @den1_images
;; @calc_den1fft_t
;; ;; @calc_den1fft_t_moments
;; @den1fft_t_images
;; @calc_nT1_phase_quantities
;; @nT1_rat_phase_images

;+
; Make survey frames of temp1 and den1
; Calling get_den1_plane after restoring the save file ensures that
; get_den1_plane uses the appropriate time dictionary
;-
ind_mask = 2*(1+indgen(16))
restore, filename=expand_path(path)+path_sep()+'temp1-'+axes+'.sav', $
         /verbose
if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
   for it=0,(size(temp1))[3]-1 do $
      temp1[*,*,it] = rotate(temp1[*,*,it],1)
@get_den1_plane
if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
   for it=0,(size(den1))[3]-1 do $
      den1[*,*,it] = rotate(den1[*,*,it],1)
@den1_survey
@calc_den1fft_t
;; @calc_den1fft_t_moments
@den1fft_t_survey
;; @nT1_phase_plot
;; @nT1_gen_phase_plot
@calc_nT1_phase_quantities
@nT1_rat_phase_survey
;; @nT1_dif_phase_survey

;;==Print a new line at the very end
print, ' '
