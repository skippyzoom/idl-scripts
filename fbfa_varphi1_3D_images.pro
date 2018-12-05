;+
; Imaging routine for fbfa_build_varphi1_3D.pro
;
; Based on nT1_rat_phase_survey.pro
;-

;;==Declare planes of interest
;;  All strings are case-insensitive
;;  'xy' = 'yx' = 'pedersen-parallel'
;;  'xz' = 'zx' = 'hall-parallel'
;;  'yz' = 'zy' = 'perpendicular'
;; planes = ['xy','xz','yz']
planes = ['yz']

;;==Read in parameter dictionary
params = set_eppic_params(path=path)

;;==Restore data
filename = expand_path(path)+path_sep()+'varphi1-3D.sav'
restore, filename=filename, $
         /verbose

;;==Get dimensions
dsize = size(varphi1)
nx = dsize[1]
ny = dsize[2]
nz = dsize[3]
nt = dsize[4]

;;==Set up k vectors
kxdata = 2*!pi*fftfreq(nx,params.dx*params.nout_avg)
kxdata = shift(kxdata,nx/2-1)
kydata = 2*!pi*fftfreq(ny,params.dy*params.nout_avg)
kydata = shift(kydata,ny/2-1)
kzdata = 2*!pi*fftfreq(nz,params.dz*params.nout_avg)
kzdata = shift(kzdata,nz/2-1)

;;==Load custom color table
ct = get_custom_ct(2)

;-------------------------;
; PEDERSEN-PARALLEL PLANE ;
;-------------------------;

if string_exists(planes,'xy',/fold_case) || $
   string_exists(planes,'yx',/fold_case) || $
   string_exists(planes,'pedersen-parallel',/fold_case) then begin
   print, '[FBFA_VARPHI1_3D_IMAGES] pedersen-parallel plane'

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
   x0 = 0
   xf = nx
   y0 = 0
   yf = ny
   z0 = nz/2-nz/4
   zf = nz/2+nz/4

   ;;==Create survey frame
   frm = objarr(n_frm)
   for it=0,n_frm-1 do begin
      fdata = mean(varphi1[*,*,*,ind_mask[it]],dim=3)/!dtor
      fdata[where(~finite(fdata))] = 0.0
      fdata = rotate(reform(fdata),4)
      imgf = fdata[y0:yf-1,x0:xf-1]
      imgx = kydata[y0:yf-1]
      imgy = kxdata[x0:xf-1]
      frm[it] = image(imgf,imgx,imgy, $
                      axis_style = 1, $
                      min_value = -180, $
                      max_value = +180, $
                      rgb_table = [[ct.r],[ct.g],[ct.b]], $
                      position = position[*,it], $
                      xtickdir = 1, $
                      ytickdir = 1, $
                      xminor = 1, $
                      yminor = 1, $
                      xticklen = 0.02, $
                      yticklen = 0.02, $
                      ;; xrange = [-!pi,+!pi], $
                      ;; yrange = [-!pi,+!pi], $
                      ;; xtickvalues = [-!pi,0,+!pi], $
                      ;; ytickvalues = [-!pi,0,+!pi], $
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
                  title = 'arg($\tau_i/\eta_i$) [deg.]', $
                  major = 13, $
                  minor = 2, $
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
   filename = build_filename('varphi1','pdf', $
                             additions = ['khal_full_mean'], $
                             path = filepath)
   frame_save, frm[0],filename=filename

endif

;---------------------;
; HALL-PARALLEL PLANE ;
;---------------------;

if string_exists(planes,'xz',/fold_case) || $
   string_exists(planes,'zx',/fold_case) || $
   string_exists(planes,'hall-parallel',/fold_case) then begin
   print, '[FBFA_VARPHI1_3D_IMAGES] hall-parallel plane'

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
   x0 = 0
   xf = nx
   y0 = ny/2-ny/4
   yf = ny/2+ny/4
   z0 = 0
   zf = nz

   ;;==Create survey frame
   frm = objarr(n_frm)
   for it=0,n_frm-1 do begin
      fdata = mean(varphi1[*,*,*,ind_mask[it]],dim=2)/!dtor
      fdata[where(~finite(fdata))] = 0.0
      fdata = rotate(reform(fdata),1)
      imgf = fdata[z0:zf-1,x0:xf-1]
      imgx = kzdata[z0:zf-1]
      imgy = kxdata[x0:xf-1]
      frm[it] = image(imgf,imgx,imgy, $
                      axis_style = 1, $
                      min_value = -180, $
                      max_value = +180, $
                      rgb_table = [[ct.r],[ct.g],[ct.b]], $
                      position = position[*,it], $
                      xtickdir = 1, $
                      ytickdir = 1, $
                      xminor = 1, $
                      yminor = 1, $
                      xticklen = 0.02, $
                      yticklen = 0.02, $
                      ;; xrange = [-!pi,+!pi], $
                      ;; yrange = [-!pi,+!pi], $
                      ;; xtickvalues = [-!pi,0,+!pi], $
                      ;; ytickvalues = [-!pi,0,+!pi], $
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

      ;; txt = text(kzdata[z0],kxdata[xf-1], $
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
                  title = 'arg($\tau_i/\eta_i$) [deg.]', $
                  major = 13, $
                  minor = 2, $
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
   filename = build_filename('varphi1','pdf', $
                             additions = ['kped_full_mean'], $
                             path = filepath)
   frame_save, frm[0],filename=filename

endif

;---------------------;
; PERPENDICULAR PLANE ;
;---------------------;

if string_exists(planes,'yz',/fold_case) || $
   string_exists(planes,'zy',/fold_case) || $
   string_exists(planes,'perpendicular',/fold_case) then begin
   print, '[FBFA_VARPHI1_3D_IMAGES] perpendicular plane'

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
   x0 = nx/2-4
   xf = nx/2+4
   y0 = ny/2-ny/4
   yf = ny/2+ny/4
   z0 = nz/2-nz/4
   zf = nz/2+nz/4

   ;;==Create survey frame
   frm = objarr(n_frm)
   for it=0,n_frm-1 do begin
      fdata = varphi1[nx/2,*,*,ind_mask[it]]/!dtor
      ;; fdata = mean(varphi1[x0:xf-1,*,*,ind_mask[it]],dim=1)/!dtor
      ;; fdata = mean(varphi1[*,*,*,ind_mask[it]],dim=1)/!dtor
      fdata[where(~finite(fdata))] = 0.0
      fdata = rotate(reform(fdata),1)
      imgf = fdata[z0:zf-1,y0:yf-1]
      imgx = kzdata[z0:zf-1]
      imgy = kydata[y0:yf-1]
      frm[it] = image(imgf,imgx,imgy, $
                      axis_style = 1, $
                      min_value = -180, $
                      max_value = +180, $
                      rgb_table = [[ct.r],[ct.g],[ct.b]], $
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

      ;; txt = text(kzdata[z0],kydata[yf-1], $
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
                  title = 'arg($\tau_i/\eta_i$) [deg.]', $
                  major = 13, $
                  minor = 2, $
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
   filename = build_filename('varphi1','pdf', $
                             additions = ['kpar_eq_0'], $
                             path = filepath)
   frame_save, frm[0],filename=filename

endif

end
