local static = require("quickfix.static")
local core = require("core")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
	core.lua.list.each(static.config.highlight, function(hl)
		vim.api.nvim_set_hl(0, hl.name, {
			foreground = hl.color,
		})
	end)
end

return {
	setup = setup,
	make = require("quickfix.make").make_qf,
	store = require("quickfix.store").store_qf,
	restore = require("quickfix.store").restore_qf,
}
