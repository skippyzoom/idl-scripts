;+
; Build distribution 0 temperature, using moments for v0. Assumes the
; user has already loaded the moments dictionary.
;
; WARNING: Check inputs to calculate_vsqr before running. Some
; projects may swap axes.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Build components of v^2
vsqrx = calculate_vsqr(params.n0d0*(1+den0), $
                       -moments.dist0.vz_m1[timesteps], $
                       nvsqrz0)
vsqry = calculate_vsqr(params.n0d0*(1+den0), $
                       +moments.dist0.vy_m1[timesteps], $
                       nvsqry0)
vsqrz = calculate_vsqr(params.n0d0*(1+den0), $
                       +moments.dist0.vx_m1[timesteps], $
                       nvsqrx0)

;;==Get rid of singular dimensions
vsqrx = reform(vsqrx)
vsqry = reform(vsqry)
vsqrz = reform(vsqrz)

;;==Declare Boltzmann's constant
kb = 1.3806503e-23

;;==Create temp0
temp0 = params.md0*(vsqrx+vsqry+vsqrz)/kb
