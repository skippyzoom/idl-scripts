;+
; Flow angle paper: Read k spectrum from a save file and make a plot
; of amplitude in certain k-bands versus time.
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

;;==Choose wavelength bands.
;;  The '-1' term in most bands separates adjacent bands, to avoid
;;  doulble counting. It is distict from the '-1' in the FOR loop,
;;  which exists purely for proper indexing. 
;;----------------------------------------------------------------
;; il = [[0,find_closest(lambda,1.0)-1], $
;;       [find_closest(lambda,1.0),find_closest(lambda,3.0)-1], $
;;       [find_closest(lambda,3.0),find_closest(lambda,6.0)-1], $
;;       [find_closest(lambda,6.0),find_closest(lambda,10.0)-1], $
;;       [find_closest(lambda,10.0),n_elements(lambda)]]
;; name = ['$\lambda$ $<$ 1 m', $
;;         '1 m $\leq$ $\lambda$ $<$ 3 m', $
;;         '3 m $\leq$ $\lambda$ $<$ 6 m', $
;;         '6 m $\leq$ $\lambda$ $<$ 10 m', $
;;         '10 m $\leq$ $\lambda$']
;; color = ['black','blue','sky blue','green','red']
;; il = [[0,find_closest(lambda,1.0)-1], $
;;       [find_closest(lambda,1.0),find_closest(lambda,5.0)-1], $
;;       [find_closest(lambda,5.0),find_closest(lambda,10.0)-1], $
;;       [find_closest(lambda,10.0),n_elements(lambda)]]
;; name = ['$\lambda$ $<$ 1 m', $
;;         '1 m $\leq$ $\lambda$ $<$ 5 m', $
;;         '5 m $\leq$ $\lambda$ $<$ 10 m', $
;;         '10 m $\leq$ $\lambda$']
;; color = ['black','blue','green','red']
il = [[0,find_closest(lambda,1.0)-1], $
      [find_closest(lambda,1.0),find_closest(lambda,5.0)-1], $
      [find_closest(lambda,5.0),n_elements(lambda)]]
name = ['$\lambda$ $<$ 1 m', $
        '1 m $\leq$ $\lambda$ $<$ 5 m', $
        '5 m $\leq$ $\lambda$']
color = ['black','blue','green']
ilsize = size(il)
n_bands = ilsize[2]
txt_x = 0.31
;; txt_y = params.ndim_space eq 2 ? 0.2 : 0.6
txt_y = 0.70
frmpath = build_filename(strip_extension(savename),'.pdf', $
                         path = expand_path(path)+path_sep()+'frames', $
                         additions = 'bands')
sys_t0 = systime(1)
for ib=0,n_bands-1 do begin
   frm = plot(float(time.stamp), $
              rms(spectrum[il[0,ib]:il[1,ib]-1,*],dim=1), $
              xstyle = 1, $
              /ylog, $
              ;; yrange = [1e-6,1e-2], $
              yrange = [1e0,1e4], $
              ;; yrange = [1e0,1e6], $
              xtitle = 'Time ['+time.unit+']', $
              ytitle = 'A(k)', $
              ;; name = name[ib], $
              color = color[ib], $
              overplot = (ib gt 0), $
              /buffer)
   txt = text(0.32,txt_y+ib*0.03, $
              name[ib], $
              color = color[ib], $
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
