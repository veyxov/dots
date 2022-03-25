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

    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        config = kfg 'lualine',
        after = "vim-nightfly-guicolors"
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

        keys = { '<leader>hh' }
    }
--[[
    use {
        "ggandor/lightspeed.nvim",
        keys = { "s", "S" },

        config = function ()
            require "lightspeed".setup {
                ignore_case = true,
                jump_to_unique_chars = { safety_timeout = nil },
            }
        end
    }
--]]
    use {
        'ggandor/leap.nvim',
        config = function()
            require 'leap'.set_default_keymaps()
            require('leap').setup {
                safe_labels = {'a', 'r', 's', 't', 'n', 'e', 'i', 'o', 'f', 'l', 'u', 'y', 'w', 'q', 'g', 'm' },
                labels = {'a', 'r', 's', 't', 'n', 'e', 'i', 'o', 'f', 'l', 'u', 'y', 'w', 'q', 'g', 'm' },
            }
        end,
        keys = { 's', 'S'}
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
                vim.cmd "colorscheme nightfly"
            end,
            event = "InsertEnter"
        },
        {
            'rebelot/kanagawa.nvim',
            config = function ()
                -- Default options:
                require('kanagawa').setup({
                    dimInactive = true,
                    globalStatus = true,
                })
                -- vim.cmd 'color kanagawa'
            end,
            event = "InsertEnter"
        }
    }
end,

config = {
    git = { clone_timeout = nil }
}})
-- Chek:
-- https://github.com/nvim-neo-tree/neo-tree.nvim/tree/v2.x
