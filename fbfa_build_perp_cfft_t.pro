;+
; Flow angle paper: Similar to fbfa_build_perp_fft_t.pro except that
; this script leaves the complex array as is.
;-

;;==Declare name of target data quantity
dataname = 'den1'

;;==Set name for reading
if strcmp(dataname, 'efield') then readname = 'phi' $
else readname = dataname

;;==Read in parameter dictionary
params = set_eppic_params(path=path)

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
E0 = params.Ex0_external+params.Ey0_external+params.Ez0_external

;;==Declare RMS range parallel to B
;; i_kx0 = nx/2-2
;; i_kxf = nx/2+2
;; str_kpar = 'kpar_4pnt_mean'
i_kx0 = 0
i_kxf = nx
str_kpar = 'kpar_full_mean'

;;==Declare time range
it0 = 0
itf = nt
itd = 2

;;==Get all file names
datapath = expand_path(path)+path_sep()+'parallel'
all_files = file_search(expand_path(datapath)+ $
                        path_sep()+'parallel*.h5', $
                        count = n_files_all)

;;==Extract a subset based on time_ref.subsample
if time_ref.haskey('subsample') && time_ref.subsample gt 1 then $
   sub_files = all_files[time_ref.subsample*indgen(nt)] $
else $
   sub_files = all_files

;;==Count the new number of files
n_files_sub = n_elements(sub_files)

;;==Make sure there is the right number of files
if n_files_sub eq nt then begin

   ;;==Construct a time dictionary for this data subset
   substeps = time_ref.subsample*params.nout* $
              (it0 + itd*lindgen((itf-it0-1)/itd + 1))
   time = time_strings(substeps, $
                       dt = params.dt, $
                       scale = 1e3, $
                       precision = 2)

   ;;==Needs differ slightly for 2-D v. 3-D runs
   if params.ndim_space eq 2 then begin

      ;;==Allocate the array
      fftdata = complexarr(nx,ny,(itf-it0)/itd+1)

      ;;==Loop over files to build array
      sys_t0 = systime(1)
      for it=it0,itf-1,itd do begin
         tmp = get_h5_data(sub_files[it],readname)
         if strcmp(dataname, 'efield') then begin
            orig = tmp
            grad = gradient(orig, $
                            dx = dx, $
                            dy = dy)
            xcomp = -1.0*grad.x
            ycomp = -1.0*grad.y
            mag = sqrt(xcomp^2 + ycomp^2)
            tmp = (mag-E0)/E0
         endif
         tmp = transpose(tmp,[1,0])
         tmp = fft(tmp,/center,/overwrite)
         tmp = reform(tmp)
         fftdata[*,*,(it-it0)/itd] = tmp
      endfor
      sys_tf = systime(1)
      print, "Elapsed minutes for build: ",(sys_tf-sys_t0)/60.

      ;;==Save the data to disk
      savename = dataname+'-cfft.sav'
      savepath = expand_path(path)+path_sep()+savename
      sys_t0 = systime(1)
      save, time,fftdata,i_kx0,i_kxf,filename=savepath
      sys_tf = systime(1)
      print, "Elapsed minutes for save: ",(sys_tf-sys_t0)/60.

   endif $
   else begin

      ;;==Allocate the array
      fftdata = complexarr(ny,nz,(itf-it0)/itd+1)

      ;;==Loop over files to build array
      sys_t0 = systime(1)
      for it=it0,itf-1,itd do begin
         tmp = get_h5_data(sub_files[it],readname)
         if strcmp(dataname, 'efield') then begin
            orig = tmp
            grad = gradient(orig, $
                            dx = dx, $
                            dy = dy, $
                            dz = dz)
            xcomp = -1.0*grad.x
            ycomp = -1.0*grad.y
            zcomp = -1.0*grad.z
            mag = sqrt(xcomp^2 + ycomp^2 + zcomp^2)
            tmp = (mag-E0)/E0
         endif
         tmp = transpose(tmp,[2,1,0])
         tmp = fft(tmp,/center,/overwrite)
         tmp = mean(tmp[i_kx0:i_kxf-1,*,*],dim=1)
         tmp = reform(tmp)
         fftdata[*,*,(it-it0)/itd] = tmp
      endfor
      sys_tf = systime(1)
      print, "Elapsed minutes for build: ",(sys_tf-sys_t0)/60.

      ;;==Save the data to disk
      savename = dataname+'-cfft-'+str_kpar+'.sav'
      savepath = expand_path(path)+path_sep()+savename
      sys_t0 = systime(1)
      save, time,fftdata,i_kx0,i_kxf,filename=savepath
      sys_tf = systime(1)
      print, "Elapsed minutes for save: ",(sys_tf-sys_t0)/60.

   endelse

endif $
else print, "N_FILES_SUB not equal to NT"

end
