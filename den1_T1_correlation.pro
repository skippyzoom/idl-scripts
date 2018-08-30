;+
; Can I determine the phase offset of density and temperature
; perturbations during linear growth?
;
; This script assumes you've run fb_flow_angle_analysis to read
; den1 and build temp1
;
; Warning: This script is pretty hacky!
;-

save_frames = 1B

if n_elements(frame_type) eq 0 then frame_type = '.pdf'

nt = n_elements(time.index)
T1 = temp1/mean(temp1) - 1

x0 = 3*nx/4-128
xf = 3*nx/4+128
y0 = ny/2-128
yf = ny/2+128

den = den1[x0:xf-1,y0:yf-1,*]
temp = T1[x0:xf-1,y0:yf-1,*]

fft_den = den*0.0
for it=0,nt-1 do $
   fft_den[*,*,it] = 10*alog10(abs(fft(den[*,*,it],/center))^2)
fft_den = smooth(fft_den,[5,5,0],/edge_wrap)
for it=0,nt-1 do $
   fft_den[*,*,it] -= max(fft_den[*,*,it])

fft_temp = temp*0.0
for it=0,nt-1 do $
   fft_temp[*,*,it] = 10*alog10(abs(fft(temp[*,*,it],/center))^2)
fft_temp = smooth(fft_temp,[5,5,0],/edge_wrap)
for it=0,nt-1 do $
   fft_temp[*,*,it] -= max(fft_temp[*,*,it])

kxdata = 2*!pi*fftfreq(nx,dx)
kxdata = shift(kxdata,nx/2)
kydata = 2*!pi*fftfreq(ny,dy)
kydata = shift(kydata,ny/2)

den_cor = den*0.0
for it=0,nt-1 do $
   den_cor[*,*,it] = convol_fft(den[*,*,it], $
                                 temp[*,*,it], $
                                 /correlate)

position = multi_position([2,2], $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffers = [0.1,0.1])
frm = objarr(nt)
sw = [1/dx,1/dy]

;; kx0 = nx/2-64
;; kxf = nx/2+64
;; ky0 = ny/2-64
;; kyf = ny/2+64

;; for it=0,nt-1 do $
;;    frm[it] = image(smooth(den[*,*,it],sw,/edge_wrap), $
;;                    ;; xdata,ydata, $
;;                    rgb_table = 5, $
;;                    ;; layout = [2,2,1], $
;;                    position = position[*,0], $
;;                    ;; min_value = -max(abs(den[*,*,it])), $
;;                    ;; max_value = +max(abs(den[*,*,it])), $
;;                    min_value = -0.3, $
;;                    max_value = +0.3, $
;;                    axis_style = 2, $
;;                    title = '$n_i$ '+time.stamp[it], $
;;                    /buffer)
;; for it=0,nt-1 do $
;;    !NULL = image(smooth(temp[*,*,it],sw,/edge_wrap), $
;;                  ;; xdata,ydata, $
;;                  rgb_table = 5, $
;;                  ;; layout = [2,2,2], $
;;                  position = position[*,1], $
;;                  ;; min_value = -max(abs(temp[*,*,it])), $
;;                  ;; max_value = +max(abs(temp[*,*,it])), $
;;                  min_value = -0.07, $
;;                  max_value = +0.07, $
;;                  axis_style = 2, $
;;                  title = '$T_i$ '+time.stamp[it], $
;;                  current = frm[it])
;; for it=0,nt-1 do $
;;    ;; !NULL = image(fft_temp[kx0:kxf-1,ky0:kyf-1,it], $
;;    !NULL = image(fft_temp[*,*,it], $
;;                  ;; kxdata,kydata, $
;;                  rgb_table = 39, $
;;                  ;; layout = [2,2,3], $
;;                  position = position[*,2], $
;;                  axis_style = 2, $
;;                  min_value = -30, $
;;                  max_value = 0, $
;;                  ;; xrange = [-!pi,+!pi], $
;;                  ;; yrange = [-!pi,+!pi], $
;;                  title = 'FFT($T_i$) '+time.stamp[it], $
;;                  current = frm[it])
;; for it=0,nt-1 do $
;;    !NULL = image(den_cor[*,*,it], $
;;                  rgb_table = 39, $
;;                  ;; layout = [2,2,4], $
;;                  position = position[*,3], $
;;                  axis_style = 2, $
;;                  title = 'Corr($n_i$,$T_i$) '+time.stamp[it], $
;;                  current = frm[it])
;; for it=0,nt-1 do $
;;    txt = text(0.0,0.005, $
;;               path, $
;;               target = frm[it], $
;;               font_name = 'Courier', $
;;               font_size = 10.0)
;; filename = expand_path(path+path_sep()+'frames')+ $
;;            path_sep()+'den1_T1-corr'+ $
;;            '-'+axes+ $
;;            '-'+time.index+ $
;;            '.'+get_extension(frame_type)
;; if keyword_set(save_frames) then $
;;    for it=0,nt-1 do $
;;       frame_save, frm[it],filename = filename[it]

cnx = abs(xf-x0)
cny = abs(yf-y0)
cx0 = cnx/2-32
cxf = cnx/2+32
cy0 = cny/2-32
cyf = cny/2+32

max_cor = fltarr(nt)
for it=0,nt-1 do $
   max_cor[it] = max(den_cor[cx0:cxf-1,cy0:cyf-1,it])

imax_cor = lonarr(nt)
for it=0,nt-1 do $
   imax_cor[it] = where(den_cor[cx0:cxf-1,cy0:cyf-1,it] eq max_cor[it])

imax2d = lonarr(nt,2)
for it=0,nt-1 do $
   imax2d[it,*] = array_indices(den_cor[cx0:cxf-1,cy0:cyf-1,it],imax_cor[it])

min_cor = fltarr(nt)
for it=0,nt-1 do $
   min_cor[it] = min(den_cor[cx0:cxf-1,cy0:cyf-1,it])

imin_cor = lonarr(nt)
for it=0,nt-1 do $
   imin_cor[it] = where(den_cor[cx0:cxf-1,cy0:cyf-1,it] eq min_cor[it])

imin2d = lonarr(nt,2)
for it=0,nt-1 do $
   imin2d[it,*] = array_indices(den_cor[cx0:cxf-1,cy0:cyf-1,it],imin_cor[it])

offset = lonarr(nt,2)
for it=0,nt-1 do $
   offset[it,*] = [cnx/2-1,cny/2-1]-imax2d[it,*]

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
;; phase = fltarr(nt)
;; k_val = 2*!pi/2.83
;; for it=0,nt-1 do $
;;    phase[it] = sqrt((offset[it,0]*dx)^2 + (offset[it,1]*dy)^2)*k_val

phase = phase/!dtor mod 360

position = multi_position([1,2], $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffer = [0.1,0.1])
frm = plot(time.index*params.dt*1e3, $
           max_cor, $
           'ko', $
           xstyle = 1, $
           position = position[*,0], $
           xtitle = 'Time [ms]', $
           ytitle = 'max{Corr(den1,T1)}', $
           /buffer)
!NULL = plot(time.index*params.dt*1e3, $
             min_cor, $
             'ko', $
             xstyle = 1, $
             position = position[*,1], $
             xtitle = 'Time [ms]', $
             ytitle = 'min{Corr(den1,T1)}', $
             current = frm)
txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den1_T1-corr_min_max'+ $
           '-'+axes+ $
           '.'+get_extension(frame_type)
if keyword_set(save_frames) then $
   frame_save, frm,filename = filename

frm = plot(time.index*params.dt*1e3, $
           lambda, $
           'ko', $
           xstyle = 1, $
           yrange = [floor(4*dx),10], $
           position = position[*,0], $
           xtitle = 'Time [ms]', $
           ytitle = 'Wavelength [m]', $
           /buffer)
!NULL = plot(time.index*params.dt*1e3, $
             phase, $
             'ko', $
             xstyle = 1, $
             yrange = [0,360], $
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
           path_sep()+'den1_T1-lambda_phase'+ $
           '-'+axes+ $
           '.'+get_extension(frame_type)
if keyword_set(save_frames) then $
   frame_save, frm,filename = filename
