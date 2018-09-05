;+
; Script to compare den1 with temp1
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

position = multi_position([1,4], $
                          edges = [0.1,0.1,0.8,0.8], $
                          buffer = [0.0,0.05])

it = 1
frm = image(1e2*den1[*,*,it], $
            rgb_table = 5, $
            title = '$\delta n$ at '+time.stamp[it], $
            position = position[*,0], $
            font_name = 'Times', $
            /buffer)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               title = '[%]', $
               font_name = 'Times', $
               textpos = 1)
frm = image(temp1[*,*,it], $
            rgb_table = 5, $
            title = '$T$ at '+time.stamp[it], $
            position = position[*,1], $
            font_name = 'Times', $
            /current)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               title = '[K]', $
               font_name = 'Times', $
               textpos = 1)

it = 5
frm = image(1e2*den1[*,*,it], $
            rgb_table = 5, $
            title = '$\delta n$ at '+time.stamp[it], $
            position = position[*,2], $
            font_name = 'Times', $
            /current)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               title = '[%]', $
               font_name = 'Times', $
               textpos = 1)
frm = image(temp1[*,*,it], $
            rgb_table = 5, $
            title = '$T$ at '+time.stamp[it], $
            position = position[*,3], $
            font_name = 'Times', $
            /current)
frm_pos = frm.position
clr = colorbar(target = frm, $
               orientation = 1, $
               position = [frm_pos[2]+0.01, $
                           frm_pos[1], $
                           frm_pos[2]+0.03, $
                           frm_pos[3]], $
               title = '[K]', $
               font_name = 'Times', $
               textpos = 1)

txt = text(0.0,0.005, $
           path, $
           target = frm, $
           font_name = 'Courier', $
           font_size = 10.0)

filename = expand_path(path+path_sep()+'frames')+ $
           path_sep()+'ni_Ti_compare'+ $
           '.pdf'

frame_save, frm,filename=filename
