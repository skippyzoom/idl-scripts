;+
; Build distribution 0 temperature, using fluxes for v0. Assumes the
; user has already loaded the flux arrays.
;
; WARNING: Check inputs to calculate_vsqr before running. Some
; projects may swap axes.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Build components of v^2
vsqrx = calculate_vsqr(params.n0d0*(1+den0), $
                       fluxx0/(params.n0d0*(1+den0)), $
                       nvsqrx0)
vsqry = calculate_vsqr(params.n0d0*(1+den0), $
                       fluxy0/(params.n0d0*(1+den0)), $
                       nvsqry0)
vsqrz = calculate_vsqr(params.n0d0*(1+den0), $
                       fluxz0/(params.n0d0*(1+den0)), $
                       nvsqrz0)

;;==Get rid of singular dimensions
vsqrx = reform(vsqrx)
vsqry = reform(vsqry)
vsqrz = reform(vsqrz)

;;==Declare Boltzmann's constant
kb = 1.3806503e-23

;;==Create temp0
temp0 = params.md0*(vsqrx+vsqry+vsqrz)/kb
