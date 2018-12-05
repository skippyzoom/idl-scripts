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
data['iri'].file_name = 'iri2016-lat'+lat+'-'+time+'-0060_1000_02.lst'
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
;;  From MSIS_IRI_plots/data/nrlmsise-info.txt
;;  0: Height, km
;;  1: O, cm-3 
;;  2: N2, cm-3
;;  3: O2, cm-3
;;  4: Temperature_neutral, K
;;  5: He, cm-3 
;;  6: Ar, cm-3
;;  7: H, cm-3
;;  8: N, cm-3
id = [1,2,3,5,6,7,8]
color = ['red','blue','green','magenta','cyan','orange','yellow']
n_plots = n_elements(id)
loadct, 4,rgb_table=ct
filename = build_filename('msis_composition',frame_type, $
                          additions = ['lat'+lat, $
                                       ;; 'log_log', $
                                       '060_150_km'], $
                          path = plot_dir)
for ip=0,n_plots-1 do $
   frm = plot(data['msis'].values[*,id[ip]]*1e3, $
              data['msis'].values[*,0], $
              ;; xrange = [1e0,1e23], $
              ;; yrange = [1e0,1e3], $
              xrange = [1e0,1e20], $
              yrange = [60,150], $
              /xlog, $
              ;; /ylog, $
              xtitle = 'Number density [$m^{-3}$]', $
              ytitle = 'Height [km]', $
              ;; linestyle = 'dot', $
              linestyle = 'solid_line', $
              ;; color = transpose(ct[ip*255/(n_plots-1),*]), $
              color = color[ip], $
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
;;  From MSIS_IRI_plots/data/iri2016-info.txt:
;;  0: Height, km
;;  1: Electron_density_Ne, m-3
;;  2: Tn, K
;;  3: Ti, K
;;  4: Te, K
;;  5: O_ions, %
;;  6: H_ions, %
;;  7: He_ions, %
;;  8: O2_ions, %
;;  9: NO_ions, %
;;  10: Cluster_ions, %
;;  11: N_ions, %
id = [1,5,6,7,8,9,11]
color = ['black','red','orange','cyan','green','blue','yellow']
n_plots = n_elements(id)
linestyle = make_array(n_plots,/string,value='solid_line')
linestyle[0] = 'dot'
;; loadct, 4,rgb_table=ct
filename = build_filename('iri_composition',frame_type, $
                          additions = ['lat'+lat, $
                                       ;; 'log_log', $
                                       '060_150_km'], $
                          path = plot_dir)
ip = 0
frm = plot(data['iri'].values[*,1], $
           data['iri'].values[*,0], $
           ;; xrange = [1e7,1e13], $
           ;; yrange = [1e0,1e3], $
           xrange = [1e7,1e12], $
           yrange = [60,150], $
           /xlog, $
           ;; /ylog, $
           xtitle = 'Number density [$m^{-3}$]', $
           ytitle = 'Height [km]', $
           ;; linestyle = 'dot', $
           ;; linestyle = 'solid_line', $
           linestyle = linestyle[ip], $
           ;; color = transpose(ct[ip,*]), $
           color = color[ip], $
           background_color = 'light gray', $
           position = [0.2,0.2,0.8,0.8], $
           font_name = 'Times', $
           font_size = 14, $
           name = strcompress(id[ip]), $
           /buffer)
for ip=1,n_plots-1 do $
   frm = plot(data['iri'].values[*,id[ip]]*data['iri'].values[*,1]*1e-2, $
              data['iri'].values[*,0], $
              ;; linestyle = 'dot', $
              ;; linestyle = 'solid_line', $
              linestyle = linestyle[ip], $
              ;; color = transpose(ct[ip*255/(n_plots-1),*]), $
              color = color[ip], $
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
filename = build_filename('electron_density',frame_type, $
                          additions = ['lat'+lat, $
                                       'log_log'], $
                          path = plot_dir)
ip = 0
frm = plot(data['iri'].values[*,1], $
           data['iri'].values[*,0], $
           xrange = [1e8,1e13], $
           yrange = [1e0,1e3], $
           /xlog, $
           /ylog, $
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
filename = build_filename('temperatures',frame_type, $
                          additions = ['lat'+lat, $
                                       'log_log'], $
                          path = plot_dir)
frm = plot(data['msis'].values[*,4], $
           data['msis'].values[*,0], $
           xrange = [1e2,5e3], $
           yrange = [1e0,1e3], $
           /xlog, $
           /ylog, $
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
filename = build_filename('neutral_temperature',frame_type, $
                          additions = ['lat'+lat, $
                                       'log_log'], $
                          path = plot_dir)
frm = plot(data['msis'].values[*,4], $
           data['msis'].values[*,0], $
           xrange = [1e2,2e3], $
           ;; yrange = [0,600], $
           yrange = [1e0,1e3], $
           /xlog, $
           /ylog, $
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
