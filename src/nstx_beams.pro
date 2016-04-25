FUNCTION nstx_beams,beam,calib=calib

    geo_file = file_dirname(source_file())+'/geometry/nstx_beams.h5'
    if not keyword_set(calib) then begin
        c = read_hdf5(geo_file,paths = "default",/shallow)
        calib=strlowcase(tag_names(c))
    endif else begin
        calib=strlowcase(calib)
        c = read_hdf5(geo_file,paths=calib,/shallow)
    endelse
    cc = c.(0)

    avail_beams = strlowcase(tag_names(cc))
    beam = strlowcase(beam)

    data_source = geo_file+':'+calib[0]
    w = where(beam eq avail_beams,nw)
    if nw eq 0 then begin
        error,'Beam '+beam+' is not available for calibration '+calib,/halt
    endif
    nbi = cc.(w)
    nbi.data_source = data_source

    return, nbi
END
