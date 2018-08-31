;+
; This script fixes some defects in flux and nvsqr arrays that came
; out of the parametric_wave runs. The specific defect is a row of NaN
; at y=0 (shifted to y=nx/4) after a certain time. It appears to be
; the result of a bug in EPPIC output_fluxes.cc and
; output_nvsqr.cc. This script simply replaces that row (in all time
; steps) with the average of the two neighboring rows.
;
; Created by Matt Young
;------------------------------------------------------------------------------
;-

;;==Set a default for data_shift
if n_elements(data_shift) eq 0 then data_shift = [0,0,0]

;;==Extract first element of data_shift
ix = data_shift[0]

;;==Fix fluxx1
if n_elements(fluxx1) ne 0 then $
   for iy=0,ny-1 do $
      fluxx1[ix,iy,*] = 0.5*(fluxx1[ix-1,iy,*]+fluxx1[ix+1,iy,*])
;;==Fix fluxy1
if n_elements(fluxy1) ne 0 then $
   for iy=0,ny-1 do $
      fluxy1[ix,iy,*] = 0.5*(fluxy1[ix-1,iy,*]+fluxy1[ix+1,iy,*])
;;==Fix fluxz1
if n_elements(fluxz1) ne 0 then $
   for iy=0,ny-1 do $
      fluxz1[ix,iy,*] = 0.5*(fluxz1[ix-1,iy,*]+fluxz1[ix+1,iy,*])
;;==Fix nvsqrx1
if n_elements(nvsqrx1) ne 0 then $
   for iy=0,ny-1 do $
      nvsqrx1[ix,iy,*] = 0.5*(nvsqrx1[ix-1,iy,*]+nvsqrx1[ix+1,iy,*])
;;==Fix nvsqry1
if n_elements(nvsqry1) ne 0 then $
   for iy=0,ny-1 do $
      nvsqry1[ix,iy,*] = 0.5*(nvsqry1[ix-1,iy,*]+nvsqry1[ix+1,iy,*])
;;==Fix nvsqrz1
if n_elements(nvsqrz1) ne 0 then $
   for iy=0,ny-1 do $
      nvsqrz1[ix,iy,*] = 0.5*(nvsqrz1[ix-1,iy,*]+nvsqrz1[ix+1,iy,*])
