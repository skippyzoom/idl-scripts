;+
; Can I determine the phase offset of density and temperature
; perturbations during linear growth?
;
; This script assumes you've run fb_flow_angle_analysis to read
; den0 and build temp0
;
; Warning: This script is pretty hacky!
;-

save_frames = 1B

if n_elements(frame_type) eq 0 then frame_type = '.pdf'

nt = n_elements(time.index)
T0 = temp0/mean(temp0) - 1

fft_den0 = den0*0.0
for it=0,nt-1 do $
   fft_den0[*,*,it] = 10*alog10(abs(fft(den0[*,*,it],/center))^2)
fft_den0 = smooth(fft_den0,[5,5,0],/edge_wrap)
for it=0,nt-1 do $
   fft_den0[*,*,it] -= max(fft_den0[*,*,it])

fft_T0 = T0*0.0
for it=0,nt-1 do $
   fft_T0[*,*,it] = 10*alog10(abs(fft(T0[*,*,it],/center))^2)
fft_T0 = smooth(fft_T0,[5,5,0],/edge_wrap)
for it=0,nt-1 do $
   fft_T0[*,*,it] -= max(fft_T0[*,*,it])

kxdata = 2*!pi*fftfreq(nx,dx)
kxdata = shift(kxdata,nx/2)
kydata = 2*!pi*fftfreq(ny,dy)
kydata = shift(kydata,ny/2)

den0_cor = den0*0.0
for it=0,nt-1 do $
   den0_cor[*,*,it] = convol_fft(den0[*,*,it], $
                                 T0[*,*,it], $
                                 /correlate)

position = multi_position([2,2], $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffers = [0.1,0.1])
frm = objarr(nt)
sw = [1/dx,1/dy]

kx0 = nx/2-64
kxf = nx/2+64
ky0 = ny/2-64
kyf = ny/2+64

for it=0,nt-1 do $
   frm[it] = image(smooth(den0[*,*,it],sw,/edge_wrap), $
                   ;; xdata,ydata, $
                   rgb_table = 5, $
                   ;; layout = [2,2,1], $
                   position = position[*,0], $
                   ;; min_value = -max(abs(den0[*,*,it])), $
                   ;; max_value = +max(abs(den0[*,*,it])), $
                   min_value = -0.3, $
                   max_value = +0.3, $
                   axis_style = 2, $
                   title = '$n_e$ '+time.stamp[it], $
                   /buffer)
for it=0,nt-1 do $
   !NULL = image(smooth(T0[*,*,it],sw,/edge_wrap), $
                 ;; xdata,ydata, $
                 rgb_table = 5, $
                 ;; layout = [2,2,2], $
                 position = position[*,1], $
                 ;; min_value = -max(abs(T0[*,*,it])), $
                 ;; max_value = +max(abs(T0[*,*,it])), $
                 min_value = -0.3, $
                 max_value = +0.3, $
                 axis_style = 2, $
                 title = '$T_e$ '+time.stamp[it], $
                 current = frm[it])
for it=0,nt-1 do $
   !NULL = image(fft_T0[kx0:kxf-1,ky0:kyf-1,it], $
                 ;; kxdata,kydata, $
                 rgb_table = 39, $
                 ;; layout = [2,2,3], $
                 position = position[*,2], $
                 axis_style = 2, $
                 min_value = -30, $
                 max_value = 0, $
                 ;; xrange = [-!pi,+!pi], $
                 ;; yrange = [-!pi,+!pi], $
                 title = 'FFT($T_e$) '+time.stamp[it], $
                 current = frm[it])
for it=0,nt-1 do $
   !NULL = image(den0_cor[*,*,it], $
                 rgb_table = 39, $
                 ;; layout = [2,2,4], $
                 position = position[*,3], $
                 axis_style = 2, $
                 title = 'Corr($n_e$,$T_e$) '+time.stamp[it], $
                 current = frm[it])
for it=0,nt-1 do $
   txt = text(0.0,0.005, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den0_T0-corr'+ $
           '-'+axes+ $
           '-'+time.index+ $
           '.'+get_extension(frame_type)
if keyword_set(save_frames) then $
   for it=0,nt-1 do $
      frame_save, frm[it],filename = filename[it]

max_cor = fltarr(nt)
for it=0,nt-1 do $
   max_cor[it] = max(den0_cor[*,*,it])

imax_cor = lonarr(nt)
for it=0,nt-1 do $
   imax_cor[it] = where(den0_cor[*,*,it] eq max_cor[it])

imax2d = lonarr(nt,2)
for it=0,nt-1 do $
   imax2d[it,*] = array_indices(den0_cor[*,*,it],imax_cor[it])

min_cor = fltarr(nt)
for it=0,nt-1 do $
   min_cor[it] = min(den0_cor[*,*,it])

imin_cor = lonarr(nt)
for it=0,nt-1 do $
   imin_cor[it] = where(den0_cor[*,*,it] eq min_cor[it])

imin2d = lonarr(nt,2)
for it=0,nt-1 do $
   imin2d[it,*] = array_indices(den0_cor[*,*,it],imin_cor[it])

offset = lonarr(nt,2)
for it=0,nt-1 do $
   offset[it,*] = [nx/2-1,ny/2-1]-imax2d[it,*]

length = lonarr(nt,2)
for it=0,nt-1 do $
   length[it,*] = imax2d[it,*]-imin2d[it,*]

lambda = fltarr(nt)
for it=0,nt-1 do $
   lambda[it] = 2*sqrt((length[it,0]*dx)^2 + (length[it,1]*dy)^2)

phase = fltarr(nt)
k_val = 2*!pi/lambda
for it=0,nt-1 do $
   phase[it] = sqrt((offset[it,0]*dx)^2 + (offset[it,1]*dy)^2)*k_val[it]

phase = phase/!dtor

position = multi_position([1,2], $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffer = [0.1,0.1])
frm = plot(time.index*params.dt*1e3, $
           max_cor, $
           'ko', $
           xstyle = 1, $
           position = position[*,0], $
           xtitle = 'Time [ms]', $
           ytitle = 'max{Corr(den0)}', $
           /buffer)
!NULL = plot(time.index*params.dt*1e3, $
             min_cor, $
             'ko', $
             xstyle = 1, $
             position = position[*,1], $
             xtitle = 'Time [ms]', $
             ytitle = 'min{Corr(den0)}', $
             current = frm)
txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den0_T0-corr_min_max'+ $
           '-'+axes+ $
           '.'+get_extension(frame_type)
if keyword_set(save_frames) then $
   frame_save, frm,filename = filename

frm = plot(time.index*params.dt*1e3, $
           lambda, $
           'ko', $
           xstyle = 1, $
           position = position[*,0], $
           xtitle = 'Time [ms]', $
           ytitle = 'Wavelength [m]', $
           /buffer)
!NULL = plot(time.index*params.dt*1e3, $
             phase, $
             'ko', $
             xstyle = 1, $
             position = position[*,1], $
             xtitle = 'Time [ms]', $
             ytitle = 'Phase diff. [deg]', $
             current = frm)
txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den0_T0-lambda_phase'+ $
           '-'+axes+ $
           '.'+get_extension(frame_type)
if keyword_set(save_frames) then $
   frame_save, frm,filename = filename

;;---------;;
;; TESTING ;;
;;---------;;
;; den0_acf = den0*0.0
;; for it=0,nt-1 do $
;;    den0_acf[*,*,it] = convol_fft(den0[*,*,it], $
;;                                  den0[*,*,it], $
;;                                  /auto_correlation)
;; den0_lag = den0*0.0
;; for it=0,nt-1 do $
;;    den0_lag[*,*,it] = convol_fft(den0[*,*,it], $
;;                                  shift(den0[*,*,it],0,25), $
;;                                  /correlate)

;; imax_cor = lonarr(nt)
;; for it=0,nt-1 do $
;;    imax_cor[it] = where(den0_cor[*,*,it] eq max(den0_cor[*,*,it]))

;; imax_acf = lonarr(nt)
;; for it=0,nt-1 do $
;;    imax_acf[it] = where(den0_acf[*,*,it] eq max(den0_acf[*,*,it]))

;; imax_lag = lonarr(nt)
;; for it=0,nt-1 do $
;;    imax_lag[it] = where(den0_lag[*,*,it] eq max(den0_lag[*,*,it]))

;; ;;-->Convert these to 2-D indices via array_indices() and calculate
;; ;;-->the shift from center. Use imax_lag to check the approach. That
;; ;;-->offset should give the phase difference between waves in the
;; ;;-->linear stage (again, you can check this with den0_lag).

;; imax2d = lonarr(nt,2)
;; for it=0,nt-1 do $
;;    imax2d[it,*] = array_indices(den0_cor[*,*,it],imax_cor[it])
;;    ;; imax2d[it,*] = array_indices(den0_acf[*,*,it],imax_acf[it])
;;    ;; imax2d[it,*] = array_indices(den0_lag[*,*,it],imax_lag[it])

;; offset = lonarr(nt,2)
;; for it=0,nt-1 do $
;;    offset[it,*] = [nx/2-1,ny/2-1]-imax2d[it,*]

;; phase = fltarr(nt)
;; k_want = 2*!pi/2.63
;; for it=0,nt-1 do $
;;    phase[it] = sqrt((offset[it,0]*dx)^2 + (offset[it,1]*dy)^2)*k_want

;; phase = phase/!dtor
