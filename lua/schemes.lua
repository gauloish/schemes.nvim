local parser = require("schemes.parser")
local selector = require("schemes.selector")
local diagnostics = require("schemes.diagnostics")

local M = {}

--- Setup schemes.nvim plugin
---@param options Plugin options
M.setup = function(options)
	local result = parser.parse_options(options)
	local messages

	messages = result.messages
	options = result.options

	table.sort(messages, function(a, b)
		return a.code < b.code
	end)

	for _, message in pairs(messages) do
		diagnostics.report("setup(options)", message)
	end

	selector.setup(options)
end

return M
