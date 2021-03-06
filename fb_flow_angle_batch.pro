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
;; SUB-THRESHOLD RUNS
;; There are two sub-threshold runs for each altitude: The run with
;; Ex0 = 0.1 mV/m allows us to derive $\nu_e$ from parallel drift; the
;; run with Ey0 = 10 mV/m allows us to derive $\nu_i$ from Pedersen
;; drift. Note that rotate and axes do not factor in to moment analysis.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-subthreshold/h0-Ex0_0.1/'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-subthreshold/h0-Ey0_010/'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-subthreshold/h1-Ex0_0.1/'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-subthreshold/h1-Ey0_010/'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-subthreshold/h2-Ex0_0.1/'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-subthreshold/h2-Ey0_010/'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; OLD 2-D RUNS
;; These runs use a 2-D spatial grid perp to Bz with Ey0 = 50 mV/m.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h0-Ey0_050-old/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h1-Ey0_050-old/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h2-Ey0_050-old/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 2-D RUNS
;; These runs use a 2-D spatial grid perp to Bz with Ey0 = 50
;; mV/m. These are twice as long as the original 2-D runs and used less
;; run-time spatial averaging.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h0-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h1-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h2-Ey0_050/'
;; ;; rotate = 0
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
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h1-Ey0_050/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D/h2-Ey0_050/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 2-D RUNS WITH FULL OUTPUT: 30 mV/m
;; These runs use a 2-D spatial grid perp to Bz with Ey0 = 30
;; mV/m. These are twice as long as the original 2-D runs and used less
;; run-time spatial averaging. These runs produced full spatial
;; (non-FT) output.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-full_output/h0-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-full_output/h1-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-full_output/h2-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 2-D RUNS WITH FULL OUTPUT: 50 mV/m
;; These runs use a 2-D spatial grid perp to Bz with Ey0 = 50
;; mV/m. These are twice as long as the original 2-D runs and used less
;; run-time spatial averaging. These runs produced full spatial
;; (non-FT) output.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-full_output/h0-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-full_output/h1-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis
 
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-full_output/h2-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 2-D RUNS WITH FULL OUTPUT: 70 mV/m
;; These runs use a 2-D spatial grid perp to Bz with Ey0 = 70
;; mV/m. These are twice as long as the original 2-D runs and used less
;; run-time spatial averaging. These runs produced full spatial
;; (non-FT) output.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-full_output/h0-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-full_output/h1-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-full_output/h2-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 3-D RUNS WITH FULL OUTPUT: 30 mV/m
;; These runs use a 3-D spatial grid with Ey0 = 30 mV/m. They use Bx
;; in place of Bz for more efficient parallelization, so the system is
;; rotated with respect to the 2-D runs. These runs produced full spatial
;; (non-FT) output.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h0-Ey0_030/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h1-Ey0_030/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h2-Ey0_030/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h0-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h1-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h2-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h0-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h1-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h2-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 3-D RUNS WITH FULL OUTPUT: 50 mV/m
;; These runs use a 3-D spatial grid with Ey0 = 50 mV/m. They use Bx
;; in place of Bz for more efficient parallelization, so the system is
;; rotated with respect to the 2-D runs. These runs produced full spatial
;; (non-FT) output.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h0-Ey0_050/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h1-Ey0_050/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h2-Ey0_050/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h0-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h1-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h2-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h0-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h1-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h2-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 3-D RUNS WITH FULL OUTPUT: 70 mV/m
;; These runs use a 3-D spatial grid with Ey0 = 70 mV/m. They use Bx
;; in place of Bz for more efficient parallelization, so the system is
;; rotated with respect to the 2-D runs. These runs produced full spatial
;; (non-FT) output.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h0-Ey0_070/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h1-Ey0_070/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h2-Ey0_070/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h0-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h1-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h2-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h0-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h1-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-full_output/h2-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 2-D RUNS WITH NEW COLLISION BUG FIX: 30 mV/m
;; These runs use a 2-D spatial grid perp to Bz with Ey0 = 30
;; mV/m. These are twice as long as the original 2-D runs and used less
;; run-time spatial averaging. These runs produced full spatial
;; (non-FT) output and included a bug-fix to the collision algorithms.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h0-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h1-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis
 
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h2-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 2-D RUNS WITH NEW COLLISION BUG FIX: 50 mV/m
;; These runs use a 2-D spatial grid perp to Bz with Ey0 = 50
;; mV/m. These are twice as long as the original 2-D runs and used less
;; run-time spatial averaging. These runs produced full spatial
;; (non-FT) output and included a bug-fix to the collision algorithms.
;;-----------------------------------------------------------------------------
@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h0-Ey0_050/'
;; rotate = 0
axes = 'xy'
@fb_flow_angle_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h1-Ey0_050/'
;; rotate = 0
axes = 'xy'
@fb_flow_angle_analysis
 
@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h2-Ey0_050/'
;; rotate = 0
axes = 'xy'
@fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 2-D RUNS WITH NEW COLLISION BUG FIX: 70 mV/m
;; These runs use a 2-D spatial grid perp to Bz with Ey0 = 70
;; mV/m. These are twice as long as the original 2-D runs and used less
;; run-time spatial averaging. These runs produced full spatial
;; (non-FT) output and included a bug-fix to the collision algorithms.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h0-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h1-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/2D-new_coll/h2-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 3-D RUNS WITH NEW COLLISION BUG FIX: 30 mV/m
;; These runs use a 3-D spatial grid with Ey0 = 30 mV/m. They use Bx
;; in place of Bz for more efficient parallelization, so the system is
;; rotated with respect to the 2-D runs. These runs produced full spatial
;; (non-FT) output and included a bug-fix to the collision algorithms.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_030/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_030/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_030/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_030/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 3-D RUNS WITH NEW COLLISION BUG FIX: 50 mV/m
;; These runs use a 3-D spatial grid with Ey0 = 50 mV/m. They use Bx
;; in place of Bz for more efficient parallelization, so the system is
;; rotated with respect to the 2-D runs. These runs produced full spatial
;; (non-FT) output and included a bug-fix to the collision algorithms.
;;-----------------------------------------------------------------------------
@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_050/'
;; rotate = 0
axes = 'yz'
@fb_flow_angle_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_050/'
;; rotate = 0
axes = 'yz'
@fb_flow_angle_analysis

@unload_defaults
@unload_data
path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_050/'
;; rotate = 0
axes = 'yz'
@fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_050/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;;-----------------------------------------------------------------------------
;; 3-D RUNS WITH NEW COLLISION BUG FIX: 70 mV/m
;; These runs use a 3-D spatial grid with Ey0 = 70 mV/m. They use Bx
;; in place of Bz for more efficient parallelization, so the system is
;; rotated with respect to the 2-D runs. These runs produced full spatial
;; (non-FT) output and included a bug-fix to the collision algorithms.
;;-----------------------------------------------------------------------------
;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_070/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_070/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_070/'
;; ;; rotate = 0
;; axes = 'yz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xy'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h0-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h1-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

;; @unload_defaults
;; @unload_data
;; path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/h2-Ey0_070/'
;; ;; rotate = 0
;; axes = 'xz'
;; @fb_flow_angle_analysis

