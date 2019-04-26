;+
; Flow angle paper: Read k spectrum from a save file and make plots
; versus time from multiple directories on the same axes.
;-

;;==Declare all dimensions
alldims = ['2D','3D']
ndims_all = n_elements(alldims)

;;==Compute positions
position = multi_position([2,1], $
                          edges = [0.15,0.3,0.9,0.9], $
                          buffers = [0.0,0.0])

;;==Loop over dimension sets
for id=0,ndims_all-1 do begin

   ;;==Choose 2-D or 3-D data sets
   simdims = alldims[id]

   ;;==Declare paths
   paths = get_base_dir()+path_sep()+'fb_flow_angle/'+ $
           [simdims+'-new_coll/h0-Ey0_050/', $
            simdims+'-new_coll/h1-Ey0_050/', $
            simdims+'-new_coll/h2-Ey0_050/']
   n_paths = n_elements(paths)

   ;;==Declare which file to restore
   savename = strcmp(simdims,'3D',/fold_case) ? $
              'den1_sqr-k_spectrum-kpar_full_mean.sav' : $
              'den1_sqr-k_spectrum.sav'

   ;;==Declare wavelengths (in meters) of interest
   ;;  Set either to !NULL to use default.
   lam0 = 1.0
   lamf = 5.0
   ;; lam0 = !NULL
   ;; lamf = !NULL

   ;;==Set color preferences
   colors = ['blue','green','red']

   ;;==Set short name for run labels
   names = ['107 km', '110 km', '113 km']

   ;;==Loop over all paths to create plots
   for ip=0,n_paths-1 do begin

      ;;==Select one path
      path = paths[ip]

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

      ;;==Rescale spectrum by number of perpendicular points.
      spectrum *= long(ny)*dy
      if params.ndim_space eq 3 then begin
         spectrum *= long(nz)*dz
      endif else begin
         spectrum *= long(nx)*dx
      endelse

      ;;==Rescale 3-D runs to account for mean along B.
      if params.ndim_space eq 3 then begin
         str_kpar = strmid(savename,strpos(savename,'kpar')+5,4)
         case 1B of
            strcmp(str_kpar,'full'): spectrum *= long(nx)
            strcmp(str_kpar,'4pnt'): spectrum *= 4L
         endcase
      endif

      ;;==Convert to square-root value as percentage.
      ;; spectrum = sqrt(spectrum)*100

      ;;==Set default wavelength range
      if n_elements(lam0) eq 0 then lam0 = lambda[0]
      if n_elements(lamf) eq 0 then lamf = lambda[nl-1]

      ;;==Set global title from wavelength range
      strlam0 = strcompress(string(lam0,format='(f4.1)'),/remove_all)
      strlamf = strcompress(string(lamf,format='(f4.1)'),/remove_all)
      title = [strlam0+" m $<$ $\lambda$ $<$ "+strlamf+" m"]

      ;;==Extract k-band indices by wavelength
      il0 = find_closest(lambda,lam0)
      ilf = find_closest(lambda,lamf)

      ;;==Create a frame of amplitude versus time within a k band
      xdata = float(time.stamp)
      ydata = mean(spectrum[il0:ilf-1,1:*],dim=1)

      frm = plot(xdata, $
                 ydata, $
                 position = position[*,id], $
                 xstyle = 1, $
                 /ylog, $
                 yrange = [1e-5,1e-1], $
                 xtitle = 'Time ['+time.unit+']', $
                 ytitle = '$\langle|\delta n(k)/n_0|^2\rangle$', $
                 ;; ytickname = ['$10^{-4}$','$10^{-3}$','$10^{-2}$', $
                 ;;              '$10^{-1}$','$10^{0}$','$10^{+1}$'], $
                 title = title, $
                 color = colors[ip], $
                 overplot = (ip gt 0), $
                 current = (id gt 0), $
                 font_name = 'Times', $
                 /buffer)
      ax = frm.axes
      ax[1].showtext = (id eq 0)

   endfor

endfor

;;==Declare the graphics file name
frmpath = get_base_dir()+path_sep()+ $
          'fb_flow_angle'+path_sep()+'common'+ $
          path_sep()+'frames'+path_sep()+ $
          'den1_sqr-k_spectrum-multirun-bands_meter.pdf'

;;==Save graphics frame
frame_save, frm,filename = frmpath

end
