local diagnostics = require("schemes.diagnostics")

local M = {}

--- File path to save scheme
M.FILE = vim.fn.stdpath("data") .. "/.scheme"
M.current = nil

--- Format name and background scheme
---@param name Name scheme
---@param background Background scheme
---@return Formatted string with name and background scheme
M.format = function(name, background)
	return ("%s: %s"):format(name, background:gsub("^%l", string.upper))
end

--- Change current scheme
---@param scheme Scheme
---@return Operation status
M.change = function(scheme)
	if scheme.background == "light" then
		vim.opt.background = "light"
	else
		vim.opt.background = "dark"
	end

	if M.current then
		if not pcall(M.before, M.current) then
			diagnostics.report(
				diagnostics.create(
					"before(scheme)",
					"an error occurs during execution of funtion 'before'"
				),
				diagnostics.WARNING
			)
		end
	end

	local ok = pcall(scheme.command)

	if ok then
		if not pcall(M.after, scheme) then
			diagnostics.report(
				diagnostics.create(
					"after(scheme)",
					"an error occurs during execution of funtion 'after'"
				),
				diagnostics.WARNING
			)
		end
	else
		diagnostics.report(
			diagnostics.create(
				"command()",
				"an error occurs during execution of funtion 'command'"
			),
			diagnostics.ERROR
		)
	end

	return ok
end

--- Change and save scheme
---@param key Scheme key
M.save = function(key)
	if key and M.schemes[key] then
		local file = io.open(M.FILE, "w")

		if file then
			if M.change(M.schemes[key]) then
				file:write(key)

				vim.print("Scheme: " .. M.schemes[key].name)
			end

			file:close()
		end
	elseif M.default then
		pcall(os.remove, M.FILE)
		M.change(M.default)
	else
		-- ...
	end
end

--- initialize scheme
M.initialize = function()
	local file = io.open(M.FILE, "r")
	local key = nil

	if file then
		key = file:read()
		file:close()
	end
	
	M.save(key)
end

--- Create a telescope picker for schemes
---@return The telescope picker for schemes
M.selector = function()
	local actions = require("telescope.actions")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")

	local keys = {}

	for key, scheme in pairs(M.schemes) do
		table.insert(keys, key)
	end

	local state = require("telescope.actions.state")

	local enter = function(prompt)
		M.save(state.get_selected_entry()[1])
		actions.close(prompt)
	end

	local retreat = function(prompt)
		actions.move_selection_previous(prompt)
	end

	local advance = function(prompt)
		actions.move_selection_next(prompt)
	end

	local options = {
		finder = finders.new_table(keys),
		sorter = sorters.get_fzy_sorter({}),
		attach_mappings = function(_, map)
			map("n", "<cr>", enter)
			map("i", "<cr>", enter)

			map("n", "k", retreat)
			map("n", "j", advance)

			return true
		end,
		layout_config = {
			width = 50,
			height = 0.6,
		},
		prompt_title = "Schemes",
	}

	return pickers.new(options)
end

--- Setup the selector and initialize scheme
---@param options Options table
M.setup = function(options)
	M.before = options.before or function(_) end
	M.after = options.after or function(_) end
	M.default = options.default
	M.schemes = {}

	for _, scheme in pairs(options.schemes) do
		local key = M.format(scheme.name, scheme.background)

		M.schemes[key] = scheme
	end

	table.sort(M.schemes)

	vim.api.nvim_create_user_command("Schemes", function()
		M.selector():find()
	end, { desc = "Choose colorschemes" })

	M.initialize()
end

return M
