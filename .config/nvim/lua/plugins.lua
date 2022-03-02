-- function for getting configuration file for a specific plugin
local kfg = function (name) return string.format('require("config/%s")', name) end

local packer = require 'packer'
local use = packer.use

return packer.startup({function()
    use {
        'wexouv/mvc.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter'
        }
    }

    use {
        'j-hui/fidget.nvim',
        config = function ()
            require"fidget".setup{}
        end
    }

    -- Faster startup
    use 'lewis6991/impatient.nvim'

    -- Global requirements
    use {
        {'wbthomason/packer.nvim'}, -- AutoManage
        {'nvim-lua/plenary.nvim', event = "BufEnter"},
        {"kyazdani42/nvim-web-devicons", event = "BufEnter"}
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
        {
            'neovim/nvim-lspconfig', requires = 'williamboman/nvim-lsp-installer',
            config = kfg 'lsp', event = 'InsertEnter'
        },
        -- Lsp improvments
        {'tami5/lspsaga.nvim', config = kfg 'lspsaga', cmd = 'Lspsaga'},
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
        'rafamadriz/friendly-snippets',
        config = kfg 'snip',
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

    use { -- Commenting made easy
        'numToStr/Comment.nvim',
        config = kfg 'comment',

        keys = {'gc', 'gcc'}
    }



    -- Debugging
    use {
        {'mfussenegger/nvim-dap', config = kfg 'nvim-dap'},
        {'rcarriga/nvim-dap-ui', config = kfg 'nvim-dap-ui'},
        {'Pocco81/DAPInstall.nvim'},
    }

    -- Eye eye-candy
    use {
        -- Fancy files tree
        {'kyazdani42/nvim-tree.lua', cmd = 'NvimTreeToggle', config = kfg 'nvim-tree'},
        -- Show Indentation level
        {'lukas-reineke/indent-blankline.nvim', config = kfg 'blankline', event = 'BufRead'},
        -- Buffers name and icon
        {'akinsho/bufferline.nvim', config = kfg 'bufferline', event = 'BufRead'},
        -- Status line
        {'nvim-lualine/lualine.nvim', config = kfg 'lualine', event = 'BufRead'}
    }

    -- Colorschemes
    use {
        {'NTBBloodbath/doom-one.nvim', config = kfg 'doom', event = 'ColorSchemePre'},
        {'EdenEast/nightfox.nvim', config = kfg 'nightfox', event = 'ColorSchemePre'},
        {'sainnhe/gruvbox-material', setup = kfg 'gruvbox', event = 'ColorSchemePre'},
        {'shaeinst/roshnivim-cs', event = 'ColorSchemePre'},
    }

    -- Focus
    use {
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
end,
    -- Packer comfiguration
    config = { git = { clone_timeout = false } }
})
