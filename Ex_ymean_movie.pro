movie_type = '.mp4'

scale = 1e3

plot_kw = dictionary()
plot_kw['xstyle'] = 1
plot_kw['yrange'] = [-0.03,+0.03]*scale
plot_kw['color'] = 'black'
plot_kw['xtitle'] = 'Zonal [m]'
plot_kw['ytitle'] = '${\langle E_x \rangle}_y$ [mV/m]'
plot_kw['font_name'] = 'Times'
plot_kw['title'] = 'it = '+time.index

plot_kw['font_size'] = 24.0
Ex_ymean = mean(Ex,dim=2)
filename = expand_path(path+path_sep()+'movies')+ $
           path_sep()+'efield_x-y_mean'+ $
           '.'+get_extension(movie_type)
data_graphics, xdata,scale*Ex_ymean, $
               /make_movie, $
               plot_kw = plot_kw, $
               filename = filename
