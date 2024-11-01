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
			-- fields of options
			-- - cwd: (string) Set the current working directory for the sub-process.
			-- - env: table<string,string> Set environment variables for the new process. Inherits the
			--   current environment with `NVIM` set to |v:servername|.
			-- - clear_env: (boolean) `env` defines the job environment exactly, instead of merging current
			--   environment.
			-- - stdin: (string|string[]|boolean) If `true`, then a pipe to stdin is opened and can be written
			--   to via the `write()` method to SystemObj. If string or string[] then will be written to stdin
			--   and closed. Defaults to `false`.
			-- - stdout: (boolean|function)
			--   Handle output from stdout. When passed as a function must have the signature `fun(err: string, data: string)`.
			--   Defaults to `true`
			-- - stderr: (boolean|function)
			--   Handle output from stderr. When passed as a function must have the signature `fun(err: string, data: string)`.
			--   Defaults to `true`.
			-- - text: (boolean) Handle stdout and stderr as text. Replaces `\r\n` with `\n`.
			-- - timeout: (integer) Run the command with a time limit. Upon timeout the process is sent the
			--   TERM signal (15) and the exit code is set to 124.
			-- - detach: (boolean) If true, spawn the child process in a detached state - this will make it
			--   a process group leader, and will effectively enable the child to keep running after the
			--   parent exits. Note that the child process will still keep the parent's event loop alive
			--   unless the parent process calls |uv.unref()| on the child's process handle.
			options = {},
			-- return false means this make config would not work
			is_enabled = function()
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
					msg = msg or ""
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
