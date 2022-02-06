local function RunShell(what) vim.fn.system(what) end
local function RunTmux(what, type) RunShell(string.format('tmux %s "%s"', type, what)) end

function Run()
	vim.cmd [[:wall]]
	local cmd = string.format('g++ -DLOCAL --std=c++20 -Wall %s && echo "Ok" && ./a.out ; read', vim.api.nvim_buf_get_name(0))
	-- local final = string.format('tmux split -h "%s"', cmd)
	local final = string.format('tmux split -h "%s"', cmd)
	vim.fn.system(final)
end

Map('n', '<leader>rr', Cmd 'lua Run()')
