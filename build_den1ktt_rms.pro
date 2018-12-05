;+
; Build an array of theta-RMS den1(k,theta,t) from a single run. 
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare target wavelength ranges
lam_lo = list(1.0,10.0)
lam_hi = list(4.0,!NULL)

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

;;==Build kttrms hash
den1ktt_rms = hash()
for is=0,ns-1 do $
   den1ktt_rms[is] = build_kttrms(den1ktt,lambda=lambda[is])
