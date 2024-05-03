---@class quickfix.Make
---@field cmd string
---@field args string[]
---@field parser fun(output: string, err: string) | string

local config = {
	---@type {[string]: quickfix.Make}
	make = {},
	---@type {[string]: fun(output: string, err: string)}
	parser = {},
}

return {
	config = config,
}
