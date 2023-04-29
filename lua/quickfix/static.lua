local config = {
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
}

return {
	config = config,
}
