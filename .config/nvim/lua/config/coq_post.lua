require "nvim-lsp-installer".on_server_ready(function(server)
    local opts = {}

    server:setup(require "coq".lsp_ensure_capabilities(opts))
end)
