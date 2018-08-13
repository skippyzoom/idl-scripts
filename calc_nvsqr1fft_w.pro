;+
; Script for calculating full FFT from nvsqr1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of nvsqr1
fsize = size(nvsqr1)

;;==Declare dimensions of full FFT array
nkx = fsize[1]
nky = fsize[2]
nw = next_power2(fsize[3])

;;==Set up full FFT array (may be padded)
nvsqr1fft_w = complexarr(nkx,nky,nw)
nvsqr1fft_w[0:fsize[1]-1, $
            0:fsize[2]-1, $
            0:fsize[3]-1] = nvsqr1

;;==Calculate full FFT
nvsqr1fft_w = fft(nvsqr1fft_w,/overwrite)
