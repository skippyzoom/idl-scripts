;+
; Script for filling in hashes for multirun_Ert0_restore.
;
; Created by Matt Young.
;------------------------------------------------------------------------------
;-

;;==Construct Ex0, Ey0
Ex0 = Ex + pp.Ex0
Ey0 = Ey + pp.Ey0

;;==Construct Et0 and Er0 from smoothed Ex0, Ey0
sw = 10.0/dx
Er0 = sqrt(smooth(Ex0,[sw,sw,0],/edge_wrap)^2 + $
           smooth(Ey0,[sw,sw,0],/edge_wrap)^2)
Et0 = atan(smooth(Ey0,[sw,sw,0],/edge_wrap), $
           smooth(Ex0,[sw,sw,0],/edge_wrap))

;;==Insert Er0 and Et0 into multi-run hashes
Er0_hash[path] = Er0
Et0_hash[path] = Et0
