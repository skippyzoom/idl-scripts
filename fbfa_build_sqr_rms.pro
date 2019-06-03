;+
; Flow angle project: Build lists of data arrays from save files
; before making plots. This is separate from the plot routine so the
; user can modify plot parameters without having to read data from
; disk every time.
;-

;;==Declare name of file to restore
savename = 'den1.sav'

;;==Declare all dimensions
alldims = ['2D','3D']
ndims_all = n_elements(alldims)

;;==Allocate array lists
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

      ;;==Restore the data
      savepath = expand_path(path)+path_sep()+savename
      sys_t0 = systime(1)
      restore, filename=savepath,/verbose
      sys_tf = systime(1)
      print, "Elapsed minutes for restore: ",(sys_tf-sys_t0)/60
      nt = time.nt

      ;;==Create arrays
      ytmp = fltarr(nt)
      if params.ndim_space eq 2 then begin
         for it=0,nt-1 do $
            ytmp[it] = rms(data[*,*,it])^2
      endif $
      else begin
         for it=0,nt-1 do $
            ytmp[it] = rms(data[*,*,*,it])^2
      endelse
      xdata.add, float(time.stamp)
      ydata.add, ytmp

      ;;==Nullify data to free memory
      data = !NULL

   endfor

endfor

end
