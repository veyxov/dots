require("nvim-lsp-installer").setup {}
local lspconfig = require("lspconfig")
lspconfig.sumneko_lua.setup {}
lspconfig.omnisharp.setup { on_attach = require 'virtualtypes'.on_attach }
lspconfig.tsserver.setup {}
