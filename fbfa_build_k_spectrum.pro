;+
; Script for building the wavenumber spectrum, averaged over all
; angles in k space, as a function of time. This script produces a
; logically (2+1)-D array: For 2-D runs, it uses the FFT of the
; simulation data; for 3-D runs, it computes the RMS over parallel
; modes within a specified range. This script saves the data to a file
; with the same name, regardless of parallel range or dimensions of
; input data. It is the user's responsibility to rename the
; resultant file in order the distinguish between, for example,
; different parallel RMS ranges.
;
; Created by Matt Young.
;-

;;==Declare name of target data quantity
dataname = 'den1'

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

;;==Declare RMS range parallel to B
;; i_kx0 = nx/2-2
;; i_kxf = nx/2+2
i_kx0 = 0
i_kxf = nx

;;==Declare time range
it0 = 0
itf = nt
itd = 2

;;==Get all file names
datapath = expand_path(path)+path_sep()+'parallel'
all_files = file_search(expand_path(datapath)+path_sep()+'parallel*.h5', $
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

   ;;==Needs differ slightly for 2-D v. 3-D runs
   if params.ndim_space eq 2 then begin

      ;;==Declare interpolation parameters
      nk = min([nx,ny])
      dk = max([dx,dy])
      k_modes = fftfreq(nk,dk)
      lambda = 1.0/k_modes[1:nk/4]
      lambda = reverse(lambda)
      nl = n_elements(lambda)
      theta = [0:2*!pi]

      ;;==Set up interpolation array
      spectrum = make_array(nl,(itf-it0)/itd+1,value=0,/float)

      ;;==Loop over files to build array
      sys_t0 = systime(1)
      for it=it0,itf-1,itd do begin
         tmp = get_h5_data(sub_files[it],dataname)
         tmp = transpose(tmp,[1,0])
         tmp = fft(tmp,/center,/overwrite)
         tmp = abs(tmp)
         tmp = reform(tmp)
         ktt = interp_xy2kt(tmp, $
                            lambda = lambda, $
                            theta = theta, $
                            dx = dx, $
                            dy = dy)
         for il=0,nl-1 do begin
            keys = ktt.keys()
            keys = keys.sort()
            spectrum[il,(it-it0)/itd] = rms(ktt[keys[il]].f_interp)
         endfor
      endfor
      sys_tf = systime(1)
      print, "Elapsed minutes for build: ",(sys_tf-sys_t0)/60.

   endif $
   else begin

      ;;==Declare interpolation parameters
      nk = min([ny,nz])
      dk = max([dy,dz])
      k_modes = fftfreq(nk,dk)
      lambda = 1.0/k_modes[1:nk/2]
      lambda = reverse(lambda)
      nl = n_elements(lambda)
      theta = [0:2*!pi]

      ;;==Set up interpolation array
      spectrum = make_array(nl,(itf-it0)/itd+1,value=0,/float)

      ;;==Loop over files to build array
      sys_t0 = systime(1)
      for it=it0,itf-1,itd do begin
         tmp = get_h5_data(sub_files[it],dataname)
         tmp = transpose(tmp,[2,1,0])
         tmp = fft(tmp,/center,/overwrite)
         tmp = mean(abs(tmp[i_kx0:i_kxf-1,*,*]),dim=1)
         tmp = reform(tmp)
         ktt = interp_xy2kt(tmp, $
                            lambda = lambda, $
                            theta = theta, $
                            dx = dy, $
                            dy = dz)
         for il=0,nl-1 do begin
            keys = ktt.keys()
            keys = keys.sort()
            spectrum[il,(it-it0)/itd] = rms(ktt[keys[il]].f_interp)
         endfor
      endfor
      sys_tf = systime(1)
      print, "Elapsed minutes for build: ",(sys_tf-sys_t0)/60.

   endelse

   ;;==Construct a time dictionary for this data subset
   substeps = time_ref.subsample*params.nout* $
              (it0 + itd*lindgen((itf-it0-1)/itd + 1))
   time = time_strings(substeps, $
                       dt = params.dt, $
                       scale = 1e3, $
                       precision = 2)

   ;;==Save the data to disk
   savename = dataname+'-k_spectrum.sav'
   savepath = expand_path(path)+path_sep()+savename
   sys_t0 = systime(1)
   save, time,lambda,spectrum,filename=savepath
   sys_tf = systime(1)
   print, "Elapsed minutes for save: ",(sys_tf-sys_t0)/60.

endif $
else print, "N_FILES_SUB not equal to NT"

end
