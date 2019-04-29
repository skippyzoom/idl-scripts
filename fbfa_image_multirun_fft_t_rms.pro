;+
; Flow angle paper: Read a (2+1)-D FFT array from a restore file or
; directly from simulation data, then create images.
;
; Created by Matt Young.
;-

;;==Declare all dimensions
alldims = ['2D','3D']
ndims_all = n_elements(alldims)

;;==Compute positions
edges = [0.1,0.1,0.9,0.9]
position = multi_position([2,3], $
                          edges = edges, $
                          buffers = [0.0,0.0])

;;==Set short name for run labels
names = ['107 km', '110 km', '113 km']
names = reverse(names)

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

         ;;==Declare image_ranges
         i_x0 = nx/2-nx/8
         i_xf = nx/2+nx/8
         i_y0 = ny/2-ny/8
         i_yf = ny/2+ny/8

         ;;==Declare ranges for computing centroids
         c_x0 = nx/2
         c_xf = nx/2+nx/8
         c_y0 = ny/2-ny/8
         c_yf = ny/2+ny/8

         ;;==Assign time RMS ranges based on run
         case 1B of 
            strcmp(run_subdir, $
               '2D-new_coll'+path_sep()+ $
                   'h0-Ey0_050'+path_sep()): begin
               growth_it = find_closest(float(time.stamp),78.85)
               t_ind = [[growth_it-2, $
                         growth_it+2], $
                        [time.nt-10, $
                         time.nt-1]]
            end
            strcmp(run_subdir, $
               '2D-new_coll'+path_sep()+ $
                   'h1-Ey0_050'+path_sep()): begin
               growth_it = find_closest(float(time.stamp),78.85)
               t_ind = [[growth_it-2, $
                         growth_it+2], $
                        [time.nt-10, $
                         time.nt-1]]
            end
            strcmp(run_subdir, $
               '2D-new_coll'+path_sep()+ $
                   'h2-Ey0_050'+path_sep()): begin
               growth_it = find_closest(float(time.stamp),111.10)
               t_ind = [[growth_it-2, $
                         growth_it+2], $
                        [time.nt-10, $
                         time.nt-1]]
            end
         endcase

         ;;==Determine number of RMS ranges
         n_ranges = (size(t_ind))[1]

         ;;==Set up k vectors
         kxdata = 2*!pi*fftfreq(nx,dx)
         kxdata = shift(kxdata,nx/2-1)
         kydata = 2*!pi*fftfreq(ny,dy)
         kydata = shift(kydata,ny/2-1)

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
               ycm = cm.y
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

            help, rcm_theta

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

            ;;==Create frames
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
                        current = current_frm, $
                        /buffer)
            current_frm = 1B

            ;;==Add radius and angle markers
            r_overlay = 2*!pi/(1+findgen(10))
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
            ;; txt = text(0.0,0.01, $
            ;;            "$\langle\lambda\rangle$ = "+ $
            ;;            strcompress(string(2*!pi/rcm_kmag), $
            ;;                        /remove_all)+ $
            ;;            " [m]      "+ $
            ;;            "$\langle\theta\rangle$ = "+ $
            ;;            strcompress(string(rcm_theta/!dtor), $
            ;;                        /remove_all)+ $
            ;;            " [deg]", $
            ;;            target = frm, $
            ;;            font_name = 'Times', $
            ;;            font_size = 10.0)

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

         endfor ;; ir=0,n_ranges-1
      endfor ;; ip=0,n_paths-1
      
      ;;==Add global colorbar
      title = '$\langle|\delta n(k)/n_0|^2\rangle$'
      major = 1 + $
              (frm.max_value-frm.min_value)/5
      clr_pos = [edges[2]+0.02, $
                 0.5*(edges[0]+edges[2])-0.3, $
                 edges[2]+0.04, $
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

         print, "not ready"

      endfor

   endelse

endfor

end

