;+
; Script for making graphics of RMS spectrally interpolated data. See
; den1_kttrms_calc.pro. 
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Get available wavelengths
lambda = den1ktt_rms.keys()
nl = den1ktt_rms.count()

;;==Create wavelength labels
str_lam = string(lambda.toarray(),format='(f04.1)')
str_lam = "$\lambda$ = "+strcompress(str_lam,/remove_all)+" m"

;;==Declare color array
;; loadct, 39,rgb_table=rgb_table
;; color = [rgb_table[80,*],rgb_table[240,*]]
loadct, 0,rgb_table=rgb_table
clr = 256*indgen(nl)/(nl-1)
color = rgb_table[clr,*]
color[lambda.where('3.0'),*] = [255,0,0]
color[lambda.where('10.6'),*] = [0,0,255]

;;==Declare line-thickness array
thick = make_array(nl,value=0.5)
thick[lambda.where('3.0'),*] = 2.0
thick[lambda.where('10.6'),*] = 2.0


;;==Plot the first wavelength
plt = plot(1e3*params.dt*time.index, $
           den1ktt_rms[lambda[0]], $
           color = reform(color[0,*]), $
           thick = thick[0], $
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
                    den1ktt_rms[lambda[il]], $
                    color = reform(color[il,*]), $
                    thick = thick[il], $
                    xtitle = 'Time [ms]', $
                    /overplot, $
                    name = str_lam[il], $
                    /buffer)

;;==Add a legend
;; xrange = plt.xrange
;; yrange = plt.yrange
;; leg = legend(target = [plt,opl], $
;;              /auto_text_color, $
;;              horizontal_alignment = 'left', $
;;              vertical_alignment = 'top', $
;;              position = [xrange[0],yrange[1]], $
;;              sample_width = 0.0, $
;;              vertical_spacing = 0.05, $
;;              /data)
;; leg.scale, 1.5,0.9
;; leg.translate, 0.005,0.0,/normal

;;==Save plots
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'den1ktt_rms'+ $
           '-3.0_10.6'+ $
           '.'+get_extension(frame_type)
frame_save, plt,filename=filename
