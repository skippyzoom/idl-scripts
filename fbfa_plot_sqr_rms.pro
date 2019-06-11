;+
; Flow angle project: Plot the arrays build by
; fbfa_build_rms_sqr.pro. These two routines are separate to allow for
; adjusting graphics without reading data from memory every time.
;-

;;==Declare plot name and type
plotname = 'den1-sqr_rms'
plottype = 'png'

;;==Declare all dimensions
alldims = ['2D','3D']
ndims_all = n_elements(alldims)

;;==Compute positions
edges = [0.15,0.3,0.9,0.9]
position = multi_position([2,1], $
                          edges = edges, $
                          buffers = [0.0,0.0])

;;==Set color preferences
colors = ['blue','green','red']

;;==Set short name for run labels
names = ['107 km', '110 km', '113 km']

;;==Loop over dimension sets
for id=0,ndims_all-1 do begin

   ;;==Choose 2-D or 3-D data sets
   simdims = alldims[id]

   ;;==Declare current position array
   current_pos = position[*,id]

   ;;==Loop over all paths to create plots
   for ip=0,n_paths-1 do begin

      ;;==Create a frame of amplitude versus time
      frm = plot(xdata[ip + n_paths*id], $
                 ydata[ip + n_paths*id], $
                 position = current_pos, $
                 xstyle = 1, $
                 /ylog, $
                 yrange = [1e-4,1e-1], $
                 ytickname = ['$10^{-4}$', '$10^{-3}$', $
                              '$10^{-2}$', '$10^{-1}$'], $
                 xtitle = 'Time ['+time.unit+']', $
                 ytitle = '$\langle|\delta n/n_0|^2\rangle$', $
                 color = colors[ip], $
                 overplot = (ip gt 0), $
                 current = (id gt 0), $
                 font_name = 'Times', $
                 xtickfont_size = 12.0, $
                 ytickfont_size = 12.0, $
                 font_size = 14.0, $
                 /buffer)
      ax = frm.axes
      ax[1].showtext = (id eq 0)

      ;;==Print altitudes on each panel
      txt = text(0.2*current_pos[0] + 0.8*current_pos[2], $
                 current_pos[1] + 0.03 + 0.03*ip, $
                 names[ip], $
                 color = colors[ip], $
                 /normal, $
                 alignment = 0.5, $
                 target = frm, $
                 font_name = 'Times', $
                 font_size = 12.0)

   endfor ;;n_paths

   ;;==Print dimensions on each panel
   txt = text(0.5*(current_pos[0]+current_pos[2]), $
              current_pos[3]-0.05, $
              simdims, $
              /normal, $
              alignment = 0.5, $
              target = frm, $
              font_name = 'Times', $
              font_size = 12.0)

endfor ;;ndims_all

;;==Declare the graphics file name
frmpath = get_base_dir()+path_sep()+ $
          'fb_flow_angle'+path_sep()+'common'+ $
          path_sep()+'frames'+path_sep()+ $
          plotname+'.'+plottype

;;==Save graphics frame
frame_save, frm,filename = frmpath

end

