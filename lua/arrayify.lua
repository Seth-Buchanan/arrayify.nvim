vim.api.nvim_create_user_command("Arrayify", function ()

    local syntax = SetSyntax()

    local input = Input()
    if syntax["pattern"] == "standard" then
        local output = StandardFormat(input, syntax)
        WriteAfterCursor(output)
    else if syntax["pattern"] == "java" then
        local output = JavaIsAnnoying(input, syntax)
        WriteAfterCursor(output)
    else
        print "pattern not defined"
    end
end

end, {})

-- Standard function that follows that pattern:
-- Bracket, quote, element, quote, deliniator, quote, element, quote, Bracket
function Input()
    local inputArray = {}
    while(true) do
        local input = vim.fn.input "Element: "
        if input == "" then
            break
        else
            table.insert(inputArray, input)
        end
    end
    return inputArray
end

function StandardFormat(inputArray, syntax)
    local output = syntax["brackets"][1]

    for _, input in ipairs(inputArray) do
        if not IsInteger(input) and not InList(syntax["keywords"], input) then
            input = string.format("%s%s%s",
            syntax["quote"], input, syntax["quote"])
        end
        output = string.format("%s%s%s", output, input, syntax["deliniator"])
    end
    output =  output:sub(1, #output - string.len(syntax["deliniator"]))
    return output .. syntax["brackets"][2]
end

function JavaIsAnnoying(inputArray, syntax)
    local output = syntax["brackets"][1]
    local type = nil
    local highestBits = 0

    if IsInteger(inputArray[1]) then
        type = "int"
    elseif InList(syntax["keywords"], inputArray[1]) then
        type = syntax["types"][2]
    else
        type = syntax["types"][3]
    end

    for _, input in ipairs(inputArray) do
        if type == "int" then
            local bits = GiveBits(input)
            if highestBits < bits then
                highestBits = bits
            end
        end
        if not IsInteger(input) and not InList(syntax["keywords"], input) then
            input = string.format("%s%s%s",
            syntax["quote"], input, syntax["quote"])
        end
        output = string.format("%s%s%s", output, input, syntax["deliniator"])
    end

    output = output:sub(1, #output - string.len(syntax["deliniator"]))
    return string.format("%s[] array = new %s[]%s%s",
    type, type, output, syntax["brackets"][2])
end

-- returns the number of bits in a number
function GiveBits(number)
    local bits = math.floor(math.log(2,number)) + 1
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
        syntax["types"]     = {{}, "boolean", "String"}
        syntax["types"][1]["8"] = "Byte"
        syntax["types"][1]["16"] = "Short"
        syntax["types"][1]["32"] = "Int"
        syntax["types"][1]["64"] = "Long"
        syntax["pattern"]   = "typeCasted"

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
function IsInteger(str)
    return not (str == "" or str:find("%D"))
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
function WriteAfterCursor(str)
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local newline = line:sub(0, pos + 1 ) .. str .. line:sub(pos + 2)
  vim.api.nvim_set_current_line(newline)
end

