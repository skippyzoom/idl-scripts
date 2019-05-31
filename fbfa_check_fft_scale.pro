;+
; I used this script to confirm that I need to scale the raw FFT
; magnitude by the number of points in the simulation domain in order
; to make the final RMS amplitude consistent with the final RMS
; amplitude of density fluctuations. I also learned that I need to
; multiply by an additional factor of nx when working with pseudo 2-D
; FFTs from 3-D runs, which I create by computing the mean along the
; parallel (i.e., x) direction. That scale factor needs to be a
; double-precision float or a 64-bit integer or it will overflow to
; 0. The pseudo 2-D scale factor is not as close to the ratio of RMS
; values as the full-array scale factor but I chalk that up to
; rounding errors and I'm willing to live with it.
;
; Created by Matt Young
;-

;;==Declare the simulation run path.
basepath = '$SCRATCH/fb_flow_angle/'
project = '2D-new_coll/'
runname = 'h0-Ey0_050/'
runpath = basepath+path_sep()+project+path_sep()+runname

;;==Read in simulation run parameters.
params = set_eppic_params(path=runpath)
nx = params.nx*params.nsubdomains/params.nout_avg
ny = params.ny/params.nout_avg
nz = params.nz/params.nout_avg
dx = params.dx*params.nout_avg
dy = params.dy*params.nout_avg
dz = params.dz*params.nout_avg
dt = params.dt*params.nout

;;==Read in density at the final time step.
filename = params.ndim_space eq 3 ? $
           'parallel032768.h5' : $
           'parallel262144.h5'
filepath = runpath+path_sep()+'parallel/'+path_sep()+filename
filepath = expand_path(filepath)
den1 = get_h5_data(filepath,'den1')
den1 = params.ndim_space eq 3 ? $
       transpose(den1,[2,1,0]) : $
       transpose(den1,[1,0])

;;==Print diagnostics for density.
print, "MAX(DEN1): ",max(den1)
print, "MIN(DEN1): ",min(den1)
print, "MEAN(DEN1): ",mean(den1)
print, "RMS(DEN1): ",rms(den1)

;;==Compute the FFT.
fftden1 = fft(den1,/center,/double)

;;==Print diagnostics for the FFT.
print, "RMS(ABS(FFTDEN1)): ",rms(abs(fftden1))
print, "RMS(DEN1)/RMS(ABS(FFTDEN1)): ",rms(den1)/rms(abs(fftden1))
scale_factor = params.ndim_space eq 3 ? $
               double(nx)*ny*nz : $
               double(nx)*ny
print, "SQRT(SCALE_FACTOR): ",sqrt(scale_factor)

;;==If this is a 3-D run, compute the mean long k-parallel and reprint
;;  diagnostics.
if params.ndim_space eq 3 then begin
   mean_fftden1 = mean(fftden1,dim=1)
   print, "RMS(ABS(MEAN_FFTDEN1)): ",rms(abs(mean_fftden1))
   print, "RMS(DEN1)/RMS(ABS(MEAN_FFTDEN1)): ",rms(den1)/rms(abs(mean_fftden1))
   mean_scale_factor = double(nx)*nx*ny*nz
   print, "SQRT(MEAN_SCALE_FACTOR): ",sqrt(mean_scale_factor)
endif

end
