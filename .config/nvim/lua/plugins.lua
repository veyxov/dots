-- Set the configuration file
local kfg = function (name) return string.format('require("config/%s")', name) end

require "packer".startup({function()
	-- Global Deps
	use {
		"wbthomason/packer.nvim",
		"nvim-lua/plenary.nvim",
        {
            "kyazdani42/nvim-web-devicons",
            after = 'nvim-tree.lua'
        },
	}

	-- LSP and Autocompletion
    use {
        'hrsh7th/nvim-cmp',
        config = kfg 'cmp',
        after = "nvim-lsp-installer"
    }

    use {
        "onsails/lspkind-nvim"
    }

    use {
        {"hrsh7th/cmp-buffer", after = "nvim-cmp" },
        {"hrsh7th/cmp-path", after = "nvim-cmp" },
        {"hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
        {"hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
        {"saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
        {"ray-x/cmp-treesitter", after = "nvim-cmp" },
        {"hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
        {"andersevenrud/cmp-tmux", after = "nvim-cmp" },
    }

    use {
        'L3MON4D3/LuaSnip'
    }

	use {
		{ 'neovim/nvim-lspconfig', after = "nvim-lsp-installer" },
		{ "williamboman/nvim-lsp-installer", event = "InsertEnter", before = "nvim-cmp" },
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
		keys = { "s", "S" },
        config = kfg 'lightspeed'
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
