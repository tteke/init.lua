-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  Neo-tree · File Explorer                   ║
-- ╚══════════════════════════════════════════════════════════════╝

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer (toggle)" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Explorer (reveal file)" },
      { "<leader>ge", "<cmd>Neotree git_status<cr>", desc = "Git Explorer" },
      { "<leader>be", "<cmd>Neotree buffers<cr>", desc = "Buffer Explorer" },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      -- Open Neo-tree if nvim is started with a directory argument
      if vim.fn.argc(-1) == 1 then
        local stat = vim.uv.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none", -- Don't conflict with leader
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            added = " ",
            modified = " ",
            deleted = " ",
            renamed = "➜ ",
            untracked = "★ ",
            ignored = "◌ ",
            unstaged = "✗ ",
            staged = "✓ ",
            conflict = " ",
          },
        },
      },
    },
  },
}
