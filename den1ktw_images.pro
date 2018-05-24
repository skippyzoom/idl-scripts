;+
; Script for creating images of den1(k,theta,w).
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

;;==Sort wavelength keys from smallest to largest
lambda = lambda.sort()

;;==Get number of wavelengths
nl = n_elements(lambda)

;;==Create an array of plot objects
img = objarr(nl)

;;==Generate images
;;-->Kind of a hack
vrange_lt_10 = [-500,+500]
vrange_ge_10 = [-100,+100]
;;<--
trange = [0,180]
xmajor = 7
xminor = 2
xtickvalues = (ceil(trange[1]-trange[0])/(xmajor-1))*indgen(xmajor)
xticklen = 0.02
xy_scale = 1.0
ymajor = 5
yminor = 4
for il=0,nl-1 do $
   img[il] = image(den1ktw[lambda[il]].f_interp, $
                   den1ktw[lambda[il]].t_interp/!dtor, $
                   wdata/float(lambda[il]), $
                   /buffer, $
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
                   yrange = float(lambda[il]) lt 10.0 ? $
                   vrange_lt_10 : vrange_ge_10, $
                   xmajor = xmajor, $
                   ymajor = ymajor, $
                   xminor = xminor, $
                   yminor = yminor, $
                   xtickvalues = xtickvalues, $
                   font_name = 'Times', $
                   font_size = 16.0)

;;==Adjust aspect ratio of each image
for il=0,nl-1 do $
   img[il].aspect_ratio = $
   xy_scale* $
   (float(img[il].xrange[1])-float(img[il].xrange[0]))/ $
   (float(img[il].yrange[1])-float(img[il].yrange[0]))

;;==Add a path label
for il=0,nl-1 do $
   txt = text(0.0,0.005, $
              path, $
              target = img[il], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Create array of file names
filename = expand_path(path)+path_sep()+ $
           'frames'+path_sep()+ $
           'den1ktw-'+lambda.toarray()+'m'+ $
           '.'+get_extension(frame_type)

;;==Save individual frames
for il=0,nl-1 do $
   frame_save, img[il],filename=filename[il]

