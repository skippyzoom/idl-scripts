;+
; Script for calculating full FFT from nvsqrx1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of nvsqrx1
fsize = size(nvsqrx1)

;;==Declare dimensions of full FFT array
nkx = fsize[1]
nky = fsize[2]
nw = next_power2(fsize[3])

;;==Set up full FFT array (may be padded)
nvsqrx1fft_w = complexarr(nkx,nky,nw)
nvsqrx1fft_w[0:fsize[1]-1, $
             0:fsize[2]-1, $
             0:fsize[3]-1] = nvsqrx1

;;==Calculate full FFT
nvsqrx1fft_w = fft(nvsqrx1fft_w,/overwrite)
