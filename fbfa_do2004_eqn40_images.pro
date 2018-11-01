;+
; Script for making an images of the temperature/density ratio given by
; Equation 40 in Dimant & Oppenheim (2004)
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare number of points in kx and ky
nkx = 512
nky = 512

;;==Declare angle parameter for ratio calculation
angle = 'theta'

;;==Get run parameters
params = set_eppic_params(path=path)
dx = params.dx*params.nout_avg
dy = params.dy*params.nout_avg

;;==Compute the ratio magnitude and phase
rat = fbfa_do2004_eqn40(path,nkx=nky,nky=nkx,/double,angle=angle)
mag = sqrt(rat.re^2+rat.im^2)
mag[where(~finite(mag))] = min(mag)
arg = atan(rat.im,rat.re)
arg[where(~finite(arg))] = 0.0

;;==Construct k-space vectors
kxvec = 2*!pi*fftfreq(nkx,dx)
kxvec = shift(kxvec,nkx/2-1)
kyvec = 2*!pi*fftfreq(nky,dy)
kyvec = shift(kyvec,nky/2-1)

;;==Set common graphics parameters
xrange = [-2*!pi,+2*!pi]
yrange = [-2*!pi,+2*!pi]


;;==Declare file name for magnitude image
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den1_temp1_DO2004_eqn40',frame_type, $
                          path = filepath, $
                          additions = [axes,'mag',angle])

;;==Create image frame
frm = image(alog10(mag),kxvec,kyvec, $
            rgb_table = 53, $
            axis_style = 1, $
            position = [0.10,0.10,0.80,0.80], $
            min_value = -3, $
            max_value = 0, $
            xrange = xrange, $
            yrange = yrange, $
            xmajor = 5, $
            xminor = 1, $
            ymajor = 5, $
            yminor = 1, $
            xstyle = 1, $
            ystyle = 1, $
            xticklen = 0.02, $
            yticklen = 0.02, $
            xsubticklen = 0.5, $
            ysubticklen = 0.5, $
            xtickdir = 1, $
            ytickdir = 1, $
            font_name = 'Times', $
            font_size = 10.0, $
            /buffer)

;;==Add colorbar
clr = colorbar(target = frm, $
               title = '$log_{10}|\tau_i/\eta_i|$', $
               major = 4, $
               minor = 1, $
               orientation = 1, $
               textpos = 1, $
               position = [0.82,0.10,0.84,0.80], $
               font_size = 12.0, $
               font_name = 'Times', $
               hide = 0)

;;==Add a path label
txt = text(0.0,0.90, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save individual images
frame_save, frm,filename=filename

;;==Declare file name for phase image
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den1_temp1_DO2004_eqn40',frame_type, $
                          path = filepath, $
                          additions = [axes,'arg',angle])

;;==Prepare custom color table
ct = get_custom_ct(2)

;;==Create image frame
frm = image(arg/!dtor,kxvec,kyvec, $
            rgb_table = [[ct.r],[ct.g],[ct.b]], $
            axis_style = 1, $
            position = [0.10,0.10,0.80,0.80], $
            min_value = -180, $
            max_value = +180, $
            xrange = xrange, $
            yrange = yrange, $
            xmajor = 5, $
            xminor = 1, $
            ymajor = 5, $
            yminor = 1, $
            xstyle = 1, $
            ystyle = 1, $
            xsubticklen = 0.5, $
            ysubticklen = 0.5, $
            xtickdir = 1, $
            ytickdir = 1, $
            font_name = 'Times', $
            font_size = 10.0, $
            /buffer)

;;==Add colorbar
clr = colorbar(target = frm, $
               title = '$arg(\tau_i/\eta_i)$', $
               major = 5, $
               minor = 1, $
               orientation = 1, $
               textpos = 1, $
               position = [0.82,0.10,0.84,0.80], $
               font_size = 12.0, $
               font_name = 'Times', $
               hide = 0)

;;==Add a path label
txt = text(0.0,0.90, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save individual images
frame_save, frm,filename=filename
