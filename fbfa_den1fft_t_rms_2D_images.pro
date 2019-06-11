;+
; Hack script to do some last-minute analysis for my dissertation
;-

;;==Read in parameter dictionary
params = set_eppic_params(path=path)

;;==Build parameters
nx = params.nx*params.nsubdomains/params.nout_avg
ny = params.ny/params.nout_avg
nt = time_ref.nt
dx = params.dx*params.nout_avg
dy = params.dy*params.nout_avg
dt = params.dt*params.nout
dkx = 2*!pi/(dx*nx)
dky = 2*!pi/(dy*ny)

;;==Get all file names
data_path = expand_path(path)+path_sep()+'parallel'
all_files = file_search(expand_path(data_path)+path_sep()+'parallel*.h5', $
                        count = n_files)

;;==Set data input mode
mode = 'build'

;;==Build or restore data
t0 = systime(1)
case 1B of 
   strcmp(mode,'build'): begin
      tmp = get_rms_ranges(path,time_ref)
      sub_ind = [tmp[0,0]:tmp[1,0]]*time_ref.subsample
      ;; sub_ind = [time_ref.nt-32:time_ref.nt-1]*time_ref.subsample
      sub_files = all_files[sub_ind]
      sub_nt = n_elements(sub_files)
      den1fft_t = complexarr(nx,ny,sub_nt)
      for it=0,sub_nt-1 do begin
         tmp = get_h5_data(sub_files[it],'den1')
         den1fft_t[*,*,it] = transpose(fft(tmp,/center),[1,0])
      endfor
   end
   strcmp(mode,'restore'): begin
      filename = expand_path(path)+path_sep()+ $
                 'den1fft_t-2D-final_32.sav'
      restore, filename=filename,/verbose
   end
endcase
tf = systime(1)
print, "Elapsed minutes for build/restore: ",(tf-t0)/60.

;;==Get dimensions
dsize = size(den1fft_t)
nx = dsize[1]
ny = dsize[2]
nt = dsize[3]

;;==Set up k vectors
kxdata = 2*!pi*fftfreq(nx,params.dx*params.nout_avg)
kxdata = shift(kxdata,nx/2-1)
kydata = 2*!pi*fftfreq(ny,params.dy*params.nout_avg)
kydata = shift(kydata,ny/2-1)

;;==Declare file name
filepath = expand_path(path)+path_sep()+'frames'
filename = build_filename('den1fft_t_rms','png', $
                          additions = ['growth', $
                                       'centroid'], $
                          path = filepath)

;;==Declare image ranges
i_x0 = nx/2-nx/8
i_xf = nx/2+nx/8
i_y0 = ny/2-ny/8
i_yf = ny/2+ny/8

;;==Declare ranges for computing centroids
c_x0 = nx/2
c_xf = nx/2+nx/8
c_y0 = ny/2-ny/8
c_yf = ny/2+ny/8

;;==Compute centroids
t0 = systime(1)
fdata = abs(den1fft_t)
fdata = reform(fdata)
tmp_theta = fltarr(sub_nt)
tmp_kmag = fltarr(sub_nt)
for it=0,sub_nt-1 do begin
   cm = calc_fft_centroid(fdata[*,*,it], $
                          xrange = [c_x0,c_xf-1], $
                          yrange = [c_y0,c_yf-1], $
                          /zero_dc, $
                          mask_threshold = 1e-1, $
                          mask_value = 0.0, $
                          mask_type = 'relative_max')
   xcm = cm.x
   ycm = cm.y-0.5*(c_yf-c_y0)
   dev_xcm = cm.dev_x
   dev_ycm = cm.dev_y
   tmp_kmag[it] = sqrt((dkx*xcm)^2 + (dky*ycm)^2)
   tmp_theta[it] = atan(ycm,xcm)
endfor
tf = systime(1)
print, "Elapsed minutes for centroids: ",(tf-t0)/60.

;;==Compute mean centroid and uncertainty
theta_m = moment(tmp_theta)
rcm_theta = theta_m[0]
dev_theta = theta_m[1]
kmag_m = moment(tmp_kmag)
rcm_kmag = kmag_m[0]
dev_kmag = kmag_m[1]

;;==Condition data for imaging
fdata = rms(fdata,dim=3)
fdata[nx/2,ny/2] = min(fdata)
fdata = 10*alog10(fdata^2)
imissing = where(~finite(fdata)) 
min_finite = min(fdata[where(finite(fdata))])
fdata[imissing] = min_finite
fdata -= max(fdata)

;;==Create frame
imgf = fdata[i_x0:i_xf-1,i_y0:i_yf-1]
;; imgx = kxdata[i_x0:i_xf-1]
;; imgy = kydata[i_y0:i_yf-1]
imgx = kxdata[i_x0-1:i_xf-2]
imgy = kydata[i_y0-2:i_yf-3]
;; imgx = indgen(i_xf-i_x0)-(i_xf-i_x0)/2
;; imgy = indgen(i_yf-i_y0)-(i_yf-i_y0)/2
frm = image(imgf, $
            imgx,imgy, $
            axis_style = 1, $
            min_value = -20, $
            max_value = 0, $
            rgb_table = 39, $
            position = [0.10,0.10,0.80,0.80], $
            xrange = [0,+2*!pi], $
            ;; xrange = [-!pi,+!pi], $
            yrange = [-!pi,+!pi], $
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

;;==Add a colorbar
clr = colorbar(target = frm, $
               title = '$\langle\delta n/n_0\rangle^2$ [dB]', $
               major = 1+(frm.max_value-frm.min_value)/5, $
               minor = 3, $
               orientation = 1, $
               textpos = 1, $
               position = [0.84,0.10,0.86,0.80], $
               font_size = 12.0, $
               font_name = 'Times', $
               hide = 0)

;;==Add radius and angle markers
r_overlay = 2*!pi/(1+findgen(10))
;; r_overlay = 2*!pi/(2+findgen(9))
theta_overlay = 10*findgen(36)
frm = overlay_rtheta(frm, $
                     r_overlay, $
                     theta_overlay, $
                     /degrees, $
                     r_color = 'white', $
                     r_thick = 1, $
                     r_linestyle = 'dot', $
                     theta_color = 'white', $
                     theta_thick = 1, $
                     theta_linestyle = 'dot')

;;==Add angle of drift velocity
vd_angle = fbfa_vd_angle(path)
frm = overlay_rtheta(frm, $
                     r_overlay[0], $
                     vd_angle, $
                     r_color = 'white', $
                     r_thick = 1, $
                     r_linestyle = 'none', $
                     theta_color = 'magenta', $
                     theta_thick = 2, $
                     theta_linestyle = 'solid_line')

;;==Add optimal flow angle
theta_opt = fbfa_chi_opt(path)+vd_angle
frm = overlay_rtheta(frm, $
                     r_overlay[0], $
                     theta_opt, $
                     r_color = 'white', $
                     r_thick = 1, $
                     r_linestyle = 'none', $
                     theta_color = 'cyan', $
                     theta_thick = 2, $
                     theta_linestyle = 'solid_line')

;;==Add angle of centroid and print on frame
frm = overlay_rtheta(frm, $
                     r_overlay[0], $
                     rcm_theta, $
                     r_color = 'white', $
                     r_thick = 2, $
                     r_linestyle = 'none', $
                     theta_color = 'white', $
                     theta_thick = 2, $
                     theta_linestyle = 'solid_line')
txt = text(0.0,0.01, $
           "$\langle\lambda\rangle$ = "+ $
           strcompress(string(2*!pi/rcm_kmag),/remove_all)+ $
           " [m]      "+ $
           "$\langle\theta\rangle$ = "+ $
           strcompress(string(rcm_theta/!dtor),/remove_all)+ $
           " [deg]", $
           target = frm, $
           font_name = 'Times', $
           font_size = 10.0)

;;==Add lines at +/- one standard deviation of centroid
frm = overlay_rtheta(frm, $
                     r_overlay[0], $
                     rcm_theta+dev_theta, $
                     r_color = 'white', $
                     r_thick = 2, $
                     r_linestyle = 'none', $
                     theta_color = 'white', $
                     theta_thick = 2, $
                     theta_linestyle = 'solid_line')
frm = overlay_rtheta(frm, $
                     r_overlay[0], $
                     rcm_theta-dev_theta, $
                     r_color = 'white', $
                     r_thick = 2, $
                     r_linestyle = 'none', $
                     theta_color = 'white', $
                     theta_thick = 2, $
                     theta_linestyle = 'solid_line')

;;==Add a path label
txt = text(0.0,0.95, $
           path, $
           target = frm[0], $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save the frame
frame_save, frm[0],filename=filename

end
