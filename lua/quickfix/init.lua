local static = require("quickfix.static")
local core = require("niuiic-core")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

--- get directory from file path
---@param path string
---@return string
local get_directory = function(path)
	local index = string.find(string.reverse(path), "/", 1, true)
	return string.sub(path, 1, string.len(path) - index)
end

local store_qf = function(path)
	local qf_list = vim.fn.getqflist()
	if #qf_list == 0 then
		return
	end

	local directory = get_directory(path)
	if not core.file.file_or_dir_exists(directory) then
		vim.cmd("!" .. static.config.create_dir .. " " .. directory)
	end

	local file = io.open(path, "w+")
	if not file then
		return
	end
	local text = vim.fn.json_encode(qf_list)
	file:write(text)
	file:close()
end

local restore_qf = function(path)
	if not core.file.file_or_dir_exists(path) then
		return
	end

	local file = io.open(path, "r")
	if not file then
		return
	end
	local text = file:read("*a")
	local qf_list = vim.fn.json_decode(text)

	vim.fn.setqflist(qf_list)
end

local highlight_qf = function()
	core.lua.list.each(static.config.hl_group, function(hl)
		vim.cmd(string.format("hi def link %s Function", hl.name))
		vim.cmd(string.format("hi %s guifg=%s", hl.name, hl.color))

		core.lua.list.each(hl.match, function(v)
			vim.cmd(string.format("syn match %s /%s/", hl.name, v))
		end)
	end)
end

return {
	setup = setup,
	store_qf = store_qf,
	restore_qf = restore_qf,
	highlight_qf = highlight_qf,
}
