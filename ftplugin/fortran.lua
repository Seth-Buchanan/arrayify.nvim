function ChangeSyntax(syntax)
	syntax["brackets"] = { "(/", "/)" }
	syntax["deliniator"] = ","
	syntax["quote"] = "'"
	return syntax
end
