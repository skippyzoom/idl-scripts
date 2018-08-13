;+
; Script for making frames from a plane of EPPIC denft1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;; ;;==Set graphics ranges
;; x0 = nx/2-128
;; xf = nx/2+128
;; y0 = ny/2
;; yf = ny/2+128

;; ;;==Condition data for (kx,ky,t) images
;; fdata = abs(denft1)
;; fdata = shift(fdata,[nx/2,ny/2,0])
;; dc_mask = 3
;; fdata[nx/2-dc_mask:nx/2+dc_mask, $
;;       ny/2-dc_mask:ny/2+dc_mask,*] = min(fdata)
;; fdata /= max(fdata)
;; fdata = 10*alog10(fdata^2)

;; ;;==Set up kx and ky vectors for images
;; xdata = 2*!pi*fftfreq(nx,dx)
;; xdata = shift(xdata,nx/2)
;; ydata = 2*!pi*fftfreq(ny,dy)
;; ydata = shift(ydata,ny/2)

;; ;;==Load frame defaults
;; @raw_frames_defaults

;; ;;==Load default graphics keywords
;; @default_graphics_kw

;; ;;==Declare specific graphics keywords
;; dsize = size(denft1)
;; nx = dsize[1]
;; ny = dsize[2]
;; data_aspect = float(yf-y0)/(xf-x0)
;; image_kw['min_value'] = -60
;; image_kw['max_value'] = 0
;; image_kw['rgb_table'] = 39
;; image_kw['xtitle'] = 'Zonal [m$^{-1}$]'
;; image_kw['ytitle'] = 'Vertical [m$^{-1}$]'
;; image_kw['xticklen'] = 0.02
;; image_kw['yticklen'] = 0.02*data_aspect
;; image_kw['dimensions'] = 3*[nx,ny]
;; image_kw['xrange'] = [-!pi,+!pi]
;; image_kw['yrange'] = [   0,+!pi]
;; colorbar_kw['title'] = '$Power [dB]$'

;; ;;==Create images
;; filename = path+path_sep()+'frames'+ $
;;            path_sep()+'denft1-'+time.index+ $
;;            name_info+'.pdf'
;; data_graphics, fdata[x0:xf-1,y0:yf-1,*], $
;;                xdata[x0:xf-1],ydata[y0:yf-1], $
;;                /make_frame, $
;;                filename = filename, $
;;                image_kw = image_kw, $
;;                colorbar_kw = colorbar_kw





;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'denft1'+ $
           ;; '-self_norm'+ $
           '-'+time.index+ $
           '.'+get_extension(frame_type)

;;==Get the number of time steps
nt = n_elements(time.index)

;;==Preserve raw FFT
fdata = denft1

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Shift FFT
fdata = shift(fdata,nkx/2,nky/2,0)

;; ;;==Suppress lowest frequencies
;; fdata[nkx/2-1:nkx/2+1,nky/2-1:nky/2+1,*] = min(fdata)
;;==Suppress lowest frequencies
dc_width = {xn:0, xp:0, $
            yn:0, yp:0}
fdata_rms[nkx/2-dc_width.xn:nkx/2+dc_width.xp, $
          nky/2-dc_width.yn:nky/2+dc_width.yp,*] = min(fdata_rms)

;;==Covert to decibels
fdata = 10*alog10(fdata^2)

;;==Set non-finite values to smallest finite value
fdata[where(~finite(fdata))] = min(fdata[where(finite(fdata))])

;;==Normalize to 0 (i.e., logarithm of 1)
fdata -= max(fdata)
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
   frm[it] = image(fdata[*,*,it],kxdata,kydata, $
                   min_value = -30, $
                   max_value = 0, $
                   rgb_table = 39, $
                   axis_style = 1, $
                   position = [0.10,0.10,0.80,0.80], $
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
r_overlay = 2*!pi/(1+findgen(10))
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
