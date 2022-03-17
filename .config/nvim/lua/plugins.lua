local kfg = function (name) return string.format('require("cfg/%s")', name) end
Map = require 'globals'.Map;
Cmd = require 'globals'.Cmd;

require 'packer'.startup({function(use)
    -- Global deps
    use {
        {
            'wbthomason/packer.nvim'
        },
        {
            'nvim-lua/plenary.nvim',
            after = 'packer.nvim'
        }
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        cmd = "Telescope",

        requires = {
            {
                'nvim-telescope/telescope-fzf-native.nvim', run = 'make',
                config = function () require('telescope').load_extension('fzf') end,
                after = 'telescope.nvim',
                opt = true
            },
        },

        config = kfg 'telescope',
        setup = function()
            require'globals'.Map('<C-F>', require'globals'.Cmd 'Telescope find_files')
            require'globals'.Map('<leader>ff', require'globals'.Cmd 'Telescope')
        end,
    }

    -- TreeSitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate", event = "InsertEnter",

        config = kfg "treesitter"
    }

    -- Autocomplete
    use {
        -- EyeCandy
        { "onsails/lspkind-nvim", after = "nvim-lsp-installer" },

        -- Snippets
        { 'L3MON4D3/LuaSnip', after = "lspkind-nvim", config = kfg 'luasnip' },

        { 'hrsh7th/nvim-cmp', after = "LuaSnip", config = kfg 'cmp' },

        -- Source
        { "hrsh7th/cmp-path",                     after = "nvim-cmp" },
        { "hrsh7th/cmp-buffer",                   after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lua",                 after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp",                 after = "nvim-cmp" },
        { "ray-x/cmp-treesitter",                 after = "nvim-cmp" },
        { "andersevenrud/cmp-tmux",               after = "nvim-cmp" },
        { "saadparwaiz1/cmp_luasnip",             after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },

    }

    -- LSP
    use {
        { 'neovim/nvim-lspconfig', after = "nvim-treesitter" },
        { 'williamboman/nvim-lsp-installer', after = "nvim-lspconfig", config = kfg "lsp" },

        { 'tami5/lspsaga.nvim', cmd = 'Lspsaga' },

        setup = function ()
            -- Lsp
            Map ("<leader>la", Cmd "Lspsaga code_action")
            Map ("<leader>ld", Cmd "lua vim.lsp.buf.implementation()")
            Map ("<leader>lD", Cmd "lua vim.lsp.buf.definition()")
            Map ("<leader>lf", Cmd "Lspsaga lsp_finder")
            Map ("<leader>lr", Cmd "Lspsaga rename")
            Map ("<leader>pd", Cmd "Lspsaga preview_definition")
            Map ("<C-K>", Cmd "Lspsaga hover_doc")
            Map ("<C-T>", Cmd "Lspsaga open_floaterm")
            Map ("<C-T>", Cmd "Lspsaga close_floaterm", "t")
        end
    }

    -- Git
    use {
        'tpope/vim-fugitive',
        cmd = "G",
    }

    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end,
        after = "plenary.nvim"
    }

    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icon
        },
        config = function() require'nvim-tree'.setup {} end
    }

    use {
        "ggandor/lightspeed.nvim",
        keys = { "s", "S" },

        config = function ()
            require "lightspeed".setup {
                ignore_case = true,
                limit_ft_matches = 10,
            }
        end
    }

    -- Colors
    use {
        'bluz71/vim-nightfly-guicolors',
        config = function()
            vim.cmd "colorscheme nightfly"
        end
    }
end,

config = {
    git = { clone_timeout = nil }
}})
