-- ╔══════════════════════════════════════════════════════════════╗
-- ║            LSP · Mason · Language Servers                   ║
-- ║  Native vim.lsp.config / vim.lsp.enable (Neovim 0.11+)     ║
-- ╚══════════════════════════════════════════════════════════════╝

-- ── All servers to enable ──────────────────────────────────────
local servers = {
  "clangd",                           -- C / C++ / CUDA
  "ts_ls",                            -- JavaScript / TypeScript / JSX / TSX
  "cssls",                            -- CSS / SCSS / LESS
  "html",                             -- HTML
  "pyright",                          -- Python
  "dockerls",                         -- Dockerfile
  "docker_compose_language_service",  -- docker-compose.yml
  "marksman",                         -- Markdown
  "yamlls",                           -- YAML
  "sqlls",                            -- SQL
  "bashls",                           -- Bash / sh
  "lua_ls",                           -- Lua (for nvim config editing)
}

return {
  -- ─── Mason: manages LSP server binaries ──────────────────────
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
      },
    },
  },

  -- ─── Mason Tool Installer: auto-install formatters/linters ───
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        -- LSP servers (also listed in mason-lspconfig, but belt-and-suspenders)
        -- Formatters
        "prettier",
        "black",
        "clang-format",
        "stylua",
        "shfmt",
        "sql-formatter",
        -- Linters
        "eslint_d",
        "ruff",
        "markdownlint",
        "shellcheck",
      },
      auto_update = false,
      run_on_start = true,
    },
  },

  -- ─── Mason-Lspconfig: bridge Mason ↔ lspconfig ──────────────
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = servers,
      automatic_installation = true,
    },
  },

  -- ─── nvim-lspconfig: provides default server definitions ─────
  -- We no longer call require('lspconfig').<server>.setup().
  -- Instead, server configs live in lsp/<server>.lua and are
  -- auto-discovered by Neovim. We use vim.lsp.config / vim.lsp.enable.
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      -- ── Diagnostics UI ──────────────────────────────────────
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- ── LSP Keymaps (attached per-buffer on LspAttach) ──────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(event)
          local buf = event.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "LSP: " .. desc })
          end

          -- Navigation (LazyVim defaults)
          map("n", "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, "Go to Definition")
          map("n", "gr", function() require("telescope.builtin").lsp_references() end, "References")
          map("n", "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, "Go to Implementation")
          map("n", "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, "Go to Type Definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")

          -- Hover & signature (borders passed directly — no vim.lsp.with)
          map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover Documentation")
          map("n", "gK", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature Help")
          map("i", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature Help")

          -- Actions (LazyVim defaults)
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
          map("n", "<leader>cl", "<cmd>LspInfo<cr>", "LSP Info")

          -- Codelens
          if vim.lsp.codelens then
            map("n", "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
            map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh Codelens")
          end
        end,
      })

      -- ── Shared capabilities (blink.cmp) for all servers ─────
      local capabilities = nil
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink.get_lsp_capabilities()
      end

      -- Apply shared config to all servers via the '*' wildcard
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- ── Enable all servers ──────────────────────────────────
      -- Server-specific configs are auto-discovered from lsp/<server>.lua
      vim.lsp.enable(servers)
    end,
  },
}
