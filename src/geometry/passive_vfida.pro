FUNCTION passive_vfida,calib=calib
   
    ;; set calib to be last time this file was modified
    if not keyword_set(calib) then begin
        finfo = file_info(source_file())
        calib = systime(0,finfo.mtime)
    endif

    ;;**********************************************************************
    ;; Detector#3 at BAY B, 10 active tangential views
    ;; inner views (i.e. "outer" lens) at Bay B
    ;; (includes 10 fibers on a 200mm f/1.8 lens, diameter 600um)
    ;; Refer to fida_mario.pro in IDL FIDAsim4.0
    ;;**********************************************************************
    ;;lens and fiber parameter saved for refrence          
    ;;det_area = !pi*10.0^2
    ;;det_normal=-[0.0942, 0.0730, 0.9928]
    ;;fnumber=1.8
    ;;dfiber = replicate(0.6, 10)
    dspot_vfida3=[0.6420, 0.6458, 0.685, 0.6864, 0.6952,$
                  0.7448, 0.7664, 0.8298, 0.7838, 0.811]
    spot_size_vfida3 = 0.5d0*dspot_vfida3
    sigma_pi_vfida3 = replicate(1.d0,n_elements(dspot_vfida3))
    
    ;;detector location
    detR_vfida3=126.2458
    detZ_vfida3=183.587
    detphi_vfida3=0.7834  ; angle already in [rad] !!
    
    detp_vfida3=[detR_vfida3*cos(detphi_vfida3), $
                 detR_vfida3*sin(detphi_vfida3), $
                 detZ_vfida3]
    detp_vfida3 = tile_array(detp_vfida3,1,10)

    ;intersection of fiber view with midplane
    rmid_vfida3=[ 83.148,    87.895,  92.160,  97.410, 102.084,$
                 106.747,   111.391, 116.014, 120.607, 125.211]
    xmid_vfida3=[  57.09,    60.42,   63.73,   67.09,  70.41, $
                   73.65,    76.91,   80.15,   83.38,  86.62 ]
    ymid_vfida3=[  60.45,    63.84,   67.19,   70.63,  73.92,$
                   77.27,    80.57,   83.87,   87.14,  90.42]
    zmid_vfida3=replicate(0.,n_elements(xmid_vfida3))
    
    mid_vfida3 = transpose([[xmid_vfida3],[ymid_vfida3],[zmid_vfida3]])
    axis_vfida3 = mid_vfida3 - detp_vfida3
    for i=0,n_elements(rmid_vfida3)-1 do begin
        axis_vfida3[*,i] = axis_vfida3[*,i]/sqrt(total(axis_vfida3[*,i]^2))
    endfor
    ;; Detector#4, outer views (i.e. "inner" lens) at Bay B
    ;; (includes 6 fibers on a 135mm f/1.8 lens, diameter 800um)
    ;;det_area = !pi*6.75^2
    ;;det_normal=[-0.4662, 0.0147, 0.8845]
    ;;fnumber=1.8
    ;;dfiber = replicate(0.8, 6)
    
    dspot_vfida4=[0.4502, 0.47, 0.4514, 0.435, 0.5622, 0.4744]
    spot_size_vfida4 = 0.5d0*dspot_vfida4
    sigma_pi_vfida4 = replicate(1.d0,n_elements(dspot_vfida4))

    ;;detector location
    detR_vfida4=103.8
    detZ_vfida4=223.209
    detphi_vfida4=0.7845  ; angle already in [rad] !!
    
    detp_vfida4=[detR_vfida4*cos(detphi_vfida4),$
                 detR_vfida4*sin(detphi_vfida4),$ 
                 detZ_vfida4]
    detp_vfida4 = tile_array(detp_vfida4,1,6)
    
    ;intersection of fiber view with midplane
    rmid_vfida4=[130.151, 135.032, 139.943, 144.841, 149.825, 154.827]
    xmid_vfida4=[ 91.69,   95.09,   98.54,  101.94,  105.40,  108.87 ]
    ymid_vfida4=[ 92.37,   95.87,   99.37,  102.90,  106.49,  110.09]
    zmid_vfida4=replicate(0.,n_elements(xmid_vfida4))

    mid_vfida4 = transpose([[xmid_vfida4],[ymid_vfida4],[zmid_vfida4]])
    axis_vfida4 = mid_vfida4 - detp_vfida4
    for i=0,n_elements(rmid_vfida4)-1 do begin
        axis_vfida4[*,i] = axis_vfida4[*,i]/sqrt(total(axis_vfida4[*,i]^2))
    endfor
    
    lens_vfida = [[detp_vfida3],[detp_vfida4]]
    axis_vfida = [[axis_vfida3],[axis_vfida4]]
    r_vfida = [rmid_vfida3,rmid_vfida4]
    sigma_pi = [sigma_pi_vfida3,sigma_pi_vfida4]
    spot_size_vfida = [spot_size_vfida3,spot_size_vfida4]

    chords = {system:['PASSIVE_VFIDA'], $
              lens:double(lens_vfida),$
              axis:double(axis_vfida),$
              radius:double(r_vfida),$
              sigma_pi:double(sigma_pi),$
              spot_size:double(spot_size_vfida),$
              nchan:long(n_elements(sigma_pi)),$
              data_source:source_file()+':calibration='+calib }
 
    return, chords
END
