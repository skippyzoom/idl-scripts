;+
; I hacked this script together to make the images of RMS(FFT(den1))
; with three angles for Chapter 6 of my dissertation.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-
;;==Read in den1, compute den1fft_t, and centroid info
t0 = 0
tf = nt_max
subsample = 1
if params.ndim_space eq 2 then subsample *= 8L
timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
time = time_strings(long(timesteps), $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)
if n_elements(subsample) ne 0 then time.subsample = subsample $
else time.subsample = 1
rotate = 0
@get_den1_plane
if (params.ndim_space eq 3 && strcmp(axes,'yz')) then $
   for it=0,(size(den1))[3]-1 do $
      den1[*,*,it] = rotate(den1[*,*,it],1)
@calc_den1fft_t_plane
@calc_den1fft_t_moments
full_rcm_theta = rcm_theta
full_dev_theta = dev_rcm_theta
@calc_den1fft_t_rms_moments
rms_rcm_theta = rcm_theta
rms_dev_theta = dev_rcm_theta
@calc_den1fft_t_theta

;;==Restore den1ktt and build den1ktt_rms
modes = fftfreq(nx,dx)
lambda = 1.0/modes[1:nx/2]
theta = [0,2*!pi]
@calc_den1ktt
@build_den1ktt_rms
ktt_norm = den1ktt_rms[0]/max(den1ktt_rms[0])-min(den1ktt_rms[0])

;;==Compute time bounds for each RMS interval
tmp_ind = transpose(get_rms_ranges(path,time))
lin_it0 = tmp_ind[0,0]
lin_itf = tmp_ind[0,1]
;; lin_it0 = min(where(ktt_norm gt 0.5))
;; lin_itf = max(where(ktt_norm lt 0.8))
;; ;; !NULL = max(ktt_norm,lin_itf)
;; sat_it0 = time.nt-8
sat_it0 = time.nt/2
sat_itf = time.nt-1

;;==Extract appropriate values of theta and uncertainty
rcm_theta = fltarr(2)
rcm_theta[0] = mean(full_rcm_theta[lin_it0:lin_itf])
rcm_theta[1] = mean(full_rcm_theta[sat_it0:sat_itf])
dev_rcm_theta = fltarr(2)
dev_rcm_theta[0] = rms_dev_theta[0]/(lin_itf-lin_it0+1)
dev_rcm_theta[1] = rms_dev_theta[1]/(sat_itf-sat_it0+1)
rms_ind = [[lin_it0,lin_itf],[sat_it0,sat_itf]]
@den1fft_t_rms_images
