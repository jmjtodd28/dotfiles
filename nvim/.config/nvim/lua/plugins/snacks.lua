return {
	{ "nvim-tree/nvim-web-devicons", enabled = true },
	{
		"folke/snacks.nvim",
		priority = 1000, -- Recommended to load early
		lazy = false,
		---@type snacks.Config
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			picker = { enabled = true },
			explorer = { enabled = true },
			indent = {
				enabled = true,
			},
		},
		keys = {
			{
				"<C-n>",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
		},
	},
}
