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
           '-'+axes+ $
           ;; '-filtered'+ $
           '-self_norm'+ $
           ;; '-max_norm'+ $
           '-zoom'+ $
           '.'+get_extension(movie_type)

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
for it=0,nt-1 do $
   fdata[*,*,it] -= max(fdata[*,*,it])

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Set axes-specific keywords
xrange = perp_plane ? [0,+!pi] : [-!pi/4,+!pi/4]
yrange = perp_plane ? [-!pi,+!pi] : [0,+2*!pi]
xminor = perp_plane ? 3 : 1

;;==Calculate dimensions of image frame
nfx = xf-x0
nfy = yf-y0
data_aspect = float(nfy)/nfx

;;==Get the number of time steps
nt = n_elements(time.index)

x_rebin = 4
y_rebin = 4

xtickvalues = [0,x_rebin*nfx/2,x_rebin*nfx]
xtickname = ['0','$\pi/2$','$\pi$']
ytickvalues = [0,y_rebin*nfy/4,y_rebin*nfy/2,y_rebin*3*nfy/4,y_rebin*nfy]
ytickname = ['$-\pi$','$-\pi/2$','0','$+\pi/2$','$+\pi$']
image_kw = dictionary('min_value', -20, $
                      'max_value', 0, $
                      'rgb_table', 39, $
                      'axis_style', 1, $
                      'position', [0.10,0.10,0.80,0.80], $
                      'title', time.index+' ('+time.stamp+')', $
                      'dimensions', [500,500], $
                      'image_dimensions', [x_rebin*nfx,y_rebin*nfy], $
                      ;; 'xrange', xrange, $
                      ;; 'yrange', yrange, $
                      'xmajor', 3, $
                      'xminor', xminor, $
                      'ymajor', 3, $
                      'yminor', 3, $
                      'xstyle', 1, $
                      'ystyle', 1, $
                      'xtickvalues', xtickvalues, $
                      ;; 'xtickname', xtickname, $
                      'ytickvalues', ytickvalues, $
                      ;; 'ytickname', ytickname, $
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
                      'font_size', 18.0)

;; colorbar_kw = dictionary('orientation', 1, $
;;                          'title', '$P(\delta n/n_0)$', $
;;                          'textpos', 1, $
;;                          'major', 5, $
;;                          'font_size', 2, $
;;                          'font_name', 'Times', $
;;                          'position', [0.82,0.10,0.84,0.80])
major = 1+(image_kw.max_value-image_kw.min_value)/5
colorbar_kw = dictionary('title', '$P(\delta n/n_I)$', $
                         'major', major, $
                         'minor', 3, $
                         'orientation', 1, $
                         'textpos', 1, $
                         'position', [0.84,0.10,0.86,0.80], $
                         'font_size', 12.0, $
                         'font_name', 'Times')

;; text_string = time.index
;; text_xyz = [100,200]
;; text_kw = dictionary('font_name', 'Times', $
;;                      'font_size', 24, $
;;                      'font_color', 'black', $
;;                      ;; 'normal', 1B, $
;;                      'data', 1B, $
;;                      'alignment', 0.0, $
;;                      'vertical_alignment', 0.0, $
;;                      'fill_background', 1B, $
;;                      'fill_color', 'white')
;; text_string = path
;; text_xyz = [0.0,0.005]
;; text_kw = dictionary('font_name', 'Courier', $
;;                      'font_size', 10)

;;==Create image movie of den1 data
data_movie, rebin(fdata[x0:xf-1,y0:yf-1,*],[x_rebin*nfx,y_rebin*nfy,nt]), $
            filename = filename, $
            image_kw = image_kw, $
            colorbar_kw = colorbar_kw, $
            text_string = text_string, $
            text_xyz = text_xyz, $
            text_kw = text_kw
