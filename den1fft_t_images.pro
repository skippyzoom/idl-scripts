;+
; Script for making frames from a plane of EPPIC den1fft_t data (i.e.,
; den1 data after spectral transform in space only). See calc_den1fft_t.pro
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den1fft_t'+ $
           '-self_norm'+ $
           '-zoom'+ $
           '-'+time.index+ $
           '.'+get_extension(frame_type)

;;==Get the number of time steps
nt = n_elements(time.index)

;;==Preserve raw FFT
fdata = den1fft_t

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Shift FFT
fdata = shift(fdata,nkx/2,nky/2,0)

;;==Suppress lowest frequencies
dc = {x:16, y:4}
fdata[nkx/2-dc.x:nkx/2+dc.x-1, $
      nky/2-dc.y:nky/2+dc.y-1,*] = min(fdata)

;;==Covert to decibels
fdata = 10*alog10(fdata^2)

;;==Set non-finite values to smallest finite value
fdata[where(~finite(fdata))] = min(fdata[where(finite(fdata))])

;;==Normalize to 0 = alog10(1)
;; fdata -= max(fdata)
;; for it=0,nt-1 do $
;;    fdata[*,*,it] -= max(fdata[*,*,it])

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Declare an array of image handles
frm = objarr(nt)

;;==Create image frames
for it=0,nt-1 do $
   frm[it] = image(fdata[*,*,it]-max(fdata[*,*,it]), $
                   kxdata,kydata, $
                   min_value = -30, $
                   max_value = 0, $
                   rgb_table = 39, $
                   axis_style = 1, $
                   position = [0.10,0.10,0.80,0.80], $
                   ;; xrange = [0,+2*!pi], $
                   ;; yrange = [-2*!pi,+2*!pi], $
                   xrange = [0,+!pi], $
                   yrange = [-!pi,+!pi], $
                   xmajor = 5, $
                   xminor = 1, $
                   ymajor = 5, $
                   yminor = 1, $
                   xstyle = 1, $
                   ystyle = 1, $
                   xsubticklen = 0.5, $
                   ysubticklen = 0.5, $
                   xtickdir = 1, $
                   ytickdir = 1, $
                   xtitle = 'Zonal [m$^{-1}$]', $
                   ytitle = 'Vertical [m$^{-1}$]', $
                   xticklen = 0.02, $
                   yticklen = 0.02, $
                   xshowtext = 1, $
                   yshowtext = 1, $
                   xtickfont_size = 12.0, $
                   ytickfont_size = 12.0, $
                   font_name = 'Times', $
                   font_size = 18.0, $
                   /buffer)

;;==Add a colorbar to each image
for it=0,nt-1 do $
   clr = colorbar(target = frm[it], $
                  title = '$P(\delta n/n_I)$', $
                  major = 7, $
                  minor = 3, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [0.82,0.10,0.84,0.80], $
                  font_size = 12.0, $
                  font_name = 'Times', $
                  hide = 0)

;;==Add radius and angle markers
;; r_overlay = 2*!pi/(1+findgen(6))
r_overlay = 2*!pi/(2+findgen(6))
theta_overlay = 10*(findgen(19)-9)
for it=0,nt-1 do $
   frm[it] = overlay_rtheta(frm[it], $
                            r_overlay, $
                            theta_overlay, $
                            /degrees, $
                            r_color = 'white', $
                            r_thick = 1, $
                            r_linestyle = 'solid_line', $
                            theta_color = 'white', $
                            theta_thick = 1, $
                            theta_linestyle = 'solid_line')

;;==Add a path label
for it=0,nt-1 do $
   txt = text(0.0,0.90, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save individual images
for it=0,nt-1 do $
   frame_save, frm[it],filename=filename[it]

;; ;;==Clear fdata
;; fdata = !NULL
