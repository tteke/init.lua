-- ╔══════════════════════════════════════════════════════════════╗
-- ║           sidekick.nvim · AI / OpenCode Integration         ║
-- ╚══════════════════════════════════════════════════════════════╝
--
-- Prerequisites:
--   1. Install opencode: https://github.com/opencode-ai/opencode
--   2. Install tmux: sudo apt install tmux
--   3. Run nvim inside a tmux session for persistent CLI sessions
--

return {
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
      cli = {
        -- Terminal multiplexer for persistent sessions
        mux = {
          backend = "tmux", -- Use "zellij" if you prefer
          enabled = true,
        },
      },
    },
    keys = {
      -- Toggle AI CLI panel (LazyVim AI prefix: <leader>a)
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      -- Send visual selection as context to CLI
      {
        "<leader>ac",
        function() require("sidekick.cli").send() end,
        mode = { "n", "v" },
        desc = "Sidekick Send Context",
      },
      -- Review diffs from AI suggestions
      {
        "<leader>ad",
        function() require("sidekick").diff() end,
        desc = "Sidekick Review Diff",
      },
      -- Accept all changes from AI
      {
        "<leader>aA",
        function() require("sidekick").accept_all() end,
        desc = "Sidekick Accept All",
      },
      -- Next Edit Suggestion (NES) — Tab in insert mode
      {
        "<Tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end,
        mode = "i",
        expr = true,
        desc = "Sidekick NES or Tab",
      },
    },
  },
}
