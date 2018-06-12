;+
; Script for creating images of den1(k,theta,w).
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Get wavelength keys
lambda = den1ktw.keys()

;;==Sort wavelength keys from smallest to largest
lambda = lambda.sort()

;;==Declare file names (one for each wavelength)
filename = expand_path(path)+path_sep()+ $
           'frames'+path_sep()+ $
           'den1ktw-'+lambda.toarray()+'m'+ $
           '-second_half'+ $
           '-norm_max'+ $
           '.'+get_extension(frame_type)

;;==Get effective time step
;;  This will differ from params.dt*params.nout in cases when the main
;;  script imported data at a sample rate > 1. It assumes a uniform
;;  sample rate.
dt = params.dt* $
     (long(time.index[1])-long(time.index[0]))
wdata = 2*!pi*fftfreq(nw,dt)
wdata = shift(wdata,nw/2-1)

;;==Get number of wavelengths
nl = n_elements(lambda)

;;==Create an array of plot objects
frm = objarr(nl)

;;==Generate images
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
trange = [0,180]
;; trange = [min(theta),max(theta)]/!dtor
;; trange = theta/!dtor
;; tdir = (theta[0] lt theta[1]) ? 1 : -1
xmajor = 7
xminor = 2
xtickvalues = (ceil(trange[1]-trange[0])/(xmajor-1))*indgen(xmajor)
xticklen = 0.02
xy_scale = 1.0
ymajor = 11
yminor = 1
for il=0,nl-1 do $
   frm[il] = $
   den1ktw_image_frame(reverse(den1ktw[lambda[il]].f_interp,1), $
                       den1ktw[lambda[il]].t_interp/!dtor, $
                       wdata/float(lambda[il]), $
                       /power, $
                       /log, $
                       /normalize, $
                       /buffer, $
                       min_value = -30, $
                       max_value = 0, $
                       rgb_table = 39, $
                       axis_style = 1, $
                       xtitle = 'Angle [deg].', $
                       ytitle = '$V_{ph}$ [m/s]', $
                       xstyle = 1, $
                       ystyle = 1, $
                       xtickdir = 1, $
                       ytickdir = 1, $
                       xticklen = xticklen, $
                       yticklen = xticklen/xy_scale, $
                       xrange = trange, $
                       yrange = vrange[lambda[il]], $
                       xmajor = xmajor, $
                       ymajor = ymajor, $
                       xminor = xminor, $
                       yminor = yminor, $
                       xtickvalues = xtickvalues, $
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

