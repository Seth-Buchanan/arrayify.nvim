vim.api.nvim_create_user_command("Arrayify", function()
	local syntax = SetSyntax()

	if syntax["pattern"] == "standard" then
		local input = Input()
		local output = StandardFormat(input, syntax)
		WriteAfterCursor(output)
	else
		print("pattern not defined")
	end
end, {})

-- Standard function that follows that pattern:
-- Bracket, quote, element, quote, deliniator, quote, element, quote, Bracket
function Input()
	local inputArray = {}
	while true do
		local input = vim.fn.input("Element: ")
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
		if IsNotInteger(input) and not InList(syntax["keywords"], input) then
			input = string.format("%s%s%s", syntax["quote"], input, syntax["quote"])
		end
		output = string.format("%s%s%s", output, input, syntax["deliniator"])
	end
	-- chops off the last deliniator
	output = output:sub(1, #output - string.len(syntax["deliniator"]))
	return output .. syntax["brackets"][2]
end

function SetSyntax()
    local syntax = {}
	syntax["brackets"] = { "[", "]" }
	syntax["deliniator"] = ", "
	syntax["keywords"] = { "True", "False" }
	syntax["quote"] = '"'
	syntax["pattern"] = "standard"

    -- For each filetype in arrayify.nvim/ftplugin there is a file with 
    -- the special syntax for each filetype. This checks if the ChangeSyntax
    -- function exists for the current filetype and returns syntax if it exists
    vim.opt.filetype = GetBufferFiletype()

    if (_G["ChangeSyntax"] ~= nil) then
         syntax = ChangeSyntax(syntax)
    end
	return syntax
end

function GetBufferFiletype()
    local current_buffer = vim.api.nvim_get_current_buf()
    local filetype = vim.api.nvim_buf_get_option(current_buffer, 'filetype')
    return filetype
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
function WriteAfterCursor(str)
	local pos = vim.api.nvim_win_get_cursor(0)[2]
	local line = vim.api.nvim_get_current_line()
	local newline = line:sub(0, pos + 1) .. str .. line:sub(pos + 2)
	vim.api.nvim_set_current_line(newline)
end
