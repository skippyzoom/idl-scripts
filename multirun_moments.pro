;+
; Script for reading and analyzing EPPIC moment*.out files from
; multiple runs in a single project.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare project path
proj_path = get_base_dir()+path_sep()+'parametric_wave/'

;;==Set up array of read paths
run = ['parametric_wave/nue_2.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_3.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_4.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_5.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_6.0e4-subthreshold-petsc_subcomm/']
nr = n_elements(run)
path = get_base_dir()+path_sep()+run

;;==Set up the hash to contain all moments files
mr_moments = hash(run)

;;==Read moments files.
for ir=0,nr-1 do $
   mr_moments[run[ir]] = read_moments(path=path[ir])

;;==Set up the hash to contain all parameter files
mr_params = hash(run)

;;==Read parameter files
for ir=0,nr-1 do $
   mr_params[run[ir]] = set_eppic_params(path=path[ir])

;;==Plot multi-run parameters
@multirun_psi_plot
@multirun_nui_plot
