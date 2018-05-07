;+
; Script for making graphics of RMS spectrally interpolated data. See
; den1_kttrms_calc.pro. 
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare frame type
frame_type = '.pdf'

;;==Get size of array
dsize = size(rms_xy2kt)
nl = dsize[1]

;;==Define string wavelengths, if possible
if n_elements(lambda) ne 0 then $
   str_lam = string(lambda,format='(f04.1)') $
else $
   str_lam = sindgen(nl)
str_lam = "$\lambda$ = "+strcompress(str_lam,/remove_all)+" m"

;;==Get a color table
loadct, 11,rgb_table=rgb_table

;;==Get number of wavelengths
color = bytarr(nl,3)
for il=0,nl-1 do $
   color[il,*] = rgb_table[il*(256/nl),*]

plt = plot(1e3*params.dt*time.index, $
           rms_xy2kt[0,*], $
           color = reform(color[0,*]), $
           xstyle = 1, $
           xtitle = 'Time [ms]', $
           ytitle = '$\langle\delta n(k)\rangle$', $
           ystyle = 0, $
           name = str_lam[0], $
           /buffer)
opl = objarr(nl-1)
for il=1,nl-1 do $
   opl[il-1] = plot(1e3*params.dt*time.index, $
                    rms_xy2kt[il,*], $
                    color = reform(color[il,*]), $
                    xtitle = 'Time [ms]', $
                    /overplot, $
                    name = str_lam[il], $
                    /buffer)
xrange = plt.xrange
yrange = plt.yrange
leg = legend(target = [plt,opl], $
             /auto_text_color, $
             horizontal_alignment = 'right', $
             vertical_alignment = 'bottom', $
             position = [xrange[1],yrange[0]], $
             /data)

filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den1_rms_xy2kt'+ $
           '.'+get_extension(frame_type)
frame_save, plt,filename=filename
