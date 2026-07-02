-- ╔══════════════════════════════════════════════════════════════╗
-- ║                LazyVim-Compatible Keymaps                   ║
-- ╚══════════════════════════════════════════════════════════════╝
--
-- LSP-specific keymaps are in lua/plugins/lsp.lua (attached via LspAttach)
-- Plugin-specific keymaps are in their respective plugin files
-- This file contains general-purpose keymaps only

local map = vim.keymap.set

-- ─── Better escape ──────────────────────────────────────────────
map("i", "jk", "<Esc>", { desc = "Escape insert mode" })
map("i", "jj", "<Esc>", { desc = "Escape insert mode" })

-- ─── Better window navigation (LazyVim default) ────────────────
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- ─── Window resize (LazyVim default) ────────────────────────────
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- ─── Buffer navigation (LazyVim default) ────────────────────────
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Delete buffer (force)" })

-- ─── Move lines (LazyVim default) ──────────────────────────────
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- ─── Clear search highlights (LazyVim default) ─────────────────
map({ "i", "n" }, "<Esc>", "<cmd>noh<cr><Esc>", { desc = "Escape and clear hlsearch" })
map("n", "<leader>ur", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })

-- ─── Better indenting (stay in visual mode) ────────────────────
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- ─── Diagnostic navigation (LazyVim default) ───────────────────
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })
map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev error" })
map("n", "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, { desc = "Next warning" })
map("n", "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end, { desc = "Prev warning" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- ─── Save / quit (LazyVim default) ──────────────────────────────
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- ─── Lazy plugin manager ───────────────────────────────────────
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- ─── Better n/N (center on search result) ──────────────────────
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Prev search result" })

-- ─── Join lines without moving cursor ──────────────────────────
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- ─── Half-page scroll, stay centered ───────────────────────────
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- ─── Paste without overwriting register ────────────────────────
map("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })

-- ─── Delete without yanking ────────────────────────────────────
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- ─── New file (LazyVim default) ────────────────────────────────
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- ─── Quickfix navigation ──────────────────────────────────────
map("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })

-- ─── Splits ────────────────────────────────────────────────────
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
