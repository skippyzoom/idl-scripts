;+
; Plot data from MSIS and IRI on the same axes.
;-

;;==Declare base directory
base_dir = '~'+path_sep()+'MSIS_IRI_plots'+path_sep()
base_dir = expand_path(base_dir)

;;==Declare the data directory (read)
data_dir = base_dir+path_sep()+'data'

;;==Declare plot directory (write)
plot_dir = base_dir+path_sep()+'frames'

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Set up data hash
template = dictionary(['file_name','n_lines','n_head','n_data'])
data = hash('iri',template[*],'msis',template[*])

;;==Declare file parameters (see data file names for options and format)
lat = '00'                      ;Latitude
time = '1200LT'                 ;Time of day (including UT or LT)

;;==Assign IRI parameters
data['iri'].file_name = 'iri2016-lat'+lat+'-'+time+'-0060-1000-02.lst'
data['iri'].path = data_dir+path_sep()+ $
                   data['iri'].file_name
data['iri'].n_lines = file_lines(data['iri'].path)
data['iri'].n_head = 0

;;==Assign MSIS parameters
data['msis'].file_name = 'nrlmsise-lat'+lat+'-'+time+'-0000_1000_02.lst'
data['msis'].path = data_dir+path_sep()+ $
                    data['msis'].file_name
data['msis'].n_lines = file_lines(data['msis'].path)
data['msis'].n_head = 36

;;==Read data
for ik=0,data.count()-1 do $
   data[(data.keys())[ik]].values = $
   read_coltxt(data[(data.keys())[ik]].path, $
               head_length = data[(data.keys())[ik]].n_head)

;;==Plot neutral composition
id = [1,2,3,5,6,7,8]
n_plots = n_elements(id)
loadct, 4,rgb_table=ct
filename = plot_dir+path_sep()+ $
           'msis_composition'+ $
           '-lat'+lat+ $
           '.'+get_extension(frame_type)
for ip=0,n_plots-1 do $
   frm = plot(data['msis'].values[*,id[ip]]*1e3, $
              data['msis'].values[*,0], $
              xrange = [1,1e23], $
              /xlog, $
              xtitle = 'Number density [$m^{-3}$]', $
              ytitle = 'Height [km]', $
              linestyle = 'dot', $
              color = transpose(ct[ip*255/(n_plots-1),*]), $
              background_color = 'light gray', $
              position = [0.2,0.2,0.8,0.8], $
              font_name = 'Times', $
              font_size = 14, $
              name = strcompress(id[ip]), $
              overplot = (ip gt 0), $
              /buffer)
leg = legend(/auto_text_color, $
             position = [0.5,0.9], $
             sample_width = 0.1, $
             vertical_alignment = 'bottom', $
             horizontal_alignment = 'center', $
             orientation = 1)
txt = text(0.0,0.02, $
           data['msis'].path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10)
frame_save, frm,filename=filename

;;==Plot ion composition
id = [1,5,6,7,8,9,10,11]
n_plots = n_elements(id)
loadct, 4,rgb_table=ct
filename = plot_dir+path_sep()+ $
           'iri_composition'+ $
           '-lat'+lat+ $
           '.'+get_extension(frame_type)
ip = 0
frm = plot(data['iri'].values[*,1], $
           data['iri'].values[*,0], $
           xrange = [1e7,1e13], $
           /xlog, $
           xtitle = 'Number density [$m^{-3}$]', $
           ytitle = 'Height [km]', $
           linestyle = 'dot', $
           color = transpose(ct[ip,*]), $
           background_color = 'light gray', $
           position = [0.2,0.2,0.8,0.8], $
           font_name = 'Times', $
           font_size = 14, $
           name = strcompress(id[ip]), $
           /buffer)
for ip=1,n_plots-1 do $
   frm = plot(data['iri'].values[*,id[ip]]*data['iri'].values[*,1]*1e-2, $
              data['iri'].values[*,0], $
              linestyle = 'dot', $
              color = transpose(ct[ip*255/(n_plots-1),*]), $
              name = strcompress(id[ip]), $
              /overplot)
leg = legend(/auto_text_color, $
             position = [0.5,0.9], $
             sample_width = 0.1, $
             vertical_alignment = 'bottom', $
             horizontal_alignment = 'center', $
             orientation = 1)
txt = text(0.0,0.02, $
           data['iri'].path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10)
frame_save, frm,filename=filename

;;==Plot total electron density
filename = plot_dir+path_sep()+ $
           'electron_density'+ $
           '-lat'+lat+ $
           '.'+get_extension(frame_type)
ip = 0
frm = plot(data['iri'].values[*,1], $
           data['iri'].values[*,0], $
           xrange = [1e8,1e13], $
           /xlog, $
           xtitle = '$n_e$ [$m^{-3}$]', $
           ytitle = 'Height [km]', $
           position = [0.2,0.2,0.8,0.8], $
           font_name = 'Times', $
           font_size = 14, $
           /buffer)
txt = text(0.0,0.02, $
           data['iri'].path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10)
frame_save, frm,filename=filename

;;==Plot all temperatures
filename = plot_dir+path_sep()+ $
           'temperatures'+ $
           '-lat'+lat+ $
           '.'+get_extension(frame_type)
frm = plot(data['msis'].values[*,4], $
           data['msis'].values[*,0], $
           xrange = [1e2,5e3], $
           /xlog, $
           xtitle = 'Temperature [K]', $
           ytitle = 'Height [km]', $
           linestyle = 'dot', $
           color = 'black', $
           background_color = 'light gray', $
           position = [0.2,0.2,0.8,0.8], $
           font_name = 'Times', $
           font_size = 14, $
           name = 'n', $
           /buffer)
frm = plot(data['iri'].values[*,3], $
           data['iri'].values[*,0], $
           linestyle = 'dot', $
           color = 'blue', $
           name = 'i', $
           /overplot)
frm = plot(data['iri'].values[*,4], $
           data['iri'].values[*,0], $
           linestyle = 'dot', $
           color = 'green', $
           name = 'e', $
           /overplot)
leg = legend(/auto_text_color, $
             position = [0.5,0.9], $
             sample_width = 0.1, $
             vertical_alignment = 'bottom', $
             horizontal_alignment = 'center', $
             orientation = 1)
txt = text([0.0,0.0],[0.01,0.04], $
           [data['msis'].path,data['iri'].path], $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10)
frame_save, frm,filename=filename

;;==Plot only neutral temperature
filename = plot_dir+path_sep()+ $
           'neutral_temperature'+ $
           '-lat'+lat+ $
           '.'+get_extension(frame_type)
frm = plot(data['msis'].values[*,4], $
           data['msis'].values[*,0], $
           xrange = [1e2,2e3], $
           yrange = [0,600], $
           /xlog, $
           xtitle = '$T_n$ [K]', $
           ytitle = 'Height [km]', $
           position = [0.2,0.2,0.8,0.8], $
           font_name = 'Times', $
           font_size = 14, $
           /buffer)
txt = text([0.0,0.0],[0.01,0.04], $
           [data['msis'].path,data['iri'].path], $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10)
frame_save, frm,filename=filename
