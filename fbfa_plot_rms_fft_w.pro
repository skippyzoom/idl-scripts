;+
; Flow angle project: Plot simulation output after computing the RMS
; in space and the FFT in time.
;-

;;==Declare all dimensions
alldims = ['2D','3D']
ndims_all = n_elements(alldims)

;;==Compute positions
edges = [0.2,0.1,0.8,0.9]
buffers = [0.0,0.0]
position = multi_position([2,3], $
                          edges = edges, $
                          buffers = [0.0,0.0])

;;==Set boolean to reuse plot frame
current_frm = 0B

;;==Determine number of plot frames
n_frames = n_elements(ydata)

;;==Declare a frame counter
ip = 0

;;==Determine numbers of rows and columns
n_cols = ndims_all
n_rows = n_frames/n_cols

;;==Set short name for run labels
names = ['107 km', '110 km', '113 km']
names = reverse(names)

;;==Loop over columns
for ic=0,n_cols-1 do begin

   ;;==Choose 2-D or 3-D data sets
   simdims = alldims[ic]

   ;;==Loop over rows
   for ir=0,n_rows-1 do begin

      ;;==Declare current position array
      current_pos = position[*,ic + ir*n_cols]

      ;;==Check if this is the bottom row
      row_is_bottom = (current_pos[1] eq min(position[1,*]))

      ;;==Check if this is the left column
      col_is_left = (current_pos[0] eq min(position[0,*]))

      ;;==Set up data
      nt = n_elements(xdata[0,0])
      xtmp = xdata[ip]
      xtmp = xtmp[nt/2+1:*]
      ytmp = ydata[ip]
      ytmp = ytmp[nt/2+1:*]
      ytmp = 10*alog10(abs(ytmp)^2)

      ;;==Create a frame of amplitude versus time
      frm = plot(xtmp, $
                 ytmp, $
                 position = current_pos, $
                 xstyle = 1, $
                 ystyle = 1, $
                 /xlog, $
                 xrange = [1e0,1e4], $
                 yrange = [-80,10], $
                 xtitle = 'f [Hz]', $
                 current = current_frm, $
                 font_name = 'Times', $
                 xtickfont_size = 12.0, $
                 ytickfont_size = 12.0, $
                 font_size = 14.0, $
                 /buffer)
      current_frm = 1B
      ax = frm.axes
      ax[0].showtext = row_is_bottom
      ax[1].showtext = col_is_left

      ;;==Print altitude on each panel
      txt = text(current_pos[2]-0.02, $
                 current_pos[3]-0.02, $
                 names[ir], $
                 /normal, $
                 alignment = 1.0, $
                 vertical_alignment = 1.0, $
                 target = frm, $
                 font_name = 'Times', $
                 font_size = 12.0)

      ;;==Update panel index
      ip++

   endfor ;;n_paths

   ;;==Print dimensions above each column
   txt = text(0.5*(current_pos[0]+current_pos[2]), $
              edges[3]+0.01, $
              simdims, $
              /normal, $
              alignment = 0.5, $
              target = frm, $
              font_name = 'Times', $
              font_size = 12.0)

endfor ;;ndims_all

;;==Print a common y-axis title
txt = text(edges[0]-0.07, $
           0.5*(edges[0]+edges[2]), $
          '$\langle|\delta E/E_0|^2\rangle$', $
           /normal, $
           alignment = 0.5, $
           baseline = [0,1,0], $
           updir = [-1,0,0], $
           target = frm, $
           font_name = 'Times', $
           font_size = 12.0)

;;==Declare the graphics file name
frmpath = get_base_dir()+path_sep()+ $
          'fb_flow_angle'+path_sep()+'common'+ $
          path_sep()+'frames'+path_sep()+ $
          'efield-rocket.pdf'

;;==Save graphics frame
frame_save, frm,filename = frmpath

end

