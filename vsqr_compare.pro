;+
; Script to compare vsqr arrays from build_temp1_from_fluxes
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

it = 5
vsqrt = vsqrx+vsqry+vsqrz

position = multi_position([2,4], $
                          edges = [0.1,0.1,0.8,0.8], $
                          buffer = [0.05,0.05])
min_value = 5e4
max_value = 8e4

xw = 128
yw = 128
x0 = nx/4-xw
xf = nx/4+xw
y0 = ny/2-yw
yf = ny/2+yw
npx = xf-x0
npy = yf-y0

frm = image(vsqrx[x0:xf-1,y0:yf-1,it], $
            rgb_table = 5, $
            position = position[*,0], $
            font_name = 'Times', $
            title = 'crest $v_x^2$', $
            ;; min_value = min_value, $
            ;; max_value = max_value, $
            dimensions = [4*npx,4*npy], $
            /buffer)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               font_name = 'Times', $
               textpos = 1)
frm = image(vsqry[x0:xf-1,y0:yf-1,it], $
            rgb_table = 5, $
            position = position[*,2], $
            font_name = 'Times', $
            title = 'crest $v_y^2$', $
            ;; min_value = min_value, $
            ;; max_value = max_value, $
            /current)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               font_name = 'Times', $
               textpos = 1)
frm = image(vsqrz[x0:xf-1,y0:yf-1,it], $
            rgb_table = 5, $
            position = position[*,4], $
            font_name = 'Times', $
            title = 'crest $v_z^2$', $
            ;; min_value = min_value, $
            ;; max_value = max_value, $
            /current)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               font_name = 'Times', $
               textpos = 1)
frm = image(vsqrt[x0:xf-1,y0:yf-1,it], $
            rgb_table = 5, $
            position = position[*,6], $
            font_name = 'Times', $
            title = 'crest $v_{total}^2$', $
            ;; min_value = 1e5, $
            ;; max_value = 3e5, $
            /current)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               font_name = 'Times', $
               textpos = 1)

x0 = 3*nx/4-xw
xf = 3*nx/4+xw
y0 = ny/2-yw
yf = ny/2+yw

frm = image(vsqrx[x0:xf-1,y0:yf-1,it], $
            rgb_table = 5, $
            position = position[*,1], $
            font_name = 'Times', $
            title = 'trough $v_x^2$', $
            ;; min_value = min_value, $
            ;; max_value = max_value, $
            /current)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               font_name = 'Times', $
               textpos = 1)
frm = image(vsqry[x0:xf-1,y0:yf-1,it], $
            rgb_table = 5, $
            position = position[*,3], $
            font_name = 'Times', $
            title = 'trough $v_y^2$', $
            ;; min_value = min_value, $
            ;; max_value = max_value, $
            /current)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               font_name = 'Times', $
               textpos = 1)
frm = image(vsqrz[x0:xf-1,y0:yf-1,it], $
            rgb_table = 5, $
            position = position[*,5], $
            font_name = 'Times', $
            title = 'trough $v_z^2$', $
            ;; min_value = min_value, $
            ;; max_value = max_value, $
            /current)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               font_name = 'Times', $
               textpos = 1)
frm = image(vsqrt[x0:xf-1,y0:yf-1,it], $
            rgb_table = 5, $
            position = position[*,7], $
            font_name = 'Times', $
            title = 'trough $v_{total}^2$', $
            ;; min_value = 1e5, $
            ;; max_value = 3e5, $
            /current)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               font_name = 'Times', $
               textpos = 1)

txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'vsqr_compare'+ $
           '-'+time.index[it]+ $
           '.pdf'

frame_save, frm,filename=filename
