local static = require("quickfix.static")

local run_make = function(make_config)
	if not make_config then
		vim.notify("No make config available", vim.log.levels.WARN, {
			title = "Quickfix",
		})
		return
	end

	local parser = make_config.parser
	if type(parser) == "string" then
		parser = static.config.parser[parser]
	end
	if type(parser) ~= "function" then
		vim.notify("No parser available", vim.log.levels.WARN, {
			title = "Quickfix",
		})
		return
	end

	vim.system(
		vim.list_extend({ make_config.cmd }, make_config.args),
		make_config.options,
		vim.schedule_wrap(function(result)
			parser(result.stdout, result.stderr)
			vim.notify("Make finished", vim.log.levels.INFO, {
				title = "Quickfix",
			})
		end)
	)
end

---@param name string | nil
local make_qf = function(name)
	if name then
		local make_config = static.config.make[name]
		if not make_config.is_enabled or make_config.is_enabled() then
			run_make(make_config)
		else
			run_make()
		end
		return
	end

	local items = {}
	for key, make_config in pairs(static.config.make) do
		if not make_config.is_enabled or make_config.is_enabled() then
			table.insert(items, key)
		end
	end

	if #items == 0 then
		run_make()
		return
	end

	if #items == 1 then
		run_make(static.config.make[items[1]])
		return
	end

	vim.ui.select(items, {
		prompt = "Select config",
	}, function(choice)
		local make_config
		if choice then
			make_config = static.config.make[choice]
		end
		run_make(make_config)
	end)
end

return {
	make_qf = make_qf,
}
