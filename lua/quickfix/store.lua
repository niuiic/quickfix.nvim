local core = require("core")

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

	core.lua.list.each(qf_list, function(qf)
		if qf.bufnr ~= nil and qf.text ~= "" then
			local success, file_name = pcall(vim.api.nvim_buf_get_name, qf.bufnr)
			if success then
				qf.filename = file_name
			end
			qf.bufnr = nil
		end
	end)

	local directory = get_directory(path)
	if not core.file.file_or_dir_exists(directory) then
		core.file.mkdir(directory)
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
	if not qf_list then
		return
	end

	vim.fn.setqflist(qf_list)
end

return {
	store_qf = store_qf,
	restore_qf = restore_qf,
}
