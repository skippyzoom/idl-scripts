;+
; Flow angle project: Mimic the electric field spectrum that a rocket
; may observe (e.g., as shown in Pfaff et al. 1987b). Since this has
; the same structure as fbfa_build_rms_fft_w.pro, you should be able
; to run fbfa_plot_fft_lists.pro directly after this to produce
; plots. 
;-

;;==Declare name of file to restore
dataname = 'phi'

;;==Declare effective boom length in meters
Lb_ped = 5.5
Lb_hal = 5.5

;;==Set scale from V to mV
scale = 1e3

;;==Declare all dimensions
alldims = ['2D','3D']
ndims_all = n_elements(alldims)

;;==Allocate array lists
times = list()
xdata = list()
ydata = list()
ddata = list()

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
      dped = dy
      dhal = params.ndim_space eq 2 ? $
             dx : dz
      nb_ped = floor(Lb_ped/dped)
      nb_hal = floor(Lb_hal/dhal)
      it0 = 0
      itf = nt
      ix0 = 0
      ixd = nx/32
      iyd = ny/32
      izd = nz/32
      fnt = itf-it0

      ;;==Extract background E field
      E0_ped = params.Ey0_external
      E0_hal = params.ndim_space eq 2 ? $
               params.Ex0_external : $
               params.Ez0_external

      ;;==Create arrays
      xtmp = fftfreq(fnt,dt)
      xtmp = shift(xtmp,fnt/2)
      xdata.add, xtmp
      rE_ped = make_array(fnt,value=0.0,type=4)
      rE_hal = make_array(fnt,value=0.0,type=4)
      rE_mag = make_array(fnt,value=0.0,type=4)
      if params.ndim_space eq 2 then begin
         fft_rE_mag = make_array(nx/ixd,ny/iyd,fnt, $
                                 value=0.0,type=6)
         E0p = scale*sqrt(E0_ped^2 + E0_hal^2)
         for ix=0,nx-1,ixd do begin
            for iy=0,ny-1,iyd do begin
               for it=it0,itf-1 do begin
                  ix0 = ix-nb_hal/2
                  ixf = (ix+nb_hal/2) mod nx
                  iy0 = iy-nb_ped/2
                  iyf = (iy+nb_ped/2) mod ny
                  phi_ped = data[ix,iy0,it]-data[ix,iyf,it]
                  phi_hal = data[ix0,iy,it]-data[ixf,iy,it]
                  rE_ped[it-it0] = scale*(phi_ped/Lb_ped)
                  rE_hal[it-it0] = scale*(phi_hal/Lb_hal)
               endfor
               rE_mag = sqrt(rE_ped^2 + rE_hal^2)
               fft_rE_mag[ix/ixd,iy/iyd,*] = fft(rE_mag, /center)
            endfor
         endfor
         mean_fft = complexarr(fnt)
         for it=0,fnt-1 do begin
            mean_fft[it] = mean(fft_rE_mag[*,*,it])
         endfor
      endif $
      else begin
         fft_rE_mag = make_array(nx/ixd,ny/iyd,nz/izd,fnt, $
                                 value=0.0,type=6)
         E0p = scale*sqrt(E0_ped^2 + E0_hal^2)
         for ix=0,nx-1,ixd do begin
            for iy=0,ny-1,iyd do begin
               for iz=0,nz-1,izd do begin
                  for it=it0,itf-1 do begin
                     iy0 = iy-nb_ped/2
                     iyf = (iy+nb_ped/2) mod ny
                     iz0 = iz-nb_hal/2
                     izf = (iz+nb_hal/2) mod nz
                     phi_ped = data[ix,iy0,iz,it]-data[ix,iyf,iz,it]
                     phi_hal = data[ix,iy,iz0,it]-data[ix,iy,izf,it]
                     rE_ped[it-it0] = scale*(phi_ped/Lb_ped)
                     rE_hal[it-it0] = scale*(phi_hal/Lb_hal)
                  endfor
                  rE_mag = sqrt(rE_ped^2 + rE_hal^2)
                  fft_rE_mag[ix/ixd,iy/iyd,iz/izd,*] = fft(rE_mag, /center)
               endfor
            endfor
         endfor
         mean_fft = complexarr(fnt)
         for it=0,fnt-1 do begin
            mean_fft[it] = mean(fft_rE_mag[*,*,*,it])
         endfor
      endelse
      ydata.add, mean_fft/E0p

      ;;==Nullify data to free memory
      data = !NULL

   endfor

endfor

;;==Save the lists, for convenience
filepath = get_base_dir()+ $
           path_sep()+"fb_flow_angle"+ $
           path_sep()+"common"+ $
           path_sep()+"fft_lists-full.sav"
save, time,xdata,ydata,filename=filepath

end
