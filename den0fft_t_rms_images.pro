;+
; Script for making frames from a plane of EPPIC den0fft_t data after RMS
; over time.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Get the number of time steps
if time.haskey('nt') then nt = time.nt $
else nt = n_elements(time.index)

;;==Get subsample frequency
if time.haskey('subsample') then subsample = time.subsample

;;==Declare RMS time ranges (assuming all time steps are in memory)
if n_elements(subsample) eq 0 then subsample = 1
if params.ndim_space eq 2 then $
   rms_time = [[22528/params.nout,62464/params.nout], $
               [159744/params.nout,nt-1]]/subsample
if params.ndim_space eq 3 then $
   rms_time = [[5760/params.nout,10368/params.nout], $
               [19968/params.nout,nt-1]]/subsample

rms_time = transpose(rms_time)
n_rms = (size(rms_time))[1]

;;==Declare file name(s)
str_rms_time = string(rms_time*params.nout,format='(i06)')
filename = strarr(n_rms)
for it=0,n_rms-1 do $
   filename[it] = expand_path(path+path_sep()+'frames')+ $
   path_sep()+'den0fft_t_rms'+ $
   '-'+axes+ $
   '-'+str_rms_time[it]+ $
   '-'+str_rms_time[it+n_rms]+ $
   '-self_norm'+ $
   '-zoom'+ $
   '.'+get_extension(frame_type)

;;==Preserve raw FFT
fdata = den0fft_t

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Declare ranges to show
x0 = nkx/2-nkx/4
xf = nkx/2+nkx/4
y0 = nky/2
yf = nky/2+nky/4
;; x0 = nkx/2
;; xf = nkx/2+nkx/4
;; y0 = nky/2-nky/4
;; yf = nky/2+nky/4
;; x0 = nkx/2-nkx/2
;; xf = nkx/2+nkx/2
;; y0 = nky/2
;; yf = nky/2+nky/16

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Compute RMS values
fdata_rms = fltarr(nx,ny,n_rms)
for it=0,n_rms-1 do $
   fdata_rms[*,*,it] = rms(fdata[*,*,rms_time[it,0]:rms_time[it,1]],dim=3)

;;==Shift FFT
fdata_rms = shift(fdata_rms,nkx/2,nky/2,0)

;;==Suppress lowest frequencies
dc_width = {xn:0, xp:0, $
            yn:0, yp:0}
fdata_rms[nkx/2-dc_width.xn:nkx/2+dc_width.xp, $
          nky/2-dc_width.yn:nky/2+dc_width.yp,*] = min(fdata_rms)

;;==Rotate image
;; for it=0,n_rms-1 do $
;;    fdata_rms[*,*,it] = rotate(fdata_rms[*,*,it],3)

;;==Covert to decibels
fdata_rms = 10*alog10(fdata_rms^2)

;;==Set non-finite values to smallest finite value
fdata_rms[where(~finite(fdata_rms))] = min(fdata_rms[where(finite(fdata_rms))])

;;==Normalize to 0 (i.e., logarithm of 1)
;; fdata_rms -= max(fdata_rms)
for it=0,n_rms-1 do $
   fdata_rms[*,*,it] -= max(fdata_rms[*,*,it])

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Declare an array of image handles
frm = objarr(n_rms)

;;==Create image frames
for it=0,n_rms-1 do $
   frm[it] = image(fdata_rms[x0:xf-1,y0:yf-1,it], $
                   kxdata[x0:xf-1],kydata[y0:yf-1], $
                   min_value = -30, $
                   max_value = 0, $
                   rgb_table = 39, $
                   axis_style = 1, $
                   position = [0.10,0.10,0.80,0.80], $
                   ;; xrange = [0,+!pi], $
                   ;; xtickvalues = [0,+!pi/2,+!pi], $
                   ;; yrange = [-!pi,+!pi], $
                   ;; ytickvalues = [-!pi,-!pi/2,0,+!pi/2,+!pi], $
                   ;; xmajor = 3, $
                   ;; xminor = 1, $
                   ;; ymajor = 3, $
                   ;; yminor = 3, $
                   ;; xrange = [-!pi,+!pi], $
                   ;; xtickvalues = [-!pi,-!pi/2,0,+!pi/2,+!pi], $
                   ;; yrange = [0,+!pi], $
                   ;; ytickvalues = [0,+!pi/2,+!pi], $
                   xrange = [-!pi/4,+!pi/4], $
                   yrange = [0,+2*!pi], $
                   xmajor = 3, $
                   xminor = 3, $
                   ymajor = 3, $
                   yminor = 3, $
                   ;; xrange = [-!pi/16,+!pi/16], $
                   ;; xtickvalues = [-!pi/16,0,+!pi/16], $
                   ;; yrange = [0,+2*!pi], $
                   ;; ytickvalues = [0,+!pi,+2*!pi], $
                   ;; xmajor = 3, $
                   ;; xminor = 1, $
                   ;; ymajor = 3, $
                   ;; yminor = 3, $
                   xstyle = 1, $
                   ystyle = 1, $
                   xsubticklen = 0.5, $
                   ysubticklen = 0.5, $
                   xtickdir = 1, $
                   ytickdir = 1, $
                   ;; xtitle = 'Hall [m$^{-1}$]', $
                   ;; ytitle = 'Pedersen [m$^{-1}$]', $
                   ;; xtitle = 'Parallel [m$^{-1}$]', $
                   ;; ytitle = 'Pedersen [m$^{-1}$]', $
                   ;; xtitle = 'Parallel [m$^{-1}$]', $
                   ;; ytitle = 'Hall [m$^{-1}$]', $
                   xticklen = 0.02, $
                   yticklen = 0.04, $
                   xshowtext = 1, $
                   yshowtext = 1, $
                   xtickfont_size = 12.0, $
                   ytickfont_size = 12.0, $
                   font_name = 'Times', $
                   font_size = 18.0, $
                   /buffer)

;;==Add a colorbar to each image
for it=0,n_rms-1 do $
   clr = colorbar(target = frm[it], $
                  title = '$P(\delta n/n_I)$', $
                  major = 7, $
                  minor = 3, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [0.84,0.10,0.86,0.80], $
                  font_size = 12.0, $
                  font_name = 'Times', $
                  hide = 0)

;; ;;==Add radius and angle markers
;; ;; r_overlay = 2*!pi/(2+findgen(9))
;; r_overlay = 2*!pi/(1+findgen(10))
;; theta_overlay = 10*findgen(36)
;; for it=0,n_rms-1 do $
;;    frm[it] = overlay_rtheta(frm[it], $
;;                             r_overlay, $
;;                             theta_overlay, $
;;                             /degrees, $
;;                             r_color = 'white', $
;;                             r_thick = 1, $
;;                             r_linestyle = 'solid_line', $
;;                             theta_color = 'white', $
;;                             theta_thick = 1, $
;;                             theta_linestyle = 'solid_line')

;;==Add a path label
for it=0,n_rms-1 do $
   txt = text(0.0,0.90, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Find location of max pixel in growth image
imax2d = array_indices(fdata_rms[x0:xf-1,y0:yf-1,0], $
                       where(fdata_rms[x0:xf-1,y0:yf-1,0] eq $
                             max(fdata_rms[x0:xf-1,y0:yf-1,0])))
ikx = x0+imax2d[0]
iky = y0+imax2d[1]
peak_lambda = 2*!pi/sqrt(kxdata[ikx]^2 + kydata[iky]^2)
;; print, "Wavelength of peak growth = ",peak_lambda," m"
peak_theta = atan(kydata[iky],kxdata[ikx])/!dtor
;; print, "Flow angle of peak growth = ",peak_theta," deg"

;;==Print wavelength and angle of max pixel on image frame
txt = text(0.0,0.01, $
           "Peak $\lambda$ = "+ $
           strcompress(string(peak_lambda),/remove_all)+ $
           " m       "+ $
           "Peak $\theta$ = "+ $
           strcompress(string(peak_theta),/remove_all)+ $
           " deg", $
           target = frm[0], $
           font_name = 'Times', $
           font_size = 10.0)

;;==Save individual images
for it=0,n_rms-1 do $
   frame_save, frm[it],filename=filename[it]

;;==Clear fdata
;; fdata = !NULL
