;+
; Script for making survey images from calc_nT1_phase_quantities
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare file name
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den1_temp1_rat_phase',frame_type, $
                          path = filepath, $
                          additions = [axes, $
                                       'survey'])

;;==Get sizes of den1 FFT
fsize = size(fden1)
nkx = fsize[1]
nky = fsize[2]

;;==Declare image ranges
x0 = nkx/2-nkx/8
xf = nkx/2+nkx/8
y0 = nky/2-nky/8
yf = nky/2+nky/8

;;==Declare index mask
nc = 4
nr = 4
n_frm = nc*nr
ind_mask = (time.nt/n_frm)*(1+indgen(n_frm))

;;==Set up position array for subframes
position = multi_position(nc*nr, $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffer = [-0.15,0.01])

;;==Set up kx and ky vectors
kxdata = 2*!pi*fftfreq(nkx,dx)
kxdata = shift(kxdata,nkx/2)
kydata = 2*!pi*fftfreq(nky,dy)
kydata = shift(kydata,nky/2)

;;==Load custom color table
ct = get_custom_ct(2)

;;==Create survey frame
frm = objarr(n_frm)
for it=0,n_frm-1 do $
   frm[it] = image(nT1_rat_arg[x0:xf-1,y0:yf-1,ind_mask[it]]/!dtor, $
                   kxdata[x0:xf-1],kydata[y0:yf-1], $
                   axis_style = 1, $
                   min_value = -180, $
                   max_value = +180, $
                   rgb_table = [[ct.r],[ct.g],[ct.b]], $
                   position = position[*,it], $
                   xtickfont_size = 12.0, $
                   ytickfont_size = 12.0, $
                   font_name = 'Times', $
                   font_size = 14.0, $
                   xshowtext = ((it  /  nc) eq nc-1), $
                   yshowtext = ((it mod nc) eq 0), $
                   current = (it gt 0), $
                   /buffer)

;;==Add global color bar
clr = colorbar(target = frm[0], $
               title = 'arg($\tau_i/\eta_i$)', $
               major = 13, $
               minor = 3, $
               orientation = 1, $
               textpos = 1, $
               position = [0.90,0.20,0.91,0.80], $
               font_size = 10.0, $
               font_name = 'Times', $
               hide = 0)

;;==Add time stamp on each panel
for it=0,n_frm-1 do $
   txt = text(kxdata[x0],kydata[yf], $
              time.stamp[ind_mask[it]], $
              /data, $
              vertical_alignment = 1.0, $
              target = frm[it], $
              color = 'white', $
              font_name = 'Courier', $
              font_size = 8.0)

;;==Add a path label
txt = text(0.0,0.95, $
           path, $
           target = frm[0], $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save the frame
frame_save, frm[0],filename=filename
