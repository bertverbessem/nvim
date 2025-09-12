-- Metadata
-- languages: sshconfig

-- Smart SSH config formatter
return {
    formatCommand = [[lua -e "
local indent = '    ' -- 4 spaces
local current_host = false
for line in io.read('*all'):gmatch('[^\r\n]*\n?') do
    local stripped = line:gsub('^%s+', '')  -- remove leading spaces
    if stripped:match('^Host%s') then
        current_host = true
        io.write(stripped)  -- Host flush left
    elseif stripped == '' then
        io.write(line)      -- preserve empty lines
    else
        -- indent lines under Host, preserve comments
        if current_host then
            io.write(indent .. stripped)
        else
            io.write(stripped)
        end
    end
end
"]],
    formatStdin = true,
}

