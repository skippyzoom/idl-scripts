;+
; Flow angle paper: Read k spectrum from a save file and make plots or
; movies.
;-

dataname = 'den1'
savename = dataname+'-k_spectrum.sav'
savepath = expand_path(path)+path_sep()+savename
restore, filename=savepath,/verbose

movpath = build_filename(strip_extension(savename),'.mp4', $
                         path = expand_path(path)+path_sep()+'movies', $
                         additions = '')
r = video(2*!pi/lambda,spectrum,'ko', $
          ;; xrange = [0,128], $
          ;; yrange = [0,2.5e-3], $
          ;; xrange = [128,256], $
          xstyle = 1, $
          yrange = [1e-6,1e-2], $
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

end
