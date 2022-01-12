-- Install servers
local lsp_installer = require("nvim-lsp-installer")
local lsp_installer_servers = require('nvim-lsp-installer.servers')

lsp_installer.settings{
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
}

-- Servers to install with nvim-lsp-installer
local servers = { 'html', 'clangd', 'omnisharp', 'sumneko_lua' }

-- Install servers of the list if they aren't installed
for _, currServer in ipairs(servers) do
    local ok, server =  lsp_installer_servers.get_server(currServer)
    if ok and not server:is_installed() then
        server:install()
    end
end

-- server's setup via lsp_installer
lsp_installer.on_server_ready(function(server)
    local cmp_capabilities = require("cmp_nvim_lsp").update_capabilities

    local opts = {
        on_attach = on_attach,
        capabilities = cmp_capabilities(vim.lsp.protocol.make_client_capabilities()),
        flags = { debounce_text_changes = 150 },
    }
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)

-- Change the default lsp diagnostic symbols
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for name, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. name
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end
