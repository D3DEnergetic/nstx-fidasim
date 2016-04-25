FUNCTION vars_to_struct,vars=vars,level=level
    ;; struct_from_list
    ;; creates structure from list of variables in specified scope
    ;; if vars not set then use all valid variables in specified scope
    if not keyword_set(level) then level=-1
    if not keyword_set(vars) then vars = scope_varname(level=level)

    nvars = n_elements(vars)

    for i=0,nvars-1 do begin
        catch, err_status
        if err_status ne 0 then begin
            catch,/cancel
            continue
        endif
        var = scope_varfetch(vars[i],level=level)
        if n_elements(var) ne 0 then begin
           if i eq 0 then begin
               s = create_struct(vars[i],var)
           endif else begin
               s = create_struct(s,vars[i],var)
           endelse
        endif
    endfor
    
    if nvars eq 1 and size(s.(0),/tname) eq 'STRUCT' then begin
        s = s.(0)
    endif
    return, s
END
