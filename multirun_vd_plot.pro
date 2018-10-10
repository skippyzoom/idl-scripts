;+
; Script for plotting $V_d \equiv v_e-v_i$ from multiple runs. This
; script assumes that the user has run build_multirun_moments.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare file name
filename = expand_path(plot_path)+path_sep()+'frames'+ $
           path_sep()+ $
           'mr_psi'+ $
           '.'+get_extension(frame_type)

;;==Declare line colors
color = ['blue', $
         'green', $
         'red']
