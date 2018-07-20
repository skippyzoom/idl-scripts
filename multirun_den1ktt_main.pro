;+
; Script for building a hash of den1ktt from multiple directories.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare project path
proj_path = get_base_dir()+path_sep()+'parametric_wave/'

;;==Declare name of save file
save_name = 'den1ktt-02.0_20.0_m-40.0_60.0_deg.sav'

;;==Declare runs
run = ['nue_2.0e4-amp_0.05-E0_9.0-petsc_subcomm/', $
       'nue_2.0e4-amp_0.10-E0_9.0-petsc_subcomm/', $
       'nue_3.0e4-amp_0.05-E0_9.0-petsc_subcomm/', $
       'nue_3.0e4-amp_0.10-E0_9.0-petsc_subcomm/', $
       'nue_4.0e4-amp_0.05-E0_9.0-petsc_subcomm/', $
       'nue_4.0e4-amp_0.10-E0_9.0-petsc_subcomm/', $
       'nue_5.0e4-amp_0.05-E0_9.0-petsc_subcomm/', $
       'nue_5.0e4-amp_0.10-E0_9.0-petsc_subcomm/', $
       'nue_6.0e4-amp_0.05-E0_9.0-petsc_subcomm/', $
       'nue_6.0e4-amp_0.10-E0_9.0-petsc_subcomm/']
nr = n_elements(run)

;;==Build the multi-run ktt hash
mr_den1ktt = build_multirun_hash(proj_path, $
                                 run, $
                                 save_name, $
                                 data_name)

;;==Run graphics scripts
@multirun_den1ktt_graphics
