;+
; Script to analyze thermal instabilities. Designed with pure-PIC runs
; in mind but should be simple to modify for hybrid runs.
;
; Note: The fb_flow_angle runs had insufficient flux data because of
; some bug, so I used the spatially averaged velocities. Other runs
; may be able to use flux arrays to calculate full spatial
; distributions of mean velocity. 
;
; Created by Matt Young
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare Boltzmann's constant
kb = 1.3806503e-23

;;==Read in moments (electrons and ions)
moments = read_moments(path=path)

;;==Plot spatially averaged temperatures
@average_temperature_plot

;; ;;==Build electron temperature
;; vsqrx = calculate_vsqr(params.n0d0*(1+den0), $
;;                        -moments.dist0.vz_m1[timesteps], $
;;                        nvsqrz0)
;; vsqry = calculate_vsqr(params.n0d0*(1+den0), $
;;                        +moments.dist0.vy_m1[timesteps], $
;;                        nvsqry0)
;; vsqrz = calculate_vsqr(params.n0d0*(1+den0), $
;;                        +moments.dist0.vx_m1[timesteps], $
;;                        nvsqrx0)
;; temp0 = params.md0*(vsqrx+vsqry+vsqrz)/kb
;; temp0 = reform(temp0)

;; ;;==Analyze electron thermal instability
;; @den0_T0_correlation

;;==Build ion temperature
;; vsqrx = calculate_vsqr(params.n0d1*(1+den1), $
;;                        -moments.dist1.vz_m1[timesteps], $
;;                        nvsqrz1)
;; vsqry = calculate_vsqr(params.n0d1*(1+den1), $
;;                        +moments.dist1.vy_m1[timesteps], $
;;                        nvsqry1)
;; vsqrz = calculate_vsqr(params.n0d1*(1+den1), $
;;                        +moments.dist1.vx_m1[timesteps], $
;;                        nvsqrx1)
vsqrx = calculate_vsqr(params.n0d1*(1+den1), $
                       ;; +moments.dist1.vx_m1[timesteps], $
                       fluxx1/(params.n0d1*(1+den1)), $
                       nvsqrx1)
vsqry = calculate_vsqr(params.n0d1*(1+den1), $
                       ;; +moments.dist1.vy_m1[timesteps], $
                       fluxy1/(params.n0d1*(1+den1)), $
                       nvsqry1)
vsqrz = calculate_vsqr(params.n0d1*(1+den1), $
                       ;; +moments.dist1.vz_m1[timesteps], $
                       fluxz1/(params.n0d1*(1+den1)), $
                       nvsqrz1)
temp1 = params.md1*(vsqrx+vsqry+vsqrz)/kb
temp1 = reform(temp1)

;;==Analyze ion thermal instability
@den1_T1_correlation
