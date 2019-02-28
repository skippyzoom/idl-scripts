;+
; Set up some defaults for flow angle analysis
;-
if n_elements(lun) eq 0 then lun = -1
printf, lun, "[DEFAULTS_AND_TIME] path = "+path
if n_elements(rotate) eq 0 then rotate = 0
if n_elements(axes) eq 0 then axes = 'xy'
if n_elements(path) eq 0 then path = './'
if n_elements(info_path) eq 0 then info_path = path
if n_elements(data_path) eq 0 then data_path = path+path_sep()+'parallel'
if n_elements(zero_point) eq 0 then zero_point = 0
params = set_eppic_params(path=path)
nt_max = calc_timesteps(path=path)
params['nt_max'] = nt_max
frame_type = '.pdf'
movie_type = '.mp4'
perp_plane = (params.ndim_space eq 2 and strcmp(axes,'xy')) || $
             (params.ndim_space eq 3 and strcmp(axes,'yz')) 

efield_save_name = expand_path(path)+path_sep()+ $
                   'efield_'+axes+ $
                   '.sav'

;+
; Build a reference time dictionary.
; This can be useful for debugging or for using a lookup hash to build
; a new time dictionary out of a subset of all available time
; steps. There are a few options shown below, but the essential part
; is an array of time steps to pass to time_strings. This takes so
; little time that there is probably no reason to comment it out.
;-
;;==Evenly spaced steps from T0 to TF at frequency SUBSAMPLE
t0 = 0
tf = nt_max
subsample = 1
;; subsample = params.nvsqr_out_subcycle1
if params.ndim_space eq 2 then subsample *= 8L
timesteps = params.nout*(t0 + subsample*lindgen((tf-t0-1)/subsample+1))
;;==Specific steps
;; timesteps = params.nout*[0, $
;;                          nt_max/4, $
;;                          nt_max/2, $
;;                          3*nt_max/4, $
;;                          nt_max-1]
;;==Construct dictionary
time_ref = time_strings(long(timesteps), $
                        dt = params.dt, $
                        scale = 1e3, $
                        precision = 2)
if n_elements(subsample) ne 0 then time_ref.subsample = subsample $
else time_ref.subsample = 1
