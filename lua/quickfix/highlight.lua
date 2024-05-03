local static = require("quickfix.static")
local core = require("core")

local highlight_qf = function()
	core.lua.list.each(static.config.highlight, function(hl)
		vim.cmd(string.format("hi def link %s Function", hl.name))
		vim.cmd(string.format("hi %s guifg=%s", hl.name, hl.color))

		core.lua.list.each(hl.match, function(v)
			vim.cmd(string.format("syn match %s /%s/", hl.name, v))
		end)
	end)
end

return { highlight_qf = highlight_qf }
