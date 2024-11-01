---@param path string
local store_qf = function(path)
	local qf_list = vim.fn.getqflist()

	vim.iter(qf_list):each(function(qf)
		if qf.bufnr ~= nil then
			local ok, file_name = pcall(vim.api.nvim_buf_get_name, qf.bufnr)
			if ok then
				qf.filename = file_name
			end
			qf.bufnr = nil
		end
	end)

	vim.fn.writefile({ vim.fn.json_encode(qf_list) }, path)
end

---@param path string
local restore_qf = function(path)
	if not vim.uv.fs_stat(path) then
		return
	end

	local text = vim.fn.readfile(path)[1]
	local ok, qf_list = pcall(vim.fn.json_decode, text)
	if not ok or not qf_list then
		return
	end

	vim.fn.setqflist(qf_list)
end

return {
	store_qf = store_qf,
	restore_qf = restore_qf,
}
