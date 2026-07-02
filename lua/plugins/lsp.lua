-- ╔══════════════════════════════════════════════════════════════╗
-- ║            LSP · Mason · Language Servers                   ║
-- ║  This is the core — makes go-to-definition etc. work       ║
-- ╚══════════════════════════════════════════════════════════════╝

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
      ensure_installed = {
        "clangd",                           -- C / C++ / CUDA
        "ts_ls",                            -- JavaScript / TypeScript / JSX / TSX
        "cssls",                            -- CSS / SCSS / LESS
        "html",                             -- HTML
        "pyright",                          -- Python
        "dockerls",                         -- Dockerfile
        "docker_compose_language_service",  -- docker-compose.yml
        "marksman",                         -- Markdown
        "yamlls",                           -- YAML
        "sqls",                             -- SQL
        "bashls",                           -- Bash / sh
        "lua_ls",                           -- Lua (for nvim config editing)
      },
      automatic_installation = true,
    },
  },

  -- ─── nvim-lspconfig: configure each server ──────────────────
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")

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

          -- Hover & signature
          map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

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

      -- ── Rounded borders on hover/signature ──────────────────
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, { border = "rounded" }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, { border = "rounded" }
      )

      -- ── Get capabilities from blink.cmp ─────────────────────
      local capabilities = nil
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        capabilities = blink.get_lsp_capabilities()
      end

      -- ── Default config for all servers ──────────────────────
      local default_opts = {
        capabilities = capabilities,
      }

      -- ── Server-specific configurations ──────────────────────

      -- C / C++ / CUDA
      lspconfig.clangd.setup(vim.tbl_deep_extend("force", default_opts, {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      }))

      -- TypeScript / JavaScript / JSX / TSX
      lspconfig.ts_ls.setup(vim.tbl_deep_extend("force", default_opts, {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      }))

      -- CSS
      lspconfig.cssls.setup(vim.tbl_deep_extend("force", default_opts, {
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
      }))

      -- HTML
      lspconfig.html.setup(vim.tbl_deep_extend("force", default_opts, {
        filetypes = { "html", "htmldjango" },
      }))

      -- Python
      lspconfig.pyright.setup(vim.tbl_deep_extend("force", default_opts, {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      }))

      -- Dockerfile
      lspconfig.dockerls.setup(default_opts)

      -- Docker Compose
      lspconfig.docker_compose_language_service.setup(default_opts)

      -- Markdown
      lspconfig.marksman.setup(default_opts)

      -- YAML
      lspconfig.yamlls.setup(vim.tbl_deep_extend("force", default_opts, {
        settings = {
          yaml = {
            keyOrdering = false, -- Don't enforce key ordering
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
            },
            validate = true,
            completion = true,
          },
        },
      }))

      -- SQL
      lspconfig.sqls.setup(default_opts)

      -- Bash
      lspconfig.bashls.setup(vim.tbl_deep_extend("force", default_opts, {
        filetypes = { "sh", "bash", "zsh" },
      }))

      -- Lua (for editing Neovim config)
      lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", default_opts, {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
            telemetry = { enable = false },
          },
        },
      }))
    end,
  },
}
