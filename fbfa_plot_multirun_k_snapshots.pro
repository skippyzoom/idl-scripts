;+
; Flow angle paper: Read k spectrum from a save file and make plots
; versus time from multiple directories on the same axes.
;-

;;==Choose 2-D or 3-D data sets
simdims = '2D'

;;==Declare paths
paths = get_base_dir()+path_sep()+'fb_flow_angle/'+ $
        [simdims+'-new_coll/h0-Ey0_050/', $
         simdims+'-new_coll/h1-Ey0_050/', $
         simdims+'-new_coll/h2-Ey0_050/']
n_paths = n_elements(paths)

;;==Declare which file to restore
savename = strcmp(simdims,'3D',/fold_case) ? $
           'den1_sqr-k_spectrum-kpar_4pnt_mean.sav' : $
           'den1_sqr-k_spectrum.sav'

;;==Declare the graphics file name
frmpath = build_filename(strip_extension(savename),'.pdf', $
                         path = get_base_dir()+path_sep()+ $
                         'fb_flow_angle/'+simdims+'-new_coll'+ $
                         path_sep()+'common'+path_sep()+'frames', $
                         additions = 'mr_snapshots')

;;==Compute positions
position = multi_position([2,3], $
                          edges = [0.1,0.1,0.9,0.9], $
                          buffers = [0.0,0.0])

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
   vol = long(ny)
   if params.ndim_space eq 3 then begin
      str_kpar = strmid(savename,strpos(savename,'kpar')+5,4)
      case 1B of
         strcmp(str_kpar,'full'): vol *= long(nz)*long(nx)
         strcmp(str_kpar,'4pnt'): vol *= long(nz)*4L
      endcase
   endif $
   else vol *= long(nx)
   spectrum *= vol

   ;;==Assign time indices based on run
   case 1B of
      strcmp(run_subdir, $
                 '2D-new_coll'+path_sep()+'h0-Ey0_050'+path_sep()): $
         t_ind = [find_closest(float(time.stamp),17.92), $
                  find_closest(float(time.stamp),78.85), $
                  find_closest(float(time.stamp),114.69), $
                  time.nt-1]
      strcmp(run_subdir, $
                 '2D-new_coll'+path_sep()+'h1-Ey0_050'+path_sep()): $
         t_ind = [find_closest(float(time.stamp),17.92), $
                  find_closest(float(time.stamp),68.10), $
                  find_closest(float(time.stamp),111.10), $
                  time.nt-1]
      strcmp(run_subdir, $
                 '2D-new_coll'+path_sep()+'h2-Ey0_050'+path_sep()): $
         t_ind = [find_closest(float(time.stamp),17.92), $
                  find_closest(float(time.stamp),111.10), $
                  find_closest(float(time.stamp),139.78), $
                  time.nt-1]
      strcmp(run_subdir, $
                 '3D-new_coll'+path_sep()+'h0-Ey0_050'+path_sep()): $
         t_ind = [find_closest(float(time.stamp),9.86), $
                  find_closest(float(time.stamp),24.19), $
                  find_closest(float(time.stamp),32.26), $
                  time.nt-1]
      strcmp(run_subdir, $
                 '3D-new_coll'+path_sep()+'h1-Ey0_050'+path_sep()): $
         t_ind = [find_closest(float(time.stamp),9.86), $
                  find_closest(float(time.stamp),21.50), $
                  find_closest(float(time.stamp),30.46), $
                  time.nt-1]
      strcmp(run_subdir, $
                 '3D-new_coll'+path_sep()+'h2-Ey0_050'+path_sep()): $
         t_ind = [find_closest(float(time.stamp),9.86), $
                  find_closest(float(time.stamp),28.67), $
                  find_closest(float(time.stamp),38.53), $
                  time.nt-1]
   endcase         

   case params.ndim_space of
      2: begin
         ply_dk = -3.0
         ply_a0 = 1e-2
         ply_af = ply_a0/10
         ply_k0 = 5.0
         ply_kf = 10^(-(alog10(ply_a0/ply_af)- $
                        ply_dk*alog10(ply_k0))/ply_dk)
      end
      3: begin
         ply_dk = -4.0
         ply_a0 = 1e-2
         ply_af = ply_a0/10
         ply_k0 = 5.0
         ply_kf = 10^(-(alog10(ply_a0/ply_af)- $
                        ply_dk*alog10(ply_k0))/ply_dk)
      end
   endcase

   n_inds = n_elements(t_ind)            
   t_ind = reverse(t_ind)
   color = ['green','blue','gray','black']

   sys_t0 = systime(1)
   for it=0,n_inds-1 do begin
      frm = plot(2*!pi/lambda, $
                 spectrum[*,t_ind[it]]/max(spectrum[*,t_ind]), $
                 position = position[*,ip], $
                 ;; yrange = [1e-6,1e-2], $
                 ;; yrange = [1e0,1e4], $
                 yrange = [1e-6,1e0], $
                 xstyle = 1, $
                 /xlog, $
                 /ylog, $
                 xtitle = 'k [m$^{-1}$]', $
                 ;; ytitle = 'A(k)', $
                 ytitle = '$\langle|\delta n(k)/n_0|^2\rangle$', $
                 xtickfont_size = 14.0, $
                 ytickfont_size = 14.0, $
                 color = color[it], $
                 symbol = 'o', $
                 sym_size = 0.5, $
                 /sym_filled, $
                 overplot = (it gt 0), $
                 current = (ip gt 0), $
                 /buffer)
      ply = polyline([ply_k0,ply_kf],[ply_a0,ply_af], $
                     'k-', $
                     target = frm, $
                     /data)
      yrange = frm.yrange
      txt = text(0.85,0.8-it*0.03, $
                 "t = "+time.stamp[t_ind[it]], $
                 color = color[it], $
                 /normal, $
                 alignment = 1.0, $
                 vertical_alignment = 0.0, $
                 target = frm, $
                 font_name = 'Courier', $
                 font_size = 4)

   endfor

endfor

;;==Add path annotation
txt = text(0.1,0,savepath, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 6)

;;==Save graphics frame
frame_save, frm,filename = frmpath

end

