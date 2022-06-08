local kfg = function(name) return string.format('require("cfg/%s")', name) end

require 'packer'.startup({ function(use)
    -- Global dependencies
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
                config = function() require('telescope').load_extension('fzf') end,
                after = 'telescope.nvim'
            },
        },

        config = kfg 'telescope',
    }

    -- Tree-Sitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate", event = "InsertEnter",

        config = kfg "treesitter"
    }

    -- Language server protocol
    use {
        { 'neovim/nvim-lspconfig', after = "nvim-treesitter" },
        { 'williamboman/nvim-lsp-installer', after = "nvim-lspconfig", config = kfg "lsp" },

        { 'tami5/lspsaga.nvim', cmd = 'Lspsaga' },
        { 'jubnzv/virtual-types.nvim' }
    }

    -- Autocomplete
    use {
        -- Eye candy
        { "onsails/lspkind-nvim", after = "nvim-lsp-installer" },

        -- Snippets
        { 'L3MON4D3/LuaSnip', after = "lspkind-nvim", config = kfg 'luasnip' },
        { 'rafamadriz/friendly-snippets' },

        { 'hrsh7th/nvim-cmp', after = "LuaSnip", config = kfg 'cmp' },
        -- Source
        { "f3fora/cmp-spell", after = "nvim-cmp" },
        { "hrsh7th/cmp-path", after = "nvim-cmp" },
        { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
        { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
        { "ray-x/cmp-treesitter", after = "nvim-cmp" },
        { "andersevenrud/cmp-tmux", after = "nvim-cmp" },
        { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
        { "github/copilot.vim" },
    }

    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        config = kfg 'lualine',
        after = "nvim-cmp"
    }

    use {
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup {}
        end,
        after = "TrueZen.nvim",
    }

    use {
        "Pocco81/TrueZen.nvim",
        config = kfg 'zen',
        cmd = "TZAtaraxis"
    }

    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
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

        event = { "BufRead", "BufNewFile" },
    }

    use {
        --a minimalist autopairs
        'windwp/nvim-autopairs',
        config = function()
            require 'nvim-autopairs'.setup()
        end
    }

    use {
        'ThePrimeagen/harpoon',
        config = function()
            require("telescope").load_extension('harpoon')
        end,
    }

    use {
        'ggandor/leap.nvim',
        config = kfg 'speed',
        keys = { 's', 'S' }
    }
    -- Full project lsp diagnostics
    use {
        'folke/trouble.nvim',
        cmd = "Trouble"
    }

    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = "MunifTanjim/nui.nvim",
        config = kfg 'tree',
        cmd = "Neotree"
    }

    use {
        'lewis6991/spellsitter.nvim',
        config = function()
            require('spellsitter').setup()
        end
    }

    use 'seandewar/killersheep.nvim'
    -- Colors
    use { 'dracula/vim' }
    use { 'adamclerk/vim-razor' }
    use { "rmehri01/onenord.nvim" }
    use { 'folke/tokyonight.nvim' }
    use { "ellisonleao/gruvbox.nvim" }
    use { 'marko-cerovac/material.nvim' }
    use { 'sainnhe/sonokai', config = function() vim.cmd [[ colorscheme sonokai ]] end }

end,

    config = {
        git = { clone_timeout = nil }
    } })
-- Chek:
-- https://github.com/nvim-neo-tree/neo-tree.nvim/tree/v2.x
