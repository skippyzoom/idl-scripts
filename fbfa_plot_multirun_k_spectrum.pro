;+
; Flow angle paper: Read k spectrum from a save file and make plots
; from multiple directories on the same axes.
;-

;;==Choose 2-D or 3-D data sets
simdims = '3D'

;;==Declare paths
paths = get_base_dir()+path_sep()+'fb_flow_angle/'+ $
        [simdims+'-new_coll/h0-Ey0_050/', $
         simdims+'-new_coll/h1-Ey0_050/', $
         simdims+'-new_coll/h2-Ey0_050/']
n_paths = n_elements(paths)

;;==Declare which file to restore
savename = strcmp(simdims,'3D',/fold_case) ? $
           'den1-k_spectrum-kpar_4pnt_mean.sav' : $
           'den1-k_spectrum.sav'

;;==Declare the graphics file name
frmpath = build_filename(strip_extension(savename),'.pdf', $
                         path = get_base_dir()+path_sep()+ $
                         'fb_flow_angle/'+simdims+'-new_coll'+ $
                         path_sep()+'common'+path_sep()+'frames', $
                         additions = ['multirun','bands'])

;;==Declare wavelengths (in meters) of interest
;;  Set either to !NULL to use default.
lam0 = 1.0
lamf = 5.0

;;==Set color preferences
colors = ['blue','green','red']

;;==Set short name for run labels
names = ['107 km', '110 km', '113 km']

;;==Loop over all paths
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

   ;;==Rescale spectrum by number of points
   vol = long(nx)*long(ny)
   if params.ndim_space eq 3 then begin
      str_kpar = strmid(savename,strpos(savename,'kpar')+5,4)
      case 1B of
         strcmp(str_kpar,'full'): vol *= long(nz)
         strcmp(str_kpar,'4pnt'): vol *= 4L
      endcase
   endif
   spectrum *= vol

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
   frm = plot(float(time.stamp), $
              ;; rms(spectrum[il0:ilf-1,*],dim=1), $
              total(spectrum[il0:ilf-1,*],1), $
              xstyle = 1, $
              /ylog, $
              ;; yrange = [1e0,1e3], $
              yrange = [1e0,1e5], $
              xtitle = 'Time ['+time.unit+']', $
              ytitle = 'A(k)', $
              title = title, $
              color = colors[ip], $
              overplot = (ip gt 0), $
              /buffer)

   ;;==Annotate according to run name
   txt = text(0.25,0.70+ip*0.03, $
              names[ip], $
              color = colors[ip], $
              /normal, $
              alignment = 1.0, $
              vertical_alignment = 0.0, $
              target = frm, $
              font_name = 'Courier', $
              font_size = 8)

endfor

;;==Add path annotation
txt = text(0.1,0,savepath, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 6)

;;==Save graphics frame
frame_save, frm,filename = frmpath

end
