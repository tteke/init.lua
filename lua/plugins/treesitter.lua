-- ╔══════════════════════════════════════════════════════════════╗
-- ║              Treesitter · Syntax Highlighting               ║
-- ╚══════════════════════════════════════════════════════════════╝

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- Required for Neovim 0.12+
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          -- Your primary languages
          "c",
          "cpp",
          "cuda",
          "javascript",
          "typescript",
          "tsx",
          "css",
          "html",
          "python",
          "dockerfile",
          "markdown",
          "markdown_inline",
          "yaml",
          "sql",
          "bash",
          -- Config / supporting
          "lua",
          "luadoc",
          "json",
          "jsonc",
          "toml",
          "xml",
          "vim",
          "vimdoc",
          "regex",
          "diff",
          "gitcommit",
          "gitignore",
          "query", -- treesitter queries
        },
        auto_install = true, -- Auto-install parsers for new filetypes
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })
    end,
  },

  -- Treesitter text objects (smart select functions, classes, etc.)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ai"] = "@conditional.outer",
              ["ii"] = "@conditional.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
            },
          },
          move = {
            enable = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
}
