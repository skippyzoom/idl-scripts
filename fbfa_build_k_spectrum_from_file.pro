;+
; Version of fbfa_build_k_spectrum.pro that reads spectral data from a
; restore file rather than building it from simulation output file.
;
; Created by Matt Young.
;-

;;==Declare name of data to restore
dataname = 'efield'

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

;;==Declare name of save file to read
if params.ndim_space eq 2 then $
   filename = dataname+'_sqr-snapshots-fft.sav' $
else $
   filename = dataname+'_sqr-snapshots-fft-kpar_full_mean.sav'

;;==Declare name of save file to write
if params.ndim_space eq 2 then $
   savename = dataname+'_sqr-snapshots-k_spectrum.sav' $
else $
   savename = dataname+'_sqr-snapshots-k_spectrum-kpar_full_mean.sav'

;;==Restore save file
restore, path+path_sep()+filename,/verbose

;;==Declare interpolation parameters
if params.ndim_space eq 2 then begin
   nk = min([ny,nx])
   dk = max([dy,dx])
endif $
else begin
   nk = min([ny,nz])
   dk = max([dy,dz])
endelse
k_modes = fftfreq(nk,dk)
lambda = 1.0/k_modes[1:nk/2]
lambda = reverse(lambda)
nl = n_elements(lambda)
theta = [0:2*!pi]

;;==Set up interpolation array
spectrum = make_array(nl,time.nt,value=0,/float)

for it=0,time.nt-1 do begin
   ktt = interp_xy2kt(fftdata[*,*,it], $
                      lambda = lambda, $
                      theta = theta, $
                      dx = dy, $
                      dy = dz)
   for il=0,nl-1 do begin
      keys = ktt.keys()
      keys = keys.sort()
      spectrum[il,it] = mean(ktt[keys[il]].f_interp)
   endfor
endfor

;;==Save the data to disk
savepath = expand_path(path)+path_sep()+savename
sys_t0 = systime(1)
save, time,lambda,spectrum,i_kx0,i_kxf,filename=savepath
sys_tf = systime(1)
print, "Elapsed minutes for save: ",(sys_tf-sys_t0)/60.

end
