;+
; Script to shift all distribution 1 data that exists in memory by a
; fixed amount.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

if n_elements(data_shift) ne 0 && n_elements(den1) ne 0 then $
   den1 = shift(den1,data_shift)
if n_elements(data_shift) ne 0 && n_elements(fluxx1) ne 0 then $
   fluxx1 = shift(fluxx1,data_shift)
if n_elements(data_shift) ne 0 && n_elements(fluxy1) ne 0 then $
   fluxy1 = shift(fluxy1,data_shift)
if n_elements(data_shift) ne 0 && n_elements(fluxz1) ne 0 then $
   fluxz1 = shift(fluxz1,data_shift)
if n_elements(data_shift) ne 0 && n_elements(nvsqrx1) ne 0 then $
   nvsqrx1 = shift(nvsqrx1,data_shift)
if n_elements(data_shift) ne 0 && n_elements(nvsqry1) ne 0 then $
   nvsqry1 = shift(nvsqry1,data_shift)
if n_elements(data_shift) ne 0 && n_elements(nvsqrz1) ne 0 then $
   nvsqrz1 = shift(nvsqrz1,data_shift)
