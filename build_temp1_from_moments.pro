;+
; Build distribution 1 temperature, using moments for v0. Assumes the
; user has already loaded the moments dictionary.
;
; WARNING: Check inputs to calculate_vsqr before running. Some
; projects may swap axes.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Build components of v^2
vsqrx = calculate_vsqr(params.n0d1*(1+den1), $
                       -moments.dist1.vz_m1[timesteps], $
                       nvsqrz1)
vsqry = calculate_vsqr(params.n0d1*(1+den1), $
                       +moments.dist1.vy_m1[timesteps], $
                       nvsqry1)
vsqrz = calculate_vsqr(params.n0d1*(1+den1), $
                       +moments.dist1.vx_m1[timesteps], $
                       nvsqrx1)

;;==Get rid of singular dimensions
vsqrx = reform(vsqrx)
vsqry = reform(vsqry)
vsqrz = reform(vsqrz)

;;==Declare Boltzmann's constant
kb = 1.3806503e-23

;;==Create temp1
temp1 = params.md1*(vsqrx+vsqry+vsqrz)/kb
