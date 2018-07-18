;+
; Script for reading and analyzing EPPIC moment*.out files from
; multiple runs in a single project.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare project path
proj_path = get_base_dir()+path_sep()+'parametric_wave/'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Set up array of read paths
run = ['parametric_wave/nue_2.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_3.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_4.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_5.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_6.0e4-subthreshold-petsc_subcomm/']
nr = n_elements(run)
path = get_base_dir()+path_sep()+run

;;==Set up the hash to contain all moments files
all_moments = hash(run)

;;==Read moments files.
for ir=0,nr-1 do $
   all_moments[run[ir]] = read_moments(path=path[ir])

;;==Set up the hash to contain all parameter files
all_params = hash(run)

;;==Read parameter files
for ir=0,nr-1 do $
   all_params[run[ir]] = set_eppic_params(path=path[ir])

;;==Plot multi-run parameters
@multirun_psi_plot
