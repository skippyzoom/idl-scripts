;+
; From Dimant & Oppenheim (2004), Equation 40.
;-

path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h0-Ey0_050-full_output/'
params = set_eppic_params(path=path)
moments = read_moments(path=path)
kb = 1.3807e-23
E0 = params.Ey0_external
;; k = 2*!pi/findgen(91,increment=0.1,start=1)
;; nk = n_elements(k)
k = 2*!pi/3.0
chi = 0.5*!pi*findgen(91)/90.
nc = n_elements(chi)

nui = 370.
wci = moments.dist1.wc
mi = params.md1
qi = params.qd1
u0 = qi*E0/(mi*wci*sqrt(1+(wci/nui)^2))
ti = 300.
vti = sqrt(kb*ti/mi)

im_tin = fltarr(nc)
for ic=0,nc-1 do $
   im_tin[ic] = nui*k*u0*cos(chi[ic])* $
   ((wci/nui)*(u0/vti)^2*sin(chi[ic])*cos(chi[ic]) - 1)/ $
   (nui^2 + (k*u0*cos(chi[ic]))^2)
plot, chi/!dtor,(2./3.)*im_tin/!dtor,xstyle=1,psym=4

nue = 1000.
wce = abs(moments.dist0.wc)
me = params.md0
te = 300.
vte = sqrt(kb*te/me)
psi = nue*nui/(wce*wci)
den = 3.3e-3

im_ten = fltarr(nc)
for ic=0,nc-1 do $
   im_ten[ic] = k*u0*psi*cos(chi[ic])* $
   (2*psi*(ti*wci/te)*(u0/vte)^2*sin(chi[ic])*cos(chi[ic]) - (1+psi)*den*nue)/ $
   (((1+psi)*den*nue)^2 + (k*u0*psi*cos(chi[ic]))^2)

oplot, chi/!dtor,(2./3.)*im_ten/!dtor,psym=3
