;+
; Flow angle paper: Read k spectrum from a save file and make plots or
; movies. See also fbfa_k_spectrum_movie.pro,
; fbfa_k_spectrum_snapshots.pro, and fbfa_k_spectrum_bands.pro
;-

;;==Declare which graphics to make
make_movie = 0B
make_snapshots = 1B
make_k_bands = 0B

;;==Read in parameter dictionary
params = set_eppic_params(path=path)

;;==Declare which file to restore
savename = params.ndim_space eq 3 ? $
           'den1_sqr-k_spectrum-kpar_full_mean.sav' : $
           'den1_sqr-k_spectrum.sav'
savepath = expand_path(path)+path_sep()+savename

;;==Build parameters
nx = params.nx*params.nsubdomains/params.nout_avg
ny = params.ny/params.nout_avg
nz = params.nz/params.nout_avg
nt = time_ref.nt
dx = params.dx*params.nout_avg
dy = params.dy*params.nout_avg
dz = params.dz*params.nout_avg
dt = params.dt*params.nout
dkx = 2*!pi/(dx*nx)
dky = 2*!pi/(dy*ny)
dkz = 2*!pi/(dz*nz)

;;==Restore the data
sys_t0 = systime(1)
restore, filename=savepath,/verbose
sys_tf = systime(1)
print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60.

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

;;==Create a video of amplitude versus k
if make_movie then begin
   movpath = build_filename(strip_extension(savename),'.mp4', $
                            path = expand_path(path)+path_sep()+'movies', $
                            additions = '')
   sys_t0 = systime(1)
   r = video(2*!pi/lambda,spectrum,'ko', $
             ;; xrange = [0,128], $
             ;; yrange = [0,2.5e-3], $
             ;; xrange = [128,256], $
             yrange = [1e-6,1e-2], $
             ;; yrange = [1e-6,1e-4], $
             xstyle = 1, $
             /xlog, $
             /ylog, $
             resize = [4,4], $
             xtitle = 'k [m$^{-1}$]', $
             ;; ytitle = 'A(k)', $
             ytitle = '$\langle\delta n(k)\rangle$', $
             title = "t = "+time.stamp, $
             text = dictionary('xyz',[0,0], $
                               'string',savepath, $
                               'font_name','Courier', $
                               'font_size',6), $
             filename = movpath)
   sys_tf = systime(1)
   print, "Elapsed minutes for video: ",(sys_tf-sys_t0)/60.
endif                           ;MAKE_MOVIE

;;==Create a frame of amplitude versus k at select times
if make_snapshots then begin

   ;;==Determine the run subdirectory
   run_subdir = strmid(path, $
                       strlen(get_base_dir()+path_sep()+ $
                              'fb_flow_angle'+path_sep()))

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
         ply_dk = -5.0
         ply_a0 = 1e-2
         ply_af = ply_a0/10
         ply_k0 = 5.0
         ply_kf = 10^(-(alog10(ply_a0/ply_af)- $
                        ply_dk*alog10(ply_k0))/ply_dk)
      end
      3: begin
         ply_dk = -6.0
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
   frmpath = build_filename(strip_extension(savename),'.pdf', $
                            path = expand_path(path)+path_sep()+'frames', $
                            additions = '')
   sys_t0 = systime(1)
   for it=0,n_inds-1 do begin
      frm = plot(2*!pi/lambda, $
                 spectrum[*,t_ind[it]]/max(spectrum[*,t_ind]), $
                 ;; yrange = [1e-6,1e-2], $
                 ;; yrange = [1e0,1e4], $
                 ;; yrange = [1e-6,1e0], $
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
                 /buffer)
      ;; ply = polyline([ply_k0,ply_kf],[ply_a0,ply_af], $
      ;;                'k-', $
      ;;                target = frm, $
      ;;                /data)
      yrange = frm.yrange
      txt = text(0.85,0.8-it*0.03, $
                 "t = "+time.stamp[t_ind[it]], $
                 color = color[it], $
                 /normal, $
                 alignment = 1.0, $
                 vertical_alignment = 0.0, $
                 target = frm, $
                 font_name = 'Courier', $
                 font_size = 8)

   endfor
   txt = text(0.1,0,savepath, $
              target = frm, $
              font_name = 'Courier', $
              font_size = 6)
   frame_save, frm,filename = frmpath
   sys_tf = systime(1)
   print, "Elapsed minutes for frame: ",(sys_tf-sys_t0)/60.
endif                           ;MAKE_SNAPSHOTS

;;==Create a frame of amplitude versus time at select k values
if make_k_bands then begin

   ;;==Choose wavelength bands.
   ;;  The '-1' term in most bands separates adjacent bands, to avoid
   ;;  doulble counting. It is distict from the '-1' in the FOR loop,
   ;;  which exists purely for proper indexing. 
   ;;----------------------------------------------------------------
   ;; il = [[0,find_closest(lambda,1.0)-1], $
   ;;       [find_closest(lambda,1.0),find_closest(lambda,3.0)-1], $
   ;;       [find_closest(lambda,3.0),find_closest(lambda,6.0)-1], $
   ;;       [find_closest(lambda,6.0),find_closest(lambda,10.0)-1], $
   ;;       [find_closest(lambda,10.0),n_elements(lambda)]]
   ;; name = ['$\lambda$ $<$ 1 m', $
   ;;         '1 m $\leq$ $\lambda$ $<$ 3 m', $
   ;;         '3 m $\leq$ $\lambda$ $<$ 6 m', $
   ;;         '6 m $\leq$ $\lambda$ $<$ 10 m', $
   ;;         '10 m $\leq$ $\lambda$']
   ;; color = ['black','blue','sky blue','green','red']
   ;; il = [[0,find_closest(lambda,1.0)-1], $
   ;;       [find_closest(lambda,1.0),find_closest(lambda,5.0)-1], $
   ;;       [find_closest(lambda,5.0),find_closest(lambda,10.0)-1], $
   ;;       [find_closest(lambda,10.0),n_elements(lambda)]]
   ;; name = ['$\lambda$ $<$ 1 m', $
   ;;         '1 m $\leq$ $\lambda$ $<$ 5 m', $
   ;;         '5 m $\leq$ $\lambda$ $<$ 10 m', $
   ;;         '10 m $\leq$ $\lambda$']
   ;; color = ['black','blue','green','red']
   il = [[0,find_closest(lambda,1.0)-1], $
         [find_closest(lambda,1.0),find_closest(lambda,5.0)-1], $
         [find_closest(lambda,5.0),n_elements(lambda)]]
   name = ['$\lambda$ $<$ 1 m', $
           '1 m $\leq$ $\lambda$ $<$ 5 m', $
           '5 m $\leq$ $\lambda$']
   color = ['black','blue','green']
   ilsize = size(il)
   n_bands = ilsize[2]
   txt_x = 0.31
   ;; txt_y = params.ndim_space eq 2 ? 0.2 : 0.6
   txt_y = 0.70
   frmpath = build_filename(strip_extension(savename),'.pdf', $
                            path = expand_path(path)+path_sep()+'frames', $
                            additions = 'bands')
   sys_t0 = systime(1)
   for ib=0,n_bands-1 do begin
      frm = plot(float(time.stamp), $
                 rms(spectrum[il[0,ib]:il[1,ib]-1,*],dim=1), $
                 xstyle = 1, $
                 /ylog, $
                 ;; yrange = [1e-6,1e-2], $
                 yrange = [1e0,1e4], $
                 ;; yrange = [1e0,1e6], $
                 xtitle = 'Time ['+time.unit+']', $
                 ytitle = 'A(k)', $
                 ;; name = name[ib], $
                 color = color[ib], $
                 overplot = (ib gt 0), $
                 /buffer)
      txt = text(0.32,txt_y+ib*0.03, $
                 name[ib], $
                 color = color[ib], $
                 /normal, $
                 alignment = 1.0, $
                 vertical_alignment = 0.0, $
                 target = frm, $
                 font_name = 'Courier', $
                 font_size = 8)
   endfor
   txt = text(0.1,0,savepath, $
              target = frm, $
              font_name = 'Courier', $
              font_size = 6)
   frame_save, frm,filename = frmpath
   sys_tf = systime(1)
   print, "Elapsed minutes for frame: ",(sys_tf-sys_t0)/60.
endif                           ;MAKE_K_BANDS

end
