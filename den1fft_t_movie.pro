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

;;==Declare file type
if n_elements(movie_type) eq 0 then movie_type = '.mp4'

;;==Preserve den1fft_t
fdata = den1fft_t

;;==Get array dimensions
fsize = size(fdata)
nx = fsize[1]
ny = fsize[2]

;;==Condition FFT for imaging
fdata = abs(fdata)
fdata = 10*alog10(fdata^2)
good = where(finite(fdata))
missing = min(fdata[good])
fdata[where(~finite(fdata))] = missing
fdata[nkx/2-32:nkx/2+32,nky/2-8:nky/2+8,*] = missing
fdata -= max(fdata)

;;==Load graphics keywords for FFT images
;; @default_image_kw
image_kw = dictionary('axis_style', 1, $
                      ;; 'position', [0.10,0.10,0.80,0.80], $
                      ;; 'xmajor', 5, $
                      ;; 'xminor', 1, $
                      ;; 'ymajor', 5, $
                      ;; 'yminor', 1, $
                      ;; 'xstyle', 1, $
                      ;; 'ystyle', 1, $
                      ;; 'xsubticklen', 0.5, $
                      ;; 'ysubticklen', 0.5, $
                      ;; 'xtickdir', 1, $
                      ;; 'ytickdir', 1, $
                      'font_name', 'Times')
colorbar_kw = dictionary('orientation', 1, $
                         'textpos', 1, $
                         ;; 'position', [0.82,0.10,0.84,0.80], $
                         'font_name', 'Times')
image_kw['min_value'] = -30
image_kw['max_value'] = 0
image_kw['rgb_table'] = 39
image_kw['xtitle'] = '$k_{Zon}$ [m$^{-1}$]'
image_kw['ytitle'] = '$k_{Ver}$ [m$^{-1}$]'
;; image_kw['xticklen'] = 0.02
;; image_kw['yticklen'] = 0.02
;; image_kw['xmajor'] = 5
;; image_kw['xminor'] = 3
;; image_kw['ymajor'] = 5
;; image_kw['yminor'] = 3
;; image_kw['xtickname'] = ['$-\pi$','$-\pi/2$','0','$+\pi$','$+\pi/2$']
;; image_kw['ytickname'] = ['$-\pi$','$-\pi/2$','0','$+\pi$','$+\pi/2$']
image_kw['font_size'] = 18
image_kw['font_name'] = 'Times'
;; image_kw['dimensions'] = [2000,2000]
;; max_dim = max([dx*nx,dy*ny])
;; image_kw['image_dimensions'] = [max_dim,max_dim]
image_kw['title'] = 'it = '+time.index
colorbar_kw['title'] = 'Power [dB]'
colorbar_kw['font_size'] = 18
colorbar_kw['major'] = 7

;;==Create movie
filename = expand_path(path)+path_sep()+'movies'+ $
           path_sep()+'den1fft_t'+ $
           '.'+get_extension(movie_type)
;; data_graphics, fdata, $
;;                /make_movie, $
;;                filename = filename, $
;;                image_kw = image_kw, $
;;                colorbar_kw = colorbar_kw
image_graphics, fdata, $
                /make_movie, $
                filename = filename, $
                image_kw = image_kw, $
                colorbar_kw = colorbar_kw
