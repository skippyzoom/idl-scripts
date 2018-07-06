;+
; Batch script for analyzing data in fb_flow_angle.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;                                   **NOTES**
; -- You may want to .reset before running this (or any) batch script
;    in multiple directories.
;-

@unload_defaults
path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h0-Ey0_050/'
rotate = 0
axes = 'xy'
@fb_flow_angle_analysis

@unload_defaults
path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h1-Ey0_050/'
rotate = 0
axes = 'xy'
@fb_flow_angle_analysis

@unload_defaults
path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h2-Ey0_050/'
rotate = 0
axes = 'xy'
@fb_flow_angle_analysis

@unload_defaults
path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h0-Ey0_050/'
rotate = 0
axes = 'yz'
@fb_flow_angle_analysis

@unload_defaults
path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h1-Ey0_050/'
rotate = 0
axes = 'yz'
@fb_flow_angle_analysis

@unload_defaults
path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h2-Ey0_050/'
rotate = 0
axes = 'yz'
@fb_flow_angle_analysis
