;+
; Script for plotting Er0 and Et0 from multiple runs
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare plane axes
axes = 'xy'

;;==Declare project path
proj_path = get_base_dir()+path_sep()+'parametric_wave/'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare name of target save file
save_name = 'efield_'+axes+ $
            '-initial_five_steps'+ $
            '.sav'

;==Set up multi-run hashes
Et0_hash = hash()
Er0_hash = hash()
color = hash()
linestyle = hash()

;;==Restore data and fill hashes
@multirun_Ert0_restore

;;==Create plots
;; @multirun_Ert0_plots
