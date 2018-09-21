;+
; Create an image of den1(k,theta,t) by resizing each wavelength array
; to match the array with maximum size
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Set default frame type
if n_elements(frame_type) eq 0 then frame_type = '.pdf'

;;==Get the number of time steps
if time.haskey('nt') then nt = time.nt $
else nt = n_elements(time.index)

;;==Get subsample frequency
if time.haskey('subsample') then subsample = time.subsample

;;==Declare RMS time ranges (assuming all time steps are in memory)
if n_elements(subsample) eq 0 then subsample = 1
if params.ndim_space eq 2 then $
   rms_time = [[22528/params.nout/subsample, $
                62464/params.nout/subsample], $
               [159744/params.nout/subsample, $
                nt-1]]
if params.ndim_space eq 3 then $
   rms_time = [[5760/params.nout/subsample, $
                10368/params.nout/subsample], $
               [19968/params.nout/subsample, $
                nt-1]]

rms_time = transpose(rms_time)
n_rms = (size(rms_time))[1]

;;==Declare file name(s)
str_rms_time = string(rms_time*params.nout*subsample, $
                      format='(i06)')
filename = strarr(n_rms)
for it=0,n_rms-1 do $
   filename[it] = expand_path(path+path_sep()+'frames')+ $
   path_sep()+'den1ktt_rms_image'+ $
   '-'+axes+ $
   '-'+str_rms_time[it]+ $
   '-'+str_rms_time[it+n_rms]+ $
   '-self_norm'+ $
   '.'+get_extension(frame_type)

;;==Preserve original
fdata = cg_den1ktt

;;==Compute RMS values
fdata_rms = fltarr(nl,max_t,n_rms)
for it=0,n_rms-1 do $
   fdata_rms[*,*,it] = rms(fdata[*,*,rms_time[it,0]:rms_time[it,1]],dim=3)

;;==Declare k and theta vectors
k_vals = 2*!pi/lambda
;; k_vals = k_vals[sort(k_vals)]
th_vals = den1ktt[min(lambda)].t_interp/!dtor

;;==Declare image ranges
ik0 = 0
ikf = n_elements(k_vals)/4
ith0 = 0
ithf = n_elements(th_vals)

;;==Declare an array of image handles
frm = objarr(n_rms)

;;==Create image frames
for it=0,n_rms-1 do $
   frm[it] = image(fdata_rms[ik0:ikf-1,ith0:ithf-1,it], $
                   k_vals[ik0:ikf-1],th_vals[ith0:ithf-1], $
                   axis_style = 2, $
                   rgb_table = 39, $
                   /buffer)

;;==Fix aspect ratio
aspect_scale = 1.0
for it=0,n_rms-1 do $
   frm[it].aspect_ratio = aspect_scale* $
   (frm[it].xrange[1]-frm[it].xrange[0])/ $
   (frm[it].yrange[1]-frm[it].yrange[0])

;;==Save individual images
for it=0,n_rms-1 do $
   frame_save, frm[it],filename=filename[it]
