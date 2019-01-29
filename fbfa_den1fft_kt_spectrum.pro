;+
; Hack script for flow-angle paper
;-

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

;;==Get all file names
data_path = expand_path(path)+path_sep()+'parallel'
all_files = file_search(expand_path(data_path)+path_sep()+'parallel*.h5', $
                        count = n_files)

;;==Set data input mode
in_mode = 'restore'
save_name = 'den1fft_t-3D-first_quarter.sav'

;;==Build or restore data
t0 = systime(1)
case 1B of 
   strcmp(in_mode,'build'): begin
      tmp = get_rms_ranges(path,time_ref)
      sub_ind = [tmp[0,0]:tmp[1,0]]*time_ref.subsample
      sub_files = all_files[sub_ind]
      sub_nt = n_elements(sub_files)
      den1fft_t = complexarr(nx,ny,nz,sub_nt)
      for it=0,sub_nt-1 do begin
         tmp = get_h5_data(sub_files[it],'den1')
         den1fft_t[*,*,*,it] = transpose(fft(tmp,/center),[2,1,0])
      endfor
   end
   strcmp(in_mode,'restore'): begin
      filename = expand_path(path)+path_sep()+save_name
      restore, filename=filename,/verbose
   end
endcase
tf = systime(1)
print, "Elapsed minutes for build/restore: ",(tf-t0)/60.

;;==Get dimensions
dsize = size(den1fft_t)
nkx = dsize[1]
nky = dsize[2]
nkz = dsize[3]
sub_nt = dsize[4]

;;==Average over oblique modes
i_kx0 = nkx/2-2
i_kxf = nkx/2+2
fdata = mean(abs(den1fft_t[i_kx0:i_kxf-1,*,*,*]),dim=1)
fdata = reform(fdata)

;;==Interpolate
k_modes = fftfreq(nky,dy)
lambda = 1.0/k_modes[1:nky/2]
lambda = reverse(lambda)
theta = [0,2*!pi]
den1ktt = interp_xy2kt(fdata, $
                       lambda = lambda, $
                       theta = theta, $
                       dx = dy, $
                       dy = dz)

nl = n_elements(lambda)
spectrum = make_array(nl,value=0,/float)
for il=0,nl-1 do $
   spectrum[il] = rms(den1ktt[lambda[il]].f_interp)

end
