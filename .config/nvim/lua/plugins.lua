local kfg = function (name) return string.format('require("cfg/%s")', name) end

require 'packer'.startup({function(use)
    -- Global deps
    use {
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
        after = "nvim-cmp"
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
        config = function() require'nvim-tree'.setup {} end,

        cmd = "NvimTreeToggle"
    }

    use {
        'ThePrimeagen/harpoon',
        config = function ()
            require("telescope").load_extension('harpoon')
        end,

        keys = { '<leader>hh' }
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

    use {
        'mfussenegger/nvim-dap',
        config = function ()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            dap.adapters.coreclr = {
                type = 'executable',
                command = '/home/iz/.local/share/nvim/dapinstall/dnetcs/netcoredbg/netcoredbg',
                args = {'--interpreter=vscode'}
            }

            dap.configurations.cs = {
            {
                    type = "coreclr",
                    name = "launch - netcoredbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
                    end,
                },
            }
            dapui.setup()
        end,
        requires = {
            {
                "rcarriga/nvim-dap-ui",
            },
            {
                "Pocco81/DAPInstall.nvim",
                config = function ()
                    local dap_install = require("dap-install")

                    dap_install.setup({
                        installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
                    })
                end
            },
        }
    }

    -- Colors
    use {
        {
            'bluz71/vim-nightfly-guicolors',
            config = function()
                vim.cmd "colorscheme nightfly"
            end
        },
        {
            'rebelot/kanagawa.nvim',
            config = function ()
                -- Default options:
                require('kanagawa').setup({
                    dimInactive = true,        -- dim inactive window `:h hl-NormalNC`
                    globalStatus = false,       -- adjust window separators highlight for laststatus=3
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
