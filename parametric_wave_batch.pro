;+
; Batch script for analyzing data in parametric_wave.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;                                   **NOTES**
; -- You may want to .reset before running this (or any) batch script
;    in multiple directories.
;-

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'parametric_wave/nue_2.0e4-amp_0.05-E0_9.0/'
rotate = 0
axes = 'xy'
@parametric_wave

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'parametric_wave/nue_3.0e4-amp_0.05-E0_9.0/'
rotate = 0
axes = 'xy'
@parametric_wave

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'parametric_wave/nue_3.0e4-amp_0.10-E0_9.0/'
rotate = 0
axes = 'xy'
@parametric_wave

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'parametric_wave/nue_4.0e4-amp_0.05-E0_9.0/'
rotate = 0
axes = 'xy'
@parametric_wave
