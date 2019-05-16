;+
; Flow angle paper: Version of fbfa_plot_multirun_k_snapshots.pro
; designed to compare density and E-field perturbations.
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

;;==Set boolean to reuse plot frame
current_frm = 0B

;;==Set short name for run labels
names = ['107 km', '110 km', '113 km']
names = reverse(names)

;;==Choose which snapshot to show
it = 1

;;==Toggle fits
plot_fits = 'den1'

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

   ;;==Declare patterns of files to restore
   savebase = strcmp(simdims,'3D',/fold_case) ? $
              '_sqr-snapshots-k_spectrum-kpar_full_mean.sav' : $
              '_sqr-snapshots-k_spectrum.sav'

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

      ;;==Build parameters
      nx = params.nx*params.nsubdomains/params.nout_avg
      ny = params.ny/params.nout_avg
      nz = params.nz/params.nout_avg
      dx = params.dx*params.nout_avg
      dy = params.dy*params.nout_avg
      dz = params.dz*params.nout_avg
      dt = params.dt*params.nout
      dkx = 2*!pi/(dx*nx)
      dky = 2*!pi/(dy*ny)
      dkz = 2*!pi/(dz*nz)

      ;;==Scale by number of perpendicular points.
      if params.ndim_space eq 3 then begin
         scale = long(ny)*dy*long(nz)*dz
      endif else begin
         scale = long(ny)*dy*long(nx)*dx
      endelse

      ;;==Rescale 3-D runs to account for mean along B.
      if params.ndim_space eq 3 then begin
         str_kpar = strmid(savebase,strpos(savebase,'kpar')+5,4)
         case 1B of
            strcmp(str_kpar,'full'): scale *= long(nx)
            strcmp(str_kpar,'4pnt'): scale *= 4L
         endcase
      endif
      
      ;;==Restore the spectra
      sys_t0 = systime(1)
      savename = 'den1'+savebase
      savepath = expand_path(path)+path_sep()+savename
      restore, filename=savepath,/verbose
      ;; print, time
      den1_spectrum = spectrum[*,it]*scale
      savename = 'efield'+savebase
      savepath = expand_path(path)+path_sep()+savename
      restore, filename=savepath,/verbose
      ;; print, time
      efield_spectrum = spectrum[*,it]*scale
      sys_tf = systime(1)
      print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60.

      ;;==Extract number of wavelengths
      nl = n_elements(lambda)

      ;;==Construct a power-law fit to the density spectrum
      k_vals = reverse(2*!pi/lambda)
      fk0 = 2.0
      fk1 = 5.0
      ifk0 = find_closest(k_vals,fk0)
      ifk1 = find_closest(k_vals,fk1)
      fitx = alog10(k_vals[ifk0:ifk1])
      den1_fity = alog10((reverse(den1_spectrum))[ifk0:ifk1])
      den1_fitc = linfit(fitx,den1_fity,yfit=den1_yfit, $
                         chisqr=den1_chisqr,prob=den1_prob,sigma=den1_sigma)
      help, den1_chisqr,den1_prob
      print, "DEN1_SIGMA: ",den1_sigma

      ;;==Construct a power-law fit to the E-field spectrum
      k_vals = reverse(2*!pi/lambda)
      fk0 = 2.0
      fk1 = 5.0
      ifk0 = find_closest(k_vals,fk0)
      ifk1 = find_closest(k_vals,fk1)
      fitx = alog10(k_vals[ifk0:ifk1])
      efield_fity = alog10((reverse(efield_spectrum))[ifk0:ifk1])
      efield_fitc = linfit(fitx,efield_fity,yfit=efield_yfit, $
                           chisqr=efield_chisqr,prob=efield_prob,sigma=efield_sigma)
      help, efield_chisqr,efield_prob
      print, "EFIELD_SIGMA: ",efield_sigma

      ;;==Declare current position array
      current_pos = position[*,ip*ndims_all+id]
      ;; current_pos = position[*,ip+id*n_paths]

      ;;==Declare y tick names
      case ip of 
         0: ytickname = [         '','$10^{-5}$','$10^{-4}$', $
                         '$10^{-3}$','$10^{-2}$','$10^{-1}$']
         1: ytickname = [         '','$10^{-5}$','$10^{-4}$', $
                         '$10^{-3}$','$10^{-2}$',         '']
         2: ytickname = ['$10^{-6}$','$10^{-5}$','$10^{-4}$', $
                         '$10^{-3}$','$10^{-2}$',         '']
         else: ytickname = ['', '', '', '', '', '']
      endcase

      ;;==Check if this is the bottom row
      row_is_bottom = (current_pos[1] eq min(position[1,*]))

      ;;==Check if this is the left column
      col_is_left = (current_pos[0] eq min(position[0,*]))

      frm = plot(2*!pi/lambda, $
                 den1_spectrum, $
                 position = current_pos, $
                 yrange = [1e-6,1e0], $
                 xstyle = 1, $
                 /xlog, $
                 /ylog, $
                 xtitle = 'k [m$^{-1}$]', $
                 xtickfont_size = 12.0, $
                 ytickfont_size = 10.0, $
                 ytickname = ytickname, $
                 color = 'black', $
                 symbol = 'o', $
                 sym_size = 0.3, $
                 /sym_filled, $
                 linestyle = 'none', $
                 font_name = 'Times', $
                 current = current_frm, $
                 /buffer)
      opl = plot(2*!pi/lambda, $
                 efield_spectrum, $
                 color = 'gray', $
                 symbol = 'o', $
                 sym_size = 0.3, $
                 /sym_filled, $
                 linestyle = 'none', $
                 overplot = frm)
      current_frm = 1B
      ax = frm.axes
      ax[0].showtext = row_is_bottom
      ax[1].showtext = col_is_left

      ;;==Plot fits
      if where(strmatch(plot_fits, 'den1')) ge 0 then begin
         opl = plot(10^fitx, $
                    10^den1_yfit, $
                    color = 'green', $
                    thick = 2, $
                    /overplot)
         slope_str = strcompress(string(den1_fitc[1], $
                                        format='(f6.1)'),/remove_all)
         txt = text(current_pos[2]-0.12, $
                    current_pos[3]-0.10, $
                    slope_str, $
                    /normal, $
                    color='green', $
                    font_name = 'Times', $
                    target = frm)
      endif
      if where(strmatch(plot_fits, 'efield')) ge 0 then begin
         opl = plot(10^fitx, $
                    10^efield_yfit, $
                    color = 'red', $
                    thick = 2, $
                    /overplot)
         slope_str = strcompress(string(efield_fitc[1], $
                                        format='(f6.1)'),/remove_all)
         txt = text(current_pos[2]-0.12, $
                    current_pos[3]-0.15, $
                    slope_str, $
                    /normal, $
                    color='red', $
                    font_name = 'Times', $
                    target = frm)
      endif

      ;;==Print altitude on each panel
      txt = text(current_pos[2]-0.01, $
                 current_pos[3]-0.01, $
                 names[ip], $
                 /normal, $
                 alignment = 1.0, $
                 vertical_alignment = 1.0, $
                 target = frm, $
                 font_name = 'Times', $
                 font_size = 12.0)
   endfor

   ;;==Print dimensions above each column
   txt = text(0.5*(current_pos[0]+current_pos[2]), $
              edges[3]+0.01, $
              simdims, $
              /normal, $
              alignment = 0.5, $
              target = frm, $
              font_name = 'Times', $
              font_size = 12.0)


endfor

;;==Print a common y-axis title
txt = text(edges[0]-0.07, $
           0.5*(edges[0]+edges[2]), $
          ;; '$\langle|\delta n(k)/n_0|^2\rangle$, '+ $
          ;; '$\langle|\delta E(k)/E_0|^2\rangle$', $
          '$\langle|\delta f(k)/f_0|^2\rangle$', $
           /normal, $
           alignment = 0.5, $
           baseline = [0,1,0], $
           updir = [-1,0,0], $
           target = frm, $
           font_name = 'Times', $
           font_size = 12.0)

;;==Declare the graphics file name
frmpath = get_base_dir()+path_sep()+ $
          'fb_flow_angle'+path_sep()+'common'+ $
          path_sep()+'frames'+path_sep()+ $
          'nE_sqr-k_spectrum-multirun-snapshots.pdf'

;;==Save graphics frame
frame_save, frm,filename = frmpath

end

