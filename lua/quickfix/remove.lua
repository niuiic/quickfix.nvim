local core = require("core")

local remove_qf = function()
	local qf_list = vim.fn.getqflist()
	local items = core.lua.list.map(qf_list, function(qf, index)
		local file = vim.api.nvim_buf_get_name(qf.bufnr)
		local line = qf.lnum
		local msg = string.gsub(qf.text, "\n", " ")

		return string.format("[%s] %s|%s: %s", index, file, line, msg)
	end)
	vim.ui.select(items, {
		prompt = "Select qf item:",
	}, function(choice)
		if not choice then
			return
		end

		local index = tonumber(string.match(choice, "%[(%d+)%].*"))
		qf_list = core.lua.list.filter(qf_list, function(_, i)
			return index ~= i
		end)
		vim.fn.setqflist(qf_list)
		vim.notify("Remove qf item: " .. choice, vim.log.levels.INFO, {
			title = "Quickfix",
		})
	end)
end

return {
	remove_qf = remove_qf,
}
