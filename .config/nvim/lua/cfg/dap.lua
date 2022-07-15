local dap = require 'dap'

dap.adapters.coreclr = {
  type = 'executable',
  command = '/home/iz/netcoredbg/netcoredbg',
  args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return "/home/iz/Projects/Alif/Audit/src/Api/bin/Debug/net6.0/Api.dll"
    end,
  },
}
