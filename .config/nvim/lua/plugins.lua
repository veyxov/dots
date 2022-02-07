-- function for getting configuration file for a specific plugin
local kfg = function (name) return string.format('require("config/%s")', name) end

local packer = require 'packer'
local use = packer.use

return packer.startup({function()
    use 'wbthomason/packer.nvim' -- AutoManage

    -- Global requirements
    use {
        "kyazdani42/nvim-web-devicons",
        event = "BufEnter"
    }

    use {
        'nvim-lua/plenary.nvim',
    }

    use { -- Telescope FuzzyFinder
        'nvim-telescope/telescope.nvim',
        requires = {
            {
                'nvim-telescope/telescope-fzf-native.nvim', run = 'make',
                config = function () require('telescope').load_extension('fzf') end,
                after = 'telescope.nvim',
                opt = true
            },
            {
                'nvim-telescope/telescope-file-browser.nvim',
                config = kfg 'telescope-file-browser', after = 'telescope.nvim',
                opt = true
            },
        },
        config = kfg 'telescope',

        cmd = 'Telescope'
    }

    use { -- Languge Server Protocole
        'neovim/nvim-lspconfig',
        requires = 'williamboman/nvim-lsp-installer',

        config = kfg 'lsp',

        event = 'InsertEnter'
    }

    use { -- AutoCompletion
        'hrsh7th/nvim-cmp',
        requires = {
            {'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp'}, -- LSP
            {'hrsh7th/cmp-cmdline', after = 'nvim-cmp'}, -- CmdLine
            {'onsails/lspkind-nvim', before = 'nvim-cmp'}, -- Nice icons
            {'ray-x/cmp-treesitter', after = 'nvim-cmp'}, -- Treesitter
            {'hrsh7th/cmp-path', after = 'nvim-cmp'}, -- FileSystem Path
            {'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp'}, -- Snippets
            {'hrsh7th/cmp-buffer', after = 'nvim-cmp'}, -- Current buffer
        },
        config = kfg 'cmp',
        after = 'nvim-lspconfig'
    }

    use { -- Help with pairing
        'windwp/nvim-autopairs',
        config = kfg 'autopairs',
        event = 'InsertEnter',
        opt = true
    }

    use { -- Snippets Engine
        'L3MON4D3/LuaSnip',
        requires = {
            'rafamadriz/friendly-snippets',
            before = 'nvim-cmp'
        },
        after = 'friendly-snippets'
    }

    use { -- Max focus editing
        'Pocco81/TrueZen.nvim',
        config = kfg 'zen',

        cmd = {
            'TZAtaraxis',
            'TZMinimalist',
            'TZFocus',
        },

        requires = {
            {
                'folke/twilight.nvim',
                config = kfg 'twilight',
                after = 'TrueZen.nvim'
            }
        }
    }

    use { -- StatusLine
        'nvim-lualine/lualine.nvim',
        config = kfg 'lualine',
        event = 'BufRead'
    }

    use { -- Treesitter
        'nvim-treesitter/nvim-treesitter',
        config = kfg 'treesitter',
        run = ':TSUpdate',

        event = 'BufRead'
    }
    use {
        'ggandor/lightspeed.nvim',
        config = kfg 'lightspeed'
    }

    use {
        'tpope/vim-fugitive',
        cmd = 'G'
    }
    use { -- Show dagnostics summary
        'folke/trouble.nvim',
        config = kfg 'trouble',
        cmd = { 'Trouble' }
    }

    use { -- Show buffers, mostly eye-candy
        'akinsho/bufferline.nvim',
        config = kfg 'bufferline',

        event = 'BufRead'
    }

    use { -- Commenting made easy
        'numToStr/Comment.nvim',
        config = kfg 'comment',

        keys = {'gc', 'gcc'}
    }

    use { -- Show Indentation level
        'lukas-reineke/indent-blankline.nvim',
        config = kfg 'blankline',

        event = 'BufRead',
    }
    use { -- For surrounding text objects
        'machakann/vim-sandwich',

        keys = { 'sa', 'sr', 'sd' }
    }

    use { -- More pleasant LSP
        'tami5/lspsaga.nvim',
        config = kfg 'lspsaga',

        cmd = 'Lspsaga'
    }
    -- Colorschemes
    use {
        'NTBBloodbath/doom-one.nvim',
        config = kfg 'doom',

        event = 'ColorSchemePre'
    }
    use {
        'EdenEast/nightfox.nvim',
        config = kfg 'nightfox',
        event = 'ColorSchemePre' }

    use {
        'sainnhe/gruvbox-material',
        setup = kfg 'gruvbox'
    }
    use { 'folke/tokyonight.nvim' }
    use {
        'tjdevries/train.nvim'
    }

    -- Debugging
    use {
        'mfussenegger/nvim-dap',
        config = kfg 'nvim-dap'
    }
    use {
        'Pocco81/DAPInstall.nvim'
    }

    use {
        'rcarriga/nvim-dap-ui',
        config = kfg 'nvim-dap-ui'
    }

    -- Packer configuration
end,
    -- Packer comfiguration
    config = { git = { clone_timeout = false } }
})

-- TOCHECK:
-- https://github.com/lewis6991/gitsigns.nvim
