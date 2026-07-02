-- ╔══════════════════════════════════════════════════════════════╗
-- ║                     Neovim Configuration                    ║
-- ║         LSP · Autocomplete · LazyVim-style Keymaps          ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Set leader key before anything else (LazyVim default: <Space>)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Ensure mise-managed tools (node, python, etc.) are on PATH
-- This lets Mason and LSP servers find the correct binaries
vim.env.PATH = vim.fn.expand("~/.local/share/mise/shims") .. ":" .. vim.env.PATH

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim — auto-loads all files in lua/plugins/
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false, -- Don't lazy-load by default (explicit per-plugin)
  },
  install = {
    colorscheme = { "catppuccin" },
  },
  checker = {
    enabled = true, -- Check for plugin updates periodically
    notify = false, -- Don't spam notifications
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
