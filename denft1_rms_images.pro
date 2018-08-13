;+
; Script for making frames from a plane of EPPIC denft1 data after RMS
; over time.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Get the number of time steps
nt = n_elements(time.index)

;;==Declare RMS time ranges
rms_time = [[5504/params.nout,11776/params.nout], $  ;Linear stage
            [17536/params.nout,20992/params.nout], $ ;Transition stage
            [20992/params.nout,nt-1]]                ;Saturated stage
rms_time = transpose(rms_time)
n_rms = (size(rms_time))[1]

;;==Declare file name(s)
filename = strarr(n_rms)
for it=0,n_rms-1 do $
   filename[it] = expand_path(path+path_sep()+'frames')+ $
   path_sep()+'denft1_rms'+ $
   ;; '-self_norm'+ $
   '-'+string(rms_time[it,0]*params.nout,format='(i06)')+ $
   '_'+string(rms_time[it,1]*params.nout,format='(i06)')+ $
   '.'+get_extension(frame_type)

;;==Preserve raw FFT
fdata = denft1

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Declare ranges to show
x0 = nkx/2-64
xf = nkx/2+64
y0 = nky/2-64
yf = nky/2+64

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

;;==Covert to decibels
fdata_rms = 10*alog10(fdata_rms^2)

;;==Set non-finite values to smallest finite value
fdata_rms[where(~finite(fdata_rms))] = min(fdata_rms[where(finite(fdata_rms))])

;;==Normalize to 0 (i.e., logarithm of 1)
fdata_rms -= max(fdata_rms)
;; for it=0,nt-1 do $
;;    fdata_rms[*,*,it] -= max(fdata_rms[*,*,it])

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Declare an array of image handles
frm = objarr(nt)

;;==Create image frames
for it=0,n_rms-1 do $
   frm[it] = image(fdata_rms[x0:xf-1,y0:yf-1,it], $
                   kxdata[x0:xf-1],kydata[y0:yf-1], $
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
for it=0,n_rms-1 do $
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
for it=0,n_rms-1 do $
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
for it=0,n_rms-1 do $
   txt = text(0.0,0.90, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save individual images
for it=0,n_rms-1 do $
   frame_save, frm[it],filename=filename[it]

;; ;;==Clear fdata
;; fdata = !NULL
