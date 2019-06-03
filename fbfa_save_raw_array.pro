;+
; Flow angle project: Read in raw data and save to an array. This may
; be faster in the long run.
;
; Created by Matt Young
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
nt = calc_timesteps(path=path)
dx = params.dx*params.nout_avg
dy = params.dy*params.nout_avg
dz = params.dz*params.nout_avg
dt = params.dt*params.nout
dkx = 2*!pi/(dx*nx)
dky = 2*!pi/(dy*ny)
dkz = 2*!pi/(dz*nz)
E0 = params.Ex0_external+params.Ey0_external+params.Ez0_external

;;==Get all file names
datapath = expand_path(path)+path_sep()+'parallel'
files = file_search(expand_path(datapath)+ $
                    path_sep()+'parallel*.h5', $
                    count = n_files)

;;==Construct a time dictionary for this data subset
steps = params.nout*lindgen(nt)
time = time_strings(steps, $
                    dt = params.dt, $
                    scale = 1e3, $
                    precision = 2)

;;==Needs differ slightly for 2-D v. 3-D runs
if params.ndim_space eq 2 then begin

   ;;==Allocate the array
   data = fltarr(nx,ny,nt)

   ;;==Loop over files to build array
   sys_t0 = systime(1)
   for it=0,nt-1 do begin
      tmp = get_h5_data(files[it],readname)
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
      data[*,*,it] = tmp
   endfor
   sys_tf = systime(1)
   print, "Elapsed minutes for read: ",(sys_tf-sys_t0)/60.

endif $
else begin

   ;;==Allocate the array
   data = fltarr(nx,ny,nz,nt)

   ;;==Loop over files to build array
   sys_t0 = systime(1)
   for it=0,nt-1 do begin
      tmp = get_h5_data(files[it],readname)
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
      data[*,*,*,it] = tmp
   endfor
   sys_tf = systime(1)
   print, "Elapsed minutes for read: ",(sys_tf-sys_t0)/60.

endelse

;;==Save the data to disk
savename = dataname+'.sav'
savepath = expand_path(path)+path_sep()+savename
sys_t0 = systime(1)
save, time,data,filename=savepath
sys_tf = systime(1)
print, "Elapsed minutes for save: ",(sys_tf-sys_t0)/60.

;;==Nullify the array to free memory
data = !NULL

end
