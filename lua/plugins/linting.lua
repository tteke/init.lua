-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  Linting · nvim-lint                         ║
-- ╚══════════════════════════════════════════════════════════════╝

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "ruff" },
        markdown = { "markdownlint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }

      -- Auto-lint on save, insert leave, and buffer enter
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          -- Only lint if the linter binary exists
          lint.try_lint()
        end,
      })

      -- Manual lint keymap
      vim.keymap.set("n", "<leader>cL", function()
        lint.try_lint()
      end, { desc = "Trigger linting" })
    end,
  },
}
