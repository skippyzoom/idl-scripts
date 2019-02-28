;+
; Flow angle paper: Read k spectrum from a save file and make a
; movie. 
;-

;;==Declare which graphics to make
make_movie = 0B
make_snapshots = 1B
make_k_bands = 0B

;;==Read in parameter dictionary
params = set_eppic_params(path=path)

;;==Declare which file to restore
savename = params.ndim_space eq 3 ? $
           'den1-k_spectrum-kpar_4pnt_mean.sav' : $
           'den1-k_spectrum.sav'
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
vol = long(nx)*long(ny)
if params.ndim_space eq 3 then begin
   str_kpar = strmid(savename,strpos(savename,'kpar')+5,4)
   case 1B of
      strcmp(str_kpar,'full'): vol *= long(nz)
      strcmp(str_kpar,'4pnt'): vol *= 4L
   endcase
endif
spectrum *= vol

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

end
