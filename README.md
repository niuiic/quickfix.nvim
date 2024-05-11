# quickfix.nvim

Extended functionality for quickfix.

[More neovim plugins](https://github.com/niuiic/awesome-neovim-plugins)

## Features

- store/restore

```lua
-- path: string
require('quickfix').store(path)
require('quickfix').restore(path)
```

- make

```lua
-- name: string | nil
require('quickfix').make(name)
```

- remove

```lua
-- remove qf item
require('quickfix').remove()
```

## Dependencies

- [niuiic/core](https://github.com/niuiic/core.nvim)
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)(optional). Feature builtin does not support `\n` in text, it's recommended to use trouble for previewing quickfix list.

## Config

Here is an example.

```lua
local config = {
	---@type {[string]: quickfix.Make}
	make = {
		node = {
			cmd = "node",
			args = { "index.js" },
			-- return false means this make config would not work
			filter = function()
				return vim.bo.filetype == "javascript"
			end,
			-- parse command output and set qf_list
			-- for basic usage, just copy this function and modify the regex
			-- note that error messages may come from `output` or `err`
			-- for advanced user, do filtering, mapping or something else as you like.
			parser = function(output, err)
				-- in this example, the error messages comes from `err`(stderr)
				local lines = vim.split(err, "\n")
				---@type {file_name: string, lnum: number, text: string}
				local qf_item
				-- qf_list is an array of qf_item
				local qf_list = {}
				for _, line in ipairs(lines) do
					-- if line match this regex, it should be the start of a new qf_item, or it should be extra info for the previous qf_item
					local file, line_nr, msg = string.match(line, "^(%S+):(%d+):?(.*)")
					if file and line then
						if qf_item then
							table.insert(qf_list, qf_item)
						end
						qf_item = { filename = file, lnum = tonumber(line_nr), text = msg }
					else
						if qf_item then
							qf_item.text = qf_item.text .. "\n" .. line
						end
					end
				end
				table.insert(qf_list, qf_item)
				vim.fn.setqflist(qf_list)
			end,
		},
		tsc = {
			cmd = "pnpm",
			args = { "tsc", "index.ts" },
			-- parser can be string or function
			-- this parser is defined below
			parser = "tsc",
		},
	},
	---@type {[string]: fun(output: string, err: string)}
	parser = {
		tsc = function(output, _)
			local lines = vim.split(output, "\n")
			local qf_item
			local qf_list = {}
			for _, line in ipairs(lines) do
				local file, line_nr, msg = string.match(line, "^(%S+)%((%d+),%d+%):(.*)")
				if file and line then
					if qf_item then
						table.insert(qf_list, qf_item)
					end
					qf_item = { filename = file, lnum = tonumber(line_nr), text = msg }
				else
					if qf_item then
						qf_item.text = qf_item.text .. "\n" .. line
					end
				end
			end
			table.insert(qf_list, qf_item)
			vim.fn.setqflist(qf_list)
		end,
	},
}
```
