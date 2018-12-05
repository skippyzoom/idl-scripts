;+
; Hack script to do some last-minute analysis for my dissertation
;-

;;==Read in parameter dictionary
params = set_eppic_params(path=path)

;;==Restore data
t0 = systime(1)
filename = expand_path(path)+path_sep()+ $
           'den1fft_t-2D-nvsqr_out_subcycle1.sav'
restore, filename=filename,/verbose
tf = systime(1)
print, "Elapsed minutes for restore: ",(tf-t0)/60.

;;==Get dimensions
dsize = size(den1fft_t)
nx = dsize[1]
ny = dsize[2]
nt = dsize[4]

;;==Set up k vectors
kxdata = 2*!pi*fftfreq(nx,params.dx*params.nout_avg)
kxdata = shift(kxdata,nx/2-1)
kydata = 2*!pi*fftfreq(ny,params.dy*params.nout_avg)
kydata = shift(kydata,ny/2-1)

;;==Declare page layout
;;  More than 16 panels per page may get crowded
nc = 4
nr = 4
n_frm = nc*nr

;;==Set index mask
ind_mask = (nt/n_frm)*(1+indgen(n_frm))

;;==Set up position array for subframes
position = multi_position([nc,nr], $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffer = [-0.15,0.01])

;;==Declare image ranges
x0 = nx/2-ny/8
xf = nx/2+ny/8
y0 = ny/2-ny/8
yf = ny/2+ny/8

;;==Create survey frame
frm = objarr(n_frm)
for it=0,n_frm-1 do begin
   ;; fdata = abs(den1fft_t[nx/2,*,*,ind_mask[it]])
   fdata = mean(abs(den1fft_t[x0:xf-1,*,*,ind_mask[it]]),dim=1)
   fdata = reform(fdata)
   fdata[nz/2,ny/2] = min(fdata)
   fdata = 10*alog10(fdata^2)
   imissing = where(~finite(fdata)) 
   min_finite = min(fdata[where(finite(fdata))])
   fdata[imissing] = min_finite
   fdata -= max(fdata)
   fdata = rotate(reform(fdata),1)
   imgf = fdata[z0:zf-1,y0:yf-1]
   imgx = kzdata[z0:zf-1]
   imgy = kydata[y0:yf-1]
   frm[it] = image(imgf,imgx,imgy, $
                   axis_style = 1, $
                   min_value = -20, $
                   max_value = 0, $
                   rgb_table = 39, $
                   position = position[*,it], $
                   xtickdir = 1, $
                   ytickdir = 1, $
                   xminor = 1, $
                   yminor = 1, $
                   xticklen = 0.02, $
                   yticklen = 0.02, $
                   xrange = [-!pi,+!pi], $
                   yrange = [-!pi,+!pi], $
                   xtickvalues = [-!pi,0,+!pi], $
                   ytickvalues = [-!pi,0,+!pi], $
                   xtickname = ['$- \pi$','0','$+ \pi$'], $
                   ytickname = ['$- \pi$','0','$+ \pi$'], $
                   ;; xtitle = '$k_x$ [m$^{-1}$]', $
                   ;; ytitle = '$k_y$ [m$^{-1}$]', $
                   font_name = 'Times', $
                   font_size = 8.0, $
                   xshowtext = ((it  /  nc) eq 3), $
                   yshowtext = ((it mod nc) eq 0), $
                   current = (it gt 0), $
                   /buffer)

   ;; txt = text(kydata[y0],kxdata[xf-1], $
   ;;            time_ref.stamp[params.nvsqr_out_subcycle1*ind_mask[it]], $
   ;;            /data, $
   ;;            vertical_alignment = 1.0, $
   ;;            target = frm[it], $
   ;;            color = 'black', $
   ;;            fill_background = 1, $
   ;;            fill_color = 'white', $
   ;;            font_name = 'Courier', $
   ;;            font_size = 8.0)
endfor

;;==Add global color bar
right_edge = frm[nc-1].position[2]+0.01
width = 0.02
clr = colorbar(target = frm[0], $
               title = '$\langle\delta n/n_0\rangle^2$ [dB]', $
               major = 1+(frm.max_value-frm.min_value)/5, $
               minor = 3, $
               orientation = 1, $
               textpos = 1, $
               position = [right_edge,0.20,right_edge+width,0.80], $
               font_size = 10.0, $
               font_name = 'Times', $
               hide = 0)

;;==Add a path label
txt = text(0.0,0.95, $
           path, $
           target = frm[0], $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save the frame
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den1fft_t','pdf', $
                          additions = ['kpar_4point_mean'], $
                          path = filepath)
frame_save, frm[0],filename=filename

end
