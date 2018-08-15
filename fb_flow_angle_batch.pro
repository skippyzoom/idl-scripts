;+
; Batch script for analyzing data in fb_flow_angle.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;                                   **NOTES**
; -- You may want to .reset before running this (or any) batch script
;    in multiple directories.
;-

;;-----------------------------------------------------------------------------
;; 2-D RUNS
;; These runs use a 2-D spatial grid perp to Bz with Ey0 = 50 mV/m.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h0-Ey0_050/'
;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h1-Ey0_050/'
;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h2-Ey0_050/'
;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 3-D RUNS
;; These runs use a 3-D spatial grid with Ey0 = 50 mV/m. They use Bx
;; in place of Bz for more efficient parallelization, so the system is
;; rotated with respect to the 2-D runs.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h0-Ey0_050/'
;; rotate = 1
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h1-Ey0_050/'
;; rotate = 1
;; axes = 'yz'
;; @fb_flow_angle_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h2-Ey0_050/'
rotate = 1
axes = 'yz'
@fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; SUB-THRESHOLD RUNS
;; There are two sub-threshold runs for each altitude: The run with
;; Ex0 = 0.1 mV/m allows us to derive $\nu_e$ from parallel drift; the
;; run with Ey0 = 10 mV/m allows us to derive $\nu_i$ from Pedersen
;; drift. Note that rotate and axes do not factor in to moment analysis.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h0-Ex0_0.1/'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h0-Ey0_010/'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h1-Ex0_0.1/'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h1-Ey0_010/'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h2-Ex0_0.1/'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h2-Ey0_010/'
;; @fb_flow_angle_analysis
