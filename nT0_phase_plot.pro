;+
; Plot the phase difference between den0 and temp0. This script
; assumes the user has loaded den0 into memory and calculated temp0,
; probably from den0, flux<x,y,z>1, and nvsqr<x,y,z>1.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den0_temp0_phase',frame_type, $
                          path = filepath, $
                          additions = axes)

;;==Convert temperature to relative perturbed temperature
delT1 = (temp0-mean(temp0))/mean(temp0)

;;==Calculate the vector of phase differences
pd = fltarr(time.nt)
for it=0,time.nt-1 do $
   pd[it] = phase_difference(den0[*,*,it],delT1[*,*,it])

;;==Create the plot frame
frm = plot(float(time.stamp), $
           pd/!dtor, $
           'ko', $
           sym_filled = 1, $
           xstyle = 1, $
           xtitle = 'Time ['+time.unit+']', $
           ytitle = 'Phase Difference [deg.]', $
           yrange = [0,180], $
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
