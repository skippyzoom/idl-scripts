;+
; Script for calculating full FFT from nvsqry1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of nvsqry1
fsize = size(nvsqry1)

;;==Declare dimensions of full FFT array
nkx = fsize[1]
nky = fsize[2]
nw = next_power2(fsize[3])

;;==Set up full FFT array (may be padded)
nvsqry1fft_w = complexarr(nkx,nky,nw)
nvsqry1fft_w[0:fsize[1]-1, $
             0:fsize[2]-1, $
             0:fsize[3]-1] = nvsqry1

;;==Calculate full FFT
nvsqry1fft_w = fft(nvsqry1fft_w,/overwrite)
