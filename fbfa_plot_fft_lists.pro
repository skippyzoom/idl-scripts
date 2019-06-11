;+
; Flow angle project: Plot FFTs of simulation output saved as lists
; (see, for example, fbfa_build_rocket_spectrum.pro).
;-

;;==Declare all dimensions
alldims = ['2D','3D']
ndims_all = n_elements(alldims)

;;==Compute positions
edges = [0.2,0.1,0.7,0.9]
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
      nt = n_elements(xdata[ip])
      xtmp = xdata[ip]
      xtmp = xtmp[nt/2+1:*]
      ytmp = ydata[ip]
      ytmp = ytmp[nt/2+1:*]
      ytmp = abs(ytmp)^2
      ;; fx0 = [20,300]
      ;; fx1 = [200,1000]
      ;; fcolors = ['red', 'gray']
      fx0 = 20
      fx1 = 200
      fcolors = ['red']
      nfx = n_elements(fx0)
      ifx0 = find_closest(xtmp,fx0)
      ifx1 = find_closest(xtmp,fx1)
      fitx = list()
      fity = list()
      fitc = list()
      yfit = list()
      fsig = list()
      for ix=0,nfx-1 do begin
         fitx.add, alog10(xtmp[ifx0[ix]:ifx1[ix]])
         fity.add, alog10(ytmp[ifx0[ix]:ifx1[ix]])
         fitc.add, linfit(fitx[ix],fity[ix],yfit=ftmp, $
                       sigma=sigma,chisqr=chisqr,prob=prob)
         fsig.add, sigma
         yfit.add, ftmp
         print, "(A,B) = ",fitc
         print, "SIGMA = ",sigma
         print, "CHISQR = ",chisqr
         print, "PROB = ",prob
      endfor
      ytmp = 10*alog10(ytmp)

      ;;==Create a frame of amplitude versus time
      frm = plot(xtmp, $
                 ytmp, $
                 position = current_pos, $
                 xstyle = 1, $
                 ystyle = 1, $
                 /xlog, $
                 xrange = [1e0,1e4], $
                 xtickname = [" ", "$10^{1}$", "$10^{2}$", $
                              "$10^{3}$", "$10^{4}$"], $
                 yrange = [-80,10], $
                 xtitle = 'f [Hz]', $
                 current = current_frm, $
                 font_name = 'Times', $
                 symbol = 'dot', $
                 linestyle = 'None', $
                 xtickfont_size = 12.0, $
                 ytickfont_size = 12.0, $
                 font_size = 14.0, $
                 /buffer)
      for ix=0,nfx-1 do begin
         opl = plot(10^fitx[ix], $
                    10*yfit[ix], $
                    color = fcolors[ix], $
                    thick = 1, $
                    /overplot)
         slope_str = string(fitc[ix,1],format='(f6.1)')
         slope_str = strcompress(slope_str,/remove_all)
         slope_str += "$\pm$ "+string(fsig[ix,1],format='(f3.1)')
         txt = text(current_pos[2]-0.11, $
                    current_pos[3]-0.10, $
                    slope_str, $
                    /normal, $
                    color = fcolors[ix], $
                    font_name = 'Times', $
                    target = frm)
      endfor
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

