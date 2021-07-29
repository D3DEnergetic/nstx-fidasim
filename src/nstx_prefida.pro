PRO nstx_prefida, inputs, igrid=igrid,bgrid=bgrid

   profile_dir = file_dirname(source_file())
   fida_dir = GETENV('FIDASIM_DIR')
   basic_inputs = {device:'NSTX',$
                   ab:2.01410178d0,ai:2.0141078d0,impurity_charge:6,$
                   lambdamin:647.0d0,lambdamax:667.0d0,nlambda:2000,$
                   n_fida:5000000L,n_npa:500000L,n_nbi:50000L, $
                   n_pfida:50000000L,n_pnpa:50000000L, $
                   n_halo:500000L,n_dcx:500000L,n_birth:10000L,$
                   ne_wght:50,np_wght:50,nphi_wght:100,emax_wght:100.0d0,$
                   nlambda_wght:1000,lambdamin_wght:647.d0,lambdamax_wght:667.d0,$
                   calc_npa:0,calc_brems:0,calc_fida:0,calc_neutron:0,calc_cfpd:0,$
                   calc_bes:0,calc_dcx:0,calc_halo:0,calc_cold:0,$
                   calc_birth:0,calc_fida_wght:0,calc_npa_wght:0,calc_pfida:0,calc_pnpa:0,$
                   adaptive:0,split_tol:0.d0,max_cell_splits:1,$
                   install_dir:fida_dir,tables_file:fida_dir+'/tables/atomic_tables.h5'}

    if not keyword_set(igrid) then begin
        igrid = rz_grid(40.d0,150.d0,55,-130.d0,130.d0,130)
    endif

    if not keyword_set(bgrid) then begin
        if total(strmatch(['nb_1a','nb_1b','nb_1c'],inputs.beam,/fold_case)) gt 0 then begin
            nbi_1b = nstx_beams('nb_1b')
            bgrid = beam_grid(nbi_1b,150.d0)
        endif else begin
            nbi_2b = nstx_beams('nb_2b')
            bgrid = beam_grid(nbi_2b,150.d0)
        endelse
    endif

    cfracs = current_fractions(inputs.einj)
    inputs = create_struct(inputs,basic_inputs,bgrid,"current_fractions",cfracs)

    nbi = nstx_beams(inputs.beam)

    w = where("spec_diag" eq strlowcase(TAG_NAMES(inputs)), nw)
    if nw ne 0 then begin
        if n_elements(inputs.spec_diag) ne 0 then begin
            spec = nstx_chords(inputs.spec_diag)
            inputs.calc_fida = 1
            inputs.calc_bes = 1
            inputs.calc_brems = 1
            inputs.calc_halo = 1
            inputs.calc_dcx = 1
        endif
    endif

    w = where("npa_diag" eq strlowcase(TAG_NAMES(inputs)),nw)
    if nw ne 0 then begin
        if n_elements(inputs.npa_diag) ne 0 then begin
            npa = nstx_npa(inputs.npa_diag)
            inputs.calc_npa = 1
        endif
    endif

    fields = read_geqdsk(inputs.geqdsk_file,igrid,rho=rho,g=g,btipsign=btipsign)
    fields.time *= 1.d-3 ;[s]
    plasma = extract_transp_plasma(inputs.transp_file,fields.time,igrid,rho)

    case strlowcase(inputs.dist_type) of
        'nubeam': dist = read_nubeam(inputs.dist_file,igrid,btipsign=btipsign)
        'mc_nubeam': dist = read_mc_nubeam(inputs.dist_file,btipsign=btipsign,$
                     ntotal=inputs.ntotal,e_range=inputs.e_range,p_range=inputs.p_range) 
        'spiral': dist = read_spiral(inputs.dist_file,btipsign=btipsign,ntotal=inputs.ntotal)
    endcase

    prefida,inputs,igrid,nbi,plasma,fields,dist,spec=spec,npa=npa

END
