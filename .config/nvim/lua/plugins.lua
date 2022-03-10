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

    -- Harpoon
    use {
        "ThePrimeagen/harpoon",
        config = function ()
            require("telescope").load_extension('harpoon')
        end,
        after = 'telescope.nvim'
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

    -- StatusLine
    use {
        'nvim-lualine/lualine.nvim',
        config = kfg 'lualine',

        event = "InsertEnter"
    }

    -- Zen
    use {
        {
            "Pocco81/TrueZen.nvim",
            config = kfg 'zen',

            cmd = { "TZAtaraxis" }
        },
        {
            "folke/twilight.nvim",
            config = kfg 'twilight',
            after = "TrueZen.nvim",
        }
    }

	-- Colorschemes
	use {
        {
            "marko-cerovac/material.nvim",
            -- Set the style for the colorscheme
            setup = function() vim.g.material_style = "deep ocean" end,
            config = kfg 'material'
        },

        {
            "sainnhe/gruvbox-material",
            setup = function ()
                local g = vim.g
                g.gruvbox_material_background = 'hard'
                g.gruvbox_material_enable_italic = 1
                g.gruvbox_material_transparent_background = 0
                g.gruvbox_material_diagnostic_virtual_text = 'colored'
            end,
            config = function ()
                vim.cmd "color gruvbox-material"
             end
        }
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
