;+
; Script for creating theta-RMS plots of den1(k,theta,w).
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'


;;==Get effective time step
;;  This will differ from params.dt*params.nout in cases when the main
;;  script imported data at a sample rate > 1. It assumes a uniform
;;  sample rate.
dt = params.dt* $
     (long(time.index[1])-long(time.index[0]))
wdata = 2*!pi*fftfreq(nw,dt)
wdata = shift(wdata,nw/2-1)

;;==Get wavelength keys
lambda = den1ktw.keys()

;;==Get number of wavelengths
nl = n_elements(lambda)

;;==Create an array of plot objects
plt = objarr(nl)

;;==Generate plots
vrange = [-500,+500]
for il=0,nl-1 do $
   plt[il] = plot(wdata/float(lambda[il]), $
                  rms(den1ktw[lambda[il]].f_interp,dim=1,/norm), $
                  /buffer, $
                  xstyle = 1, $
                  xtitle = '$V_{ph}$ [m/s]', $
                  ytitle = 'Power', $
                  xrange = vrange, $
                  font_name = 'Times', $
                  font_size = 16.0)

;;==Create array of file names
filename = expand_path(path)+path_sep()+ $
           'frames'+path_sep()+ $
           'den1ktw_rms-'+lambda.toarray()+'m'+ $
           '.'+get_extension(frame_type)

;;==Save individual frames
for il=0,nl-1 do $
   frame_save, plt[il],filename=filename[il]
