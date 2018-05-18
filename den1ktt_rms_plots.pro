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

;;==Declare wavelengths to call out
l_callout = [3.0,10.6]

;;==Get number of call-outs
nlc = n_elements(l_callout)

;;==Ensure correct format (cf. interp_xy2kt.pro)
if nlc gt 0 then l_callout = string(l_callout,format='(f06.2)')

;;==Construct call-outs label for file name
str_l_callout = ''
for ilc=0,nlc-1 do $
   str_l_callout += l_callout[ilc]+'_'
if nlc gt 0 then $
   str_l_callout = str_l_callout.remove(-1)+'m' $

;;==Sort wavelength keys from smallest to largest
lambda = lambda.sort()

;;==Create wavelength labels
str_lam = "$\lambda$ = "+strcompress(lambda.toarray(),/remove_all)+" m"

;;==Declare color array
;; loadct, 39,rgb_table=rgb_table
;; color = [rgb_table[80,*],rgb_table[240,*]]
loadct, 43,rgb_table=rgb_table,bottom=30
rgb_table = reverse(rgb_table,1)
clr = 256*indgen(nl)/(nl-1)
color = rgb_table[clr,*]

;;==Declare line-thickness array
thick = make_array(nl,value=0.5)
if nlc gt 0 then $
   for ilc=0,nlc-1 do $
      thick[(lambda.where(l_callout[ilc]))[0]] = 2.0


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
           '-'+str_l_callout+ $
           '.'+get_extension(frame_type)
frame_save, plt,filename=filename
