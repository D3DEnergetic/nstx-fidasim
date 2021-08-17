FUNCTION nstx_npa, npa
    
    ;;from TRANSP namelist
    ;;NPA/SSNPA settings
    ;;CXRSTA=221.7, 221.7, 221.7, 221.7, 221.7, 183.6, 183.6, 183.6, 183.6
    ;;                              ; RADIUS FROM MACHINE CENTERLINE TO CX PIVOT
    ;;CXYSTA=9*0.0          ; ELEVATION OF PIVOT ABOVE MIDPLANE
    ;;CXZETA=0.0,   0.0,   0.0,   0.0,   0.0,   30.,   30.,    30.,   30.
    ;;                              ; TOROIDAL LOCATION OF PIVOT IN DEGREES
    ;;CXYTAN=9*0.0          ; HEIGHT ABOVE MIDPLANE OF PIVOT
    ;;CXRTAN=120.,  100.,  90.,   80.,    65., 120.73, 101.63, 88.52, 63.8
    ;;                              ; CX RTAN (+CO, -CTR)
    
    ;the angle difference of TRANSP coordinates and FIDA (u,v,z) coordinates
    angle_transp_uvz=0.0/180.*!pi ;check angle_transp_uvz within nstxu_beams.pro
    
    CXRSTA_nstx= [replicate(221.7,4),replicate(183.6,8)]
    nch_nstx_npa=n_elements(CXRSTA_nstx)
    CXYSTA_nstx=replicate(0.,nch_nstx_npa)
    CXZETA_nstx= [replicate(0.,4),   replicate(30.,8)]/180.*!pi+142.38/180.*!pi
    CXTHETA_nstx=[replicate(0.,4),   replicate(0.,8)]/180./!pi
    Rtan_nstx_npa= [70., 80., 100., 120., 63.8,  88.5,   101.6, 110.,$
                                          63.8,  88.5,   101.6, 110. ]  
                            
    npap_nstx=fltarr(nch_nstx_npa,3)         ;detector center position in (u,v,z) (cm)
    npa_mid_nstx=fltarr(nch_nstx_npa,3)      ;intersection of NPA and midplane in (u,v,z) (cm)
    det_radius_nstx=fltarr(nch_nstx_npa)     ;radius of NPA dector (cm)  
    
    npa_area_nstx=0.04d
    npa_l_nstx=26.d
    npa_aperture_nstx=sqrt(npa_area_nstx/!pi)
    
    ;;ssnpa flight tube geometry
    ;;ssnpa_l: flight tube length
    ;;ssnpa_hole: radius of at input side flight tube
    ;;ssnpa_det:  effective detector radius (which equals the aperture radius) 
    ssnpa_l_nstx=[     25.4,      25.4,       25.4,        25.4      ] 
    ssnpa_hole_nstx=[0.3/2.,    0.27/2.,    0.31/2.,     0.27/2.     ]
    ssnpa_det_nstx=[ 0.005/2.,  0.0035/2.,  0.0035/2.,   0.0025/2.   ] 
    
    det_radius_nstx=[replicate(sqrt(npa_area_nstx/!pi),4),   $   ;E||B NPA    
                     ssnpa_det_nstx,$                            ;actual SSNPA 
                     5.0d,  5.0d,    5.0d,   5.0d]               ;SSNPA in TRANSP
    
    aperture_radius_nstx=[replicate(sqrt(npa_area_nstx/!pi),4),   $   ;E||B NPA    
                          ssnpa_hole_nstx,$                           ;actual SSNPA 
                      5.d,  5.d,    5.0d,   5.0d]                 ;SSNPA in TRANSP
    
    dcollimator_nstx=[replicate(sqrt(npa_l_nstx),4),$
                      ssnpa_l_nstx,$
                      160.d, 160.d,200.d,200.d]
    
    npa_solid_angle_nstx=!pi*aperture_radius_nstx^2/dcollimator_nstx^2.
      
    for iDet=0,nch_nstx_npa-1 do begin
        ;detector position in uvz coordinate
        npap_nstx[iDet,*]=[CXRSTA_nstx[iDet]*cos(CXZETA_nstx[iDet]),$
                           CXRSTA_nstx[iDet]*sin(CXZETA_nstx[iDet]),$
                           CXYSTA_nstx[iDet] ]  
        ;intersection of npa detector and midplane in uvz coordinate
        angle=CXZETA_nstx[iDet]-signum(Rtan_nstx_npa[iDet])*$
                                acos(abs(Rtan_nstx_npa[iDet])/CXRSTA_nstx[iDet])     
        npa_mid_nstx[iDet,*]=[abs(Rtan_nstx_npa[iDet])*cos(angle),$
                              abs(Rtan_nstx_npa[iDet])*sin(angle),$
                              tan(CXTHETA_nstx[iDet])*$
                              sqrt(CXRSTA_nstx[iDet]^2.-Rtan_nstx_npa[iDet]^2.)+$
                              CXYSTA_nstx[iDet] ] 
    endfor
             
    
    ;New SSNPA at Bay I (16 cm below midplane)
    ;CXRSTA=5*188.0                   ! RADIUS FROM MACHINE CENTERLINE OF CX PIVOT
    ;CXYSTA=5*0.0             ! ELEVATION OF PIVOT ABOVE MIDPLANE
    ;CXZETA=5*61.7                    ! TOROIDAL LOCATION OF PIVOT IN DEGREES
    ;CXRTAN=140., 130.,120.,110.,100. ! CX RTAN (+CO, -CTR)
    ;CXTHEA=5*0.0                 ! ANGLE OF CHORD ABOVE MIDPLANE IN DEGREES
    ;CXYTAN=5*0.0                     ! HEIGHT ABOVE MIDPLANE OF TANGENCY RADIUS
    CXRTAN_tssnpa=[145., 142., 139., 136.,$
                   133., 130., 127., 124.,$
                   121., 118., 115., 112.,$
                   109., 106., 103., 100.,97.]  ;! CX RTAN (+CO, -CTR)
    nch_tssnpa=n_elements(CXRTAN_tssnpa)
    
    
    CXRSTA_tssnpa=replicate(188.0,nch_tssnpa)        ;! RADIUS FROM MACHINE CENTERLINE OF CX PIVOT
    CXYSTA_tssnpa=replicate(0.0,nch_tssnpa)          ;! ELEVATION OF PIVOT ABOVE MIDPLANE
    ;! TOROIDAL LOCATION OF PIVOT IN DEGREES
    CXZETA_tssnpa=replicate(61.7,nch_tssnpa)/180*!pi+142.38/180.*!pi
    CXTHEA_tssnpa=replicate(0.0,nch_tssnpa)      ;! ANGLE OF CHORD ABOVE MIDPLANE IN DEGREES
    CXYTAN_tssnpa=replicate(0.0,nch_tssnpa)          ;! HEIGHT ABOVE MIDPLANE OF TANGENCY RADIUS
    CXTHETA_tssnpa=replicate(0.0,nch_tssnpa)  
    
    tssnpap=fltarr(nch_tssnpa,3)             ;detector center position in (u,v,z) (cm)
    tssnpa_mid=fltarr(nch_tssnpa,3)          ;intersection of NPA and midplane in (u,v,z) (cm)
    det_radius_tssnpa=fltarr(nch_tssnpa)     ;radius of NPA dector (cm)  
    
    for iDet=0,nch_tssnpa-1 do begin
        ;detector position in uvz coordinate
        tssnpap[iDet,*]=[CXRSTA_tssnpa[iDet]*cos(CXZETA_tssnpa[iDet]),$
                         CXRSTA_tssnpa[iDet]*sin(CXZETA_tssnpa[iDet]),$
                         CXYSTA_tssnpa[iDet] ]  
        ;intersection of npa detector and midplane in uvz coordinate
        angle=CXZETA_tssnpa[iDet]-signum(CXRTAN_tssnpa[iDet])*$
                                  acos(abs(CXRTAN_tssnpa[iDet])/CXRSTA_tssnpa[iDet]) 
        tssnpa_mid[iDet,*]=[abs(CXRTAN_tssnpa[iDet])*cos(angle),$
                            abs(CXRTAN_tssnpa[iDet])*sin(angle),$
                            tan(CXTHETA_tssnpa[iDet])*$
                            sqrt(CXRSTA_tssnpa[iDet]^2.-CXRTAN_tssnpa[iDet]^2.)+$
                            CXYSTA_tssnpa[iDet] ] 
    endfor
    tssnpa_area=0.01d
    tssnpa_l=2.54d*2.75
    tssnpa_aperture=sqrt(0.03*0.085/!pi)
    
    det_radius_tssnpa=[replicate(sqrt(tssnpa_area/!pi),nch_tssnpa)] 
    aperture_radius_tssnpa=[replicate(sqrt(tssnpa_area/!pi),nch_tssnpa)]
    dcollimator_tssnpa=[replicate(sqrt(tssnpa_l),nch_tssnpa)]     
    
    tssnpa_solid_angle=!pi*aperture_radius_tssnpa^2/dcollimator_tssnpa^2.   
    
    
    ;New SSNPA at Bay L (+2.5cm above midplance)
    ;CXRSTA=5*203.                  ! RADIUS FROM MACHINE CENTERLINE OF CX PIVOT
    ;CXYSTA=5*0.0           ! ELEVATION OF PIVOT ABOVE MIDPLANE
    ;CXZETA=5*-39.4                 ! TOROIDAL LOCATION OF PIVOT IN DEGREES
    ;CXRTAN=90.,80.,70.,60.,50.     ! CX RTAN (+CO, -CTR)
    ;CXTHEA=5*0.0               ! ANGLE OF CHORD ABOVE MIDPLANE IN DEGREES
    ;CXYTAN=5*0.0                   ! HEIGHT ABOVE MIDPLANE OF TANGENCY RADIUS
    CXRTAN_rssnpa=[90., 85., 80., 75.,$
                   70., 65., 60., 55.,$
                   50., 45., 40., 35.,$
                   30., 25., 20., 15.,$
                   10., 5.]  
    nch_rssnpa=n_elements(CXRTAN_rssnpa)
    CXRSTA_rssnpa=replicate(203.0,nch_rssnpa)        ;! RADIUS FROM MACHINE CENTERLINE OF CX PIVOT
    CXYSTA_rssnpa=replicate(0.0,nch_rssnpa)          ;! ELEVATION OF PIVOT ABOVE MIDPLANE
    CXZETA_rssnpa=replicate(-39.4,nch_rssnpa)/180*!pi+142.38/180.*!pi
                                                     ;! TOROIDAL LOCATION OF PIVOT IN DEGREES
                  ;! CX RTAN (+CO, -CTR)
    CXTHEA_rssnpa=replicate(0.0,nch_rssnpa)      ;! ANGLE OF CHORD ABOVE MIDPLANE IN DEGREES
    CXYTAN_rssnpa=replicate(0.0,nch_rssnpa)          ;! HEIGHT ABOVE MIDPLANE OF TANGENCY RADIUS
    CXTHETA_rssnpa=replicate(0.0,nch_rssnpa)  
    
    rssnpap=fltarr(nch_rssnpa,3)             ;detector center position in (u,v,z) (cm)
    rssnpa_mid=fltarr(nch_rssnpa,3)          ;intersection of NPA and midplane in (u,v,z) (cm)
    det_radius_rssnpa=fltarr(nch_rssnpa)     ;radius of NPA dector (cm)  
    
    for iDet=0,nch_rssnpa-1 do begin
        ;detector position in uvz coordinate
        rssnpap[iDet,*]=[CXRSTA_rssnpa[iDet]*cos(CXZETA_rssnpa[iDet]),$
                         CXRSTA_rssnpa[iDet]*sin(CXZETA_rssnpa[iDet]),$
                         CXYSTA_rssnpa[iDet] ]  
        ;intersection of npa detector and midplane in uvz coordinate
        angle=CXZETA_rssnpa[iDet]-signum(CXRTAN_rssnpa[iDet])*$
                                  acos(abs(CXRTAN_rssnpa[iDet])/CXRSTA_rssnpa[iDet]) 
        rssnpa_mid[iDet,*]=[abs(CXRTAN_rssnpa[iDet])*cos(angle),$
                            abs(CXRTAN_rssnpa[iDet])*sin(angle),$
                            tan(CXTHETA_rssnpa[iDet])*$
                            sqrt(CXRSTA_rssnpa[iDet]^2.-CXRTAN_rssnpa[iDet]^2.)+$
                            CXYSTA_rssnpa[iDet] ] 
    endfor
    rssnpa_area=0.01d
    rssnpa_l=2.54d*2.35
    rssnpa_aperture=sqrt(0.03*0.085/!pi)
    
    det_radius_rssnpa=[replicate(sqrt(rssnpa_area/!pi),nch_rssnpa)] 
    aperture_radius_rssnpa=[replicate(sqrt(rssnpa_area/!pi),nch_rssnpa)]
    dcollimator_rssnpa=[replicate(sqrt(rssnpa_l),nch_rssnpa)]     
    
    rssnpa_solid_angle=!pi*aperture_radius_rssnpa^2/dcollimator_rssnpa^2. 
    
    
    ;New SSNPA at Bay B (+13.3cm above midplane)
    ;CXRSTA=5*170.                   ! RADIUS FROM MACHINE CENTERLINE OF CX PIVOT
    ;CXYSTA=5*0.0                ! ELEVATION OF PIVOT ABOVE MIDPLANE
    ;CXZETA=5*-88.6                  ! TOROIDAL LOCATION OF PIVOT IN DEGREES
    ;CXRTAN=40.,25.,10.,0.,-10.      ! CX RTAN (+CO, -CTR)
    ;CXTHEA=5*0.0                ! ANGLE OF CHORD ABOVE MIDPLANE IN DEGREES
    ;CXYTAN=5*0.0                    ! HEIGHT ABOVE MIDPLANE OF TANGENCY RADIUS
    CXRSTA_pssnpa=replicate(170.0,5)                   ;! RADIUS FROM MACHINE CENTERLINE OF CX PIVOT
    CXYSTA_pssnpa=replicate(0.0,5)             ;! ELEVATION OF PIVOT ABOVE MIDPLANE
    CXZETA_pssnpa=replicate(-88.6,5)/180*!pi+142.38/180.*!pi
                                                       ;! TOROIDAL LOCATION OF PIVOT IN DEGREES
    CXRTAN_pssnpa=[40.,25.,10.,0.,-10.]                ;! CX RTAN (+CO, -CTR)
    CXTHEA_pssnpa=replicate(0.0,5)                 ;! ANGLE OF CHORD ABOVE MIDPLANE IN DEGREES
    CXYTAN_pssnpa=replicate(0.0,5)                     ;! HEIGHT ABOVE MIDPLANE OF TANGENCY RADIUS
    CXTHETA_pssnpa=replicate(0.0,5)  
    nch_pssnpa=n_elements(CXRTAN_pssnpa)
    pssnpap=fltarr(nch_pssnpa,3)             ;detector center position in (u,v,z) (cm)
    pssnpa_mid=fltarr(nch_pssnpa,3)          ;intersection of NPA and midplane in (u,v,z) (cm)
    det_radius_pssnpa=fltarr(nch_pssnpa)     ;radius of NPA dector (cm)  
    
    for iDet=0,nch_pssnpa-1 do begin
        ;detector position in uvz coordinate
        pssnpap[iDet,*]=[CXRSTA_pssnpa[iDet]*cos(CXZETA_pssnpa[iDet]),$
                         CXRSTA_pssnpa[iDet]*sin(CXZETA_pssnpa[iDet]),$
                         CXYSTA_pssnpa[iDet] ]  
        ;intersection of npa detector and midplane in uvz coordinate
        angle=CXZETA_pssnpa[iDet]-signum(CXRTAN_pssnpa[iDet])*$
                                  acos(abs(CXRTAN_pssnpa[iDet])/CXRSTA_pssnpa[iDet]) 
        pssnpa_mid[iDet,*]=[abs(CXRTAN_pssnpa[iDet])*cos(angle),$
                            abs(CXRTAN_pssnpa[iDet])*sin(angle),$
                            tan(CXTHETA_pssnpa[iDet])*$
                            sqrt(CXRSTA_pssnpa[iDet]^2.-CXRTAN_pssnpa[iDet]^2.)+$
                            CXYSTA_pssnpa[iDet] ] 
    endfor
    pssnpa_area=0.01d
    pssnpa_l=2.54d*3.0
    pssnpa_aperture=sqrt(pssnpa_area/!pi)
    
    det_radius_pssnpa=[replicate(sqrt(pssnpa_area/!pi),5)] 
    aperture_radius_pssnpa=[replicate(sqrt(pssnpa_area/!pi),5)]
    dcollimator_pssnpa=[replicate(sqrt(pssnpa_l),5)]     
    
    pssnpa_solid_angle=!pi*aperture_radius_pssnpa^2/dcollimator_pssnpa^2.
    
    
    
    ;CXRSTA=5*170.                   ! RADIUS FROM MACHINE CENTERLINE OF CX PIVOT
    ;CXYSTA=5*0.0                ! ELEVATION OF PIVOT ABOVE MIDPLANE
    ;CXZETA=5*-88.6                  ! TOROIDAL LOCATION OF PIVOT IN DEGREES
    ;CXRTAN=40.,25.,10.,0.,-10.      ! CX RTAN (+CO, -CTR)
    ;CXTHEA=5*0.0                ! ANGLE OF CHORD ABOVE MIDPLANE IN DEGREES
    ;CXYTAN=5*0.0                    ! HEIGHT ABOVE MIDPLANE OF TANGENCY RADIUS
    CXRSTA_nstxu_npa=replicate(190.0,5)                   ;! RADIUS FROM MACHINE CENTERLINE OF CX PIVOT
    CXYSTA_nstxu_npa=replicate(0.0,5)              ;! ELEVATION OF PIVOT ABOVE MIDPLANE
    CXZETA_nstxu_npa=replicate(8.0,5)/180*!pi+142.38/180.*!pi 
                                                       ;! TOROIDAL LOCATION OF PIVOT IN DEGREES
    CXRTAN_nstxu_npa=[120.,100.,90.,80.,70.]                ;! CX RTAN (+CO, -CTR)
    CXTHEA_nstxu_npa=replicate(0.0,5)                  ;! ANGLE OF CHORD ABOVE MIDPLANE IN DEGREES
    CXYTAN_nstxu_npa=replicate(0.0,5)                     ;! HEIGHT ABOVE MIDPLANE OF TANGENCY RADIUS
    CXTHETA_nstxu_npa=replicate(0.0,5)  
    nch_nstxu_npa=n_elements(CXRTAN_nstxu_npa)
    nstxu_npap=fltarr(nch_nstxu_npa,3)             ;detector center position in (u,v,z) (cm)
    nstxu_npa_mid=fltarr(nch_nstxu_npa,3)          ;intersection of NPA and midplane in (u,v,z) (cm)
    det_radius_nstxu_npa=fltarr(nch_nstxu_npa)     ;radius of NPA dector (cm)  
    
    for iDet=0,nch_nstxu_npa-1 do begin
        ;detector position in uvz coordinate
        nstxu_npap[iDet,*]=[CXRSTA_nstxu_npa[iDet]*cos(CXZETA_nstxu_npa[iDet]),$
                            CXRSTA_nstxu_npa[iDet]*sin(CXZETA_nstxu_npa[iDet]),$
                            CXYSTA_nstxu_npa[iDet] ]  
        ;intersection of npa detector and midplane in uvz coordinate
        angle=CXZETA_nstxu_npa[iDet]-signum(CXRTAN_nstxu_npa[iDet])*$
                                  acos(abs(CXRTAN_nstxu_npa[iDet])/CXRSTA_nstxu_npa[iDet]) 
        nstxu_npa_mid[iDet,*]=[abs(CXRTAN_nstxu_npa[iDet])*cos(angle),$
                               abs(CXRTAN_nstxu_npa[iDet])*sin(angle),$
                               tan(CXTHETA_nstxu_npa[iDet])*$
                               sqrt(CXRSTA_nstxu_npa[iDet]^2.-CXRTAN_nstxu_npa[iDet]^2.)+$
                               CXYSTA_nstxu_npa[iDet] ] 
    endfor
    nstxu_npa_area=0.04d
    nstxu_npa_l=26.d
    nstxu_npa_aperture=sqrt(nstxu_npa_area/!pi)
    
    det_radius_nstxu_npa=[replicate(sqrt(nstxu_npa_area/!pi),5)] 
    aperture_radius_nstxu_npa=[replicate(sqrt(nstxu_npa_area/!pi),5)]
    dcollimator_nstxu_npa=[replicate(sqrt(nstxu_npa_l),5)]     
    
    nstxu_npa_solid_angle=!pi*aperture_radius_nstxu_npa^2/dcollimator_nstxu_npa^2.
    
        case npa of 
            'NSTX_NPA': begin 
             ;;Intersection of NPA sightline and midplane
             xlos=npa_mid_nstx[*,0]
             ylos=npa_mid_nstx[*,1]
             zlos=npa_mid_nstx[*,2]
             ;;NPA detector location
             xhead=npap_nstx[*,0]
             yhead=npap_nstx[*,1]
             zhead=npap_nstx[*,2]
             
             nchan=n_elements(xlos)        
             sigma_pi=replicate(1.d0,nchan)
             ra=aperture_radius_nstx ;;aperture radius
             rd=det_radius_nstx      ;;detector radius
             h=dcollimator_nstx      ;;length collimator length
             chan_id=replicate(1.d0,nchan) ;;1 for npa chords
            end
            'NSTXU_TSSNPA': begin       
             ;;Intersection of NPA sightline and midplane
             xlos=tssnpa_mid[*,0]
             ylos=tssnpa_mid[*,1]
             zlos=tssnpa_mid[*,2]
             ;;NPA detector location
             xhead=tssnpap[*,0]
             yhead=tssnpap[*,1]
             zhead=tssnpap[*,2]
             
             nchan=n_elements(xlos)        
             sigma_pi=replicate(1.d0,nchan)
             ra=aperture_radius_tssnpa ;;aperture radius
             rd=det_radius_tssnpa      ;;detector radius
             h=dcollimator_tssnpa      ;;length collimator length
             chan_id=replicate(1.d0,nchan) ;;1 for npa chords
            end
            'NSTXU_RSSNPA': begin       
             ;;Intersection of NPA sightline and midplane
             xlos=rssnpa_mid[*,0]
             ylos=rssnpa_mid[*,1]
             zlos=rssnpa_mid[*,2]
             ;;NPA detector location
             xhead=rssnpap[*,0]
             yhead=rssnpap[*,1]
             zhead=rssnpap[*,2]
             
             nchan=n_elements(xlos)        
             sigma_pi=replicate(1.d0,nchan)
             ra=aperture_radius_rssnpa ;;aperture radius
             rd=det_radius_rssnpa      ;;detector radius
             h=dcollimator_rssnpa      ;;length collimator length
             chan_id=replicate(1.d0,nchan) ;;1 for npa chords
            end
            'NSTXU_PSSNPA': begin       
             ;;Intersection of NPA sightline and midplane
             xlos=pssnpa_mid[*,0]
             ylos=pssnpa_mid[*,1]
             zlos=pssnpa_mid[*,2]
             ;;NPA detector location
             xhead=pssnpap[*,0]
             yhead=pssnpap[*,1]
             zhead=pssnpap[*,2]
             
             nchan=n_elements(xlos)        
             sigma_pi=replicate(1.d0,nchan)
             ra=aperture_radius_pssnpa ;;aperture radius
             rd=det_radius_pssnpa      ;;detector radius
             h=dcollimator_pssnpa      ;;length collimator length
             chan_id=replicate(1.d0,nchan) ;;1 for npa chords
            end
            'NSTXU_NPA': begin      
             ;;Intersection of NPA sightline and midplane
             xlos=nstxu_npa_mid[*,0]
             ylos=nstxu_npa_mid[*,1]
             zlos=nstxu_npa_mid[*,2]
             ;;NPA detector location
             xhead=nstxu_npap[*,0]
             yhead=nstxu_npap[*,1]
             zhead=nstxu_npap[*,2]
             
             nchan=n_elements(xlos)        
             sigma_pi=replicate(1.d0,nchan)
             ra=aperture_radius_nstxu_npa ;;aperture radius
             rd=det_radius_nstxu_npa      ;;detector radius
             h=dcollimator_nstxu_npa      ;;length collimator length
             chan_id=replicate(1.d0,nchan) ;;1 for npa chords
            end     
            else: begin
              print, '% Diagnostic unknown'
              stop
            end
        endcase

    npap = fltarr(nchan,3)
    for i=0,nchan-1 do begin
        npap[i,*] = [xhead[i],yhead[i],zhead[i]]
    endfor

    npa_mid = fltarr(nchan,3)
    for i=0,nchan-1 do begin
        npa_mid[i,*] = [xlos[i],ylos[i],zlos[i]]
    endfor

    a_cent = dblarr(3,nchan)
    a_redge = dblarr(3,nchan)
    a_tedge = dblarr(3,nchan)
    d_cent = dblarr(3,nchan)
    d_redge = dblarr(3,nchan)
    d_tedge = dblarr(3,nchan)
    radius = dblarr(nchan)    
    id = strarr(nchan)    
    for i=0,nchan-1 do begin
        r0 = reform(npap[i,*])
        v0 = reform(npa_mid[i,*]) - r0
        v0 = v0/sqrt(total(v0*v0))
        basis = line_basis(r0,v0)
        a_cent[*,i] = basis##[0.0, 0.0, 0.0] + r0
        a_redge[*,i] = basis##[0.0, ra[i], 0.0] + r0
        a_tedge[*,i] = basis##[0.0, 0.0, ra[i]] + r0
        d_cent[*,i] = basis##[-h[i], 0.0, 0.0] + r0
        d_redge[*,i] = basis##[-h[i], ra[i], 0.0] + r0
        d_tedge[*,i] = basis##[-h[i], 0.0, ra[i]] + r0
        radius[i] = sqrt(xhead[i]^2 + yhead[i]^2)
        id[i] = 'c' + strtrim(i,2)
    endfor
    a_shape = replicate(2,nchan)
    d_shape = replicate(2,nchan)

    return, {nchan:nchan,system:npa[0],data_source:source_file(),$
             id:id, radius:radius,a_shape:a_shape,d_shape:d_shape,$
             d_cent:d_cent,d_redge:d_redge,d_tedge:d_tedge, $
             a_cent:a_cent,a_redge:a_redge,a_tedge:a_tedge}

END
