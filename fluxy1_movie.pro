;+
; Script for making movies from a plane of EPPIC fluxy1 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set defaults
if n_elements(x0) eq 0 then x0 = 0
if n_elements(xf) eq 0 then xf = nx-1
if n_elements(y0) eq 0 then y0 = 0
if n_elements(yf) eq 0 then yf = ny-1
if n_elements(name_info) eq 0 then name_info = ''

;;==Load graphics keywords for fluxy1
@fluxy1_kw

;;==Create image movie of fluxy1 data
filename = path+path_sep()+'movies'+ $
           path_sep()+'fluxy1.mp4'
data_graphics, fluxy1,xdata,ydata, $
               /make_movie, $
               filename = filename, $
               image_kw = image_kw, $
               colorbar_kw = colorbar_kw
