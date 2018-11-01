;+
; Build an array of theta-RMS den1(k,theta,t) from multiple runs. 
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare project path
proj_path = get_base_dir()+path_sep()+'fb_flow_angle/3D-new_coll/'

;;==Declare name of save file
den1ktt_save_name = build_filename('den1ktt','sav', $
                                   additions = ['all_k', $
                                                'all_theta', $
                                                'subsample_1'])

;;==Declare target wavelength ranges
lam_lo = list(1.0,10.0)
lam_hi = list(4.0,!NULL)

;;==Declare runs
;; run = ['h0-Ey0_030', $
;;        'h1-Ey0_030', $
;;        'h2-Ey0_030']
;; run = ['h0-Ey0_050', $
;;        'h1-Ey0_050', $
;;        'h2-Ey0_050']
run = ['h0-Ey0_070', $
       'h1-Ey0_070', $
       'h2-Ey0_070']
nr = n_elements(run)

;;==Declare note to append to filenames
filename_note = strmid(run[0],3,7)

;;==Declare index of parameter hash
iph = 0

;;==Get common parameters from one directory
path = expand_path(proj_path)+path_sep()+run[iph]
params = set_eppic_params(path=path)
restore, expand_path(path)+path_sep()+den1ktt_save_name

;;==Get available wavelengths
l_keys = ((den1ktt.keys()).sort()).toarray()

;;==Determine number of wavelength subsets
ns = max([n_elements(lam_lo),n_elements(lam_hi)])

;;==Set default low and high wavelengths, if necessary
for is=0,ns-1 do $
   if n_elements(lam_lo[is]) eq 0 then lam_lo[is] = min(l_keys)
for is=0,ns-1 do $
   if n_elements(lam_hi[is]) eq 0 then lam_hi[is] = max(l_keys)

;;==Filter wavelengths into target wavelength subsets
lambda = list()
for is=0,ns-1 do $
   lambda.add, l_keys[where(l_keys ge lam_lo[is] and l_keys le lam_hi[is])]

;;==Get number of time steps
nt = n_elements(time.index)

;;==Build the multi-run ktt hash
mr_den1ktt = build_multirun_hash(proj_path, $
                                   run, $
                                   den1ktt_save_name, $
                                   data_name)

;;==Build the multi-run kttrms hash
mr_kttrms = hash()
for is=0,ns-1 do $
   mr_kttrms[is] = build_multirun_kttrms(mr_den1ktt, $
                                         'den1ktt', $
                                         lambda=lambda[is])

;;==Get number of time steps in each run
mr_nt = lonarr(nr)
for ir=0,nr-1 do $
   mr_nt[ir] = n_elements((mr_kttrms[0])[run[ir]])
