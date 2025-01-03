local parser = require("schemes.parser")
local selector = require("schemes.diagnostics")
local diagnostics = require("schemes.diagnostics")

local M = {}

--- Setup schemes.nvim plugin
---@param options Plugin options
M.setup = function(options)
	local result = parser.parse_options(options)
	local messages

	messages = result.messages
	options = result.options

	for _, message in pairs(messages) do
		diagnostics.report("setup(options)", message)
	end

	selector.setup(option)
end

return M
