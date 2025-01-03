local M = {}

local text = "[schemes.nvim] %s in function %s: %s\n"

--- Report an error
---@param source Function where error holds
---@param message Error message
M.report_error = function(source, message)
	if type(source) ~= "string" then
		M.report_error("report_error(source, message)", "\"source\" argument must be a \"string\"")
	elseif type(message) ~= "string" then
		M.report_error("report_error(source, message)", "\"message\" argument must be a \"string\"")
	else
		vim.api.nvim_echo({{text:format("Error", source, message), "ErrorMsg"}}, true, {})
	end
end

--- Report a warning
---@param source Function where warning holds
---@param message Warning message
M.report_warning = function(source, message)
	if type(source) ~= "string" then
		M.report_error("report_warning(source, message)", "\"source\" argument must be a \"string\"")
	elseif type(message) ~= "string" then
		M.report_error("report_warning(source, message)", "\"message\" argument must be a \"string\"")
	else
		vim.api.nvim_echo({{text:format("Warning", source, message), "WarnMsg"}}, true, {})
	end
end

return M
