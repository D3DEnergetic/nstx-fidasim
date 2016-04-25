FUNCTION active_tfida,calib=calib

    ;; set calib to be last time this file was modified
    if not keyword_set(calib) then begin
        finfo = file_info(source_file())
        calib = systime(0,finfo.mtime)
    endif
    ;;**********************************************************************
    ;; Tangential FIDA system, refer to fida_alessandro.pro in IDL FIDAsim4.0
    ;; Detectors at BAY L, 16 active tangential views
    ;; (includes 16 fibers on a 20mm f/1.7 lens, diameter 600um)
    ;;**********************************************************************
    ;;lens and fiber parameter saved for refrence          
    ;det_area = !pi*0.5882^2
    ;det_normal=[0.6125,   -0.5278,   -0.5884]
    ;fnumber=1.7
    ;dfiber = replicate(0.6, 16)
    dspot_tfida=2.5 * replicate(2,16)
    
    ;;detector location
    detR_active_tfida=168.91
    detZ_active_tfida=48.26
    detphi_active_tfida=1.8326  ; angle already in [rad] !!
    detp_active_tfida=[detR_active_tfida*cos(detphi_active_tfida),$
                       detR_active_tfida*sin(detphi_active_tfida),$
                       detZ_active_tfida]
    detp_active_tfida = tile_array(detp_active_tfida,1,16)
    
    ;intersection of fiber view with midplane
    rmid_active_tfida=[ 0.8500,    0.8967,    0.9433,    0.9900, $
                        1.0367,    1.0833,    1.1300,    1.1767, $
                        1.2233,    1.2700,    1.3167,    1.3633, $
                        1.4100,    1.4567,    1.5033,    1.5500]*100     
    xmid_active_tfida=[-0.1698,   -0.1354,   -0.1024,   -0.0705, $
                       -0.0394,   -0.0089,    0.0209,    0.0504, $
                        0.0794,    0.1080,    0.1364,    0.1646, $
                        0.1925,    0.2202,    0.2477,    0.2751]*100
    ymid_active_tfida=[ 0.8329,    0.8864,    0.9378,    0.9875, $
                        1.0359,    1.0833,    1.1298,    1.1756, $
                        1.2208,    1.2654,    1.3096,    1.3534, $
                        1.3968,    1.4399,    1.4828,    1.5254]*100
    zmid_active_tfida=replicate(0.,n_elements(xmid_active_tfida))
    mid_active_tfida = transpose([[xmid_active_tfida], $
                                  [ymid_active_tfida], $
                                  [zmid_active_tfida]])
 
    axis_tfida = mid_active_tfida - detp_active_tfida
    for i=0,n_elements(rmid_active_tfida)-1 do begin
        axis_tfida[*,i] = axis_tfida[*,i]/sqrt(total(axis_tfida[*,i]^2))
    endfor

    spot_size = 0.5d0*dspot_tfida
    sigma_pi = replicate(1.d0,n_elements(rmid_active_tfida))

    chords = {system:['ACTIVE_TFIDA'], $
              lens:double(detp_active_tfida),$
              axis:double(axis_tfida),$
              radius:double(rmid_active_tfida),$
              sigma_pi:double(sigma_pi),$
              spot_size:double(spot_size),$
              nchan:long(n_elements(sigma_pi)),$
              data_source:source_file()+':calibration='+calib }
 
    return, chords
END
