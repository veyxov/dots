local kfg = function (name) return string.format('require("cfg/%s")', name) end

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

        event = "BufWritePre"
    }

    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons',
            before = "nvim-tree.lua"
        },
        config = function() require'nvim-tree'.setup {} end,

        cmd = "NvimTreeToggle"
    }

    use {
        'ThePrimeagen/harpoon',
        config = function ()
            require("telescope").load_extension('harpoon')
        end,
        after = "telescope.nvim"
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

    -- Full project lsp diagnostics
    use {
        'folke/trouble.nvim',
        cmd = "Trouble"
    }

    -- Colors
    use {
        {
            'bluz71/vim-nightfly-guicolors',
            config = function()
                -- vim.cmd "colorscheme nightfly"
            end
        },
        {
            'rebelot/kanagawa.nvim',
            config = function ()
                -- Default options:
                require('kanagawa').setup({
                    transparent = false,        -- do not set background color
                    dimInactive = true,        -- dim inactive window `:h hl-NormalNC`
                    globalStatus = true,       -- adjust window separators highlight for laststatus=3
                })
                vim.cmd 'color kanagawa'
            end
        }
    }
end,

config = {
    git = { clone_timeout = nil }
}})
