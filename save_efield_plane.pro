;+
; Script for storing Ex and Ey consistent way. See
; get_efield_plane.pro and restore_efield_plane.pro
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set defaults
if n_elements(path) eq 0 then path = './'
if n_elements(axes) eq 0 then axes = 'xy'

;;==Save the arrays
save, Ex,Ey,filename=expand_path(path)+path_sep()+'efield_'+axes+'.sav'
