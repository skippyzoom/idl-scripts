;+
; Script for making survey images from calc_den1fft_t
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den1fft_t',frame_type, $
                          path = filepath, $
                          additions = [axes, $
                                       'self_norm', $
                                       '20dB', $
                                       'zoom', $
                                       'survey'])

;;==Preserve raw FFT
fdata = den1fft_t

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Declare ranges to show
x0 = perp_plane ? nkx/2 : nkx/2-nkx/4
xf = perp_plane ? nkx/2+nkx/4 : nkx/2+nkx/4
y0 = perp_plane ? nky/2-nky/4 : nky/2
yf = perp_plane ? nky/2+nky/4 : nky/2+nky/4

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Shift FFT
fdata = shift(fdata,nkx/2,nky/2,0)

;;==Suppress lowest frequencies
dc_width = {xn:0, xp:0, $
            yn:0, yp:0}
fdata[nkx/2-dc_width.xn:nkx/2+dc_width.xp, $
          nky/2-dc_width.yn:nky/2+dc_width.yp,*] = min(fdata)

;;==Covert to decibels
fdata = 10*alog10(fdata^2)

;;==Set non-finite values to smallest finite value
fdata[where(~finite(fdata))] = min(fdata[where(finite(fdata))])

;;==Normalize to 0 (i.e., logarithm of 1)
;; fdata -= max(fdata)
for it=0,time.nt-1 do $
   fdata[*,*,it] -= max(fdata[*,*,it])

;;==Declare index mask
nc = 4
nr = 4
n_frm = nc*nr
ind_mask = (time.nt/n_frm)*(1+indgen(n_frm))

;;==Set up position array for subframes
position = multi_position(nc*nr, $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffer = [-0.15,0.01])

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Set axes-specific keywords
xrange = perp_plane ? [0,+2*!pi] : [-!pi/4,+!pi/4]
yrange = perp_plane ? [-!pi,+!pi] : [0,+2*!pi]
xminor = perp_plane ? 3 : 1

;;==Declare an array of image handles
frm = objarr(n_frm)

;;==Create image frames
for it=0,n_frm-1 do $
   frm[it] = image(fdata[x0:xf-1,y0:yf-1,it], $
                   kxdata[x0:xf-1],kydata[y0:yf-1], $
                   min_value = -20, $
                   max_value = 0, $
                   rgb_table = 39, $
                   axis_style = 1, $
                   position = position[*,it], $
                   xrange = xrange, $
                   yrange = yrange, $
                   xmajor = 3, $
                   xminor = xminor, $
                   ymajor = 3, $
                   yminor = 3, $
                   ;; xstyle = 1, $
                   ;; ystyle = 1, $
                   xtickfont_size = 12.0, $
                   ytickfont_size = 12.0, $
                   font_name = 'Times', $
                   font_size = 14.0, $
                   xshowtext = ((it  /  nc) eq nc-1), $
                   yshowtext = ((it mod nc) eq 0), $
                   current = (it gt 0), $
                   /buffer)

;;==Add global color bar
clr = colorbar(target = frm[0], $
               title = '$P(\delta n/n_I)$', $
               major = 5, $
               minor = 4, $
               orientation = 1, $
               textpos = 1, $
               position = [0.90,0.20,0.91,0.80], $
               font_size = 10.0, $
               font_name = 'Times', $
               hide = 0)

;;==Add time stamp on each panel
for it=0,n_frm-1 do $
   txt = text(xrange[0],yrange[1], $
              time.stamp[ind_mask[it]], $
              /data, $
              vertical_alignment = 1.0, $
              target = frm[it], $
              color = 'white', $
              font_name = 'Courier', $
              font_size = 8.0)

;;==Add a path label
txt = text(0.0,0.95, $
           path, $
           target = frm[0], $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save the frame
frame_save, frm[0],filename=filename
