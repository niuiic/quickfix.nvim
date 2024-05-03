local static = require("quickfix.static")
local core = require("core")

local run_make = function(make_config)
	if not make_config then
		vim.notify("No make config specified", vim.log.levels.WARN, {
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

	local output = ""
	local err = ""
	core.job.spawn(make_config.cmd, make_config.args, {}, function()
		parser(output, err)
		vim.notify("Make finished", vim.log.levels.INFO, {
			title = "Quickfix",
		})
	end, function(_, data)
		err = err .. data
	end, function(_, data)
		output = output .. data
	end)
end

---@param name string | nil
local make_qf = function(name)
	if name then
		run_make(static.config.make[name])
		return
	end

	local items = {}
	for key, _ in pairs(static.config.make) do
		table.insert(items, key)
	end

	if table.maxn(items) == 0 then
		run_make()
		return
	end

	if table.maxn(items) == 1 then
		run_make(static.config.make[items[1]])
		return
	end

	vim.ui.select(items, {
		prompt = "Select config:",
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
