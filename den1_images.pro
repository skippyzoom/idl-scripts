;+
; Script for making frames from a plane of EPPIC den1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Add a description to the file name
;;  (e.g., 'full', 'center512', 'right_half' to distinguish different
;;  sets of ranges)
file_description = 'center256'

;;==Declare image ranges
x0 = nx/2-128
xf = nx/2+128
y0 = ny/2-128
yf = ny/2+128
;; x0 = 0
;; xf = nx
;; y0 = 0
;; yf = ny


;; ;;==Load graphics keywords for den1
;; ;; @default_image_kw
dsize = size(den1)
nx = dsize[1]
ny = dsize[2]
data_aspect = float(yf-y0)/(xf-x0)
;; ;; image_kw['min_value'] = -max(abs(den1[*,*,1:*]))
;; ;; image_kw['max_value'] = +max(abs(den1[*,*,1:*]))
;; ;; image_kw['min_value'] = -0.15
;; ;; image_kw['max_value'] = +0.15
;; image_kw['min_value'] = -0.4
;; image_kw['max_value'] = +0.4
;; ;; image_kw['min_value'] = min(den1)
;; ;; image_kw['max_value'] = max(den1)
;; image_kw['rgb_table'] = 5
;; image_kw['xtitle'] = 'Zonal [m]'
;; image_kw['ytitle'] = 'Vertical [m]'
;; image_kw['xticklen'] = 0.02
;; image_kw['yticklen'] = 0.02*data_aspect
;; image_kw['title'] = 't = '+time.stamp
;; image_kw['xshowtext'] = 0
;; image_kw['yshowtext'] = 0
;; image_kw['font_size'] = 18.0
;; colorbar_kw['title'] = '$\delta n/n_0$'
;; colorbar_kw['font_size'] = 12.0
;; colorbar_kw['major'] = 5
;; colorbar_kw['minor'] = 3

;; ;;==Create images
;; if n_elements(file_description) eq 0 then $
;;    file_description = ''
;; filename = expand_path(path+path_sep()+'frames')+ $
;;            path_sep()+'den1'+ $
;;            '-'+file_description+ $
;;            '-'+time.index+ $
;;            '.'+get_extension(frame_type)
;; data_graphics, den1[x0:xf-1,y0:yf-1,*], $
;;                xdata[x0:xf-1],ydata[y0:yf-1], $
;;                /make_frame, $
;;                filename = filename, $
;;                image_kw = image_kw, $
;;                colorbar_kw = colorbar_kw

;;==Get the number of time steps
nt = n_elements(time.index)

;;==Declare an array of image handles
img = objarr(nt)

;;==Create image frames
for it=0,nt-1 do $
   img[it] = image(den1[x0:xf-1,y0:yf-1,it], $
                   xdata[x0:xf-1],ydata[y0:yf-1], $
                   ;; min_value = -max(abs(den1[*,*,1:*])), $
                   ;; max_value = +max(abs(den1[*,*,1:*])), $
                   ;; min_value = -0.15, $
                   ;; max_value = +0.15, $
                   min_value = -0.4, $
                   max_value = +0.4, $
                   ;; min_value = min(den1), $
                   ;; max_value = max(den1), $
                   rgb_table = 5, $
                   axis_style = 1, $
                   position = [0.10,0.10,0.80,0.80], $
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
                   xtitle = 'Zonal [m]', $
                   ytitle = 'Vertical [m]', $
                   xticklen = 0.02, $
                   yticklen = 0.02*data_aspect, $
                   title = 't = '+time.stamp[it], $
                   xshowtext = 0, $
                   yshowtext = 0, $
                   font_name = 'Times', $
                   font_size = 18.0, $
                   /buffer)

;;==Add a colorbar to each image
for it=0,nt-1 do $
   clr = colorbar(target = img[it], $
                  title = '$\delta n/n_0$', $
                  major = 5, $
                  minor = 3, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [0.82,0.10,0.84,0.80], $
                  font_size = 12.0, $
                  font_name = 'Times')

;;==Declare file name
if n_elements(file_description) eq 0 then $
   file_description = ''
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den1'+ $
           '-'+file_description+ $
           '-'+time.index+ $
           '.'+get_extension(frame_type)

;;==Save individual images
for it=0,nt-1 do $
   frame_save, img[it],filename=filename[it]
