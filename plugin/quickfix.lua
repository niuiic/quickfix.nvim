vim.api.nvim_create_autocmd({ "WinNew", "BufReadPost" }, {
	pattern = "*",
	callback = function(args)
		if not args.buf then
			return
		end
		local filetype = vim.api.nvim_buf_get_option(args.buf, "filetype")
		if filetype == "qf" then
			local bufnr = vim.api.nvim_win_get_buf(0)
			vim.api.nvim_set_current_buf(args.buf)
			require("quickfix").highlight_qf()
			vim.api.nvim_set_current_buf(bufnr)
		end
	end,
})
