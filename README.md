# quickfix.nvim

Extended functionality for quickfix.

## Features

- function to store/restore quickfix

```lua
require('quickfix').store_qf(path)
require('quickfix').restore_qf(path)
```

- highlight text in quickfix

## Dependencies

- [niuiic/core](https://github.com/niuiic/core.nvim)

## Config

```lua
-- default
require("quickfix").setup({
	create_dir = "mkdir -p",
	hl_group = {},
})

-- example
require("quickfix").setup({
	create_dir = "mkdir -p",
	hl_group = {
		{
			name = "QuickFixWarn",
			match = {
				"warn",
				"Warn",
				"warning",
				"WARN",
				"WARNING",
			},
			color = "#ff0000",
		},
		{
			name = "QuickFixErr",
			match = {
				"error",
				"Error",
				"ERROR",
			},
			color = "#ffff00",
		},
	},
})
```
