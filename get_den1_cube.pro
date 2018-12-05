;+
; Script for reading den1 from EPPIC simulations
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Load defaults
if n_elements(path) eq 0 then path = './'
if n_elements(info_path) eq 0 then info_path = path
if n_elements(data_path) eq 0 then data_path = path+path_sep()+'parallel'
if n_elements(params) eq 0 then params = set_eppic_params(path=path)
if n_elements(nt_max) eq 0 then nt_max = calc_timesteps(path=path)
if ~params.haskey('nt_max') then params['nt_max'] = nt_max
if n_elements(time) eq 0 then $
   time = time_strings(params.nout*lindgen(params.nt_max), $
                       dt=params.dt,scale=1e3,precision=2)

;;==Load a plane of data
den1 = import_cube_data('den1', $
                        timestep = long(time.index), $
                        ranges = ranges, $
                        rotate = rotate, $
                        info_path = info_path, $
                        data_path = data_path, $
                        data_type = 4, $
                        data_isft = 0B, $
                        /verbose)

;;==Build parameters
nx = params.nx*params.nsubdomains/params.nout_avg
ny = params.ny/params.nout_avg
nz = params.nz/params.nout_avg
dx = params.dx*params.nout_avg
dy = params.dy*params.nout_avg
dz = params.dz*params.nout_avg
