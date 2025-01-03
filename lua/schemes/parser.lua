local M = {}

--- Parse options structure and check if
--- it is correct
---@param options Options argument to be parsed
---@return Status messages and processed options
M.parse_options = function(options)
	local messages = {}
	local result = {}

	-- Parse options type
	if type(options) ~= "table" then
		messages:insert("options must be a \"table\"")
	else
		-- Parse options.before type
		if options.before and type(options.before) ~= "function" then
			messages:insert("options.before must be \"nil\" or a \"function\"")
		else
			result.before = options.before
		end

		-- Parse options.after type
		if options.after and type(options.after) ~= "function" then
			messages:insert("options.after must be \"nil\" or a \"function\"")
		else
			result.after = options.after
		end

		-- Parse options.default value
		if options.default then
			local ok = true

			-- Parse options.default type
			if type(options.default) ~= "table" then
				messages:insert("options.default must be either a \"table\"")
				ok = false
			else
				-- Parse options.default.name type
				if type(options.default.name) ~= "string" then
					messages:insert("options.default.name must be a \"string\"")
					ok = false
				end

				-- Parse options.default.background type
				if type(options.default.background) ~= "string" then
					messages:insert("options.default.background must be a \"string\"")
					ok = false
				else
					-- Parse options.default.background value
					if options.default.background ~= "dark" and options.default.background ~= "light" then
						messages:insert("options.default.background value must be \"dark\" or \"light\"")
						ok = false
					end
				end

				-- Parse options.default.command value
				if type(options.default.command) ~= "function" then
					messages:insert("options.default.command must be a \"function\"")
					ok = false
				end
			end

			if ok then
				result.default = options.default
			end
		end

		-- Parse options.schemes value
		if options.schemes then
			if type(options.schemes) == "table" then
				result.schemes = {}

				-- Parse each given scheme
				for key, scheme in pairs(options) do
					local ok = true

					-- Parse options.schemes[key] type
					if type(scheme) ~= "table" then
						messages:insert("options.schemes[%s] must be either a \"table\"")
						ok = false
					else
						-- Parse options.schemes[key].name type
						if type(scheme.name) ~= "string" then
							messages:insert(("options.schemes[%s].name must be a \"string\""):format(key))
							ok = false
						end

						-- Parse options.schemes[key].background type
						if type(scheme.background) ~= "string" then
							messages:insert(("options.schemes[%s].background must be a \"string\""):format(key))
							ok = false
						else
							-- Parse options.schemes[key].background value
							if scheme.background ~= "dark" and scheme.background ~= "light" then
								messages:insert(("options.schemes[%s].background value must be \"dark\" or \"light\""):format(key))
								ok = false
							end
						end

						-- Parse options.schemes[key].command value
						if type(scheme.command) ~= "function" then
							messages:insert(("options.schemes[%s].command must be a \"function\""):format(key))
							ok = false
						end
					end

					if ok then
						result.schemes[key] = scheme
					end
				end
			else
				messages:insert("options.schemes must be either a \"table\"")
			end
		end
	end

	return messages, result
end
