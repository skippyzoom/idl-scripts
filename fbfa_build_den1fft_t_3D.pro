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

;;==Select a subset of times and declare save-file name
;;>>Second half of run
sub_ind = [0:time_ref.nt/4-1]
filename = 'den1fft_t-3D-first_quarter'
;;>>Second half of run
;; sub_ind = [time_ref.nt/2:time_ref.nt-1]
;; filename = 'den1fft_t-3D-second_half'
;;>>Temperature subcycle
;; sub_ind = params.nvsqr_out_subcycle1* $
;;           lindgen(1+nt/params.nvsqr_out_subcycle1)
;; filename = 'den1fft_t-3D-nvsqr_out_subcycle1'
;;>>Final 32 time steps
;; sub_ind = [time_ref.nt-32:time_ref.nt-1]
;; filename = 'den1fft_t-3D-final_32'
;;>>Growth stage
;; tmp = get_rms_ranges(path,time_ref)
;; sub_ind = [tmp[0,0]:tmp[1,0]]
;; filename = 'den1fft_t-3D-growth'

;;==Retrieve file subset
sub_files = all_files[sub_ind]
sub_nt = n_elements(sub_files)

;;==Set up den1fft_t array
t0 = systime(1)
den1fft_t = complexarr(nx,ny,nz,sub_nt)
tf = systime(1)
print, "Elapsed minutes for setup: ",(tf-t0)/60.

;;==Loop over subset to build 3-D den1fft_t
t0 = systime(1)
for it=0,sub_nt-1 do begin
   tmp = get_h5_data(sub_files[it],'den1')
   den1fft_t[*,*,*,it] = transpose(fft(tmp,/center),[2,1,0])
endfor
tf = systime(1)
print, "Elapsed minutes for build: ",(tf-t0)/60.

;;==Save den1fft_t
t0 = systime(1)
save, den1fft_t,filename=expand_path(path)+path_sep()+ $
      strip_extension(filename)+'.sav'
tf = systime(1)
print, "Elapsed minutes for save: ",(tf-t0)/60.

end
