local static = require("quickfix.static")

local setup = function(new_config)
	static.config = vim.tbl_deep_extend("force", static.config, new_config or {})
end

return {
	setup = setup,
	store_qf = require("quickfix.store").store_qf,
	restore_qf = require("quickfix.store").restore_qf,
	highlight_qf = require("quickfix.highlight").highlight_qf,
}
