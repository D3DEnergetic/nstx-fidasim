FUNCTION passive_tfida, calib=calib

    ;; set calib to be last time this file was modified
    if not keyword_set(calib) then begin
        finfo = file_info(source_file())
        calib = systime(0,finfo.mtime)
    endif
    ;;**********************************************************************
    ;; Detectors at BAY F, 16 passive tangential views
    ;; (includes 16 fibers on a 20mm f/1.7 lens, diameter 600um)
    ;; Refer to fida_alessandro.pro in IDL FIDAsim4.0
    ;;**********************************************************************
    ;lens and fiber parameter saved for refrence           
    ;det_area = !pi*0.5882^2
    ;det_normal=[ -0.5722,    0.5712,   -0.5884]
    ;fnumber=1.7
    ;dfiber = replicate(0.6, 16)

    dspot=2.5 * replicate(2,16)
    
    ;;detector location
    detR_passive_tfida=168.91
    detZ_passive_tfida=48.26
    detphi_passive_tfida=-1.3823  ; angle already in [rad] !!
    detp_passive_tfida=[detR_passive_tfida*cos(detphi_passive_tfida),$
                        detR_passive_tfida*sin(detphi_passive_tfida),$
                        detZ_passive_tfida]
    detp_passive_tfida = tile_array(detp_passive_tfida,1,16)
    
    ;intersection of fiber view with midplane
    rmid_passive_tfida=[ 0.8500,    0.8967,    0.9433,    0.9900, $
                         1.0367,    1.0833,    1.1300,    1.1767, $
                         1.2233,    1.2700,    1.3167,    1.3633, $
                         1.4100,    1.4567,    1.5033,    1.5500]*100
    xmid_passive_tfida=[ 0.1083,    0.0701,    0.0334,   -0.0021, $
                        -0.0367,   -0.0705,   -0.1037,   -0.1364, $
                        -0.1686,   -0.2005,   -0.2320,   -0.2633, $
                        -0.2943,   -0.3251,   -0.3557,   -0.3861]*100
    ymid_passive_tfida=[-0.8431,   -0.8939,   -0.9427,   -0.9900, $
                        -1.0360,   -1.0810,   -1.1252,   -1.1687, $
                        -1.2117,   -1.2541,   -1.2961,   -1.3377, $
                        -1.3789,   -1.4199,   -1.4607,   -1.5011]*100
    zmid_passive_tfida=replicate(0.,n_elements(xmid_passive_tfida)) 

    mid_passive_tfida = transpose([[xmid_passive_tfida], $
                                  [ymid_passive_tfida], $
                                  [zmid_passive_tfida]])
 
    axis_tfida = mid_passive_tfida - detp_passive_tfida
    for i=0,n_elements(rmid_passive_tfida)-1 do begin
        axis_tfida[*,i] = axis_tfida[*,i]/sqrt(total(axis_tfida[*,i]^2))
    endfor

    spot_size = 0.5d0*dspot
    sigma_pi = replicate(1.d0,n_elements(rmid_passive_tfida))

    chords = {system:['PASSIVE_TFIDA'], $
              lens:double(detp_passive_tfida),$
              axis:double(axis_tfida),$
              radius:double(rmid_passive_tfida),$
              sigma_pi:double(sigma_pi),$
              spot_size:double(spot_size),$
              nchan:long(n_elements(sigma_pi)),$
              data_source:source_file()+':calibration='+calib }
 
    return, chords
END
