FUNCTION nstx_inputs
    shot = 141648L
    time = 0.770d0
    transp_file = '/p/transparch/result/NSTX/10/141648H09.CDF'
    geqdsk_file = '/p/fida/lstagner/NSTX/g141648.00770'
    dist_file = '/p/fida/lstagner/NSTX/141648E01_fi_3.cdf'
    dist_type = 'nubeam'
    e_range = [0.0, 100.0]
    p_range = [-1.0, 1.0]    
    result_dir = '/p/fida/lstagner/NSTX/'
    spec_diag = ['ACTIVE_VFIDA']
    npa_diag = ['NSTX_NPA']
    beam = 'nb_1b'
    pinj = 1.98d0
    einj = 90.47d0
    comment = 'TEST shot'
    runid='141648.00770'
    inputs = vars_to_struct()
    return, inputs
END
