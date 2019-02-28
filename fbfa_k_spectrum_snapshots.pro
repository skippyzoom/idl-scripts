;+
; Flow angle paper: Read k spectrum from a save file and make a plot
; of amplitude versus k.
;-

;;==Read in parameter dictionary
params = set_eppic_params(path=path)

;;==Declare which file to restore
savename = params.ndim_space eq 3 ? $
           'den1-k_spectrum-kpar_4pnt_mean.sav' : $
           'den1-k_spectrum.sav'
savepath = expand_path(path)+path_sep()+savename

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

;;==Restore the data
sys_t0 = systime(1)
restore, filename=savepath,/verbose
sys_tf = systime(1)
print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60.

;;==Rescale spectrum by number of points
vol = long(nx)*long(ny)
if params.ndim_space eq 3 then begin
   str_kpar = strmid(savename,strpos(savename,'kpar')+5,4)
   case 1B of
      strcmp(str_kpar,'full'): vol *= long(nz)
      strcmp(str_kpar,'4pnt'): vol *= 4L
   endcase
endif
spectrum *= vol

t_ind = [find_closest(float(time.stamp),9.86*8), $
         find_closest(float(time.stamp),28.67*8), $
         find_closest(float(time.stamp),38.53*8), $
         time.nt-1]

n_inds = n_elements(t_ind)            
t_ind = reverse(t_ind)
color = ['green','blue','gray','black']
frmpath = build_filename(strip_extension(savename),'.pdf', $
                         path = expand_path(path)+path_sep()+'frames', $
                         additions = '')
sys_t0 = systime(1)
for it=0,n_inds-1 do begin
   frm = plot(2*!pi/lambda, $
              spectrum[*,t_ind[it]], $
              ;; yrange = [1e-6,1e-2], $
              yrange = [1e0,1e4], $
              xstyle = 1, $
              /xlog, $
              /ylog, $
              xtitle = 'k [m$^{-1}$]', $
              ;; ytitle = 'A(k)', $
              ytitle = '$\langle\delta n(k)\rangle$', $
              color = color[it], $
              symbol = 'o', $
              sym_size = 0.5, $
              /sym_filled, $
              overplot = (it gt 0), $
              /buffer)
   ply_dk = -3
   ply_k0 = 3.5
   ply_kf = 10^(-(1-ply_dk*alog10(ply_k0))/ply_dk)
   ply = polyline([ply_k0,ply_kf],[1e3,1e2], $
                  'k-', $
                  target = frm, $
                  /data)
   yrange = frm.yrange
   txt = text(0.85,0.8-it*0.05, $
              "t = "+time.stamp[t_ind[it]], $
              color = color[it], $
              /normal, $
              alignment = 1.0, $
              vertical_alignment = 0.0, $
              target = frm, $
              font_name = 'Courier', $
              font_size = 8)

endfor
txt = text(0.1,0,savepath, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 6)
frame_save, frm,filename = frmpath
sys_tf = systime(1)
print, "Elapsed minutes for frame: ",(sys_tf-sys_t0)/60.

end
