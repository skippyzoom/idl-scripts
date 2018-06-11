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
frm = objarr(nl)

;;==Generate plots
;;-->Kind of a hack
;; vrange_lt_10 = [-500,+500]
;; vrange_ge_10 = [-100,+100]
vrange = hash(lambda)
vrange['002.00'] = [-1000,+1000]
vrange['003.00'] = [-500,+500]
vrange['004.00'] = [-500,+500]
vrange['005.00'] = [-500,+500]
vrange['010.00'] = [-100,+100]
vrange['020.00'] = [-100,+100]
;;<--
xmajor = 11
xminor = 1
xticklen = 0.02
xy_scale = 1.0
for il=0,nl-1 do $
   frm[il] = plot(wdata/float(lambda[il]), $
                  rms(den1ktw[lambda[il]].f_interp,dim=1,/norm), $
                  /buffer, $
                  xstyle = 1, $
                  xtitle = '$V_{ph}$ [m/s]', $
                  ytitle = 'Power', $
                  ;; xrange = float(lambda[il]) lt 10.0 ? $
                  ;; vrange_lt_10 : vrange_ge_10, $
                  xrange = vrange[lambda[il]], $
                  xmajor = xmajor, $
                  xminor = xminor, $
                  xticklen = xticklen, $
                  yticklen = xticklen/xy_scale, $
                  font_name = 'Times', $
                  font_size = 16.0)

;;==Adjust aspect ratio of each image
for il=0,nl-1 do $
   frm[il].aspect_ratio = $
   xy_scale* $
   (float(frm[il].xrange[1])-float(frm[il].xrange[0]))/ $
   (float(frm[il].yrange[1])-float(frm[il].yrange[0]))

;;==Add a path label
for il=0,nl-1 do $
   txt = text(0.0,0.005, $
              path, $
              target = frm[il], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Create array of file names
filename = expand_path(path)+path_sep()+ $
           'frames'+path_sep()+ $
           'den1ktw_rms-'+lambda.toarray()+'m'+ $
           '.'+get_extension(frame_type)

;;==Save individual frames
for il=0,nl-1 do $
   frame_save, frm[il],filename=filename[il]
