PRO nstx_prefida, inputs, inter_grid=inter_grid,beam_grid=beam_grid

   profile_dir = file_dirname(source_file())
   fida_dir = GETENV('FIDASIM_DIR')
   basic_inputs = {device:'NSTX',$
                   ab:2.01410178d0,ai:2.0141078d0,impurity_charge:6,$
                   lambdamin:647.0d0,lambdamax:667.0d0,nlambda:2000,$
                   n_fida:5000000L,n_npa:500000L,n_nbi:50000L, $
                   n_halo:500000L,n_dcx:500000L,n_birth:10000L,$
                   ne_wght:50,np_wght:50,nphi_wght:100,emax_wght:100.0d0,$
                   nlambda_wght:1000,lambdamin_wght:647.d0,lambdamax_wght:667.d0,$
                   calc_npa:0,calc_brems:1,calc_bes:1,calc_fida:1,$
                   calc_birth:1,calc_fida_wght:1,calc_npa_wght:0,$
                   load_neutrals:0,dump_dcx:0,verbose:1,$
                   install_dir:fida_dir,tables_file:fida_dir+'/tables/atomic_tables.h5'}

    if not keyword_set(inter_grid) then begin
        inter_grid = rz_grid(40.d0,150.d0,55,-130.d0,130.d0,130)
    endif

    if not keyword_set(beam_grid) then begin
        if total(strmatch(['nb_1a','nb_1b','nb_1c'],inputs.beam,/fold_case)) gt 0 then begin
            nbi_1b = nstx_beams('nb_1b')
            beam_grid = beam_grid(nbi_1b,150.d0)
        endif else begin
            nbi_2b = nstx_beams('nb_2b')
            beam_grid = beam_grid(nbi_2b,150.d0)
        endelse
    endif
    species_mix = current_fractions(inputs.einj)
    inputs = create_struct(inputs,basic_inputs,beam_grid,"species_mix",species_mix)

    nbi = nstx_beams(inputs.beam)
    if n_elements(inputs.spec_diag) ne 0 and inputs.spec_diag ne '' then begin
        spec = nstx_chords(inputs.spec_diag)
    endif

    fields = read_geqdsk(inputs.geqdsk_file,inter_grid,flux=flux,g=g)
    plasma = extract_transp_plasma(inputs.transp_file,inputs.time,inter_grid,flux,profiles=prof)

    case strlowcase(inputs.dist_type) of
        'nubeam': dist = read_nubeam(inputs.dist_file,inter_grid,btipsign=inputs.btipsign) 
        'spiral': dist = read_spiral(inputs.dist_file,btipsign=inputs.btipsign)
    endcase

    prefida,inputs,inter_grid,nbi,plasma,fields,dist,spec=spec

END
