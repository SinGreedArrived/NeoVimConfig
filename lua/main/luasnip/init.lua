local ls = require "luasnip"
local types = require("luasnip.util.types")

require("luasnip.session.snippet_collection").clear_snippets "go"
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/luasnippets/" })

-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
})

-- vim.cmd([[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]]) --}}}
-- vim.cmd([[autocmd BufEnter */snippets/*.lua nnoremap <silent> <buffer> <CR> /-- End Refactoring --<CR>O<Esc>O]])

-- require("luasnip.loaders.from_vscode").lazy_load()
-- require("luasnip.session.snippet_collection").clear_snippets "lua"
--
-- local snippet_from_nodes = ls.sn
--
-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local rep = require("luasnip.extras").rep
-- local fmt = require("luasnip.extras.fmt").fmt
--
-- local ts_locals = require "nvim-treesitter.locals"
-- local ts_utils = require "nvim-treesitter.ts_utils"
-- local get_node_text = vim.treesitter.get_node_text
--
-- vim.treesitter.set_query(
--   "go",
--   "LuaSnip_Result",
--   [[ [
--     (method_declaration result: (_) @id)
--     (function_declaration result: (_) @id)
--     (func_literal result: (_) @id)
--   ] ]]
-- )
--
--
--
-- local same = function(index)
--   return f(function(args)
-- 		print(vim.inspect(args))
--     return args[1]
--   end, { index })
-- end
--
-- -- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
-- local transform = function(text, info)
--   if text == "int" then
--     return t "0"
--   elseif text == "error" then
--     if info then
--       info.index = info.index + 1
--       return c(info.index, {
-- 				t(
-- 					string.format(
-- 						'fmt.Errorf("%s: %%w", %s)',
-- 						string.gsub(info.func_name, "[^.]+%.","",1),
-- 						info.err_name
-- 					)
-- 				),
-- 				t(string.format(
-- 					'fmt.Errorf("%s: %%w", %s)',
-- 					info.func_name,
-- 					info.err_name
-- 					)
-- 				),
--         t(info.err_name),
--       })
--     else
--       return t "err"
--     end
--   elseif text == "bool" then
--     return t "false"
--   elseif text == "string" then
--     return t '""'
--   elseif string.find(text, "*", 1, true) then
--     return t "nil"
--   end
--
--   return t(text)
-- end
--
-- local handlers = {
--   ["parameter_list"] = function(node, info)
--     local result = {}
--
--     local count = node:named_child_count()
--     for idx = 0, count - 1 do
--       table.insert(
-- 				result,
-- 				transform(
-- 					get_node_text(
-- 						node:named_child(idx),
-- 						0
-- 					),
-- 					info
-- 				)
-- 			)
--       if idx ~= count - 1 then
--         table.insert(result, t { ", " })
--       end
--     end
--
--     return result
--   end,
--
--   ["type_identifier"] = function(node, info)
--     local text = get_node_text(node, 0)
--     return { transform(text, info) }
--   end,
-- }
--
-- local function go_result_type(info)
--   local cursor_node = ts_utils.get_node_at_cursor()
--   local scope = ts_locals.get_scope_tree(cursor_node, 0)
--
--   local function_node
--   for _, v in ipairs(scope) do
--     if v:type() == "function_declaration" or
--       v:type() == "method_declaration" or
--       v:type() == "func_literal" then
--       function_node = v
--       break
--     end
--   end
--
--   local query = vim.treesitter.get_query("go", "LuaSnip_Result")
--   for _, node in query:iter_captures(function_node, 0) do
--     if handlers[node:type()] then
--       return handlers[node:type()](node, info)
--     end
--   end
-- end
--
-- local go_ret_vals = function(args)
-- 	local cursor_node = ts_utils.get_node_at_cursor()
-- 	P(cursor_node)
--   return sn(nil, t"")
-- 	-- snippet_from_nodes(
--  --    nil,
--  --    go_result_type {
--  --      index = 0,
--  --      err_name = args[1][1],
--  --      func_name = args[2][1],
--  --    }
--  --  )
-- end
--
--
-- ls.add_snippets("lua", {
-- 	s( {trig = "mytest", descr = "EXAMPLE"}, fmt([[ example: {}, function: {} ]], { i(1), same(1) }))
-- })
--
-- ls.add_snippets("go", {
-- 	s("test", fmt([[ TEST:{}, EXAMPLE:{}, {} ]], { i(1), i(2), d(3, go_ret_vals , {1,2})})),
-- 	s("fn", fmt(
-- 		[[
-- 			func {} {}({}) {} {{
-- 				{}
-- 			}}
-- 		]],{
-- 			c(1, {
-- 				t(""),
-- 				sn(nil, {
-- 					t("("),
-- 					i(1),
-- 					t(" "),
-- 					c(2, {
-- 						t(""),
-- 						t("*")
-- 					}),
-- 					i(3),
-- 					t(")"),
-- 				}),
-- 			}),
-- 			i(2, "Function"),
-- 			i(3),
-- 			c(4, {
-- 				sn(nil, {
-- 					r(1, "result", i(1)),
-- 				}),
-- 				sn(nil, {
-- 					t("("),
-- 					r(1, "result"),
-- 					t(",error)"),
-- 				}),
-- 				sn(nil, {
-- 					t("("),
-- 					r(1, "result"),
-- 					i(2),
-- 					t(")"),
-- 				}),
-- 			}),
-- 			i(0),
-- 	})),
-- 	s({
-- 		trig = "ap",
-- 		dscr = "append to array",
-- 		}, fmt(
-- 		[[
-- 			{} = append({}, {})
-- 			{}
-- 		]], {
-- 			i(1,"array"),
-- 			rep(1),
-- 			i(2, "interface{}"),
-- 			i(0)
-- 	})),
-- 	s(
-- 		{
-- 			trig="forr([%S]+)",
-- 			regTrig=true,
-- 		}, fmt(
-- 		[[
-- 			for {} := range {} {{
-- 			{}
-- 		}}
-- 		]], {
-- 			c(1, {
-- 				sn(nil, {
-- 					r(1, "index", i(1)),
-- 				}),
-- 				sn(nil, {
-- 					t("_, "),
-- 					r(1, "value", i(1)),
-- 				}),
-- 				sn(nil, {
-- 					r(1, "index"),
-- 					t(", "),
-- 					r(2, "value"),
-- 				}),
-- 			}),
-- 			d(2, function (_, snip)
-- 				return sn(2, i(2, snip.captures[1]))
-- 			end),
-- 			i(0),
-- 	})),
-- 	s("ife", fmt(
-- 		[[
-- 			if {} := {}{}({}); err != nil {{
-- 				return fmt.Errorf("{}: %w", err)
-- 			}}
-- 		]], {
-- 			c(1, { t("_, err"), t("err")}),
-- 			i(2, "obj"),
-- 			i(3, "Meth"),
-- 			i(4, "args"),
-- 			rep(3),
-- 	})),
-- 	s("ife", fmt(
-- 		[[
-- 			{}, {} := {}{}({})
-- 			if {} != nil {{
-- 				return {}
-- 			}}
-- 		]], {
-- 			i(1, "result"),
-- 			i(2, "err"),
-- 			i(3, "object"),
-- 			i(4, "function"),
-- 			i(5),
-- 			rep(2),
-- 			d(6, go_ret_vals, {2,4} ),
-- 	})),
-- 	s( "rerr", fmt(
-- 		[[
-- 			{}.Require().{}(err)
-- 		]], {
-- 			i(1),
-- 			c(2, { t("NoError"), t("Error") })
-- 	})),
-- 	s( "err", fmt(
-- 		[[
-- 			if err != nil {{
-- 			return {}
-- 		}}
-- 		]],{
-- 			c(1, {
-- 				t('fmt.Errorf(" %w", err)'),
-- 				t('err'),
-- 			}),
-- 	})),
-- 	s("typ", fmt(
-- 		[[
-- 			type {} {} {{
-- 				{}
-- 			}}
-- 		]],{
-- 			i(1, "TypeName"),
-- 			c(2, {
-- 				t("struct"),
-- 				t("interface"),
-- 			}),
-- 			i(0),
-- 		})),
-- 		s({
-- 			trig = "debug_print",
-- 			dscr = "debug print struct",
-- 		},{
-- 			t({"","func(i interface{}) {",
-- 			"\tdata, _ := json.MarshalIndent(i, \"\", \"\\t\")",
-- 			"\tfmt.Println(string(data))",
-- 			"}("}), i(0, "interface{}"), t({")",""})
-- 		}),
-- },{
--     key = "go",
-- })
