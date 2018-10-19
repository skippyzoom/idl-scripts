;+
; Script for reading and analyzing EPPIC moment*.out files from
; multiple runs in a single project.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare project name
;; project = 'parametric_wave'
project = 'fb_flow_angle/3D'

;;==Set project path
proj_path = get_base_dir()+path_sep()+project

;;==Set up array of read paths
;; run = ['nue_2.0e4-subthreshold-petsc_subcomm/', $
;;        'nue_3.0e4-subthreshold-petsc_subcomm/', $
;;        'nue_4.0e4-subthreshold-petsc_subcomm/', $
;;        'nue_5.0e4-subthreshold-petsc_subcomm/', $
;;        'nue_6.0e4-subthreshold-petsc_subcomm/']
;; run = ['h0-Ex0_0.1', $
;;        'h0-Ey0_010', $
;;        'h1-Ex0_0.1', $
;;        'h1-Ey0_010', $
;;        'h2-Ex0_0.1', $
;;        'h2-Ey0_010']
;; run = ['h0-Ey0_010', $
;;        'h1-Ey0_010', $
;;        'h2-Ey0_010']
run = ['h0-Ex0_0.1', $
       'h1-Ex0_0.1', $
       'h2-Ex0_0.1']
;; run = ['h0-Ey0_030-full_output', $
;;        'h1-Ey0_030-full_output', $
;;        'h2-Ey0_030-full_output']
;; run = ['h0-Ey0_050-full_output', $
;;        'h1-Ey0_050-full_output', $
;;        'h2-Ey0_050-full_output']
;; run = ['h0-Ey0_070-full_output', $
;;        'h1-Ey0_070-full_output', $
;;        'h2-Ey0_070-full_output']
nr = n_elements(run)
path = get_base_dir()+path_sep()+project+path_sep()+run

;;==Declare note to append to file names
filename_note = strmid(run[0],3)

;;==Set up the hash to contain all moments files
mr_moments = hash(run)

;;==Read moments files
for ir=0,nr-1 do $
   mr_moments[run[ir]] = read_moments(path=path[ir])

;;==Set up the hash to contain all parameter files
mr_params = hash(run)

;;==Read parameter files
for ir=0,nr-1 do $
   mr_params[run[ir]] = set_eppic_params(path=path[ir])

;;==Plot multi-run parameters
;; @multirun_psi_plot
;; @multirun_nui_plot
;; @multirun_nue_plot
;; @multirun_vd_plot
