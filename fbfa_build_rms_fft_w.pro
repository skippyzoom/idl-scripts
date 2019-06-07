;+
; Flow angle project
;-

;;==Declare name of file to restore
dataname = 'efield'

;;==Declare all dimensions
alldims = ['2D','3D']
ndims_all = n_elements(alldims)

;;==Allocate array lists
times = list()
xdata = list()
ydata = list()

;;==Loop over dimension sets
for id=0,ndims_all-1 do begin

   ;;==Choose 2-D or 3-D data sets
   simdims = alldims[id]

   ;;==Declare paths
   paths = get_base_dir()+path_sep()+'fb_flow_angle/'+ $
           [simdims+'-new_coll/h0-Ey0_050/', $
            simdims+'-new_coll/h1-Ey0_050/', $
            simdims+'-new_coll/h2-Ey0_050/']
   n_paths = n_elements(paths)

   ;;==Loop over all paths
   for ip=0,n_paths-1 do begin

      ;;==Select one path
      path = paths[ip]

      ;;==Read in parameter dictionary
      params = set_eppic_params(path=path)

      ;;==Declare which file to restore
      savename = params.ndim_space eq 2 ? $
                 dataname+'-itd_4.sav' : $
                 dataname+'-itd_2.sav'

      ;;==Restore the data
      savepath = expand_path(path)+path_sep()+savename
      sys_t0 = systime(1)
      restore, filename=savepath,/verbose
      sys_tf = systime(1)
      print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60
      times.add, time

      ;;==Declare grid parameters
      nx = params.nx*params.nsubdomains/params.nout_avg
      ny = params.ny/params.nout_avg
      nz = params.nz/params.nout_avg      
      nt = time.nt
      dx = params.dx*params.nout_avg
      dy = params.dy*params.nout_avg
      dz = params.dz*params.nout_avg
      dt = params.dt*params.nout

      ;;==Create arrays
      xtmp = fftfreq(nt,dt)
      xtmp = shift(xtmp,nt/2)
      xdata.add, xtmp
      rtmp = fltarr(nt)
      if params.ndim_space eq 2 then begin
         for it=0,nt-1 do $
            rtmp[it] = rms(data[*,*,it])
      endif $
      else begin
         for it=0,nt-1 do $
            rtmp[it] = rms(data[*,*,*,it])
      endelse
      ytmp = fft(rtmp,/center)
      ydata.add, ytmp

      ;;==Nullify data to free memory
      data = !NULL

   endfor

endfor

end
