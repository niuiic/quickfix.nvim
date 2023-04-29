local quickfix = require("quickfix")

vim.api.nvim_create_autocmd({ "WinNew", "BufReadPost" }, {
	pattern = "*",
	callback = function(args)
		if not args.buf then
			return
		end
		local filetype = vim.api.nvim_buf_get_option(args.buf, "filetype")
		if filetype == "qf" then
			quickfix.highlight_qf()
		end
	end,
})
