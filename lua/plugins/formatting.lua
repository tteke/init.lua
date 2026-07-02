-- ╔══════════════════════════════════════════════════════════════╗
-- ║              Formatting · conform.nvim                      ║
-- ╚══════════════════════════════════════════════════════════════╝

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
    },
    opts = {
      formatters_by_ft = {
        -- Web languages
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        -- Systems
        c = { "clang-format" },
        cpp = { "clang-format" },
        cuda = { "clang-format" },
        -- Python
        python = { "black" },
        -- Lua
        lua = { "stylua" },
        -- SQL
        sql = { "sql-formatter" },
        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        -- Fallback: trim whitespace for any filetype
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = false,
      -- Customize individual formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" }, -- 2-space indent for shell scripts
        },
        prettier = {
          prepend_args = { "--tab-width", "2" },
        },
      },
    },
  },
}
