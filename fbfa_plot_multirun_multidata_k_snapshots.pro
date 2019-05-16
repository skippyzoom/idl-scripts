;+
; Flow angle paper: Version of fbfa_plot_multirun_k_snapshots.pro
; designed to compare density and E-field perturbations.
;
; Created by Matt Young.
;-

;;==Declare data names
datanames = ['den1', 'phi', 'efield']

;;==Declare a color for each data name
colors = ['black', 'gray', 'green']

;;==Choose which snapshots to show
snapshots = [0,1]

;;==Toggle fits
;;  The key gives the data name; the value gives the snapshot.
plot_fits = dictionary('den1', 1)

;;==Declare common y-axis range
yrange = [1e-6,1e0]

;;==Declare common y-axis tick names
ytickname = ['$10^{-6}$','$10^{-5}$','$10^{-4}$', $
             '$10^{-3}$','$10^{-2}$','$10^{-1}$']

;;==Declare all dimensions
alldims = ['2D','3D']

;;==Compute positions
edges = [0.1,0.1,0.9,0.9]
position = multi_position([2,3], $
                          edges = edges, $
                          buffers = [0.0,0.0])

;;==Declare altitude labels
altitudes = ['107 km', '110 km', '113 km']
altitudes = reverse(altitudes)

;;==Set boolean to reuse plot frame
current_frm = 0B

;;==Loop over all snapshots
n_snapshots = n_elements(snapshots)
for it=0,n_snapshots-1 do begin

;;==Loop over dimension sets
   ndims_all = n_elements(alldims)
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
         spectra = list()
         n_datanames = n_elements(datanames)
         for in=0,n_datanames-1 do begin
            savename = datanames[in]+savebase
            savepath = expand_path(path)+path_sep()+savename
            restore, filename=savepath
            cur_spectrum = spectrum[*,it]*scale

            ;;==Extract number of wavelengths
            nl = n_elements(lambda)

            ;;==Construct a power-law fit to the ion density spectrum
            fit_this = 0B
            if where(strmatch(plot_fits.keys(), datanames[in])) ge 0 then $
               if plot_fits[datanames[in]] eq it then $
                  fit_this = 1B
               
            if fit_this then begin
               k_vals = reverse(2*!pi/lambda)
               fk0 = 2.0
               fk1 = 5.0
               ifk0 = find_closest(k_vals,fk0)
               ifk1 = find_closest(k_vals,fk1)
               fitx = alog10(k_vals[ifk0:ifk1])
               fity = alog10((reverse(cur_spectrum))[ifk0:ifk1])
               fitc = linfit(fitx,fity,yfit=yfit, $
                             chisqr=chisqr,prob=prob,sigma=sigma)
            endif

            ;;==Declare current position array
            current_pos = position[*,ip*ndims_all+id]

            ;;==Update y tick names
            nyticks = n_elements(ytickname)
            cur_ytickname = ytickname
            case ip of 
               0: begin
                  cur_ytickname[0] = ''
               end
               1: begin
                  cur_ytickname[0] = ''
                  cur_ytickname[nyticks-1] = ''
               end
               2: begin
                  cur_ytickname[nyticks-1] = ''
               end
               else: cur_ytickname = make_array(nyticks, value='')
            endcase

            ;;==Check if this is the bottom row
            row_is_bottom = (current_pos[1] eq min(position[1,*]))

            ;;==Check if this is the left column
            col_is_left = (current_pos[0] eq min(position[0,*]))

            frm = plot(2*!pi/lambda, $
                       cur_spectrum, $
                       position = current_pos, $
                       yrange = yrange, $
                       xstyle = 1, $
                       /xlog, $
                       /ylog, $
                       xtitle = 'k [m$^{-1}$]', $
                       xtickfont_size = 12.0, $
                       ytickfont_size = 12.0, $
                       ytickname = cur_ytickname, $
                       color = colors[in], $
                       symbol = 'o', $
                       sym_size = 0.3, $
                       /sym_filled, $
                       linestyle = 'none', $
                       font_name = 'Times', $
                       current = current_frm, $
                       overplot = (in gt 0), $
                       /buffer)
            current_frm = 1B
            ax = frm.axes
            ax[0].showtext = row_is_bottom
            ax[1].showtext = col_is_left

            ;;==Plot fit
            if fit_this then begin
               opl = plot(10^fitx, $
                          10^yfit, $
                          color = 'red', $
                          thick = 2, $
                          /overplot)
               slope_str = strcompress(string(fitc[1], $
                                              format='(f6.1)'),/remove_all)
               txt = text(current_pos[2]-0.12, $
                          current_pos[3]-0.10, $
                          slope_str, $
                          /normal, $
                          color='red', $
                          font_name = 'Times', $
                          target = frm)
            endif

         endfor ;; n_datanames

         ;;==Print altitude on each panel
         txt = text(current_pos[2]-0.01, $
                    current_pos[3]-0.01, $
                    altitudes[ip], $
                    /normal, $
                    alignment = 1.0, $
                    vertical_alignment = 1.0, $
                    target = frm, $
                    font_name = 'Times', $
                    font_size = 12.0)
      endfor ;; n_paths

      ;;==Print dimensions above each column
      txt = text(0.5*(current_pos[0]+current_pos[2]), $
                 edges[3]+0.01, $
                 simdims, $
                 /normal, $
                 alignment = 0.5, $
                 target = frm, $
                 font_name = 'Times', $
                 font_size = 12.0)


   endfor ;; ndims_all

   ;;==Print a common y-axis title
   txt = text(edges[0]-0.07, $
              0.5*(edges[0]+edges[2]), $
              '$\langle|\delta f(k)/f_0|^2\rangle$', $
              /normal, $
              alignment = 0.5, $
              baseline = [0,1,0], $
              updir = [-1,0,0], $
              target = frm, $
              font_name = 'Times', $
              font_size = 12.0)

;;==Declare the graphics file name
name_abbrev = ''
for in=0,n_datanames-1 do $
   name_abbrev += strmid(datanames[in],0,1)
frmpath = get_base_dir()+path_sep()+ $
          'fb_flow_angle'+path_sep()+'common'+ $
          path_sep()+'frames'+path_sep()+ $
          name_abbrev+'_sqr-k_spectrum-multirun-snapshots-'+ $
          strcompress(it,/remove_all)+'.pdf'

;;==Save graphics frame
frame_save, frm,filename = frmpath

endfor ;; n_snapshots

end

