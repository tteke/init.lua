return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup {}

    vim.keymap.set("n", "<leader>pv", [[:Telescope file_browser<CR>]])
  end,
}
