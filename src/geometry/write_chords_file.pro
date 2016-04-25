PRO write_chords_file

    avfida = active_vfida()
    pvfida = passive_vfida()
    atfida = active_tfida()
    ptfida = passive_tfida()


    calib_2016 = {active_vfida:avfida,passive_vfida:pvfida,$
                  active_tfida:atfida,passive_tfida:ptfida}

    chords = {calib_2016:calib_2016} ;need to nest in structure to preserve tree

    write_hdf5,chords, filename = "nstx_chords.h5",/clobber

    id = h5f_open("./nstx_chords.h5",/write)
    h5g_link,id,"calib_2016","default",/softlink
    h5f_close,id

END
