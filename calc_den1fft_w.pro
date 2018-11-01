;+
; Script for calculating full FFT from den1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of den1
fsize = size(den1)

;;==Declare dimensions of full FFT array
nkx = fsize[1]
nky = fsize[2]
nw = max([512,next_power2(fsize[3])])

;;==Set up full FFT array (may be padded)
den1fft_w = complexarr(nkx,nky,nw)
den1fft_w[0:fsize[1]-1, $
          0:fsize[2]-1, $
          0:fsize[3]-1] = den1

;;==Calculate full FFT
den1fft_w = fft(den1fft_w,/overwrite)
