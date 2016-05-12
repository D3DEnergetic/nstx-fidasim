FUNCTION nstx_chords, diags, calib=calib

    geo_file = file_dirname(source_file())+'/geometry/nstx_chords.h5'
    if not keyword_set(calib) then begin
        c = read_hdf5(geo_file,paths = "default",/shallow)
        calib=strlowcase(tag_names(c))
    endif else begin
        calib=strlowcase(calib)
        c = read_hdf5(geo_file,paths=calib,/shallow)
    endelse
    cc = c.(0)

    avail_diags = strlowcase(tag_names(cc))
    diags = strlowcase(diags)

    data_source = geo_file+':'+calib[0]
    nchan = 0
    system = []
    axis = []
    lens = []
    radius = []
    sigma_pi = []
    spot_size = []
    id = []
    for i=0,n_elements(diags)-1 do begin
        w = where(diags[i] eq avail_diags,nw)
        if nw eq 0 then begin
            error,diags[i]+' is not available for calibration '+calib
            continue
        endif
        system = [system, cc.(w).system]
        nchan = nchan + cc.(w).nchan
        id = [id,cc.(w).system+'_'+strcompress(string(indgen(cc.(w).nchan)),/remove_all)]
        axis = [[axis],[cc.(w).axis]]
        lens = [[lens],[cc.(w).lens]]
        radius = [radius,cc.(w).radius]
        sigma_pi = [sigma_pi,cc.(w).sigma_pi]
        spot_size = [spot_size,cc.(w).spot_size]
    endfor

    if nchan eq 0 then begin
        error,'No valid FIDA/BES systems selected',/halt
    endif
    return, {system:strjoin(system,", ",/single),data_source:data_source, $
             id:id, nchan:nchan,axis:axis,lens:lens,$
             radius:radius,sigma_pi:sigma_pi,spot_size:spot_size}

END
