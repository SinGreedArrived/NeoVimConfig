function _G.ReloadConfig()
	for name, _ in pairs(package.loaded) do
		if name:match("^dev") then
			package.loaded[name] = nil
		end
	end

	dofile(vim.env.MYVIMRC)
end

vim.api.nvim_create_user_command("ReloadConfig", ReloadConfig, { desc = "reload lua.dev.*.lua" })

-- local ts_utils = require("nvim-treesitter.ts_utils")
--
-- local function get_method_name()
-- 	local node = ts_utils.get_node_at_cursor()
--
-- 	while true do
-- 		if node == nil then
-- 			return nil
-- 		end
--
-- 		if node:type() == "field_identifier" then
-- 			break
-- 		end
-- 		local prev = ts_utils.get_previous_node(node, false, false)
-- 		if prev == nil then
-- 			node = node:parent()
-- 		else
-- 			node = prev
-- 		end
-- 	end
--
--
-- 	P(vim.treesitter.get_node_text(node,0))
-- end

-- vim.api.nvim_create_user_command("MethodFind", get_method_name, {})

local function get_current_par()
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

	local rowi = row
	while true do
		local lastLine = vim.api.nvim_buf_get_lines(0, rowi, rowi+1, false) or {""}
		if lastLine[1] == "" then
			break
		end
		if lastLine[1] == nil then
			break
		end
		rowi = rowi +1
	end

	local rowj = row
	while true do
		local lastLine = vim.api.nvim_buf_get_lines(0, rowj, rowj+1, false) or {""}
		if lastLine[1] == "" then
			break
		end
		if lastLine[1] == nil then
			break
		end
		rowj = rowj - 1
		if rowj < 1 then
			break
		end
	end

	local lines = vim.api.nvim_buf_get_lines(0, rowj-1, rowi, false)
	local result = table.concat(lines, " ")

	return result
end

local function ExecCommand()
	local cmd = get_current_par()
	vim.cmd("tabnew | r ! " .. cmd)
end

vim.api.nvim_create_user_command("ExecCommand", ExecCommand, {})
