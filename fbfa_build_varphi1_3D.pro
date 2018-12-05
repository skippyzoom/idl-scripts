;+
; Hack script to do some last-minute analysis for my dissertation
;-

;;==Build parameters
nx = params.nx*params.nsubdomains/params.nout_avg
ny = params.ny/params.nout_avg
nz = params.nz/params.nout_avg
nt = time_ref.nt
dx = params.dx*params.nout_avg
dy = params.dy*params.nout_avg
dz = params.dz*params.nout_avg
dt = params.dt*params.nout

;;==Get all file names
data_path = expand_path(path)+path_sep()+'parallel'
all_files = file_search(expand_path(data_path)+path_sep()+'parallel*.h5', $
                        count = n_files)

;;==Select a subset of times
sub_ind = params.nvsqr_out_subcycle1* $
          lindgen(1+nt/params.nvsqr_out_subcycle1)
sub_files = all_files[sub_ind]
sub_nt = n_elements(sub_files)

;;==Restore temp1 array
t0 = systime(1)
filename = 'temp1-3D.sav'
restore, filename=expand_path(path)+path_sep()+filename
tf = systime(1)
print, "Elapsed minutes for restore: ",(tf-t0)/60.

;;==Set up varphi1 array
t0 = systime(1)
;; varphi1 = complexarr(nx,ny,nz,sub_nt)
varphi1 = complexarr(ny,nz,sub_nt)
tf = systime(1)
print, "Elapsed minutes for setup: ",(tf-t0)/60.

;;==Loop over subset to build varphi1
t0 = systime(1)
for it=0,sub_nt-1 do begin
   n1 = transpose(get_h5_data(sub_files[it],'den1'),[2,1,0])
   T1 = temp1[*,*,*,it]
   T1 = (T1-mean(T1))/mean(T1)
   ;; varphi1[*,*,*,it] = fft(T1,/center)/fft(n1,/center)
   tmp_T1 = fft(T1,/center)
   tmp_T1 = mean(tmp_T1[nx/2-2:nx/2+2,*,*],dim=1)
   tmp_n1 = fft(n1,/center)
   tmp_n1 = mean(tmp_n1[nx/2-2:nx/2+2,*,*],dim=1)
   varphi1[*,*,it] = tmp_T1/tmp_n1
endfor
tf = systime(1)
print, "Elapsed minutes for build: ",(tf-t0)/60.

;;==Extract real and imaginary parts of varphi1
t0 = systime(1)
varphi1_r = real_part(varphi1)
varphi1_i = imaginary(varphi1)
varphi1 = !NULL
tf = systime(1)
print, "Elapsed minutes for real/imag: ",(tf-t0)/60.

;;==Compute the phase and store in varphi1
t0 = systime(1)
varphi1 = atan(varphi1_i,varphi1_r)
tf = systime(1)
print, "Elapsed minutes for arctan: ",(tf-t0)/60.

;;==Save array
t0 = systime(1)
filename = expand_path(path)+path_sep()+'varphi1-3D-kpar_4point_mean.sav'
save, varphi1,filename=filename
tf = systime(1)
print, "Elapsed minutes for save: ",(tf-t0)/60.

end
