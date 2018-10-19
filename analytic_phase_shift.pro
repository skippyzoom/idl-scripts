;+
; From Dimant & Oppenheim (2004), Equation 40.
;-

path = get_base_dir()+path_sep()+'fb_flow_angle/2D/h2-Ey0_070-full_output/'
params = set_eppic_params(path=path)
moments = read_moments(path=path)
kb = 1.3807e-23
E0 = params.Ey0_external
;; k = 2*!pi/findgen(91,increment=0.1,start=1)
;; nk = n_elements(k)
k = 2*!pi/2.5
chi = !pi*(findgen(91)/90. - 0.5)
nc = n_elements(chi)
alt = strmid(file_basename(path),0,2)
nui = hash('h0',1021.70, $
           'h1',610.055, $
           'h2',369.367)
nue = hash('h0',964.595, $
           'h1',671.417, $
           'h2',490.508)
wci = moments.dist1.wc
mi = params.md1
qi = params.qd1
u0 = qi*E0/(mi*wci*sqrt(1+(wci/nui[alt])^2))
ti = 600.
vti = sqrt(kb*ti/mi)

re_tin = fltarr(nc)
for ic=0,nc-1 do $
   re_tin[ic] = (2./3.)*((wci/nui[alt])* $
                         (u0/vti)^2*nui[alt]^2*sin(chi[ic])*cos(chi[ic]) + $
                         (k*u0*cos(chi[ic]))^2)/(nui[alt]^2 + (k*u0*cos(chi[ic]))^2)
im_tin = fltarr(nc)
for ic=0,nc-1 do $
   im_tin[ic] = (2./3.)*nui[alt]*k*u0*cos(chi[ic])* $
   ((wci/nui[alt])*(u0/vti)^2*sin(chi[ic])*cos(chi[ic]) - 1)/ $
   (nui[alt]^2 + (k*u0*cos(chi[ic]))^2)

wce = abs(moments.dist0.wc)
me = params.md0
te = 300.
vte = sqrt(kb*te/me)
psi = nue[alt]*nui[alt]/(wce*wci)
den = 3.3e-3

im_ten = fltarr(nc)
for ic=0,nc-1 do $
   im_ten[ic] = k*u0*psi*cos(chi[ic])* $
   (2*psi*(ti*wci/te)*(u0/vte)^2*sin(chi[ic])*cos(chi[ic]) - (1+psi)*den*nue[alt])/ $
   (((1+psi)*den*nue[alt])^2 + (k*u0*psi*cos(chi[ic]))^2)

plot, chi/!dtor,atan(im_tin,re_tin)/!dtor,xstyle=1,psym=4, $
      xtitle='chi [deg.]',ytitle='arg(T/n) [deg.]'
