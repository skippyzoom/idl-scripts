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

;;==Declare Boltzmann's constant
kb = 1.3806503e-23

;;==Set up array for temp1
temp1 = fltarr(nx,ny,nz,sub_nt)

;;==Loop over subset to build temp1
t0 = systime(1)
for it=0,sub_nt-1 do begin
   ;; den = get_h5_data(sub_files[it],'den1')
   ;; den = params.n0d1*(1+den)
   den_inv = 1.0/(params.n0d1*(1+get_h5_data(sub_files[it],'den1')))
   fluxx = get_h5_data(sub_files[it],'fluxx1')
   fluxy = get_h5_data(sub_files[it],'fluxy1')
   fluxz = get_h5_data(sub_files[it],'fluxz1')
   nvsqrx = get_h5_data(sub_files[it],'nvsqrx1')
   nvsqry = get_h5_data(sub_files[it],'nvsqry1')
   nvsqrz = get_h5_data(sub_files[it],'nvsqrz1')
   ;; vsqrx = nvsqrx/den - (fluxx/den)^2
   ;; vsqry = nvsqry/den - (fluxy/den)^2
   ;; vsqrz = nvsqrz/den - (fluxz/den)^2
   vsqrx = nvsqrx*den_inv - (fluxx*den_inv)^2
   vsqry = nvsqry*den_inv - (fluxy*den_inv)^2
   vsqrz = nvsqrz*den_inv - (fluxz*den_inv)^2
   temp1[*,*,*,it] = transpose(params.md1*(vsqrx+vsqry+vsqrz)/kb,[2,1,0])
endfor
tf = systime(1)
print, "Elapsed minutes for build: ",(tf-t0)/60.

;;==Save array
t0 = systime(1)
save, temp1,filename=expand_path(path)+path_sep()+'temp1-3D.sav'
tf = systime(1)
print, "Elapsed minutes for save: ",(tf-t0)/60.

end
