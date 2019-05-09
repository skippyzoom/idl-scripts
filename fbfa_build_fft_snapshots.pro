;+
; Flow angle paper: Build an FFT at specified times.
;
; I originally wrote this routine to recreate the multirun density k
; spectrum figure for electric field perturbations, without having to
; read data at every time step.
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
;; str_kpar = 'kpar_4pnt_mean'
i_kx0 = 0
i_kxf = nx
str_kpar = 'kpar_full_mean'

;;==Determine the run subdirectory
run_subdir = strmid(path, $
                    strlen(get_base_dir()+path_sep()+ $
                           'fb_flow_angle'+path_sep()))


;;==Assign time indices based on run
t_ind = fbfa_select_time_indices(run_subdir, time_ref)

;;==Determine number of time indices
n_inds = n_elements(t_ind)            

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

;;==Extract the snapshot times
snap_files = sub_files[t_ind]

end
