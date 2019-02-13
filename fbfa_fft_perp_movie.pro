;+
; Make movies of perpendicular or pseudo-perpendicular FFT
; spectrum. This script produces a logically (2+1)-D array: For 2-D
; runs, it uses the FFT of the simulation data; for 3-D runs, it
; computes the RMS over parallel modes within a specified range. This
; script saves the data to a file with the same name, regardless of
; parallel range or dimensions of input data. It is the user's
; responsibility to rename the resultant file in order the distinguish
; between, for example, different parallel RMS ranges. 
;
; Created by Matt Young.
;-

;;==Declare name of target data quantity
data_name = 'den1'

;;==Read in parameter dictionary
params = set_eppic_params(path=path)

;;==Build parameters
nx = params.nx*params.nsubdomains/params.nout_avg
ny = params.ny/params.nout_avg
nz = params.nz/params.nout_avg
nt = time_ref.nt
dx = params.dx*params.nout_avg
dy = params.dy*params.nout_avg
dz = params.dz*params.nout_avg
dt = params.dt*params.nout
dkx = 2*!pi/(dx*nx)
dky = 2*!pi/(dy*ny)
dkz = 2*!pi/(dz*nz)

;;==Declare RMS range parallel to B
i_kx0 = nx/2-2
i_kxf = nx/2+2
;; i_kx0 = 0
;; i_kxf = nx

;;==Declare time range
it0 = 0
itf = nt
itd = 2

;;==Get all file names
datapath = expand_path(path)+path_sep()+'parallel'
all_files = file_search(expand_path(datapath)+path_sep()+'parallel*.h5', $
                        count = n_files_all)

;;==Extract a subset based on time_ref.subsample
if time_ref.haskey('subsample') && time_ref.subsample gt 1 then $
   sub_files = all_files[time_ref.subsample*indgen(nt)] $
else $
   sub_files = all_files

;;==Count the new number of files
n_files_sub = n_elements(sub_files)

;;==Make sure there is the right number of files
if n_files_sub eq nt then begin

   ;;==Set graphics parameters
   npx = params.ndim_space eq 2 ? nx/2 : ny
   npy = params.ndim_space eq 2 ? ny/2 : nz
   xmajor = 5
   ymajor = 5
   xtickvalues = [0,npx/4,npx/2,3*npx/4,npx-1]
   ytickvalues = [0,npy/4,npy/2,3*npy/4,npy-1]
   xtickname = ['$-2\pi$','$-\pi$','0','$+\pi$','$+2\pi$']
   ytickname = ['$-2\pi$','$-\pi$','0','$+\pi$','$+2\pi$']
   xtitle = "$k_{Hall}$"
   ytitle = "$k_{Ped}$"
   xtickfont_size = 18
   ytickfont_size = 18
   font_name = 'Courier'
   font_size = 18
   axis_style = 2
   rgb_table = 39
   min_value = -20
   max_value = 0

   ;;==Set up movie
   video_path = expand_path(path)+path_sep()+'movies'+ $
                path_sep()+data_name+'-fft.mp4'
   if ~file_test(file_dirname(video_path),/directory) then $
      spawn, 'mkdir -p '+file_dirname(video_path)
   x_dim = 350
   y_dim = 300
   frm_scale = [4.0,4.0]
   dimensions = [ceil(x_dim*frm_scale[0]), $
                 ceil(y_dim*frm_scale[1])]
   framerate = 20
   vobj = idlffvideowrite(video_path)
   stream = vobj.addvideostream(dimensions[0],dimensions[1],framerate)
   print, "Creating "+video_path+"..."

   ;;==Needs differ slightly for 2-D v. 3-D runs
   if params.ndim_space eq 2 then begin

      ;;==Loop over files to create movie
      for it=it0,itf-1,itd do begin
         tmp = h5_getdata(all_files[it],'/'+data_name)
         tmp = transpose(tmp,[1,0])
         tmp = fft(tmp,/center,/overwrite)
         tmp = abs(tmp)
         tmp = rebin(tmp,npx,npy)
         tmp = 10*alog10(tmp^2)
         imiss = where(~finite(tmp))
         min_fin = min(tmp[where(finite(tmp))])
         tmp[imiss] = min_fin
         tmp -= max(tmp)
         frm = image(tmp, $
                     dimensions = dimensions, $
                     axis_style = axis_style, $
                     rgb_table = rgb_table, $
                     min_value = min_value, $
                     max_value = max_value, $
                     xmajor = xmajor, $
                     ymajor = ymajor, $
                     xtitle = xtitle, $
                     ytitle = ytitle, $
                     xtickfont_size = xtickfont_size, $
                     ytickfont_size = ytickfont_size, $
                     xtickvalues = xtickvalues, $
                     ytickvalues = ytickvalues, $
                     xtickname = xtickname, $
                     ytickname = ytickname, $
                     title = "t = "+time_ref.stamp[it], $
                     font_name = font_name, $
                     font_size = font_size, $
                     /buffer)
         frm.scale, frm_scale[0],frm_scale[1]
         frm_pos = frm.position
         clr_pos = [frm_pos[2]+0.01, $
                    frm_pos[1], $
                    frm_pos[2]+0.03, $
                    frm_pos[3]]
         clr = colorbar(target = frm, $
                        position = clr_pos, $
                        textpos = 1, $
                        font_size = font_size, $
                        title = "Norm. Power [dB]", $
                        orientation = 1)
         frame = frm.copywindow()
         vtime = vobj.put(stream,frame)
         frm.close
      endfor

   endif $
   else begin

      ;;==Loop over files to create movie
      for it=it0,itf-1,itd do begin
         tmp = h5_getdata(all_files[it],'/'+data_name)
         tmp = transpose(tmp,[2,1,0])
         tmp = fft(tmp,/center,/overwrite)
         tmp = mean(abs(tmp[i_kx0:i_kxf-1,*,*]),dim=1)
         tmp = reform(tmp)
         tmp = rebin(tmp,npx,npy)
         tmp = 10*alog10(tmp^2)
         imiss = where(~finite(tmp))
         min_fin = min(tmp[where(finite(tmp))])
         tmp[imiss] = min_fin
         tmp -= max(tmp)
         tmp = rotate(tmp,1)
         frm = image(tmp, $
                     dimensions = dimensions, $
                     axis_style = axis_style, $
                     rgb_table = rgb_table, $
                     min_value = min_value, $
                     max_value = max_value, $
                     xmajor = xmajor, $
                     ymajor = ymajor, $
                     xtitle = xtitle, $
                     ytitle = ytitle, $
                     xtickfont_size = xtickfont_size, $
                     ytickfont_size = ytickfont_size, $
                     xtickvalues = xtickvalues, $
                     ytickvalues = ytickvalues, $
                     xtickname = xtickname, $
                     ytickname = ytickname, $
                     title = "t = "+time_ref.stamp[it], $
                     font_name = font_name, $
                     font_size = font_size, $
                     /buffer)
         frm.scale, frm_scale[0],frm_scale[1]
         frm_pos = frm.position
         clr_pos = [frm_pos[2]+0.01, $
                    frm_pos[1], $
                    frm_pos[2]+0.03, $
                    frm_pos[3]]
         clr = colorbar(target = frm, $
                        position = clr_pos, $
                        textpos = 1, $
                        font_size = font_size, $
                        title = "Norm. Power [dB]", $
                        orientation = 1)
         frame = frm.copywindow()
         vtime = vobj.put(stream,frame)
         frm.close
      endfor

   endelse

   ;;==Clean up and save movie
   vobj.cleanup
   print, "Finished"

endif $
else print, "N_FILES_SUB not equal to NT"

end


