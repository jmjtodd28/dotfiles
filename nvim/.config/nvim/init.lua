vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set relativenumber")

--links system and vim clipboard
vim.opt.clipboard = "unnamedplus"

-- leader button
vim.g.mapleader = " "

-- relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- amount of room at the bottom of the screen when scrolling down
vim.opt.scrolloff = 10

vim.opt.smartindent = true

-- set spell check language to gb english, run :set spell to activate
vim.opt.spelllang = { "en_gb" }

-- tmux
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- cd to the current directory
vim.keymap.set('n', '<leader>cd', function()
  local dir = vim.fn.expand('%:p:h')
  vim.cmd('cd ' .. dir)
  print('Changed directory to: ' .. dir)
end, { desc = "Change dir to current file's folder" })


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
require("puku")
