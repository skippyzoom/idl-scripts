;+
; Script for making a movie from the spatial FFT of a plane of EPPIC
; den1 data. See calc_den1fft_t.pro.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;                                   **NOTES**
; -- Passing x and y vectors (e.g., xdata and ydata) to image() via
;    data_graphics.pro appears to slow down image() to the point that
;    making a movie of a long run can take prohibitively long.
;-

;;==Set default movie type
if n_elements(movie_type) eq 0 then movie_type = '.mp4'

;;==Declare file name
filename = expand_path(path+path_sep()+'movies')+ $
           path_sep()+'den1fft_t'+ $
           '-self_norm'+ $
           '-zoom'+ $
           '.'+get_extension(movie_type)

;;==Preserve raw FFT
fdata = den1fft_t

;; ;;==Get dimensions of den1
;; dsize = size(den1)
;; ndim = dsize[0]
;; nx = dsize[1]
;; ny = dsize[2]

;; ;;==Declare image ranges
;; x0 = nx/2
;; xf = nx
;; y0 = 0
;; yf = ny

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Declare ranges to show
;; x0 = nkx/2
;; xf = nkx/2+nkx/4
;; y0 = nky/2-nky/4
;; yf = nky/2+nky/4
;; x0 = 0
;; xf = nkx
;; y0 = 0
;; yf = nky
;; x0 = nkx/2-nkx/4
;; xf = nkx/2+nkx/4
;; y0 = nky/2
;; yf = nky/2+nky/4
;; x0 = nkx/2-nkx/8
;; xf = nkx/2+nkx/8
;; y0 = nky/2-nky/8
;; yf = nky/2+nky/8
;; x0 = nkx/2
;; xf = (params.ndim_space eq 2) ? nkx/2+nkx/32 : nkx/2+nkx/16
;; y0 = (params.ndim_space eq 2) ? nky/2-nky/32 : nky/2-nky/16
;; yf = (params.ndim_space eq 2) ? nky/2+nky/32 : nky/2+nky/16
x0 = nkx/2
xf = (params.ndim_space eq 2) ? nkx/2+nkx/8 : nkx/2+nkx/4
y0 = (params.ndim_space eq 2) ? nky/2-nky/8 : nky/2-nky/4
yf = (params.ndim_space eq 2) ? nky/2+nky/8 : nky/2+nky/4

;;==Calculate dimensions of image frame
nfx = xf-x0
nfy = yf-y0

;;==Get the number of time steps
nt = n_elements(time.index)

;;==Convert complex FFT to its magnitude
fdata = abs(fdata)

;;==Shift FFT
fdata = shift(fdata,nkx/2,nky/2,0)

;; ;;==Suppress lowest frequencies
;; fdata[nkx/2-16:nkx/2+15,nky/2-4:nky/2+3,*] = min(fdata)

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

;; ;;==Set up kx and ky vectors
;; kxdata = 2*!pi*fftfreq(nkx,dx)
;; kxdata = shift(kxdata,nkx/2)
;; kydata = 2*!pi*fftfreq(nky,dy)
;; kydata = shift(kydata,nky/2)

;; data_aspect = float(nfy)/nfx
;; image_kw = dictionary('min_value', -30, $
;;                       'max_value', 0, $
;;                       'rgb_table', 39, $
;;                       'axis_style', 1, $
;;                       'position', [0.10,0.10,0.80,0.80], $
;;                       ;; 'xrange', [0,+2*!pi], $
;;                       ;; 'yrange', [-2*!pi,+2*!pi], $
;;                       ;; 'xrange', [nx/2,nx-1], $
;;                       ;; 'yrange', [0,ny-1], $
;;                       'xmajor', 5, $
;;                       'xminor', 1, $
;;                       'ymajor', 5, $
;;                       'yminor', 1, $
;;                       'xstyle', 1, $
;;                       'ystyle', 1, $
;;                       'xsubticklen', 0.5, $
;;                       'ysubticklen', 0.5, $
;;                       'xtickdir', 1, $
;;                       'ytickdir', 1, $
;;                       'xtitle', strmid(axes,0,1), $
;;                       'ytitle', strmid(axes,1,1), $
;;                       'xticklen', 0.02, $
;;                       'yticklen', 0.02*data_aspect, $
;;                       'xshowtext', 1, $
;;                       'yshowtext', 1, $
;;                       'xtickfont_size', 12.0, $
;;                       'ytickfont_size', 12.0, $
;;                       ;; 'image_dimensions', [512,1024], $
;;                       'font_name', 'Times', $
;;                       'font_size', 18.0)
;; colorbar_kw = dictionary('title', '$P(\delta n/n_0)$', $
;;                          'major', 5, $
;;                          'orientation', 1, $
;;                          'textpos', 1, $
;;                          'position', [0.82,0.10,0.84,0.80], $
;;                          'font_size', 18.0, $
;;                          'font_name', 'Times')

;; ;;==Create movie
;; image_graphics, fdata[x0:xf-1,y0:yf-1,*], $
;;                 ;; kxdata,kydata, $
;;                 /make_movie, $
;;                 filename = filename, $
;;                 image_kw = image_kw, $
;;                 colorbar_kw = colorbar_kw

img_pos = [0.10,0.10,0.80,0.80]
clr_pos = [0.82,0.10,0.84,0.80]

data_aspect = float(nfy)/nfx
image_kw = dictionary('axis_style', 1, $
                      'position', img_pos, $
                      'min_value', -30, $
                      'max_value', 0, $
                      'rgb_table', 39, $
                      'title', 'it = '+time.index, $
                      'xtitle', strmid(axes,0,1), $
                      'ytitle', strmid(axes,1,1), $
                      'xmajor', 5, $
                      'xminor', 1, $
                      'ymajor', 8, $
                      'yminor', 1, $
                      'xstyle', 1, $
                      'ystyle', 1, $
                      'xsubticklen', 0.5, $
                      'ysubticklen', 0.5, $
                      'xtickdir', 1, $
                      'ytickdir', 1, $
                      'xticklen', 0.02, $
                      'yticklen', 0.02*data_aspect, $
                      'font_name', 'Times', $
                      'font_size', 18)
colorbar_kw = dictionary('orientation', 1, $
                         'title', '$P(\delta n/n_0)$', $
                         'textpos', 1, $
                         'major', 5, $
                         'font_size', 18, $
                         'font_name', 'Times', $
                         'position', clr_pos)
text_string = time.index
text_xyz = [100,200]
text_kw = dictionary('font_name', 'Times', $
                     'font_size', 24, $
                     'font_color', 'black', $
                     ;; 'normal', 1B, $
                     'data', 1B, $
                     'alignment', 0.0, $
                     'vertical_alignment', 0.0, $
                     'fill_background', 1B, $
                     'fill_color', 'white')

;;==Create image movie of den1 data
;; data_movie, rebin(fdata[x0:xf-1,y0:yf-1,*],[8*nfx,8*nfy,nt]), $
data_movie, rebin(fdata[x0:xf-1,y0:yf-1,*],[4*nfx,4*nfy,nt]), $
            filename = filename, $
            image_kw = image_kw, $
            colorbar_kw = colorbar_kw, $
            text_string = text_string, $
            text_xyz = text_xyz, $
            text_kw = text_kw
