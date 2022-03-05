-- Set the configuration file
local kfg = function (name) return string.format('require("config/%s")', name) end

require "packer".startup({function()
	-- Global Deps
	use {
		"wbthomason/packer.nvim",
		"nvim-lua/plenary.nvim",
        {
            "kyazdani42/nvim-web-devicons",
            after = 'nvim-tree.lua',
            opt = true
        },
	}

	-- LSP and Autocompletion
	use {
		{
			"ms-jpq/coq_nvim",
			setup = kfg 'coq',
			config = kfg 'coq_post',
			after = "nvim-lsp-installer"
		},

		{ "ms-jpq/coq.thirdparty", after = "coq_nvim" },
		{ 'neovim/nvim-lspconfig', after = "nvim-lsp-installer" },
		{ "williamboman/nvim-lsp-installer", event = "InsertEnter" },
        {
            'tami5/lspsaga.nvim',
            cmd = "Lspsaga"
        }
	}

	use {
		"kyazdani42/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		config = function() require'nvim-tree'.setup {} end
	}

	-- Telescope
	use {
		"nvim-telescope/telescope.nvim",

		requires = {
			{
				'nvim-telescope/telescope-fzf-native.nvim', run = 'make',
				config = function () require('telescope').load_extension('fzf') end,
				after = 'telescope.nvim',
				opt = true
			},
		},

		cmd = "Telescope",

		config = kfg "telescope"
	}
	-- TreeSitter
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate", event = "InsertEnter",

		config = kfg "treesitter"
	}

        -- GIT
        use {
                "tpope/vim-fugitive",
                cmd = "G"
        }

	-- MISC
	use {
		"ggandor/lightspeed.nvim",
		keys = { "s", "S" }
	}
	-- Colorschemes
	use {
		"sainnhe/gruvbox-material"
	}
end,

config = {
	git = {
		clone_timeout = nil
	},

	display = {
		open_fn = function()
			return require("packer.util").float({ border = "single" })
		end
	}
}})
