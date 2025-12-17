return {
	"sindrets/diffview.nvim", -- Easily cycle through diffs for all modified files
	opts = {
		use_icons = vim.g.have_nerd_font,
	},
	config = function()
		vim.keymap.set("n", "<leader>do", "<cmd>:DiffviewOpen<cr>")
		vim.keymap.set("n", "<leader>dc", "<cmd>:DiffviewClose<cr>")
	end,
}
