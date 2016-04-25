FUNCTION active_vfida,calib=calib

    if not keyword_set(calib) then calib = '2008_new'
    ;;**********************************************************************
    ;; Vertical FIDA system, refer to fida_mario.pro in IDL FIDAsim4.0
    ;; Detector#1 at BAY A, 10 active vertical views
    ;; inner views (i.e. "outer" lens) at Bay A
    ;; (includes 10 fibers on a 200mm f/1.8 lens, diameter 600um)
    ;;**********************************************************************
    ;;lens and fiber parameter saved for reference          
    ;;det_area = !pi*10.0^2
    ;;det_normal=-[0.0876, 0.1131, 0.9896]
    ;;fnumber=1.8
    ;;dfiber = replicate(0.6, 10)
 
    CASE strlowcase(calib) OF
        '2008_old': begin
            ;;detector location
            lens_r_vfida1=127.794
            lens_z_vfida1=191.757
            lens_phi_vfida1=1.4869  ; angle already in [rad] !!
            
            lens_vfida1=[lens_r_vfida1*cos(lens_phi_vfida1), $
                         lens_r_vfida1*sin(lens_phi_vfida1), $
                         lens_z_vfida1]
            lens_vfida1 = tile_array(lens_vfida1,10)
 
            ;intersection of fiber view with midplane
            rmid_vfida1=[  85.81,     89.99,     94.28,     98.72,  103.26,$
                          107.87,    112.51,    117.23,    122.04,  126.84]  
            xmid_vfida1=[ -20.34,    -17.17,    -14.12,    -10.93,   -7.80, $
                           -4.76,     -1.74,      1.33,      4.32,    7.31]
            ymid_vfida1=[  83.36,     88.34,     93.22,     98.11,  102.96, $
                          107.77,    112.50,    117.22,    121.96,  126.63]
            zmid_vfida1=replicate(0.,n_elements(xmid_vfida1))

            mid_vfida1_2008 = transpose([[xmid_vfida1],[ymid_vfida1],[zmid_vfida1]])
        END
        '2008_new': begin
            ;;New vfida1 calculated by liu_compute_fida_midplane_position.pro
            ;;detector location
            lens_r_vfida1=127.130
            lens_z_vfida1=188.075
            lens_phi_vfida1=1.48446  ; angle already in [rad] !!
            
            lens_vfida1=[lens_r_vfida1*cos(lens_phi_vfida1), $
                         lens_r_vfida1*sin(lens_phi_vfida1), $
                         lens_z_vfida1]
            lens_vfida1 = tile_array(lens_vfida1,1,10)

            ;intersection of fiber view with midplane
            rmid_vfida1=[  86.298,    90.387,    94.697,    99.085, 103.570,$
                          108.134,   112.728,   117.441,   122.204, 126.995] 
            xmid_vfida1=[ -20.850,   -17.633,   -14.550,   -11.337,  -8.214,$
                           -5.123,    -2.118,     0.963,     3.981,   6.972]
            ymid_vfida1=[  83.741,    88.651,    93.572,    98.434, 103.244,$
                          108.012,   112.708,   117.437,   122.140, 126.803]
            zmid_vfida1=replicate(0.,n_elements(xmid_vfida1))

            mid_vfida1 = transpose([[xmid_vfida1],[ymid_vfida1],[zmid_vfida1]])
        END
    ENDCASE

    axis_vfida1 = mid_vfida1 - lens_vfida1
    for i=0,n_elements(rmid_vfida1)-1 do begin
        axis_vfida1[*,i] = axis_vfida1[*,i]/sqrt(total(axis_vfida1[*,i]^2))
    endfor
    dspot_vfida1 = [0.7082, 0.6596, 0.668, 0.6832, 0.6604,$
                    0.6766, 0.6784, 0.6684, 0.6784, 0.6386]
    spot_size_vfida1 = 0.5d0*dspot_vfida1
    sigma_pi_vfida1 = replicate(1.d0,n_elements(rmid_vfida1))

    ;; Detector#2, outer views (i.e. "inner" lens) at Bay A
    ;; (includes 6 fibers on a 135mm f/1.8 lens, diameter 800um)
    ;;lens and fiber parameter saved for refrence
    ;;det_area=!pi*6.75^2
    ;;det_normal=-[-0.1071, -0.1868, 0.9764]
    ;;fnumber=1.8
    ;;dfiber=replicate(0.8, 6)
    CASE strlowcase(calib) OF
        '2008_old': begin
            ;;Old vfida2
            ;;detector location
            lens_r_vfida2=104.350
            lens_z_vfida2=196.716
            lens_phi_vfida2=1.5978  ; angle already in [rad] !!
            
            lens_vfida2=[lens_r_vfida2*cos(lens_phi_vfida2),$
                              lens_r_vfida2*sin(lens_phi_vfida2),$ 
                              lens_z_vfida2]
            lens_vfida2 = tile_array(lens_vfida2,1,6)
            
            ;intersection of fiber view with midplane
            rmid_vfida2=[130.782, 135.567, 140.383, 145.357, 150.371, 155.429]
            xmid_vfida2=[ 10.82,   13.69,   16.58,   19.49,   22.45,   25.42 ]
            ymid_vfida2=[ 130.33, 134.87,  139.40,  144.05,  148.69,   153.34]
            zmid_vfida2=replicate(0.,n_elements(xmid_vfida2))

            mid_vfida2= transpose([[xmid_vfida2],[ymid_vfida2],[zmid_vfida2]])
        END
        '2008_new': begin
            ;;New vfida2
            ;;detector location
            lens_r_vfida2=103.790
            lens_z_vfida2=200.097
            lens_phi_vfida2=1.60961  ; angle already in [rad] !!
            
            lens_vfida2=[lens_r_vfida2*cos(lens_phi_vfida2),$
                         lens_r_vfida2*sin(lens_phi_vfida2),$ 
                         lens_z_vfida2]
            lens_vfida2 = tile_array(lens_vfida2,1,6)
            
            ;intersection of fiber view with midplane
            rmid_vfida2=[130.848, 135.613, 140.445, 145.425, 150.422, 155.496]
            xmid_vfida2=[ 10.540,  13.406,  16.301,  19.243,  22.207,  25.181]
            ymid_vfida2=[130.423, 134.949, 139.496, 144.146, 148.774 ,153.443]
            zmid_vfida2=replicate(0.,n_elements(xmid_vfida2))
           
            mid_vfida2 = transpose([[xmid_vfida2],[ymid_vfida2],[zmid_vfida2]])
        END
    ENDCASE

    axis_vfida2 = mid_vfida2 - lens_vfida2
    for i=0,n_elements(rmid_vfida2)-1 do begin
        axis_vfida2[*,i] = axis_vfida2[*,i]/sqrt(total(axis_vfida2[*,i]^2))
    endfor
    dspot_vfida2 = [0.4058, 0.4270, 0.3722, 0.4122, 0.3952, 0.4066]
    spot_size_vfida2 = 0.5d0*dspot_vfida2
    sigma_pi_vfida2 = replicate(1.d0,n_elements(rmid_vfida2))

    lens_vfida = [[lens_vfida1],[lens_vfida2]]
    axis_vfida = [[axis_vfida1],[axis_vfida2]]
    r_vfida = [rmid_vfida1,rmid_vfida2]
    sigma_pi = [sigma_pi_vfida1,sigma_pi_vfida2]
    spot_size_vfida = [spot_size_vfida1,spot_size_vfida2]
   
    chords = {system:['ACTIVE_VFIDA'], $
              lens:double(lens_vfida),$
              axis:double(axis_vfida),$
              radius:double(r_vfida),$
              sigma_pi:double(sigma_pi),$
              spot_size:double(spot_size_vfida),$
              nchan:long(n_elements(sigma_pi)),$
              data_source:source_file()+':calibration='+calib}
 
    return, chords
END
