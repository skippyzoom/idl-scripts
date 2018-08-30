;+
; Script for making movies from a plane of EPPIC denft1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;; ;;==Set graphics ranges
;; x0 = nx/2
;; xf = nx/2+nx/4
;; y0 = ny/2-nx/4
;; yf = ny/2+nx/4

;; ;;==Condition data for (kx,ky,t) images
;; dc_mask = 3
;; mask_index = [[nx/2-dc_mask,nx/2+dc_mask], $
;;               [ny/2-dc_mask,ny/2+dc_mask], $
;;               [0,n_elements(time.index)]]
;; fdata = condition_fft(denft1, $
;;                       /magnitude, $
;;                       shift = [nx/2,ny/2,0], $
;;                       mask_index = mask_index, $
;;                       missing = 1e-6, $
;;                       /finite, $
;;                       /normalize, $
;;                       /to_dB)
;; fdata = mirror_denft_plane(fdata)

;;==Set default movie type
if n_elements(movie_type) eq 0 then movie_type = '.pdf'

;;==Declare file name(s)
filename = expand_path(path+path_sep()+'movies')+ $
           path_sep()+'denft1'+ $
           '-'+axes+ $
           '-self_norm'+ $
           '-zoom'+ $
           '.'+get_extension(movie_type)

;;==Preserve raw FFT
fdata = denft1

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Declare ranges to show
x0 = nkx/2
xf = nkx/2+nkx/4
y0 = nky/2-nky/4
yf = nky/2+nky/4
;; x0 = nkx/2-nkx/4
;; xf = nkx/2+nkx/4
;; y0 = nky/2
;; yf = nky/2+nky/4
;; x0 = nkx/2-nkx/8
;; xf = nkx/2+nkx/8
;; y0 = nky/2-nky/8
;; yf = nky/2+nky/8

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
for it=0,nt-1 do $
   fdata[*,*,it] -= max(fdata[*,*,it])

;; ;;==Set up kx and ky vectors for images
;; kxdata = 2*!pi*fftfreq(nx,dx)
;; kxdata = shift(kxdata,nx/2)
;; kydata = 2*!pi*fftfreq(ny,dy)
;; kydata = shift(kydata,ny/2)

;; ;;==Declare file type
;; if n_elements(movie_type) eq 0 then movie_type = '.mp4'

;; ;;==Declare specific graphics keywords
;; @denft1_kw

image_kw = dictionary('min_value', -30, $
                      'max_value', 0, $
                      'rgb_table', 39, $
                      'axis_style', 1, $
                      'position', [0.10,0.10,0.80,0.80], $
                      'xrange', [0,+!pi], $
                      'xtickvalues', [0,+!pi/2,+!pi], $
                      'xmajor', 3, $
                      'xminor', 1, $
                      'yrange', [-!pi,+!pi], $
                      'ytickvalues', [-!pi,-!pi/2,0,+!pi/2,+!pi], $
                      'ymajor', 3, $
                      'yminor', 3, $
                      'xstyle', 1, $
                      'ystyle', 1, $
                      'xsubticklen', 0.5, $
                      'ysubticklen', 0.5, $
                      'xtickdir', 1, $
                      'ytickdir', 1, $
                      'xticklen', 0.02, $
                      'yticklen', 0.04, $
                      'xshowtext', 1, $
                      'yshowtext', 1, $
                      'xtickfont_size', 12.0, $
                      'ytickfont_size', 12.0, $
                      'font_name', 'Times', $
                      'font_size', 18.0, $
                      'buffer', 1B)

;; ;;==Create image movie of den1 data
;; filename = expand_path(path+path_sep()+'movies'+ $
;;            path_sep()+'denft1')+ $
;;            '.'+get_extension(movie_type)
;; ;; data_graphics, fdata[x0:xf-1,y0:yf-1,*], $
;; ;;                xdata[x0:xf-1],ydata[y0:yf-1], $
;; ;;                /make_movie, $
;; ;;                filename = filename, $
;; ;;                image_kw = image_kw, $
;; ;;                colorbar_kw = colorbar_kw
data_graphics, fdata[x0:xf-1,y0:yf-1,*], $
               /make_movie, $
               filename = filename, $
               image_kw = image_kw, $
               colorbar_kw = colorbar_kw
