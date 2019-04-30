;+
; Flow angle paper: Read a (2+1)-D FFT array from a restore file or
; directly from simulation data, then create images.
;
; I hand-coded the text labels via trial and error, so you will need
; to adjust them if you change the panel layout or axes.
;
; Created by Matt Young.
;-

;;==Declare all dimensions
alldims = ['2D','3D']
ndims_all = n_elements(alldims)

;;==Compute positions
edges = [0.1,0.1,0.9,0.9]
buffers = [-0.3,0.0]
position = multi_position([2,3], $
                          edges = edges, $
                          buffers = buffers)

;;==Set printable run names
run_names = ['107 km', '110 km', '113 km']
run_names = reverse(run_names)

;;==Set printable range names
range_names = ['Growth','Saturation']

;;==Loop over dimension sets
for id=0,ndims_all-1 do begin

   ;;==Choose 2-D or 3-D data sets
   simdims = alldims[id]

   ;;==Declare paths
   paths = get_base_dir()+path_sep()+'fb_flow_angle/'+ $
           [simdims+'-new_coll/h2-Ey0_050/', $
            simdims+'-new_coll/h1-Ey0_050/', $
            simdims+'-new_coll/h0-Ey0_050/']
   n_paths = n_elements(paths)

   if strcmp(simdims,'2D') then begin
      
      ;;==Set boolean to reuse plot frame
      current_frm = 0B

      ;;==Loop over all paths to create plots
      for ip=0,n_paths-1 do begin

         ;;==Select one path
         path = paths[ip]

         ;;==Extract the run subdirectory
         run_subdir = strmid(path, $
                             strlen(get_base_dir()+path_sep()+ $
                                    'fb_flow_angle'+path_sep()))

         ;;==Read in parameter dictionary
         params = set_eppic_params(path=path)

         ;;==Declare which file to restore
         savename = 'den1_sqr-fft.sav'

         ;;==Restore the data
         savepath = expand_path(path)+path_sep()+savename
         sys_t0 = systime(1)
         restore, filename=savepath,/verbose
         sys_tf = systime(1)
         print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60.

         ;;==Extract data dimensions
         dsize = size(fftdata)
         d_nx = dsize[1]
         d_ny = dsize[2]
         d_nt = dsize[3]

         ;;==Build run parameters
         nx = params.nx*params.nsubdomains/params.nout_avg
         ny = params.ny/params.nout_avg
         nt = time.nt
         dx = params.dx*params.nout_avg
         dy = params.dy*params.nout_avg
         dt = params.dt*params.nout
         dkx = 2*!pi/(dx*nx)
         dky = 2*!pi/(dy*ny)

         ;;==Set up k vectors
         kxdata = 2*!pi*fftfreq(nx,dx)
         kxdata = shift(kxdata,nx/2-1)
         kydata = 2*!pi*fftfreq(ny,dy)
         kydata = shift(kydata,ny/2-1)

         ;;==Declare image ranges
         ;; i_x0 = nx/2-nx/8
         ;; i_xf = nx/2+nx/8
         ;; i_y0 = ny/2-ny/8
         ;; i_yf = ny/2+ny/8
         i_x0 = nx/2
         i_xf = nx/2+nx/8
         i_y0 = ny/2-ny/8
         i_yf = ny/2+ny/8

         ;;==Declare ranges for computing centroids
         ;; c_x0 = nx/2
         ;; c_xf = nx/2+nx/8
         ;; c_y0 = ny/2-ny/8
         ;; c_yf = ny/2+ny/8
         c_x0 = i_x0
         c_xf = i_xf
         c_y0 = i_y0
         c_yf = i_yf

         ;;==Assign time RMS ranges based on run
         case 1B of 
            strcmp(run_subdir, $
               '2D-new_coll'+path_sep()+ $
                   'h0-Ey0_050'+path_sep()): begin
               growth_it = find_closest(float(time.stamp),78.85)
               t_ind = [[growth_it-1, $
                         growth_it+1], $
                        [3*time.nt/4, $
                         time.nt-1]]
            end
            strcmp(run_subdir, $
               '2D-new_coll'+path_sep()+ $
                   'h1-Ey0_050'+path_sep()): begin
               growth_it = find_closest(float(time.stamp),78.85)
               t_ind = [[growth_it-1, $
                         growth_it+1], $
                        [3*time.nt/4, $
                         time.nt-1]]
            end
            strcmp(run_subdir, $
               '2D-new_coll'+path_sep()+ $
                   'h2-Ey0_050'+path_sep()): begin
               growth_it = find_closest(float(time.stamp),111.10)
               t_ind = [[growth_it-1, $
                         growth_it+1], $
                        [3*time.nt/4, $
                         time.nt-1]]
            end
         endcase

         ;;==Determine number of RMS ranges
         n_ranges = (size(t_ind))[1]

         ;;==Loop over time ranges
         for ir=0,n_ranges-1 do begin

            ;;==Extract data subset
            fdata = fftdata[*,*,t_ind[0,ir]:t_ind[1,ir]]
            r_nt = (size(fdata))[3]

            ;;==Compute centroids
            t0 = systime(1)
            tmp_theta = fltarr(r_nt)
            tmp_kmag = fltarr(r_nt)
            for it=0,r_nt-1 do begin
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
            print, "Elapsed minutes for centroid: ",(tf-t0)/60.

            ;;==Compute mean centroid and uncertainty
            theta_m = moment(tmp_theta)
            rcm_theta = theta_m[0]
            dev_theta = theta_m[1]
            kmag_m = moment(tmp_kmag)
            rcm_kmag = kmag_m[0]
            dev_kmag = kmag_m[1]

            ;;==Condition data
            fdata = rms(fdata,dim=3)
            fdata[nx/2,ny/2] = min(fdata)
            fdata = 10*alog10(fdata^2)
            imissing = where(~finite(fdata)) 
            min_finite = min(fdata[where(finite(fdata))])
            fdata[imissing] = min_finite
            fdata -= max(fdata)

            ;;==Extract current position array
            current_pos = position[*,ip*n_ranges+ir]

            ;;==Check if this is the bottom row
            row_is_bottom = (current_pos[1] eq min(position[1,*]))

            ;;==Check if this is the left column
            col_is_left = (current_pos[0] eq min(position[0,*]))

            ;;==Create frames
            t0 = systime(1)
            imgf = fdata[i_x0:i_xf-1,i_y0:i_yf-1]
            imgx = kxdata[i_x0-1:i_xf-2]
            imgy = kydata[i_y0-2:i_yf-3]
            frm = image(imgf, $
                        imgx,imgy, $
                        axis_style = 1, $
                        min_value = -20, $
                        max_value = 0, $
                        rgb_table = 39, $
                        position = current_pos, $
                        xrange = [0,+!pi], $
                        yrange = [-!pi/2,+!pi/2], $
                        xtickvalues = [0.0,1.0,2.0,3.0,4.0], $
                        ytickvalues = [-2.0,-1.0,0,+1.0,+2.0], $
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
                        xtickfont_size = 12.0, $
                        ytickfont_size = 12.0, $
                        font_name = 'Times', $
                        font_size = 18.0, $
                        current = current_frm, $
                        /buffer)
            current_frm = 1B
            ax = frm.axes
            ax[0].showtext = row_is_bottom
            ax[1].showtext = col_is_left

            ;;==Add radius and angle markers
            r_overlay = [4.0,3.0,2.0,1.0]
            theta_overlay = [0.0,-30.0,-60.0,-90.0]
            frm = overlay_rtheta(frm, $
                                 r_overlay, $
                                 theta_overlay, $
                                 /degrees, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'dot', $
                                 theta_color = 'white', $
                                 theta_thick = 0.5, $
                                 theta_linestyle = 'dot')

            ;;==Add angle of drift velocity
            vd_angle = fbfa_vd_angle(path)
            frm = overlay_rtheta(frm, $
                                 r_overlay[0], $
                                 vd_angle, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'none', $
                                 theta_color = 'magenta', $
                                 theta_thick = 1, $
                                 theta_linestyle = 'solid_line')

            ;;==Add optimal flow angle
            theta_opt = fbfa_chi_opt(path)+vd_angle
            frm = overlay_rtheta(frm, $
                                 r_overlay[0], $
                                 theta_opt, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'none', $
                                 theta_color = 'cyan', $
                                 theta_thick = 1, $
                                 theta_linestyle = 'solid_line')

            ;;==Add angle of centroid and print on frame
            frm = overlay_rtheta(frm, $
                                 r_overlay[0], $
                                 rcm_theta, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'none', $
                                 theta_color = 'white', $
                                 theta_thick = 1, $
                                 theta_linestyle = 'solid_line')

            ;;==Add lines at +/- one standard deviation of centroid
            frm = overlay_rtheta(frm, $
                                 r_overlay[0], $
                                 rcm_theta+dev_theta, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'none', $
                                 theta_color = 'white', $
                                 theta_thick = 1, $
                                 theta_linestyle = 'solid_line')
            frm = overlay_rtheta(frm, $
                                 r_overlay[0], $
                                 rcm_theta-dev_theta, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'none', $
                                 theta_color = 'white', $
                                 theta_thick = 1, $
                                 theta_linestyle = 'solid_line')

            ;;==Print angle of centroid on frame
            str_rcm_theta = string(rcm_theta/!dtor, $
                                   format='(f6.1)')
            str_rcm_theta = strcompress(str_rcm_theta, $
                                        /remove_all)
            txt = text(current_pos[0]+0.17, $
                       current_pos[3]-0.025, $
                       "$\langle\theta\rangle$ = "+ $
                       str_rcm_theta+ $
                       "$^\circ$", $
                       /normal, $
                       target = frm, $
                       alignment = 0.0, $
                       color = 'white', $
                       font_name = 'Times', $
                       font_style = 'Normal', $
                       font_size = 8.0)

            ;;==Print altitude on frame
            txt = text(current_pos[0]+0.37, $
                       current_pos[3]-0.025, $
                       run_names[ip], $
                       /normal, $
                       target = frm, $
                       alignment = 1.0, $
                       color = 'white', $
                       font_name = 'Times', $
                       font_style = 'Normal', $
                       font_size = 8.0)

            ;;==Print range name above column
            if ip eq 0 then begin
               txt = text(current_pos[0]+0.27, $
                          current_pos[3]+0.017, $
                          range_names[ir], $
                          /normal, $
                          target = frm, $
                          alignment = 0.5, $
                          color = 'black', $
                          font_name = 'Times', $
                          font_style = 'Normal', $
                          font_size = 12.0)
            endif

            tf = systime(1)
            print, "Elapsed minutes for frame: ",(tf-t0)/60.

         endfor ;; ir=0,n_ranges-1
      endfor    ;; ip=0,n_paths-1
      
      ;;==Add global colorbar
      title = '$\langle|\delta n(k)/n_0|^2\rangle$ [dB]'
      major = 1 + $
              (frm.max_value-frm.min_value)/5
      ;; global_right_edge = max(position[2,*])+buffers[0]
      global_right_edge = 0.75
      clr_pos = [global_right_edge+0.02, $
                 0.5*(edges[0]+edges[2])-0.3, $
                 global_right_edge+0.04, $
                 0.5*(edges[0]+edges[2])+0.3]
      clr = colorbar(target = frm, $
                     title = title, $
                     major = major, $
                     minor = 3, $
                     orientation = 1, $
                     textpos = 1, $
                     position = clr_pos, $
                     font_size = 12.0, $
                     font_name = 'Times', $
                     hide = 0)

      ;;==Add global axis labels
      txt = text(0.5, $
                 0.04, $
                 "$k_{Hall}$ [m$^{-1}$]", $
                 /normal, $
                 target = frm, $
                 alignment = 0.5, $
                 vertical_alignment = 0.5, $
                 baseline = [1.0,0.0,0.0], $
                 updir = [0.0,1.0,0.0], $
                 color = 'black', $
                 font_name = 'Times', $
                 font_style = 'Normal', $
                 font_size = 12.0)
      txt = text(0.2, $
                 0.5, $
                 "$k_{Ped}$ [m$^{-1}$]", $
                 /normal, $
                 target = frm, $
                 alignment = 0.5, $
                 vertical_alignment = 0.5, $
                 baseline = [0.0,1.0,0.0], $
                 updir = [-1.0,0.0,0.0], $
                 color = 'black', $
                 font_name = 'Times', $
                 font_style = 'Normal', $
                 font_size = 12.0)

      ;;==Save graphics frame
      frmpath = get_base_dir()+ $
                path_sep()+'fb_flow_angle'+ $
                path_sep()+'2D-new_coll'+ $
                path_sep()+'common'+ $
                path_sep()+'frames'+ $
                path_sep()+swap_extension(savename,'pdf')
      frame_save, frm,filename = frmpath

   endif $
   else begin ;; 3D

      ;;==Set boolean to reuse plot frame
      current_frm = 0B

      ;;==Loop over all paths to create plots
      for ip=0,n_paths-1 do begin

         ;;==Select one path
         path = paths[ip]

         ;;==Extract the run subdirectory
         run_subdir = strmid(path, $
                             strlen(get_base_dir()+path_sep()+ $
                                    'fb_flow_angle'+path_sep()))

         ;;==Read in parameter dictionary
         params = set_eppic_params(path=path)

         ;;==Declare which file to restore
         savename = 'den1_sqr-fft-kpar_full_mean.sav'

         ;;==Restore the data
         savepath = expand_path(path)+path_sep()+savename
         sys_t0 = systime(1)
         restore, filename=savepath,/verbose
         sys_tf = systime(1)
         print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60.

         ;;==Extract data dimensions
         dsize = size(fftdata)
         d_nx = dsize[1]
         d_ny = dsize[2]
         d_nz = dsize[3]
         d_nt = dsize[4]

         ;;==Build run parameters
         nx = params.nx*params.nsubdomains/params.nout_avg
         ny = params.ny/params.nout_avg
         nz = params.nz/params.nout_avg
         nt = time.nt
         dx = params.dx*params.nout_avg
         dy = params.dy*params.nout_avg
         dz = params.dz*params.nout_avg
         dt = params.dt*params.nout
         dkx = 2*!pi/(dx*nx)
         dky = 2*!pi/(dy*ny)
         dkz = 2*!pi/(dz*nz)

         ;;==Set up k vectors
         kxdata = 2*!pi*fftfreq(nx,dx)
         kxdata = shift(kxdata,nx/2-1)
         kydata = 2*!pi*fftfreq(ny,dy)
         kydata = shift(kydata,ny/2-1)
         kzdata = 2*!pi*fftfreq(nz,dz)
         kzdata = shift(kzdata,nz/2-1)

         ;;==Declare image ranges
         ;; i_x0 = nz/2-nz/4
         ;; i_xf = nz/2+nz/4
         ;; i_y0 = ny/2-ny/4
         ;; i_yf = ny/2+ny/4
         i_x0 = nz/2
         i_xf = nz/2+nz/4
         i_y0 = ny/2-ny/4
         i_yf = ny/2+ny/4

         ;;==Declare ranges for computing centroids
         ;; c_x0 = nz/2
         ;; c_xf = nz/2+nz/8
         ;; c_y0 = ny/2-ny/8
         ;; c_yf = ny/2+ny/8
         c_x0 = i_x0
         c_xf = i_xf
         c_y0 = i_y0
         c_yf = i_yf

         ;;==Assign time RMS ranges based on run
         case 1B of 
            strcmp(run_subdir, $
               '3D-new_coll'+path_sep()+ $
                   'h0-Ey0_050'+path_sep()): begin
               growth_it = find_closest(float(time.stamp),30.46)
               t_ind = [[growth_it-1, $
                         growth_it+1], $
                        [3*time.nt/4, $
                         time.nt-1]]
            end
            strcmp(run_subdir, $
               '3D-new_coll'+path_sep()+ $
                   'h1-Ey0_050'+path_sep()): begin
               growth_it = find_closest(float(time.stamp),25.09)
               t_ind = [[growth_it-1, $
                         growth_it+1], $
                        [3*time.nt/4, $
                         time.nt-1]]
            end
            strcmp(run_subdir, $
               '3D-new_coll'+path_sep()+ $
                   'h2-Ey0_050'+path_sep()): begin
               growth_it = find_closest(float(time.stamp),30.46)
               t_ind = [[growth_it-1, $
                         growth_it+1], $
                        [3*time.nt/4, $
                         time.nt-1]]
            end
         endcase

         ;;==Determine number of RMS ranges
         n_ranges = (size(t_ind))[1]

         ;;==Loop over time ranges
         for ir=0,n_ranges-1 do begin

            ;;==Extract data subset
            fdata = fftdata[*,*,t_ind[0,ir]:t_ind[1,ir]]
            r_nt = (size(fdata))[3]

            ;;==Rotate data to align with 2-D runs
            for it=0,r_nt-1 do $
               fdata[*,*,it] = rotate(fdata[*,*,it],1)

            ;;==Compute centroids
            t0 = systime(1)
            tmp_theta = fltarr(r_nt)
            tmp_kmag = fltarr(r_nt)
            for it=0,r_nt-1 do begin
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
            print, "Elapsed minutes for centroid: ",(tf-t0)/60.

            ;;==Compute mean centroid and uncertainty
            theta_m = moment(tmp_theta)
            rcm_theta = theta_m[0]
            dev_theta = theta_m[1]
            kmag_m = moment(tmp_kmag)
            rcm_kmag = kmag_m[0]
            dev_kmag = kmag_m[1]

            ;;==Condition data
            fdata = rms(fdata,dim=3)
            fdata[ny/2,nz/2] = min(fdata)
            fdata = 10*alog10(fdata^2)
            imissing = where(~finite(fdata)) 
            min_finite = min(fdata[where(finite(fdata))])
            fdata[imissing] = min_finite
            fdata -= max(fdata)

            ;;==Extract current position array
            current_pos = position[*,ip*n_ranges+ir]

            ;;==Check if this is the bottom row
            row_is_bottom = (current_pos[1] eq min(position[1,*]))

            ;;==Check if this is the left column
            col_is_left = (current_pos[0] eq min(position[0,*]))

            ;;==Create frames
            t0 = systime(1)
            imgf = fdata[i_x0:i_xf-1,i_y0:i_yf-1]
            imgx = kzdata[i_x0-1:i_xf-2]
            imgy = kydata[i_y0-2:i_yf-3]
            frm = image(imgf, $
                        imgx,imgy, $
                        axis_style = 1, $
                        min_value = -20, $
                        max_value = 0, $
                        rgb_table = 39, $
                        position = current_pos, $
                        xrange = [0,+!pi], $
                        yrange = [-!pi/2,+!pi/2], $
                        xtickvalues = [0.0,1.0,2.0,3.0,4.0], $
                        ytickvalues = [-2.0,-1.0,0,+1.0,+2.0], $
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
                        xtickfont_size = 12.0, $
                        ytickfont_size = 12.0, $
                        font_name = 'Times', $
                        font_size = 18.0, $
                        current = current_frm, $
                        /buffer)
            current_frm = 1B
            ax = frm.axes
            ax[0].showtext = row_is_bottom
            ax[1].showtext = col_is_left

            ;;==Add radius and angle markers
            r_overlay = [4.0,3.0,2.0,1.0]
            theta_overlay = [0.0,-30.0,-60.0,-90.0]
            frm = overlay_rtheta(frm, $
                                 r_overlay, $
                                 theta_overlay, $
                                 /degrees, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'dot', $
                                 theta_color = 'white', $
                                 theta_thick = 0.5, $
                                 theta_linestyle = 'dot')

            ;;==Add angle of drift velocity
            vd_angle = fbfa_vd_angle(path)
            frm = overlay_rtheta(frm, $
                                 r_overlay[0], $
                                 vd_angle, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'none', $
                                 theta_color = 'magenta', $
                                 theta_thick = 1, $
                                 theta_linestyle = 'solid_line')

            ;;==Add optimal flow angle
            theta_opt = fbfa_chi_opt(path)+vd_angle
            frm = overlay_rtheta(frm, $
                                 r_overlay[0], $
                                 theta_opt, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'none', $
                                 theta_color = 'cyan', $
                                 theta_thick = 1, $
                                 theta_linestyle = 'solid_line')

            ;;==Add angle of centroid and print on frame
            frm = overlay_rtheta(frm, $
                                 r_overlay[0], $
                                 rcm_theta, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'none', $
                                 theta_color = 'white', $
                                 theta_thick = 1, $
                                 theta_linestyle = 'solid_line')

            ;;==Add lines at +/- one standard deviation of centroid
            frm = overlay_rtheta(frm, $
                                 r_overlay[0], $
                                 rcm_theta+dev_theta, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'none', $
                                 theta_color = 'white', $
                                 theta_thick = 1, $
                                 theta_linestyle = 'solid_line')
            frm = overlay_rtheta(frm, $
                                 r_overlay[0], $
                                 rcm_theta-dev_theta, $
                                 r_color = 'white', $
                                 r_thick = 0.5, $
                                 r_linestyle = 'none', $
                                 theta_color = 'white', $
                                 theta_thick = 1, $
                                 theta_linestyle = 'solid_line')

            ;;==Print angle of centroid on frame
            str_rcm_theta = string(rcm_theta/!dtor, $
                                   format='(f6.1)')
            str_rcm_theta = strcompress(str_rcm_theta, $
                                        /remove_all)
            txt = text(current_pos[0]+0.17, $
                       current_pos[3]-0.025, $
                       "$\langle\theta\rangle$ = "+ $
                       str_rcm_theta+ $
                       "$^\circ$", $
                       /normal, $
                       target = frm, $
                       alignment = 0.0, $
                       color = 'white', $
                       font_name = 'Times', $
                       font_style = 'Normal', $
                       font_size = 8.0)

            ;;==Print altitude on frame
            txt = text(current_pos[0]+0.37, $
                       current_pos[3]-0.025, $
                       run_names[ip], $
                       /normal, $
                       target = frm, $
                       alignment = 1.0, $
                       color = 'white', $
                       font_name = 'Times', $
                       font_style = 'Normal', $
                       font_size = 8.0)

            ;;==Print range name above column
            if ip eq 0 then begin
               txt = text(current_pos[0]+0.27, $
                          current_pos[3]+0.017, $
                          range_names[ir], $
                          /normal, $
                          target = frm, $
                          alignment = 0.5, $
                          color = 'black', $
                          font_name = 'Times', $
                          font_style = 'Normal', $
                          font_size = 12.0)
            endif

            tf = systime(1)
            print, "Elapsed minutes for frame: ",(tf-t0)/60.

         endfor ;; ir=0,n_ranges-1
      endfor    ;; ip=0,n_paths-1
      
      ;;==Add global colorbar
      title = '$\langle|\delta n(k)/n_0|^2\rangle$ [dB]'
      major = 1 + $
              (frm.max_value-frm.min_value)/5
      ;; global_right_edge = max(position[2,*])+buffers[0]
      global_right_edge = 0.75
      clr_pos = [global_right_edge+0.02, $
                 0.5*(edges[0]+edges[2])-0.3, $
                 global_right_edge+0.04, $
                 0.5*(edges[0]+edges[2])+0.3]
      clr = colorbar(target = frm, $
                     title = title, $
                     major = major, $
                     minor = 3, $
                     orientation = 1, $
                     textpos = 1, $
                     position = clr_pos, $
                     font_size = 12.0, $
                     font_name = 'Times', $
                     hide = 0)

      ;;==Add global axis labels
      txt = text(0.5, $
                 0.04, $
                 "$k_{Hall}$ [m$^{-1}$]", $
                 /normal, $
                 target = frm, $
                 alignment = 0.5, $
                 vertical_alignment = 0.5, $
                 baseline = [1.0,0.0,0.0], $
                 updir = [0.0,1.0,0.0], $
                 color = 'black', $
                 font_name = 'Times', $
                 font_style = 'Normal', $
                 font_size = 12.0)
      txt = text(0.2, $
                 0.5, $
                 "$k_{Ped}$ [m$^{-1}$]", $
                 /normal, $
                 target = frm, $
                 alignment = 0.5, $
                 vertical_alignment = 0.5, $
                 baseline = [0.0,1.0,0.0], $
                 updir = [-1.0,0.0,0.0], $
                 color = 'black', $
                 font_name = 'Times', $
                 font_style = 'Normal', $
                 font_size = 12.0)

      ;;==Save graphics frame
      frmpath = get_base_dir()+ $
                path_sep()+'fb_flow_angle'+ $
                path_sep()+'3D-new_coll'+ $
                path_sep()+'common'+ $
                path_sep()+'frames'+ $
                path_sep()+swap_extension(savename,'pdf')
      frame_save, frm,filename = frmpath

   endelse ;; 3D
endfor     ;;id=0,n_dims_all-1 

end

