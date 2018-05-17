;+
; Script for making graphics of RMS spectrally interpolated data. See
; den1_kttrms_calc.pro. 
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

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

;;==Declare wavelength color array
clr = 256*indgen(nl)/(nl-1)
color = rgb_table[clr,*]

;;==Plot the first wavelength
plt = plot(1e3*params.dt*time.index, $
           rms_xy2kt[0,*], $
           color = reform(color[0,*]), $
           xstyle = 1, $
           xtitle = 'Time [ms]', $
           ytitle = '$\langle\delta n(k)\rangle$', $
           ;; yrange = [2e-5,5e-5], $
           ystyle = 0, $
           name = str_lam[0], $
           /buffer)

;;==Plot additional wavelengths, if necessary
opl = objarr(nl-1)
for il=1,nl-1 do $
   opl[il-1] = plot(1e3*params.dt*time.index, $
                    rms_xy2kt[il,*], $
                    color = reform(color[il,*]), $
                    xtitle = 'Time [ms]', $
                    /overplot, $
                    name = str_lam[il], $
                    /buffer)

;;==Add a legend
xrange = plt.xrange
yrange = plt.yrange
leg = legend(target = [plt,opl], $
             /auto_text_color, $
             horizontal_alignment = 'left', $
             vertical_alignment = 'top', $
             position = [xrange[0],yrange[1]], $
             sample_width = 0.0, $
             vertical_spacing = 0.05, $
             /data)
leg.scale, 2.0,0.9
leg.translate, 0.005,0.0,/normal

;;==Save plots
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den1ktt_rms'+ $
           '.'+get_extension(frame_type)
frame_save, plt,filename=filename
