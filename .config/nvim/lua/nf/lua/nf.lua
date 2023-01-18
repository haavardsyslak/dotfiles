local fietype = vim.bo.filetype

local config = {
    author = "Håvard Syslak";
    date = os.date("%d.%m.%Y");
}

-- TODO: use find to find src folder like in nf_h()
local cwd = vim.fn.getcwd()

local function nf_c(Filename) 
    if Filename == nil then
        print("Filename cannot be nil\n")
        return
    end

    local buf = string.format(
    "/**\n" ..
    "* @author %s\n" ..
    "* @date %s\n" ..
    "*/\n\n", config.author, config.author)

    local path = cwd .. "/" .. Filename .. ".c"
    print(path)
    
    local file = io.open(path, "r")
    if file ~= nil then
         print("file exists")
         file:close()
         return
    end

    file:close()
    file = io.open(path, "w")
    if file == nil then
        return
    end

    file:write(buf)
    file:close()

    if prompt_headder() then
        nf_h()
    end
end


local function prompt_headder()
    local inn = string.lower(vim.fn.input("Create headdr file? [Y/n]"))
    if inn == "y" or inn == "yes" or inn == "" then
        return True
    else
        return False
    end

end


local function open_file()
    vim.api.nvim_command(string.format("edit %s", path))
    vim.api.nvim_command(":$")
end


local function find_headder_path(pattern)
    local command = "find" .. " -type d -iname include"
    print(command)
    local dirs = io.popen(command)
    local path
    local n = 999
    for i in dirs:lines() do
        local count = 0
        for _ in string.gmatch(i, "/") do
            count = count + 1
        end
        if count < n then
            n = count
            path = i
        end
    end
    dirs:close()
    return path
end

function nf_h(Filename)
    local path = find_headder_path()
    local def = string.upper() .. "_H"
    local buf = string.format(
    "/**\n" ..
    "* @author %s\n" ..
    "* @date %s\n" ..
    "*/\n\n"..
    "#ifndef %s\n" ..
    "#define %s\n\n" ..
    "endif", config.author, config.author, def, def)

    print(path)

    local file = io.open(path, "r")
    if file ~= nil then
         print("error " .. path .. " exists")
         file:close()
         return
    end

    file:close()
    file = io.open(path, "w")
    if file == nil then
        return
    end

    file:write(buf)
    file:close()


end
