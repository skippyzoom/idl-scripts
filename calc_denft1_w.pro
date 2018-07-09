;+
; Script for calculating full FFT from denft1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get dimensions of denft1
fsize = size(denft1)

;;==Declare dimensions of full FFT array
nkx = fsize[1]
nky = fsize[2]
nw = next_power2(fsize[3])

;;==Set up full FFT array (may be padded)
denft1_w = complexarr(nkx,nky,nw)
denft1_w[0:fsize[1]-1, $
          0:fsize[2]-1, $
          0:fsize[3]-1] = denft1

;;==Calculate full FFT
denft1_w = fft(denft1_w,dim=3,/overwrite)
