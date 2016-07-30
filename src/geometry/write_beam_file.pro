PRO write_beam_file

    beam1A = {NAME:'1A', NBSHAP:1, $
              FOCLZ:988.d0, FOCLR:988.d0, $
              DIVZ:1.36d-2, DIVR:4.94d-3, $
              BMWIDZ:21.5d0,BMWIDR: 6.d0, $
              RTCENA:69.3d0,XLBAPA:[5.103d2],$
              XLBTNA:1.1307d3,XBZETA:5.691d1,$
              XYBAPA:0.d0,XYBSCA:0.d0,NLCO:1,$
              NBAPSHA:[1], RAPEDGA:[11.d0], XZPEDGA:[30.25d0],$
              XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }
 
    beam1B = {NAME:'1B', NBSHAP:1, $
              FOCLZ:988.d0, FOCLR:988.d0, $
              DIVZ:1.36d-2, DIVR:4.94d-3, $
              BMWIDZ:21.5d0,BMWIDR: 6.d0, $
              RTCENA:59.1d0,XLBAPA:[5.103d2],$
              XLBTNA:1.1352d3,XBZETA:6.038d1,$
              XYBAPA:0.d0,XYBSCA:0.d0,NLCO:1,$
              NBAPSHA:[1], RAPEDGA:[11.d0], XZPEDGA:[30.25d0],$
              XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }
  
    beam1C = {NAME:'1C', NBSHAP:1, $
              FOCLZ:988.d0, FOCLR:988.d0, $
              DIVZ:1.36d-2, DIVR:4.94d-3, $
              BMWIDZ:21.5d0,BMWIDR: 6.d0, $
              RTCENA:48.7d0,XLBAPA:[5.103d2],$
              XLBTNA:1.1389d3,XBZETA:6.385d1,$
              XYBAPA:0.d0,XYBSCA:0.d0,NLCO:1,$
              NBAPSHA:[1], RAPEDGA:[11.d0], XZPEDGA:[30.25d0],$
              XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    beam2A = {NAME:'2A', NBSHAP:1, $
              FOCLZ:988.d0, FOCLR:988.d0, $
              DIVZ:1.36d-2, DIVR:4.94d-3, $
              BMWIDZ:21.5d0,BMWIDR: 6.d0, $
              RTCENA:1.299d2,XLBAPA:[5.103d2],$
              XLBTNA:1.1253d3,XBZETA:1.0309d2,$
              XYBAPA:0.d0,XYBSCA:0.d0,NLCO:1,$
              NBAPSHA:[1], RAPEDGA:[11.d0], XZPEDGA:[30.25d0],$
              XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    beam2B = {NAME:'2B', NBSHAP:1, $
              FOCLZ:988.d0, FOCLR:988.d0, $
              DIVZ:1.36d-2, DIVR:4.94d-3, $
              BMWIDZ:21.5d0,BMWIDR: 6.d0, $
              RTCENA:1.20d2,XLBAPA:[5.103d2],$
              XLBTNA:1.134d3,XBZETA:1.0654d2,$
              XYBAPA:0.d0,XYBSCA:0.d0,NLCO:1,$
              NBAPSHA:[1], RAPEDGA:[11.d0], XZPEDGA:[30.25d0],$
              XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    beam2C = {NAME:'2C', NBSHAP:1, $
              FOCLZ:988.d0, FOCLR:988.d0, $
              DIVZ:1.36d-2, DIVR:4.94d-3, $
              BMWIDZ:21.5d0,BMWIDR: 6.d0, $
              RTCENA:1.095d2,XLBAPA:[5.103d2],$
              XLBTNA:1.142d3,XBZETA:1.0998d2,$
              XYBAPA:0.d0,XYBSCA:0.d0,NLCO:1,$
              NBAPSHA:[1], RAPEDGA:[11.d0], XZPEDGA:[30.25d0],$
              XRAPOFFA:[0.d0], XZAPOFFA:[0.d0] }

    nb_1a = nubeam_geometry(beam1A)
    nb_1b = nubeam_geometry(beam1B)
    nb_1c = nubeam_geometry(beam1C)
    nb_2a = nubeam_geometry(beam2A)
    nb_2b = nubeam_geometry(beam2B)
    nb_2c = nubeam_geometry(beam2C)

    calib_2016 = {nb_1a:nb_1a,nb_1b:nb_1b,nb_1c:nb_1c,$
                  nb_2a:nb_2a,nb_2b:nb_2b,nb_2c:nb_2c}
    beams = {calib_2016:calib_2016} ;need to nest in structure to preserve tree

    write_hdf5,beams, filename = "nstx_beams.h5",/clobber

    id = h5f_open("./nstx_beams.h5",/write)
    h5g_link,id,"calib_2016","default",/softlink
    h5f_close,id

END

