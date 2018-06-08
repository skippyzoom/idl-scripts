;+
; Script for restoring data to fill in hashes for multirun_Ert0_main.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

path = expand_path(proj_path)+path_sep()+'nue_2.0e4-amp_0.05-E0_9.0/'
color[path] = 'red'
linestyle[path] = 0
restore, filename=expand_path(path)+path_sep()+save_name,/verbose
@load_plane_params
@build_efield_components
@build_Ert0_hashes

path = expand_path(proj_path)+path_sep()+'nue_3.0e4-amp_0.05-E0_9.0/'
color[path] = 'blue'
linestyle[path] = 0
restore, filename=expand_path(path)+path_sep()+save_name,/verbose
@load_plane_params
@build_efield_components
@build_Ert0_hashes

path = expand_path(proj_path)+path_sep()+'nue_3.0e4-amp_0.10-E0_9.0/'
color[path] = 'blue'
linestyle[path] = 2
restore, filename=expand_path(path)+path_sep()+save_name,/verbose
@load_plane_params
@build_efield_components
@build_Ert0_hashes

path = expand_path(proj_path)+path_sep()+'nue_4.0e4-amp_0.05-E0_9.0/'
color[path] = 'green'
linestyle[path] = 0
restore, filename=expand_path(path)+path_sep()+save_name,/verbose
@load_plane_params
@build_efield_components
@build_Ert0_hashes