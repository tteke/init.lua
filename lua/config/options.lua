-- ╔══════════════════════════════════════════════════════════════╗
-- ║                       Core Options                          ║
-- ╚══════════════════════════════════════════════════════════════╝

local opt = vim.opt

-- Leader (set in init.lua, but reinforced here)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Always use cwd as root (prevents root-jumping in submodule/monorepo projects)
vim.g.root_spec = { "cwd" }

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "100"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10 -- Max autocomplete popup height
opt.showmode = false -- Statusline handles this

-- Window behavior
opt.splitright = true
opt.splitbelow = true

-- Clipboard (system clipboard)
opt.clipboard = "unnamedplus"

-- Undo persistence
opt.undofile = true
opt.undolevels = 10000

-- Backup / swap
opt.backup = false
opt.swapfile = false
opt.writebackup = false

-- File handling
opt.fileencoding = "utf-8"
opt.updatetime = 250
opt.timeoutlen = 300 -- Faster which-key popup

-- Wrapping
opt.wrap = false
opt.linebreak = true

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Folding (treesitter-based)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Grep (use ripgrep)
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Mouse
opt.mouse = "a"

-- Fillchars for cleaner UI
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
