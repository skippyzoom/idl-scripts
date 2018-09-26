;+
; Plot the phase difference between den0 and temp0. This script
; assumes the user has loaded den0 into memory and calculated temp0,
; probably from den0, flux<x,y,z>0, and nvsqr<x,y,z>0.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den0_temp0_phase'+ $
           '-'+axes+ $
           '.'+get_extension(frame_type)

;;==Calculate the vector of phase differences
pd = fltarr(time.nt)
for it=0,time.nt-1 do $
   pd[it] = phase_difference(den0[*,*,it],temp0[*,*,it])

;;==Create the plot frame
frm = plot(float(time.stamp), $
           pd/!dtor, $
           xstyle = 1, $
           xtitle = 'Time ['+time.unit+']', $
           ytitle = 'Phase Difference [deg.]', $
           font_name = 'Times', $
           font_size = 10.0, $
           /buffer)

;;==Add a path label
txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save individual images
frame_save, frm,filename=filename
