;+
; Script for making frames from calc_nT0_phase_quantities
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name(s)
filepath = expand_path(path)+path_sep()+'frames'
str_step = strcompress(time.index)
filename = strarr(time.nt)
for it=0,time.nt-1 do $
   filename[it] = build_filename('den0_temp0_rat_phase',frame_type, $
                                 path = filepath, $
                                 additions = [axes, $
                                              str_step[it]])

;;==Preserve raw data
fdata = nT0_rat_arg/!dtor

;;==Get dimensions
fsize = size(fdata)
nkx = fsize[1]
nky = fsize[2]

;;==Declare image ranges
x0 = params.ndim_space eq 2 ? nkx/2-nkx/8 : nkx/2-nkx/4
xf = params.ndim_space eq 2 ? nkx/2+nkx/8 : nkx/2+nkx/4
y0 = params.ndim_space eq 2 ? nky/2-nky/8 : nky/2-nky/4
yf = params.ndim_space eq 2 ? nky/2+nky/8 : nky/2+nky/4

;;==Set non-finite values to 0.0
fdata[where(~finite(fdata))] = 0.0

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Load custom color table
ct = get_custom_ct(2)

;;==Declare an array of image handles
frm = objarr(time.nt)

;;==Create image frames
for it=0,time.nt-1 do $
   frm[it] = image(fdata[x0:xf-1,y0:yf-1,it], $
                   kxdata[x0:xf-1],kydata[y0:yf-1], $
                   axis_style = 1, $
                   min_value = -180, $
                   max_value = +180, $
                   rgb_table = [[ct.r],[ct.g],[ct.b]], $
                   position = [0.10,0.10,0.80,0.80], $
                   xrange = [-2*!pi,+2*!pi], $
                   yrange = [-2*!pi,+2*!pi], $
                   xmajor = 3, $
                   xminor = 3, $
                   ymajor = 3, $
                   yminor = 3, $
                   xstyle = 1, $
                   ystyle = 1, $
                   xsubticklen = 0.5, $
                   ysubticklen = 0.5, $
                   xtickdir = 1, $
                   ytickdir = 1, $
                   xticklen = 0.02, $
                   yticklen = 0.02, $
                   xshowtext = 1, $
                   yshowtext = 1, $
                   xtickfont_size = 12.0, $
                   ytickfont_size = 12.0, $
                   font_name = 'Times', $
                   font_size = 18.0, $
                   /buffer)

;;==Add a colorbar to each image
for it=0,time.nt-1 do $
   clr = colorbar(target = frm[it], $
                  title = 'arg($\tau_e/\eta_e$)', $
                  major = 13, $
                  minor = 2, $
                  orientation = 1, $
                  textpos = 1, $
                  position = [0.82,0.10,0.84,0.80], $
                  font_size = 12.0, $
                  font_name = 'Times', $
                  hide = 0)

;;==Add a path label
for it=0,time.nt-1 do $
   txt = text(0.0,0.90, $
              path, $
              target = frm[it], $
              font_name = 'Courier', $
              font_size = 10.0)

;;==Save individual images
for it=0,time.nt-1 do $
   frame_save, frm[it],filename=filename[it]
