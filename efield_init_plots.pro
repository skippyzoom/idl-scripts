;+
; Create plots of initial total E from an EPPIC run
;
; This script assumes that the user has called @get_efield_plane.pro
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

if n_elements(Ex0) eq 0 then Ex0 = 0.0
if n_elements(Ey0) eq 0 then Ey0 = 0.0
if n_elements(Ex0) eq 1 then Ex0 = Ex + Ex0
if n_elements(Ey0) eq 1 then Ey0 = Ey + Ey0

sw = 10.0/dx
if n_elements(Et0) eq 0 then $
   Et0 = atan(smooth(Ey0,[sw,sw,0],/edge_wrap), $
              smooth(Ex0,[sw,sw,0],/edge_wrap))
if n_elements(Er0) eq 0 then $
   Er0 = sqrt(smooth(Ex0,[sw,sw,0],/edge_wrap)^2 + $
              smooth(Ey0,[sw,sw,0],/edge_wrap)^2)

pos = multi_position([1,2], $
                     edges = [0.1,0.1,1.0,0.9], $
                     buffers = [0,0.05])
it0 = 1

;;==Create two stacked plot frames
plt = plot(xdata,mean(Er0[*,*,it0],dim=2)*1e3, $
           xstyle = 1, $
           xtitle = 'Zonal Distance [m]', $
           xshowtext = 0, $
           ystyle = 1, $
           yrange = [0,40], $
           ytitle = '$|E_{total}|$ [mV/m]', $
           position = pos[*,0], $
           font_name = 'Times', $
           font_size = 14, $
           /buffer)
plt = plot(xdata,mean(Et0[*,*,it0],dim=2)/!dtor, $
           xstyle = 1, $
           xtitle = 'Zonal Distance [m]', $
           ystyle = 1, $
           yrange = [0,180], $
           ytitle = '$tan^{-1}(E_{total})$ [deg.]', $
           position = pos[*,1], $
           font_name = 'Times', $
           font_size = 14, $
           /current)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'Ert_init_stack.pdf'
frame_save, plt,filename=filename

;;==Create two overplotted frames
plt = plot(xdata,mean(Er0[*,*,it0],dim=2)*1e3, $
           axis_style = 1, $
           xstyle = 1, $
           xtitle = 'Zonal Distance [m]', $
           xmajor = 5, $
           xminor = 3, $
           ystyle = 1, $
           yrange = [0,40], $
           ytitle = '$|E_{total}|$ [mV/m]', $
           position = [0.1,0.1,0.8,0.9], $
           font_name = 'Times', $
           font_size = 14, $
           /buffer)
ymax = (plt.yrange)[1]
opl = plot(xdata,(ymax/180.0)*mean(Et0[*,*,it0],dim=2)/!dtor, $
           color = 'blue', $           
           /overplot)
yax = axis('y', $
           target = opl, $
           color = 'blue', $           
           major = 7, $
           minor = 2, $
           coord_transform = [0,180.0/ymax], $
           location = 'right', $
           title = '$tan^{-1}(E_{total})$ [deg.]', $
           axis_range = [0,180], $
           tickfont_name = 'Times', $
           tickfont_size = 14)
filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'Ert_init_overplot.pdf'
frame_save, plt,filename=filename
