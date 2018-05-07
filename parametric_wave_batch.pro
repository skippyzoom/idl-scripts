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
path = get_base_dir()+path_sep()+'parametric_wave/run015/'
rotate = 0
axes = 'xy'
@parametric_wave
