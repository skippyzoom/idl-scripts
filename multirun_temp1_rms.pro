;+
; Script for plotting RMS of ion temperature for multiple runs on the
; same axes.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Declare project path
proj_path = get_base_dir()+path_sep()+'parametric_wave/'

;;==Declare name of save file
save_name = 'temp1.sav'

;;==Declare runs
str_amp = '0.10'
run = ['nue_3.0e4-amp_'+str_amp+'-E0_9.0-petsc_subcomm/', $
       'nue_4.0e4-amp_'+str_amp+'-E0_9.0-petsc_subcomm/', $
       'nue_5.0e4-amp_'+str_amp+'-E0_9.0-petsc_subcomm/', $
       'nue_6.0e4-amp_'+str_amp+'-E0_9.0-petsc_subcomm/']
nr = n_elements(run)

;;==Build the full multi-run hash
mr_temp1 = build_multirun_hash(proj_path, $
                               run, $
                               save_name, $
                               data_name)


;;==Get the number of time steps
time = mr_temp1[run[0]].time
nt = n_elements(time.index)

;;==Get dimensions of data
fsize = size(mr_temp1[run[0]].temp1)
nx = fsize[1]
ny = fsize[2]

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Declare plot path
plot_path = expand_path(proj_path)+path_sep()+'common'

;;==Declare plot file name
filename = expand_path(plot_path)+path_sep()+'frames'+ $
           path_sep()+'mr_temp1_rms'+ $
           '-amp_'+str_amp+ $
           '.'+get_extension(frame_type)

;;==Declare line colors
color = ['blue','green','black','red']

;;==Declare spatial RMS ranges (crest)
x0 = nx/4-128
xf = nx/4+128
y0 = ny/2-128
yf = ny/2+128

;;==Build the multi-run RMS array
mr_rms = build_multirun_spatial_rms(mr_temp1, $
                                    'temp1', $
                                    run=run, $
                                    ranges=[x0,xf,y0,yf])

;;==Create frame
for ir=0,nr-1 do $
   frm = plot(float(time.stamp), $
              mr_rms[*,ir], $
              color = color[ir], $
              linestyle = 0, $
              xstyle = 1, $
              yrange = [600,700], $
              xtitle = 'Time [ms]', $
              ytitle = 'Temperature [K]', $
              font_name = 'Times', $
              overplot = (ir gt 0), $
              /buffer)

;;==Declare spatial RMS ranges (trough)
x0 = 3*nx/4-128
xf = 3*nx/4+128
y0 = ny/2-128
yf = ny/2+128

;;==Build the multi-run RMS array
mr_rms = build_multirun_spatial_rms(mr_temp1, $
                                    'temp1', $
                                    run=run, $
                                    ranges=[x0,xf,y0,yf])

;;==Update frame
for ir=0,nr-1 do $
   !NULL = plot(float(time.stamp), $
                mr_rms[*,ir], $
                color = color[ir], $
                linestyle = 1, $
                /overplot)

;;==Add a path label
txt = text(0.0,0.005, $
           proj_path+'(petsc_subcomm)', $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)
;;==Add save-file label
txt = text(0.0,0.955, $
           'original file: '+save_name, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

;;==Save individual images
frame_save, frm,filename=filename
