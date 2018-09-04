;+
; Script for making movies from a plane of EPPIC denft1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

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
;; x0 = nkx/2
;; xf = nkx/2+nkx/4
;; y0 = nky/2-nky/4
;; yf = nky/2+nky/4
;; x0 = 0
;; xf = nkx
;; y0 = 0
;; yf = nky
x0 = nkx/2
xf = nkx/2+nkx/32
y0 = nky/2-nky/32
yf = nky/2+nky/32
;; x0 = nkx/2-nkx/4
;; xf = nkx/2+nkx/4
;; y0 = nky/2
;; yf = nky/2+nky/4
;; x0 = nkx/2-nkx/8
;; xf = nkx/2+nkx/8
;; y0 = nky/2-nky/8
;; yf = nky/2+nky/8

;;==Calculate dimensions of image frame
nfx = xf-x0
nfy = yf-y0

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

;; image_kw = dictionary('min_value', -30, $
;;                       'max_value', 0, $
;;                       'rgb_table', 39, $
;;                       'axis_style', 2, $
;;                       ;; 'position', [0.10,0.10,0.80,0.80], $
;;                       'title', 'it = '+time.index, $
;;                       ;; 'title', 'TITLE', $
;;                       ;; 'xtitle', 'X', $
;;                       ;; 'ytitle', 'Y', $
;;                       ;; ;; 'xrange', [0,+!pi], $
;;                       ;; ;; 'xtickvalues', [0,+!pi/2,+!pi], $
;;                       ;; 'xmajor', 3, $
;;                       ;; 'xminor', 1, $
;;                       ;; ;; 'yrange', [-!pi,+!pi], $
;;                       ;; ;; 'ytickvalues', [-!pi,-!pi/2,0,+!pi/2,+!pi], $
;;                       ;; 'ymajor', 3, $
;;                       ;; 'yminor', 3, $
;;                       ;; 'xstyle', 1, $
;;                       ;; 'ystyle', 1, $
;;                       ;; 'xsubticklen', 0.5, $
;;                       ;; 'ysubticklen', 0.5, $
;;                       ;; 'xtickdir', 1, $
;;                       ;; 'ytickdir', 1, $
;;                       ;; 'xticklen', 0.02, $
;;                       ;; 'yticklen', 0.04, $
;;                       ;; 'dimensions', [1000,1000], $
;;                       ;; 'image_dimensions', [512,1024], $
;;                       ;; 'xshowtext', 1, $
;;                       ;; 'yshowtext', 1, $
;;                       ;; 'xtickfont_size', 12.0, $
;;                       ;; 'ytickfont_size', 12.0, $
;;                       'font_name', 'Times', $
;;                       'font_size', 14.0, $
;;                       'font_color', 'black')
img_pos = [0.10,0.10,0.80,0.80]
clr_pos = [0.82,0.10,0.84,0.80]

image_kw = dictionary('axis_style', 1, $
                      'position', img_pos, $
                      'xmajor', 5, $
                      'xminor', 1, $
                      'ymajor', 5, $
                      'yminor', 1, $
                      'xstyle', 1, $
                      'ystyle', 1, $
                      'xsubticklen', 0.5, $
                      'ysubticklen', 0.5, $
                      'xtickdir', 1, $
                      'ytickdir', 1, $
                      'font_name', 'Times')
colorbar_kw = dictionary('orientation', 1, $
                         'textpos', 1, $
                         'font_name', 'Times', $
                         'position', clr_pos)
text_kw = dictionary('font_name', 'Times', $
                     'font_size', 24, $
                     'font_color', 'black', $
                     'normal', 1B, $
                     'alignment', 0.0, $
                     'vertical_alignment', 0.0, $
                     'fill_background', 1B, $
                     'fill_color', 'white')

data_aspect = float(nfy)/nfx
;; image_kw['min_value'] = -max(abs(den1[x0:xf-1,y0:yf-1,1:*]))
;; image_kw['max_value'] = +max(abs(den1[x0:xf-1,y0:yf-1,1:*]))
image_kw['min_value'] = -30
image_kw['max_value'] = 0
image_kw['axis_style'] = 2
image_kw['rgb_table'] = 39
image_kw['xtitle'] = strmid(axes,0,1)
image_kw['ytitle'] = strmid(axes,1,1)
image_kw['xticklen'] = 0.02
image_kw['yticklen'] = 0.02*data_aspect
image_kw['title'] = 'it = '+time.index
image_kw['xmajor'] = 5
image_kw['xminor'] = 3
image_kw['ymajor'] = 5
image_kw['yminor'] = 3
image_kw['font_size'] = 18
image_kw['font_name'] = 'Times'
;; image_kw['dimensions'] = [1024,256]
;; image_kw['image_dimensions'] = [1024,256]
image_kw['dimensions'] = [512,512]
image_kw['image_dimensions'] = [512,512]
colorbar_kw['title'] = '$P(\delta n/n_0)$'
colorbar_kw['font_size'] = 18
colorbar_kw['font_name'] = 'Times'
colorbar_kw['major'] = 5

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
;; fdata = fdata[x0:xf-1,y0:yf-1,*]
;; ;; data_graphics, fdata[x0:xf-1,y0:yf-1,*], $
;; data_graphics, rebin(fdata,[8*nfx,8*nfy,nt]), $
;;                /make_movie, $
;;                filename = filename, $
;;                image_kw = image_kw, $
;;                colorbar_kw = colorbar_kw
;; data_movie, rebin(fdata,[8*nfx,8*nfy,nt]), $
data_graphics, fdata[x0:xf-1,y0:yf-1,*], $
               /make_movie, $
               filename = filename, $
               image_kw = image_kw, $
               colorbar_kw = colorbar_kw
