;+
; Flow angle project: Plot squared RMS amplitude over time directly
; from the 2-D or pseudo 2-D complex FFT. This is a more robust an
; alternative to scripts that plot the interpolated FFT for all
; wavelengths. 
;
; Created by Matt Young
;-

;;==Set up path parameters.
basepath = '$SCRATCH/fb_flow_angle/'
dataname = 'den1'
all_dims = ['2D','3D']
ndims_all = n_elements(all_dims)
altitudes = ['h0','h1','h2']
n_altitudes = n_elements(altitudes)
frmpath = get_base_dir()+path_sep()+ $
          'fb_flow_angle'+path_sep()+'common'+ $
          path_sep()+'frames'+path_sep()+ $
          dataname+'-cfft-sqr_rms.pdf'

;;==Declare plot colors.
colors = ['blue', 'green', 'red']

;;==Declare altitude labels.
labels = ['107 km', '110 km' ,'113 km']

;;==Declare boolean for using current frame.
use_current = 0B

;;==Loop over all dimension sets.
for id=0,ndims_all-1 do begin

   ;;==Declare project name
   project = all_dims[id]+'-new_coll/'

   ;;==Declare frame edges.
   width = 0.4
   buffer = 0.0
   height = 0.8
   left_edge = 0.1 + (buffer+width)*id
   bottom_edge = 0.1
   right_edge = left_edge + width
   top_edge = bottom_edge + height

   ;;==Loop over all altitudes.
   for ia=0,n_altitudes-1 do begin

      ;;==Declare simulation run name and.
      runname = altitudes[ia]+'-Ey0_050/'

      ;;==Build path to simulation run.
      runpath = basepath+path_sep()+project+path_sep()+runname

      ;;==Read run parameters.
      params = set_eppic_params(path=runpath)

      ;;==Declare IDL save file name.
      filename = params.ndim_space eq 3 ? $
                 'den1-cfft-kpar_full_mean.sav' : $
                 'den1-cfft.sav'

      ;;==Build path to IDL save file.
      filepath = runpath+path_sep()+filename
      filepath = expand_path(filepath)

      ;;==Restore the IDL save file.
      sys_t0 = systime(1)
      restore, filename=filepath,/verbose
      sys_tf = systime(1)
      print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60.

      ;;==Declare geometric parameters.
      nx = params.nx*params.nsubdomains/params.nout_avg
      ny = params.ny/params.nout_avg
      nz = params.nz/params.nout_avg
      nt = time.nt
      dx = params.dx*params.nout_avg
      dy = params.dy*params.nout_avg
      dz = params.dz*params.nout_avg
      dt = params.dt*params.nout
      lx = nx*dx
      ly = ny*dy
      lz = nz*dz

      ;;==Declare normalization factor.
      factor = 1.0
      factor = params.ndim_space eq 3 ? $
               double(nx)*nx*ny*nz : $
               double(nx)*ny
      factor = sqrt(factor)

      ;;==Build array for plotting.
      sqr_rms = fltarr(time.nt)
      for it=0,time.nt-1 do $
         sqr_rms[it] = rms(factor*abs(fftdata[*,*,it]))^2

      ;;==Create the frame or add plots.
      frm = plot(float(time.stamp), $
                 sqr_rms, $
                 axis_style = 2, $
                 xstyle=1, $
                 /ylog, $
                 position=[left_edge, $
                           bottom_edge, $
                           right_edge, $
                           top_edge], $
                 xtitle = 'Time ['+time.unit+']', $
                 yrange = [1e-4,1e-1], $
                 ytickname = ['$10^{-4}$', '$10^{-3}$', $
                              '$10^{-2}$', '$10^{-1}$'], $
                 ytitle = '$\langle|\delta n/n_0|^2\rangle$', $
                 color = colors[ia], $
                 font_name = 'Times', $
                 overplot = (ia gt 0), $
                 current = use_current, $
                 /buffer)
      use_current = 1B
      ax = frm.axes
      ax[1].showtext = (id eq 0)
      current_pos = frm.position

      ;;==Print altitudes on each panel.
      txt = text(0.2*current_pos[0] + 0.8*current_pos[2], $
                 current_pos[1] + 0.03 + 0.03*ia, $
                 labels[ia], $
                 color = colors[ia], $
                 /normal, $
                 alignment = 0.5, $
                 target = frm, $
                 font_name = 'Times', $
                 font_size = 12.0)

   endfor ;;n_altitudes

   ;;==Print dimensions on each panel
   txt = text(0.5*(current_pos[0]+current_pos[2]), $
              current_pos[3]-0.05, $
              all_dims[id], $
              /normal, $
              alignment = 0.5, $
              target = frm, $
              font_name = 'Times', $
              font_size = 12.0)

endfor ;;ndims_all

;;==Save the frame.
frame_save, frm,filename = frmpath
                          
end
