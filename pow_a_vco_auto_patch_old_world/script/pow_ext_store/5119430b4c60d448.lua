
pow_ext_diag = pow_ext_diag or {}

function pow_ext_diag.emit(category, event_name, data)
    local h = pow_ext_diag.handler
    if h then h(category, event_name, data) end
end
