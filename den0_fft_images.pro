;+
; Script for making frames from a plane of EPPIC den0 data.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set defaults
if n_elements(name_info) eq 0 then name_info = ''

;;==Calculate the spatial FFT of the den0 plane
fdata = den0
@fft_2D_time

;;==Load graphics keywords for FFT images
@fft_kw

;;==Create image frames of den0 spatial FFT
filename = path+path_sep()+'frames'+ $
           path_sep()+'den0_fft-'+time.index+ $
           name_info+'.pdf'
data_graphics, fdata,xdata,ydata, $
               /make_frame, $
               filename = filename, $
               image_kw = image_kw, $
               colorbar_kw = colorbar_kw
