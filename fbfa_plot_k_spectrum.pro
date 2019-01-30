;+
; Flow angle paper: Read k spectrum from a save file and make plots or
; movies.
;-

;;==Declare which file to restore
savename = 'den1-k_spectrum-kpar_4pnt_mean.sav'
savepath = expand_path(path)+path_sep()+savename
movpath = build_filename(strip_extension(savename),'.mp4', $
                         path = expand_path(path)+path_sep()+'movies', $
                         additions = '')

;;==Restore the data
sys_t0 = systime(1)
restore, filename=savepath,/verbose
sys_tf = systime(1)
print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60.

;;==Create a video
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

end
