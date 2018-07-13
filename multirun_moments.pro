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

;;==Set up the list of run directories
run = list()
run = ['parametric_wave/nue_2.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_3.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_4.0e4-subthreshold-petsc_subcomm/', $
       'parametric_wave/nue_5.0e4-subthreshold-petsc_subcomm/']
nr = n_elements(run)

;;==Set up the hash to contain all moments files
all_moments = hash(run)

;;==Read moments files.
;;-->This could be a loop over calls to a function (e.g.,
;;'build_all_moments'). If so, you should extract the actual function
;;calls from the analyze_moments script.
ir = 0       
path = get_base_dir()+path_sep()+run[ir]
params = set_eppic_params(path=path)
nt_max = calc_timesteps(path=path)
params['nt_max'] = nt_max
@analyze_moments
all_moments[run[ir]] = moments

ir = 1
path = get_base_dir()+path_sep()+run[ir]
params = set_eppic_params(path=path)
nt_max = calc_timesteps(path=path)
params['nt_max'] = nt_max
@analyze_moments
all_moments[run[ir]] = moments

ir = 2
path = get_base_dir()+path_sep()+run[ir]
params = set_eppic_params(path=path)
nt_max = calc_timesteps(path=path)
params['nt_max'] = nt_max
@analyze_moments
all_moments[run[ir]] = moments

ir = 3
path = get_base_dir()+path_sep()+run[ir]
params = set_eppic_params(path=path)
nt_max = calc_timesteps(path=path)
params['nt_max'] = nt_max
@analyze_moments
all_moments[run[ir]] = moments


;;==Plot multi-run parameters
@multrun_psi_plot
