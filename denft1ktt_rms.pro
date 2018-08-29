;+
; Script for making a plot of theta-RMS denft1(k,theta,t) from one run.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Get wavelengths
lambda = denft1ktt.keys()
lambda = lambda.sort()
nl = denft1ktt.count()

;;==Get number of time steps
nt = n_elements(time.index)

;;==Set up RMS array
f_rms = make_array(nt,/float,value=0)

;;==Loop over all wavelengths
for il=0,nl-1 do $
   f_rms += rms(denft1ktt[lambda[il]].f_interp,dim=1)

;;==Create plot frame
frm = plot(1e3*params.dt*time.index, $
           f_rms/f_rms[0], $
           xstyle = 1, $
           /ylog, $
           yrange = [1e0,1e4], $
           xtitle = 'Time [ms]', $
           ytitle = '$\delta n(k,t)/n_0$', $
           title = lambda[0]+' m < $\lambda$ < '+lambda[nl-1]+' m', $
           font_name = 'Times', $
           font_size = 14.0, $
           /buffer)

;;==Add a path label
txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save frame
frame_save, frm, $
            filename = expand_path(path+path_sep()+'frames')+ $
            path_sep()+'denft1ktt_rms.pdf'
