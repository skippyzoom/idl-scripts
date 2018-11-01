;+
; Script to plot the angular deflection of the spectral centroid from
; the Hall direction, with 1-sigma error, throughout an entire run.
;
; Created by Matt Young.
;------------------------------------------------------------------------------

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name
if n_elements(bw) ne 0 then $
   str_bw = 'bw'+strcompress(bw,/remove_all) $
else str_bw = ''
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den0fft_t_rcm_theta',frame_type, $
                          path = filepath, $
                          additions = str_bw)

;;==Create plot frame
frm = plot(float(time.stamp), $
           rcm_theta/!dtor, $
           xstyle = 1, $
           xtitle = 'Time ['+time.unit+']', $
           ytitle = '$\theta$', $
           yrange = [-40,+10], $
           font_size = 10.0, $
           font_name = 'Times', $
           /buffer)

;;==Overplot error lines
!NULL = plot(float(time.stamp), $
             (rcm_theta+dev_rcm_theta)/!dtor, $
             linestyle = 1, $
             overplot = frm, $
             /buffer)
!NULL = plot(float(time.stamp), $
             (rcm_theta-dev_rcm_theta)/!dtor, $
             linestyle = 1, $
             overplot = frm, $
             /buffer)

;;==Overplot drift-velocity angle
!NULL = plot(float(time.stamp), $
             make_array(time.nt,value=fbfa_vd_angle(path)/!dtor), $
             linestyle = 2, $
             overplot = frm, $
             /buffer)

;;==Add a path label
txt = text(0.0,0.90, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save graphics frame
frame_save, frm,filename=filename
