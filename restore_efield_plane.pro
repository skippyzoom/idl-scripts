;+
; Script for restoring Ex and Ey for a given plane
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set defaults
if n_elements(path) eq 0 then path = './'
if n_elements(axes) eq 0 then axes = 'xy'

;;==Declare filename
filename = expand_path(path)+path_sep()+ $
           'efield_'+axes+ $
           '-subsample_2'+ $
           '.sav'

;;==Restore the IDL data file
restore, filename=filename,/verbose
