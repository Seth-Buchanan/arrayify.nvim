function ChangeSyntax(syntax)
	syntax["brackets"] = { "@(", ")" }
	syntax["quote"] = "'"
	syntax["keywords"] = {}
	return syntax
end
