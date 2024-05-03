local static = require("quickfix.static")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

return {
	setup = setup,
	make = require("quickfix.make").make_qf,
	store = require("quickfix.store").store_qf,
	restore = require("quickfix.store").restore_qf,
}
