local kfg = function (name) return string.format('require("cfg/%s")', name) end

require 'packer'.startup({function(use)
    -- Global deps
    use {
        'lewis6991/impatient.nvim',
        'wbthomason/packer.nvim',
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons'
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        cmd = "Telescope",

        requires = {
            {
                'nvim-telescope/telescope-fzf-native.nvim', run = 'make',
                config = function () require('telescope').load_extension('fzf') end,
                after = 'telescope.nvim'
            },
        },

        config = kfg 'telescope',
    }

    -- TreeSitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate", event = "InsertEnter",

        config = kfg "treesitter"
    }

    -- LSP
    use {
        { 'neovim/nvim-lspconfig', after = "nvim-treesitter" },
        { 'williamboman/nvim-lsp-installer', after = "nvim-lspconfig", config = kfg "lsp" },

        { 'tami5/lspsaga.nvim', cmd = 'Lspsaga' },
    }

    -- Autocomplete
    use {
        -- EyeCandy
        { "onsails/lspkind-nvim", after = "nvim-lsp-installer" },

        -- Snippets
        { 'L3MON4D3/LuaSnip', after = "lspkind-nvim", config = kfg 'luasnip' },
        { 'rafamadriz/friendly-snippets' },

        { 'hrsh7th/nvim-cmp', after = "LuaSnip", config = kfg 'cmp' },
        -- Source
        { "hrsh7th/cmp-path",                     after = "nvim-cmp" },
        { "hrsh7th/cmp-buffer",                   after = "nvim-cmp" },
        { "hrsh7th/cmp-cmdline",                  after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lua",                 after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp",                 after = "nvim-cmp" },
        { "ray-x/cmp-treesitter",                 after = "nvim-cmp" },
        { "andersevenrud/cmp-tmux",               after = "nvim-cmp" },
        { "saadparwaiz1/cmp_luasnip",             after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
    }

    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        config = kfg 'lualine',
    }

    use {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup {
            }
        end
    }

    use {
        "Pocco81/TrueZen.nvim",
        config = kfg 'zen'
    }

    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function ()
            require("indent_blankline").setup {}
        end
    }

    -- Git
    use {
        'tpope/vim-fugitive',
        cmd = "Gedit",
    }

    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end,

        event = "BufWritePost"
    }

    use {
        'kyazdani42/nvim-tree.lua',
        config = kfg 'tree',

        cmd = "NvimTreeToggle"
    }

    use {
        'ThePrimeagen/harpoon',
        config = function ()
            require("telescope").load_extension('harpoon')
        end,
    }

    use {
        'ggandor/leap.nvim',
        config = kfg 'speed',
        keys = { 's', 'S'}
    }
    -- Full project lsp diagnostics
    use {
        'folke/trouble.nvim',
        cmd = "Trouble"
    }

    -- Colors
    use {
        'luisiacc/gruvbox-baby',
        setup = function ()
            vim.g.gruvbox_baby_transparent_mode = 1
            vim.g.background_color = 'dark'
        end,

        config = function ()
            vim.cmd "color gruvbox-baby"
        end
    }
end,

    config = {
        git = { clone_timeout = nil }
    }})
-- Chek:
-- https://github.com/nvim-neo-tree/neo-tree.nvim/tree/v2.x
