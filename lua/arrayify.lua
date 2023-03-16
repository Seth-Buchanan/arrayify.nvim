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
	local filetype = vim.bo.filetype

	-- Defualt Array symbols
	syntax["brackets"] = { "[", "]" }
	syntax["deliniator"] = ", "
	syntax["keywords"] = { "True", "False" }
	syntax["quote"] = '"'
	syntax["pattern"] = "standard"
	-- TODO: look into using a "map" for storing defualts

	-- Changes to the Defualt symbols by file extention
	-- Lua
	if filetype == "lua" then
		syntax["brackets"] = { "{", "}" }
		syntax["keywords"] = { "true", "false" }

		-- Java
	elseif filetype == "java" then
		syntax["brackets"] = { "{", "};" }
		syntax["keywords"] = { "true", "false" }

		-- Python
	elseif filetype == "python" then
		syntax["quote"] = "'"

		-- PowerShell
	elseif filetype == "ps1" then
		syntax["brackets"] = { "@(", ")" }
		syntax["quote"] = "'"
		syntax["keywords"] = {}

		-- DOS Batch
	elseif filetype == "dosbatch" then
		syntax["brackets"] = { "", "" }
		syntax["deliniator"] = " "
		syntax["keywords"] = {}

		-- Fortran
	elseif filetype == "fortran" then
		syntax["brackets"] = { "(/", "/)" }
		syntax["deliniator"] = ","
		syntax["quote"] = "'"
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
function WriteAfterCursor(str)
	local pos = vim.api.nvim_win_get_cursor(0)[2]
	local line = vim.api.nvim_get_current_line()
	local newline = line:sub(0, pos + 1) .. str .. line:sub(pos + 2)
	vim.api.nvim_set_current_line(newline)
end
