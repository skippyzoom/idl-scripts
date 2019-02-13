;+
; Flow angle paper: Read k spectrum from a save file and make plots or
; movies.
;-

;;==Declare which file to restore
savename = params.ndim_space eq 3 ? $
           'den1-k_spectrum-kpar_4pnt_mean.sav' : $
           'den1-k_spectrum.sav'
savepath = expand_path(path)+path_sep()+savename

;;==Restore the data
sys_t0 = systime(1)
restore, filename=savepath,/verbose
sys_tf = systime(1)
print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60.

;;==Create a video of amplitude versus k
if 0 then begin                 ;SKIP
movpath = build_filename(strip_extension(savename),'.mp4', $
                         path = expand_path(path)+path_sep()+'movies', $
                         additions = '')
sys_t0 = systime(1)
r = video(2*!pi/lambda,spectrum,'ko', $
          ;; xrange = [0,128], $
          ;; yrange = [0,2.5e-3], $
          ;; xrange = [128,256], $
          yrange = [1e-6,1e-2], $
          ;; yrange = [1e-6,1e-4], $
          xstyle = 1, $
          /xlog, $
          /ylog, $
          resize = [4,4], $
          xtitle = 'k [m$^{-1}$]', $
          ytitle = 'A(k)', $
          title = "t = "+time.stamp, $
          text = dictionary('xyz',[0,0], $
                            'string',savepath, $
                            'font_name','Courier', $
                            'font_size',6), $
          filename = movpath)
sys_tf = systime(1)
print, "Elapsed minutes for video: ",(sys_tf-sys_t0)/60.
endif

;;==Create a frame of amplitude versus k at select times
if 0 then begin                 ;SKIP
case params.ndim_space of
   2: t_ind = [find_closest(float(time.stamp),13.44*8), $
               find_closest(float(time.stamp),23.3*8), $
               find_closest(float(time.stamp),34.05*8), $
               find_closest(float(time.stamp),44.80*8), $
               time.nt-1]
   3: t_ind = [find_closest(float(time.stamp),13.44), $
               find_closest(float(time.stamp),23.30), $
               find_closest(float(time.stamp),34.05), $
               find_closest(float(time.stamp),44.80), $
               time.nt-1]
endcase
n_inds = n_elements(t_ind)            
t_ind = reverse(t_ind)
color = ['black','blue','gray','green','red']

frmpath = build_filename(strip_extension(savename),'.pdf', $
                         path = expand_path(path)+path_sep()+'frames', $
                         additions = '')
sys_t0 = systime(1)
for it=0,n_inds-1 do begin
   frm = plot(2*!pi/lambda,spectrum[*,t_ind[it]], $
              yrange = [1e-6,1e-2], $
              xstyle = 1, $
              /xlog, $
              /ylog, $
              xtitle = 'k [m$^{-1}$]', $
              ytitle = 'A(k)', $
              color = color[it], $
              symbol = 'o', $
              sym_size = 0.5, $
              /sym_filled, $
              overplot = (it gt 0), $
              /buffer)
   yrange = frm.yrange
   txt = text(0.9,0.8-it*0.05, $
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
endif

;;==Create a frame of amplitude versus time at select k values
il0 = [0, $
       find_closest(lambda,1.0), $
       find_closest(lambda,4.0), $
       find_closest(lambda,10.0)]
       
ilf = [find_closest(lambda,1.0), $
       find_closest(lambda,4.0), $
       find_closest(lambda,10.0), $
       n_elements(lambda)]
n_bands = n_elements(il0)
;; name = ['submeter','meter','intermediate','decameter']
name = ['$\lambda$ $<$ 1 m', $
        '1 m $\leq$ $\lambda$ $<$ 4 m', $
        '4 m $\leq$ $\lambda$ $<$ 10 m', $
        '10 m $\leq$ $\lambda$']
color = ['black','blue','green','red']
txt_y = params.ndim_space eq 2 ? 0.2 : 0.6
frmpath = build_filename(strip_extension(savename),'.pdf', $
                         path = expand_path(path)+path_sep()+'frames', $
                         additions = 'bands')
sys_t0 = systime(1)
for ib=0,n_bands-1 do begin
   frm = plot(float(time.stamp), $
              rms(spectrum[il0[ib]:ilf[ib]-1,*],dim=1), $
              xstyle = 1, $
              /ylog, $
              yrange = [1e-6,1e-2], $
              xtitle = 'Time ['+time.unit+']', $
              ytitle = 'A(k)', $
              ;; name = name[ib], $
              color = color[ib], $
              overplot = (ib gt 0), $
              /buffer)
   txt = text(0.32,txt_y+ib*0.05, $
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
