;+
; Script for creating images of den1(k,theta,w).
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;; ;;==Get wavelength keys
;; lambda = den1ktw.keys()

;; ;;==Sort wavelength list from smallest to largest
;; if isa(lambda,'list') then lambda = lambda.sort()

;;==Get wavelength keys from smallest to largest
if n_elements(lambda) eq 0 then lambda = (den1ktw.keys()).sort()

;;==Convert list to string array, if necessary
if isa(lambda,'list') then lambda = lambda.toarray()

;;==Get number of wavelengths
nl = n_elements(lambda)

;;==Declare file names (one for each wavelength)
filepath = expand_path(path)+path_sep()+'frames'
if isa(lambda,'string') then str_lambda = lambda $
else str_lambda = string(float(lambda),format='(f5.1)')
str_lambda = strcompress(str_lambda,/remove_all)
filename = strarr(nl)
for il=0,nl-1 do $
   filename[il] = build_filename('den1ktw',frame_type, $
                                 path = filepath, $
                                 additions = [str_lambda[il], $
                                              'second_half', $
                                              ;; 'full_time', $
                                              'norm_max', $
                                              'vph'])

;;==Get effective time step
dt = params.dt*params.nout*time.subsample

;;==Create frequency vector
wdata = 2*!pi*fftfreq(nw,dt)
wdata = shift(wdata,nw/2-1)

;;==Create an array of plot objects
frm = objarr(nl)

;;==Generate images
trange = [0,180]
;; trange = [min(theta),max(theta)]/!dtor
;; trange = theta/!dtor
;; tdir = (theta[0] lt theta[1]) ? 1 : -1
toffset = 90
xmajor = 7
xminor = 2
xtickvalues = trange[0] + $
              (ceil(trange[1]-trange[0])/(xmajor-1))*indgen(xmajor)
xtickname = (trange[1]-trange[0])*indgen(xmajor)/(xmajor-1) - toffset
xtickname = plusminus_labels(xtickname,format='(i3)')
xticklen = 0.02
xy_scale = 1.0
for il=0,nl-1 do $
   frm[il] = $
   ;; ktw_image_frame(reverse(den1ktw[lambda[il]].f_interp,1), $
   ktw_image_frame(den1ktw[lambda[il]].f_interp, $
                   den1ktw[lambda[il]].t_interp/!dtor, $
                   ;; wdata, $
                   wdata/(2*!pi/float(lambda[il])), $
                   /power, $
                   /log, $
                   /normalize, $
                   /buffer, $
                   min_value = -30, $
                   max_value = 0, $
                   rgb_table = 39, $
                   axis_style = 1, $
                   title = str_lambda[il]+' m', $
                   xtitle = 'Zenith Angle [deg].', $
                   ytitle = '$V_{ph}$ [m/s]', $
                   xstyle = 1, $
                   ystyle = 1, $
                   xtickdir = 1, $
                   ytickdir = 1, $
                   xticklen = xticklen, $
                   yticklen = xticklen/xy_scale, $
                   ;; xrange = trange, $
                   ;; yrange = [-1.2e3,+1.2e3], $
                   yrange = [-2e3,+2e3], $
                   ;; yrange = ([[-500,+500], $
                   ;;            [-800,+800], $
                   ;;            [-800,+800]])[*,il], $
                   xmajor = xmajor, $
                   xminor = xminor, $
                   ymajor = 5, $
                   ;; yminor = ([4,7,7])[il], $
                   yminor = 4, $
                   ;; xtickvalues = xtickvalues, $
                   ;; xtickname = xtickname, $
                   xshowtext = 1, $
                   yshowtext = 1, $
                   font_name = 'Times', $
                   font_size = 16.0)

;;==Adjust aspect ratio of each image
for il=0,nl-1 do $
   frm[il].aspect_ratio = $
   xy_scale* $
   (float(frm[il].xrange[1])-float(frm[il].xrange[0]))/ $
   (float(frm[il].yrange[1])-float(frm[il].yrange[0]))

;;==Print value of RMS sound speed
if n_elements(Cs_rms) ne 0 then $
   for il=0,nl-1 do $
      txt = text(0.0,0.95, $
                 '$\langle C_s \rangle$ = '+ $
                 string(Cs_rms,format='(f5.1)')+ $
                 ' m/s', $
                 target = frm[il], $
                 font_name = 'Times', $
                 font_size = 10.0)

;;==Overplot lines at +/- sound speed
if n_elements(Cs_rms) ne 0 then $
   for il=0,nl-1 do $
      !NULL = plot([frm[il].xrange[0],frm[il].xrange[1]], $
                   ;; [+(2*!pi/lambda[il])*Cs_rms, $
                   ;;  +(2*!pi/lambda[il])*Cs_rms], $
                   [+Cs_rms,+Cs_rms], $
                   linestyle = 1, $
                   thick = 1.5, $
                   color = 'white', $
                   overplot = frm[il])
if n_elements(Cs_rms) ne 0 then $
   for il=0,nl-1 do $
      !NULL = plot([frm[il].xrange[0],frm[il].xrange[1]], $
                   ;; [-(2*!pi/lambda[il])*Cs_rms, $
                   ;;  -(2*!pi/lambda[il])*Cs_rms], $
                   [-Cs_rms,-Cs_rms], $
                   linestyle = 1, $
                   thick = 1.5, $
                   color = 'white', $
                   overplot = frm[il])

;;==Print value of RMS drift
if n_elements(Vd_rms) ne 0 then $
   for il=0,nl-1 do $
      txt = text(0.0,0.92, $
                 '$\langle V_d \rangle$ = '+ $
                 string(Vd_rms,format='(f5.1)')+ $
                 ' m/s', $
                 target = frm[il], $
                 font_name = 'Times', $
                 font_size = 10.0)

;;==Overplot lines at +/- drift speed
;; if n_elements(Vd_rms) ne 0 then $
;;    for il=0,nl-1 do $
;;       !NULL = plot([frm[il].xrange[0],frm[il].xrange[1]], $
;;                    [+(2*!pi/lambda[il])*Vd_rms, $
;;                     +(2*!pi/lambda[il])*Vd_rms], $
;;                    linestyle = 2, $
;;                    color = 'white', $
;;                    overplot = frm[il])
;; if n_elements(Vd_rms) ne 0 then $
;;    for il=0,nl-1 do $
;;       !NULL = plot([frm[il].xrange[0],frm[il].xrange[1]], $
;;                    [-(2*!pi/lambda[il])*Vd_rms, $
;;                     -(2*!pi/lambda[il])*Vd_rms], $
;;                    linestyle = 2, $
;;                    color = 'white', $
;;                    overplot = frm[il])

;;==Add a path label
for il=0,nl-1 do $
   txt = text(0.0,0.005, $
              path, $
              target = frm[il], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save individual frames
for il=0,nl-1 do $
   frame_save, frm[il],filename=filename[il]

