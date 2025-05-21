return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
		config = function ()
			local configs = require("nvim-treesitter.configs")

      vim.api.nvim_command('filetype indent off')
      vim.opt.smartindent = false
			configs.setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir",
					"heex", "javascript", "html", "typescript", "rust", "python",
					"jsdoc", "bash"
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "markdown" },
				},
        indent = {
          enable = true
        }
			})
		end

	}
}
