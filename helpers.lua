local helpers = {}

function helpers.serialize(data)
    local chunks = {'return {'}
    for k, v in pairs(data) do
        local val = type(v) == 'string' and string.format('%q', v) or tostring(v)
        table.insert(chunks, string.format('  [%q] = %s,', tostring(k), val))
    end
    table.insert(chunks, '}')
    return table.concat(chunks, '\n')
end

function helpers.deserialize(raw)
    local func, err = load(raw)
    if not func then return nil, err end
    return func()
end

function helpers.sanitize_path(path)
    local clean = string.gsub(path, '[^%w%./_-]', '')
    return './data/' .. clean .. '.lua'
end

function helpers.save_profile(name, cfg)
    local file = io.open(helpers.sanitize_path(name), 'w')
    if file then
        file:write(helpers.serialize(cfg))
        file:close()
        return true
    end
    return false
end

return helpers