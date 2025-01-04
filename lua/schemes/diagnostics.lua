local M = {}

local text = "[schemes.nvim] %s in function %s: %s\n"

M.ERROR = "Error"
M.WARNING = "Warning"

--- Create a diagnostic message
---@param message Diagnostic text
---@param code Diagnostic type
---@return Diagnostic
M.create = function(text, code)
	return {
		text = text,
		code = code,
	}
end

--- Report an diagnostic message
---@param source Function where diagnostic is reported
---@param message Diagnostic message
M.report = function(source, message)
	if message.code == M.ERROR then
		vim.api.nvim_echo({{text:format(M.ERROR, source, message.text), "ErrorMsg"}}, true, {})
	elseif message.code == M.WARNING then
		vim.api.nvim_echo({{text:format(M.WARNING, source, message.text), "WarningMsg"}}, true, {})
	end
end

return M
