;+
; Script for parametric_wave project
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

if n_elements(path) eq 0 then $
   path = get_base_dir()+path_sep()+ $
          'parametric_wave/nue_3.0e4-amp_0.10-E0_9.0-petsc_subcomm/'
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
                   ;; '-second_half'+ $
                   ;; '-initial_five_steps'+ $
                   '.sav'

;;==Declare time steps
;;-----------------------------------------------------------------------------
;; Equally spaced time steps at a subsample frequency given relative
;; to params.nout, in the range [t0,tf)
;;-----------------------------------------------------------------------------
;; ;; t0 = params.nt_max/2
;; ;; tf = params.nt_max
;; t0 = 0
;; tf = params.nt_max
;; subsample = 2
;; ;; subsample = nt_max/8
;; timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))

;;-----------------------------------------------------------------------------
;; First and last output time steps
;;-----------------------------------------------------------------------------
;; timesteps = params.nout*[1,params.nt_max-1]

;;-----------------------------------------------------------------------------
;; Original simulation runs: batch runs
;;-----------------------------------------------------------------------------
;; timesteps = [params.nout, $     ;One collision time
;;              5*params.nout, $   ;Five collision times
;;              10*params.nout, $  ;Ten collision times
;;              5056, $            ;Growth of 5% runs
;;              15104, $           ;Saturated 5% runs
;;              2048, $            ;Growth of 10% runs
;;              10048, $           ;Saturated 10% runs
;;              params.nout*(2*(params.nt_max/2))]

;;-----------------------------------------------------------------------------
;; PETSc subcomm simulation runs: most batch runs
;;-----------------------------------------------------------------------------
;; timesteps = [params.nout, $     ;One collision time
;;              5*params.nout, $   ;Five collision times
;;              10*params.nout, $  ;Ten collision times
;;              2048, $            ;Growth of 10% runs
;;              4096, $            ;Growth of 5% runs
;;              24576]             ;Saturated

;;--Testing some simulated rocket scripts
;; timesteps = [10048, $
;;              10048+150*params.nout, $
;;              10048+300*params.nout, $
;;              10048+450*params.nout]

;;-----------------------------------------------------------------------------
;; PETSc subcomm simulation runs: Ex_ymean_multiplot batch runs
;;-----------------------------------------------------------------------------
;; amp = strmid(path,strpos(path,'amp_0')+4,4)
;; if strcmp(amp,'0.10') then $
;;    timesteps = [params.nout, $  ;One collision time
;;                 2048, $         ;Growth of 10% runs
;;                 24576]          ;Saturated
;; if strcmp(amp,'0.05') then $
;;    timesteps = [params.nout, $  ;One collision time
;;                 4096, $         ;Growth of 5% runs
;;                 24576]          ;Saturated

;;-----------------------------------------------------------------------------
;; An array of 'nt' time steps, equally spaced at the output frequency
;; of this EPPIC run
;;-----------------------------------------------------------------------------
nt = 5
timesteps = params.nout*lindgen(nt)

;;==Create time struct
time = time_strings(timesteps, $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)

;; @analyze_moments

;; @get_den1_plane
;; data_shift = [nx/4,0,0]
;; den1 = shift(den1,data_shift)
;; ;; den1 = params.n0d1*(1 + den1)
;; for it=0,n_elements(time.index)-1 do $
;;    den1[*,*,it] = high_pass_filter(den1[*,*,it], $
;;                                    100, $
;;                                    dx=dx,dy=dy)

;; @calc_den1fft_t
;; @den1fft_t_images

;; @get_phi_plane
;; data_shift = [nx/4,0,0]
;; phi = shift(phi,data_shift)

;; @get_fluxx1_plane
;; data_shift = [nx/4,0,0]
;; fluxx1 = shift(fluxx1,data_shift)
;; for iy=0,ny-1 do $ ;; HACK
;;    fluxx1[512,iy,*] = 0.5*(fluxx1[511,iy,*]+fluxx1[513,iy,*])
;; for it=0,n_elements(time.index)-1 do $
;;    fluxx1[*,*,it] = high_pass_filter(fluxx1[*,*,it], $
;;                                      100, $
;;                                      dx=dx,dy=dy)
;; @fluxx1_images
;; @get_fluxy1_plane
;; data_shift = [nx/4,0,0]
;; fluxy1 = shift(fluxy1,data_shift)
;; for iy=0,ny-1 do $ ;; HACK
;;    fluxy1[512,iy,*] = 0.5*(fluxy1[511,iy,*]+fluxy1[513,iy,*])
;; for it=0,n_elements(time.index)-1 do $
;;    fluxy1[*,*,it] = high_pass_filter(fluxy1[*,*,it], $
;;                                      100, $
;;                                      dx=dx,dy=dy)
;; ;; @fluxy1_images
;; @get_fluxz1_plane
;; data_shift = [nx/4,0,0]
;; fluxz1 = shift(fluxz1,data_shift)
;; for iy=0,ny-1 do $ ;; HACK
;;    fluxz1[512,iy,*] = 0.5*(fluxz1[511,iy,*]+fluxz1[513,iy,*])
;; for it=0,n_elements(time.index)-1 do $
;;    fluxz1[*,*,it] = high_pass_filter(fluxz1[*,*,it], $
;;                                      100, $
;;                                      dx=dx,dy=dy)
;; ;; @fluxz1_images

;; @get_nvsqrx1_plane
;; data_shift = [nx/4,0,0]
;; nvsqrx1 = shift(nvsqrx1,data_shift)
;; for iy=0,ny-1 do $ ;; HACK
;;    nvsqrx1[512,iy,*] = 0.5*(nvsqrx1[511,iy,*]+nvsqrx1[513,iy,*])
;; for it=0,n_elements(time.index)-1 do $
;;    nvsqrx1[*,*,it] = high_pass_filter(nvsqrx1[*,*,it], $
;;                                       100, $
;;                                       dx=dx,dy=dy)
;; @nvsqrx1_images
;; @get_nvsqry1_plane
;; data_shift = [nx/4,0,0]
;; nvsqry1 = shift(nvsqry1,data_shift)
;; for iy=0,ny-1 do $ ;; HACK
;;    nvsqry1[512,iy,*] = 0.5*(nvsqry1[511,iy,*]+nvsqry1[513,iy,*])
;; for it=0,n_elements(time.index)-1 do $
;;    nvsqry1[*,*,it] = high_pass_filter(nvsqry1[*,*,it], $
;;                                       100, $
;;                                       dx=dx,dy=dy)
;; ;; @nvsqry1_images
;; @get_nvsqrz1_plane
;; data_shift = [nx/4,0,0]
;; nvsqrz1 = shift(nvsqrz1,data_shift)
;; for iy=0,ny-1 do $ ;; HACK
;;    nvsqrz1[512,iy,*] = 0.5*(nvsqrz1[511,iy,*]+nvsqrz1[513,iy,*])
;; for it=0,n_elements(time.index)-1 do $
;;    nvsqrz1[*,*,it] = high_pass_filter(nvsqrz1[*,*,it], $
;;                                       100, $
;;                                       dx=dx,dy=dy)
;; ;; @nvsqrz1_images

;; @calc_nvsqr1fft_t
;; @nvsqr1fft_t_images

;; @calc_nvsqr1fft_w
;; lambda = [2.0,3.0,4.0,5.0,10.0,20.0]
;; theta = [0,180]*!dtor
;; @calc_nvsqr1ktw
;; moments = read_moments(path=path)
;; Cs_rms = rms(moments.Cs[nt_max/2:*])
;; @nvsqr1ktw_images

;; @den1_images

;; @den1_movie

;; dlam = max([dx,dy])
;; lam0 = 4*dlam
;; lamf = 40*dlam
;; lambda = [lam0+dlam*findgen((lamf-lam0)/dlam + 1)]
;; theta = [40,60]*!dtor
;; dlam = max([2*!pi/nx,2*!pi/ny])
;; nlam = min([nx,ny])/2
;; lambda = !pi/(dlam*(1+findgen(nlam)))
;; theta = [0,180]*!dtor
;; den1ktt_save_name = 'den1ktt'+ $
;;                     '-'+ $
;;                     string(lambda[0],format='(f05.1)')+ $
;;                     '_'+ $
;;                     string(lambda[n_elements(lambda)-1],format='(f05.1)')+ $
;;                     '_m'+ $
;;                     '-'+ $
;;                     string(theta[0]/!dtor,format='(f05.1)')+ $
;;                     '_'+ $
;;                     string(theta[1]/!dtor,format='(f05.1)')+ $
;;                     '_deg'+ $
;;                     '.sav'
;; @calc_den1fft_t
;; @calc_den1ktt
;; save, time,den1ktt, $
;;       filename=expand_path(path)+path_sep()+den1ktt_save_name

;; @calc_den1fft_t
;; @den1fft_t_images
;; @den1fft_t_movie

;; @calc_den1ktt
;; @den1ktt_movie

;; @calc_den1fft_t
;; @calc_den1ktt

;; @get_den1_plane
;; @calc_den1fft_w
;; lambda = [3.0,5.0,10.0]
;; theta = [0,180]*!dtor
;; @calc_den1ktw
;; moments = read_moments(path=path)
;; Cs_rms = rms(moments.Cs[nt_max/2:*])
;; ;; ;; restore, filename=efield_save_name,/verbose
;; ;; ;; @load_plane_params
;; ;; @get_efield_plane
;; ;; @build_efield_components
;; ;; nt = n_elements(time.index)
;; ;; Vd_rms = rms(sqrt(((Ex+Ex0)^2 + (Ey+Ey0)^2)[*,*,nt/2:*]))/params.Bz
;; @den1ktw_images
;; ;; @den1ktw_rms_plots

;; @den1_ktt_frames
;; @den1_ktt_movie
;; @den1_fft_movie
;; @den1_kttrms_calc
;; @den1_kttrms_plots

;; @get_efield_plane
;; save, time,efield,filename=efield_save_name

;; @get_efield_plane
;; @build_efield_components
;; data_shift = [nx/4,0,0]
;; Ex = shift(Ex,data_shift)
;; Ey = shift(Ey,data_shift)
;; Er = shift(Er,data_shift)
;; Et = shift(Et,data_shift)

;; restore, filename=efield_save_name,/verbose
;; @load_plane_params
;; @build_efield_components
;; data_shift = [nx/4,0,0]
;; Ex = shift(Ex,data_shift)
;; Ey = shift(Ey,data_shift)
;; Er = shift(Er,data_shift)
;; Et = shift(Et,data_shift)

;; @EXB_angle_plot

;; @Ex_ymean_movie

;; @Ex_ymean_plots
;; @den1_Ex_ymean_plots
;; @Ex_ymean_multiplot

;; @calc_Erfft_t
;; @Erfft_t_images

;; save, time,Erfft_t, $
;;       filename=expand_path(path)+path_sep()+'Erfft_t.sav'

;; @calc_Erktt

;; @calc_Erfft_t
;; theta = [40,60]*!dtor
;; ;; lambda = [3.0,10.6]
;; lam0 = 2.0
;; lamf = 5.0
;; dlam = 0.1
;; lambda = [lam0+dlam*findgen((lamf-lam0)/dlam + 1)]
;; @calc_Erktt_rms
;; save, time,Erktt_rms, $
;;       filename=expand_path(path)+path_sep()+ $
;;       'Erktt_rms-02to05_meter-040to060_deg.sav'
;; lambda = 50.0
;; @calc_Erktt_rms
;; save, time,Erktt_rms, $
;;       filename=expand_path(path)+path_sep()+ $
;;       'Erktt_rms-50_meter-040to060_deg.sav'

;; dlam = max([dx,dy])
;; lam0 = 4*dlam
;; lamf = 40*dlam
;; lambda = [lam0+dlam*findgen((lamf-lam0)/dlam + 1)]
;; theta = [40,60]*!dtor
;; Erktt_save_name = 'Erktt'+ $
;;                   '-'+ $
;;                   string(lambda[0],format='(f04.1)')+ $
;;                   '_'+ $
;;                   string(lambda[n_elements(lambda)-1],format='(f04.1)')+ $
;;                   '_m'+ $
;;                   '-'+ $
;;                   string(theta[0]/!dtor,format='(f04.1)')+ $
;;                   '_'+ $
;;                   string(theta[1]/!dtor,format='(f04.1)')+ $
;;                   '_deg'+ $
;;                   '.sav'
;; @calc_Erfft_t
;; @calc_Erktt
;; save, time,Erktt, $
;;       filename=expand_path(path)+path_sep()+Erktt_save_name

@get_den1_plane
@get_fluxx1_plane
@get_fluxy1_plane
@get_fluxz1_plane
@get_nvsqrx1_plane
@get_nvsqry1_plane
@get_nvsqrz1_plane

if n_elements(nx) ne 0 then data_shift = [nx/4,0,0]
@shift_dist1_data
@fix_parametric_wave_defects

;; @calc_fluxx1fft_t
;; @fluxx1fft_t_images
;; @calc_fluxy1fft_t
;; @fluxy1fft_t_images

@build_temp1_from_fluxes
;; save, time,temp1, $
;;       filename=expand_path(path)+path_sep()+'temp1.sav'
;; @temp1_rms_plot
;; @thermal_instability
;; restore, filename=expand_path(path)+path_sep()+'temp1.sav'

;; @calc_temp1fft_t
;; @temp1fft_t_images

;; @vsqr_compare
;; @n1_T1_compare

;;==Print a new line at the very end
print, ' '
