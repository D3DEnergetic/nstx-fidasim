FUNCTION current_fractions, einj, power=power, verbose=verbose
    ; Calculates current fractions

    denergy = [0., 80., 100.,  120., 200.]
    dmix1 = [0.467, 0.467, 0.440, 0.392, 0.392]
    dmix2 = [0.374, 0.374, 0.386, 0.395, 0.395]
    dmix3 = [0.159, 0.159, 0.174, 0.213, 0.213]

    curfrc = dblarr(3)
    ; Interpolate beam current fraction for deuterium
    curfrc[0] = interpol(dmix1, denergy, einj)
    curfrc[1] = interpol(dmix2, denergy, einj)
    curfrc[2] = interpol(dmix3, denergy, einj)

    powfrc = [curfrc[0], curfrc[1]/2.0, curfrc[2]/3.0]
    powfrc = powfrc/total(powfrc)

    if keyword_set(verbose) then begin
        print,'current fractions: ',curfrc 
        print,'power fractions: ',powfrc
    endif

    if keyword_set(power) then begin
        species_mix = powfrc
    endif else begin
        species_mix = curfrc
    endelse

    return, species_mix

END
