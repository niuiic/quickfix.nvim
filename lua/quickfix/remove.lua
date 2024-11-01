local remove_qf = function()
	local qf_list = vim.fn.getqflist()

	local items = vim.iter(qf_list)
		:enumerate()
		:map(function(index, qf)
			local file = vim.api.nvim_buf_get_name(qf.bufnr)
			local line = qf.lnum
			local msg = string.gsub(qf.text, "\n", " ")
			return string.format("[%s] %s|%s: %s", index, file, line, msg)
		end)
		:totable()

	if #items == 0 then
		vim.notify("No items in quickfix list", vim.log.levels.INFO, {
			title = "Quickfix",
		})
		return
	end

	vim.ui.select(items, {
		prompt = "Select qf item",
	}, function(choice)
		if not choice then
			return
		end

		local index = tonumber(string.match(choice, "%[(%d+)%].*"))
		table.remove(qf_list, index)
		vim.fn.setqflist(qf_list)
		vim.notify("Remove qf item" .. choice, vim.log.levels.INFO, {
			title = "Quickfix",
		})
	end)
end

return {
	remove_qf = remove_qf,
}
