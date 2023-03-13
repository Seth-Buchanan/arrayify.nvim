vim.api.nvim_create_user_command("Arrayify", function ()

    local syntax = SetSyntax()

    if syntax["pattern"] == "standard" then
        local output = Standard(syntax)
        WriteAtCursor(output)
    else
        print "pattern not defined"
    end

end, {})

-- Standard function that follows that pattern:
-- Bracket, quote, element, quote, deliniator, quote, element, quote, Bracket
function Standard(syntax)
    local output = syntax["brackets"][1]
    while(true)
        do
            local input = vim.fn.input "Element: "
            if input == "" then
                break
            elseif IsNotInteger(input) and not InList(syntax["keywords"], input) then
                input = string.format("%s%s%s",
                syntax["quote"], input, syntax["quote"])
            end
            output = string.format("%s%s%s", output, input, syntax["deliniator"])
        end
        -- Chops off the extra deliniator at end of string
        output = output:sub(1, #output - string.len(syntax["deliniator"]))
        return (output .. syntax["brackets"][2])
end

function SetSyntax()
    local syntax = {}
    local filetype = vim.fn.expand("%:e")

    -- Defualt Array symbols
    syntax["brackets"]      = {"[", "]"}
    syntax["deliniator"]    = ", "
    syntax["keywords"]      = {"True", "False"}
    syntax["quote"]         = "\""
    syntax["pattern"]       = "standard"

    -- Changes to the Defualt symbols by file extention
    -- Lua
    if filetype == "lua" then
        syntax["brackets"]  = { "{", "}" }
        syntax["keywords"]  = {"true", "false"}

    -- Java
    elseif filetype == "java" then
        syntax["brackets"]  = { "{", "};" }
        syntax["keywords"]  = {"true", "false"}

    -- Python
    elseif filetype == "py" then
        syntax["quote"]     = "\'"

    -- PowerShell
    elseif filetype == "ps1" then
        syntax["brackets"]  = { "@(", ")" }
        syntax["quote"]     = "\'"
        syntax["keywords"]  = {}

    -- DOS Batch
    elseif filetype == "bat" then
        syntax["brackets"]  = { "", "" }
        syntax["deliniator"]    = " "
        syntax["keywords"]  = {}

    -- Fortran
    elseif InList({"f90", "f95", "f03"}, filetype) then
        syntax["brackets"]  = { "(/", "/)" }
        syntax["deliniator"]    = ","
        syntax["quote"]     = "\'"
    end
    return syntax
end

-- returns true if string contains anything other than an integer
function IsNotInteger(str)
    return (str == "" or str:find("%D"))
end

-- Iterator function that sees if "str" is in "array"
function InList(array, str)
    for _, element in ipairs(array) do
        if element == str then
            return true
        end
    end
    return false
end

-- Finds where cursor is currently and prints output there
function WriteAtCursor(str)
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(0, pos + 1 ) .. str .. line:sub(pos + 2)
  vim.api.nvim_set_current_line(nline)
end
