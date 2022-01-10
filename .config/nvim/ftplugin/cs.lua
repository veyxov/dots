-- TODO: Make this async
local function RunShell(what) vim.fn.system(what) end
local function RunTmux(what, type) RunShell(string.format('tmux %s "%s"', type, what)) end

function Build()
	RunTmux('dotnet build -v d', 'split -h')
	vim.cmd [[ :Trouble ]]
end

function Run() RunTmux('dotnet run -v d; read', 'neww') end

function OnlyRun() RunTmux('dotnet run -v d --no-build; read', 'neww') end

Map('n', '<leader>bb', Cmd 'lua Build()')
Map('n', '<leader>br', Cmd 'lua OnlyRun()')
Map('n', '<leader>bR', Cmd 'lua Run()')
