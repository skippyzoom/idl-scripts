;+
; Batch script for analyzing data in parametric_wave.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;                                   **NOTES**
; -- You may want to .reset before running this (or any) batch script
;    in multiple directories.
;-

;;-----------------------------------------------------------------------------
;;                              ORIGINAL DATA SET
;; These runs represent the original set of runs from which I planned
;; to write the paper. When the 2.0e4-0.10 run blew up, I decided to
;; make the 3.0e4-0.05 run the baseline to which I would compare two
;; runs at different altitudes (i.e., 2.0e4-0.05 and 4.0e4-0.05) and
;; one run at double amplitude (i.e., 3.0e4-0.10). Unfortunately, the
;; 0.05 runs were very noisy. That prompted me to install the EPPIC
;; functionality that allows it to run PETSc on a subset of MPI
;; processes.
;;-----------------------------------------------------------------------------

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'parametric_wave/nue_2.0e4-amp_0.05-E0_9.0/'
;; rotate = 0
;; axes = 'xy'
;; @parametric_wave_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'parametric_wave/nue_3.0e4-amp_0.05-E0_9.0/'
;; rotate = 0
;; axes = 'xy'
;; @parametric_wave_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'parametric_wave/nue_3.0e4-amp_0.10-E0_9.0/'
;; rotate = 0
;; axes = 'xy'
;; @parametric_wave_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'parametric_wave/nue_4.0e4-amp_0.05-E0_9.0/'
;; rotate = 0
;; axes = 'xy'
;; @parametric_wave_analysis

;;-----------------------------------------------------------------------------
;;                            PETSC SUBCOMM DATA SET
;; These runs represent the data set I produced after implementing the
;; EPPIC functionality that allows it to run PETSc on a subset of MPI
;; processes. That functionality improved the particle signal-to-noise
;; ratio in the 0.05 runs. Both 2.0e4 runs still blew up (the 0.10 run
;; after 1664 time steps and the 0.05 run after 24896 time steps) but
;; I was able to push the collision frequencies higher, and thus the
;; effective altitude lower, because of the SNR improvement. I left in
;; the 2.0e4 runs because they still provide some information. There
;; is also a 'nue_*e4-subthreshold-petsc_subcomm' run corresponding to
;; each effective altitude. Each of those runs provides data on
;; background plasma parameters. Specifically, I report the
;; effectively altitude of each run based on the subthreshold $\Psi_0$
;; value.
;;-----------------------------------------------------------------------------

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_2.0e4-amp_0.05-E0_9.0-petsc_subcomm/'
rotate = 0
axes = 'xy'
@parametric_wave_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_2.0e4-amp_0.10-E0_9.0-petsc_subcomm/'
rotate = 0
axes = 'xy'
@parametric_wave_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_3.0e4-amp_0.05-E0_9.0-petsc_subcomm/'
rotate = 0
axes = 'xy'
@parametric_wave_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_3.0e4-amp_0.10-E0_9.0-petsc_subcomm/'
rotate = 0
axes = 'xy'
@parametric_wave_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_4.0e4-amp_0.05-E0_9.0-petsc_subcomm/'
rotate = 0
axes = 'xy'
@parametric_wave_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_4.0e4-amp_0.10-E0_9.0-petsc_subcomm/'
rotate = 0
axes = 'xy'
@parametric_wave_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_5.0e4-amp_0.05-E0_9.0-petsc_subcomm/'
rotate = 0
axes = 'xy'
@parametric_wave_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_5.0e4-amp_0.10-E0_9.0-petsc_subcomm/'
rotate = 0
axes = 'xy'
@parametric_wave_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_6.0e4-amp_0.05-E0_9.0-petsc_subcomm/'
rotate = 0
axes = 'xy'
@parametric_wave_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+ $
       'parametric_wave/nue_6.0e4-amp_0.10-E0_9.0-petsc_subcomm/'
rotate = 0
axes = 'xy'
@parametric_wave_analysis
