;+
; Flow angle paper: Read k spectrum from a save file and make plots
; versus time from multiple directories on the same axes.
;-

;;==Declare all dimensions
alldims = ['2D','3D']
ndims_all = n_elements(alldims)

;;==Compute positions
position = multi_position([2,3], $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffers = [0.0,0.0])

;;==Set boolean to reuse plot frame
current_frm = 0B

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

   ;;==Declare which file to restore
   savename = strcmp(simdims,'3D',/fold_case) ? $
              'den1_sqr-k_spectrum-kpar_full_mean.sav' : $
              'den1_sqr-k_spectrum.sav'

   ;;==Loop over all paths
   for ip=0,n_paths-1 do begin

      ;;==Select one path
      path = paths[ip]

      ;;==Determine the run subdirectory
      run_subdir = strmid(path, $
                          strlen(get_base_dir()+path_sep()+ $
                                 'fb_flow_angle'+path_sep()))

      ;;==Read in parameter dictionary
      params = set_eppic_params(path=path)

      ;;==Restore the data
      savepath = expand_path(path)+path_sep()+savename
      sys_t0 = systime(1)
      restore, filename=savepath,/verbose
      sys_tf = systime(1)
      print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60.

      ;;==Build parameters
      nx = params.nx*params.nsubdomains/params.nout_avg
      ny = params.ny/params.nout_avg
      nz = params.nz/params.nout_avg
      nt = time.nt
      nl = n_elements(lambda)
      dx = params.dx*params.nout_avg
      dy = params.dy*params.nout_avg
      dz = params.dz*params.nout_avg
      dt = params.dt*params.nout
      dkx = 2*!pi/(dx*nx)
      dky = 2*!pi/(dy*ny)
      dkz = 2*!pi/(dz*nz)

      ;;==Rescale spectrum by number of points
      vol = long(ny)*dy
      if params.ndim_space eq 3 then begin
         str_kpar = strmid(savename,strpos(savename,'kpar')+5,4)
         case 1B of
            strcmp(str_kpar,'full'): vol *= long(nz)*long(nx)*dz
            strcmp(str_kpar,'4pnt'): vol *= long(nz)*4L*dz
         endcase
      endif $
      else vol *= long(nx)*dx
      spectrum *= vol

      ;;==Assign time indices based on run
      case 1B of
         ;; strcmp(run_subdir, $
         ;;         '2D-new_coll'+path_sep()+'h0-Ey0_050'+path_sep()): $
         ;;    t_ind = [find_closest(float(time.stamp),17.92), $
         ;;             find_closest(float(time.stamp),78.85), $
         ;;             find_closest(float(time.stamp),114.69), $
         ;;             time.nt-1]
         strcmp(run_subdir, $
                 '2D-new_coll'+path_sep()+'h0-Ey0_050'+path_sep()): $
            t_ind = [find_closest(float(time.stamp),78.85), $
                     time.nt-1]
         ;; strcmp(run_subdir, $
         ;;         '2D-new_coll'+path_sep()+'h1-Ey0_050'+path_sep()): $
         ;;    t_ind = [find_closest(float(time.stamp),17.92), $
         ;;             find_closest(float(time.stamp),68.10), $
         ;;             find_closest(float(time.stamp),111.10), $
         ;;             time.nt-1]
         strcmp(run_subdir, $
                 '2D-new_coll'+path_sep()+'h1-Ey0_050'+path_sep()): $
            t_ind = [find_closest(float(time.stamp),78.85), $
                     time.nt-1]
         ;; strcmp(run_subdir, $
         ;;         '2D-new_coll'+path_sep()+'h2-Ey0_050'+path_sep()): $
         ;;    t_ind = [find_closest(float(time.stamp),17.92), $
         ;;             find_closest(float(time.stamp),111.10), $
         ;;             find_closest(float(time.stamp),139.78), $
         ;;             time.nt-1]
         strcmp(run_subdir, $
                 '2D-new_coll'+path_sep()+'h2-Ey0_050'+path_sep()): $
            t_ind = [find_closest(float(time.stamp),111.10), $
                     time.nt-1]
         ;; strcmp(run_subdir, $
         ;;         '3D-new_coll'+path_sep()+'h0-Ey0_050'+path_sep()): $
         ;;    t_ind = [find_closest(float(time.stamp),9.86), $
         ;;             find_closest(float(time.stamp),24.19), $
         ;;             find_closest(float(time.stamp),32.26), $
         ;;             time.nt-1]
         strcmp(run_subdir, $
                 '3D-new_coll'+path_sep()+'h0-Ey0_050'+path_sep()): $
            t_ind = [find_closest(float(time.stamp),30.46), $
                     time.nt-1]
         ;; strcmp(run_subdir, $
         ;;         '3D-new_coll'+path_sep()+'h1-Ey0_050'+path_sep()): $
         ;;    t_ind = [find_closest(float(time.stamp),9.86), $
         ;;             find_closest(float(time.stamp),21.50), $
         ;;             find_closest(float(time.stamp),30.46), $
         ;;             time.nt-1]
         strcmp(run_subdir, $
                 '3D-new_coll'+path_sep()+'h1-Ey0_050'+path_sep()): $
            t_ind = [find_closest(float(time.stamp),25.09), $
                     time.nt-1]
         ;; strcmp(run_subdir, $
         ;;         '3D-new_coll'+path_sep()+'h2-Ey0_050'+path_sep()): $
         ;;    t_ind = [find_closest(float(time.stamp),9.86), $
         ;;             find_closest(float(time.stamp),28.67), $
         ;;             find_closest(float(time.stamp),38.53), $
         ;;             time.nt-1]
         strcmp(run_subdir, $
                 '3D-new_coll'+path_sep()+'h2-Ey0_050'+path_sep()): $
            t_ind = [find_closest(float(time.stamp),30.46), $
                     time.nt-1]
      endcase         

      ;;==Determine number of time indices
      n_inds = n_elements(t_ind)            

      ;;==Construct a power-law fit to the final spectrum
      ;; fy0 = 1e-1
      ;; fy1 = 1e-2
      ;; fx0 = find_closest(spectrum[*,t_ind[n_inds-1]],fy0)
      ;; fx1 = find_closest(spectrum[*,t_ind[n_inds-1]],fy1)
      ;; fk0 = 2*!pi/lambda[fx0]
      ;; fk1 = 2*!pi/lambda[fx1]
      ;; fitx = alog10(2*!pi/lambda[fx1:fx0])
      ;; fity = alog10(spectrum[fx1:fx0,t_ind[n_inds-1]])
      k_vals = reverse(2*!pi/lambda)
      fk0 = 2.0
      fk1 = 5.0
      ifk0 = find_closest(k_vals,fk0)
      ifk1 = find_closest(k_vals,fk1)
      fitx = alog10(k_vals[ifk0:ifk1])
      fity = alog10((reverse(spectrum))[ifk0:ifk1,t_ind[n_inds-1]])
      fitc = linfit(fitx,fity,yfit=yfit)

      ;;==Reverse the time indices for plotting
      ;;  I did this so that the growth-stage spectrum stands out more
      t_ind = reverse(t_ind)

      ;;==Declare plot colors
      ;; color = ['green','blue','gray','black']
      color = ['black','gray']

      current_pos = position[*,ip*ndims_all+id]
      ;; current_pos = position[*,ip+id*n_paths]
      row_is_bottom = (current_pos[1] eq min(position[1,*]))
      col_is_left = (current_pos[0] eq min(position[0,*]))

      for it=0,n_inds-1 do begin
         frm = plot(2*!pi/lambda, $
                    spectrum[*,t_ind[it]], $
                    position = current_pos, $
                    yrange = [1e-6,1e0], $
                    xstyle = 1, $
                    /xlog, $
                    /ylog, $
                    xtitle = 'k [m$^{-1}$]', $
                    ytitle = '$\langle|\delta n(k)/n_0|^2\rangle$', $
                    xtickfont_size = 12.0, $
                    ytickfont_size = 10.0, $
                    color = color[it], $
                    symbol = 'o', $
                    sym_size = 0.5, $
                    /sym_filled, $
                    overplot = (it gt 0), $
                    current = current_frm, $
                    font_name = 'Times', $
                    /buffer)
         opl = plot(10^fitx, $
                    10^yfit, $
                    color = 'red', $
                    thick = 2, $
                    /overplot)
         current_frm = 1B
         ax = frm.axes
         ax[0].showtext = row_is_bottom
         ax[1].showtext = col_is_left
         slope_str = strcompress(string(fitc[1],format='(f6.1)'),/remove_all)
         txt = text(current_pos[2]-0.1, $
                    current_pos[3]-0.1, $
                    slope_str, $
                    /normal, $
                    color='red', $
                    font_name = 'Times', $
                    target = frm)

      endfor

   endfor

endfor

;;==Declare the graphics file name
frmpath = get_base_dir()+path_sep()+ $
          'fb_flow_angle'+path_sep()+'common'+ $
          path_sep()+'frames'+path_sep()+ $
          'den1_sqr-k_spectrum-multirun-snapshots.pdf'

;;==Save graphics frame
frame_save, frm,filename = frmpath

end

