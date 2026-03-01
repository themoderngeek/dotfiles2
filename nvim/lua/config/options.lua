-- Spaces over Tabs!
vim.opt.expandtab = true
vim.opt.shiftwidth = 4

vim.opt.tabstop = 4
vim.softtabstop = 4

vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Always show line numbers and make them relative
vim.opt.number = true
vim.opt.relativenumber = true

-- Show line under cursor
vim.opt.cursorline = true

-- store undos between sessions
vim.opt.undofile = true

-- Enable mouse mode
vim.opt.mouse = "a"

--Don't show the mode as it is in the status bar
vim.opt.showmode = false

-- Word wrap
vim.opt.breakindent = true

--Case insensitive searching 
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Always show the sign column
vim.opt.signcolumn = "yes"

-- Sets how new splits are opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5
