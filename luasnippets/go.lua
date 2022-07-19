local ls = require("luasnip") --{{{
local s = ls.s
local i = ls.i
local t = ls.t

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local r = ls.restore_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local snippets, autosnippets = {}, {} --}}}

local group = vim.api.nvim_create_augroup("Golang Snippets", { clear = true })
local file_pattern = "*.go"

local function cs(trigger, nodes, opts) --{{{
	local snippet = s(trigger, nodes)
	local target_table = snippets

	local pattern = file_pattern
	local keymaps = {}

	if opts ~= nil then
		-- check for custom pattern
		if opts.pattern then
			pattern = opts.pattern
		end

		-- if opts is a string
		if type(opts) == "string" then
			if opts == "auto" then
				target_table = autosnippets
			else
				table.insert(keymaps, { "i", opts })
			end
		end

		-- if opts is a table
		if opts ~= nil and type(opts) == "table" then
			for _, keymap in ipairs(opts) do
				if type(keymap) == "string" then
					table.insert(keymaps, { "i", keymap })
				else
					table.insert(keymaps, keymap)
				end
			end
		end

		-- set autocmd for each keymap
		if opts ~= "auto" then
			for _, keymap in ipairs(keymaps) do
				vim.api.nvim_create_autocmd("BufEnter", {
					pattern = pattern,
					group = group,
					callback = function()
						vim.keymap.set(keymap[1], keymap[2], function()
							ls.snip_expand(snippet)
						end, { noremap = true, silent = true, buffer = true })
					end,
				})
			end
		end
	end

	table.insert(target_table, snippet) -- insert snippet into appropriate table
end --}}}

-- Start Refactoring --
local testmode = s("testmode", t("This is test mode") )
table.insert(snippets, testmode)

local forrange = s({ trig = "forr%s+(%S+)", regTrig = true, hidden = true }, fmt(
	[[
		for {} := range {} {{
			{}
		}}
	]], {
		c(1, {
			sn(1, {
				i(1, "i"),
			}),
			sn(1, {
				t("_, "),
				i(1, "v"),
			}),
			sn(1, {
				i(1, "i"),
				t(", "),
				i(2, "v"),
			}),
		}),
		f(function (_, snip)
			return snip.captures[1]
		end),
		i(0),
}))
table.insert(snippets, forrange)

local rerr = s({ trig = "rerr(%w+)", regTrig = true, hidden = true }, fmt(
	[[
		{}.Require().{}(err)
	]], {
		f(function (_, snip)
			return snip.captures[1]
		end),
		c(1, { t("NoError"), t("Error") })
}))
table.insert(snippets, rerr)

local type = s("type", fmt(
	[[
		type {} {} {{
			{}
		}}
	]],{
		i(1, "TypeName"),
		c(2, {
			t("struct"),
			t("interface"),
		}),
		i(0),
}))
table.insert(autosnippets, type)


local if_err_check = s("ife", fmt(
	[[
		if {} := {}{}({}); err != nil {{
			return fmt.Errorf("{}: %w", err)
		}}
	]], {
		c(1, { t("_, err"), t("err")}),
		i(2, "obj"),
		i(3, "Meth"),
		i(4, "args"),
		rep(3),
}))
table.insert(snippets, if_err_check)

local append = s({trig="ap%s+(%w+)", regTrig = true, hidden = true}, fmt(
	[[
		{} = append({}, {})
	]], {
		d(1,function (_, snip)
			return sn(1, i(1, snip.captures[1]))
		end),
		rep(1),
		i(0),
}))
table.insert(snippets, append)

local func = s({trig="fn%s+(.+)", regTrig=true}, fmt(
		[[
			// {}
			func {} {}({}) {} {{
				{}
			}}
		]],{
			f(function (index)
				return index[1]
			end, {2}),
			c(1, {
				t(""),
				sn(nil, {
					t("("),
					i(1),
					t(" "),
					c(2, {
						t(""),
						t("*")
					}),
					i(3),
					t(")"),
				}),
			}),
			d(2, function (_, snip)
				return sn(1, i(1, snip.captures[1]))
			end),
			i(3),
			c(4, {
				sn(nil, {
					r(1, "result", i(1)),
				}),
				sn(nil, {
					t("("),
					r(1, "result"),
					t(",error)"),
				}),
			}),
			i(0),
}))
table.insert(snippets, func)


local make_slice_or_map = s({ trig="make%s+(%S+)", regTrig=true}, fmt(
	[[
		{} := make({}{})
	]], {
		f(function (import)
			local parts = vim.split(import[1][1], ".", true)
			return parts[#parts]:gsub("^%u", string.lower)
		end, {1}),
		d(1, function (_, snip)
			return sn(1, i(1, snip.captures[1]))
		end),
		c(2, {
			sn(nil, {
				i(1),
			}),
			sn(nil, {
				t(","),
				r(1, "lenArr", i(1,"0")),
			}),
			sn(nil, {
				t(","),
				r(1, "lenArr"),
				t(","),
				r(2, "alloc", i(1,"0")),
			}),
		})
}))
table.insert(snippets, make_slice_or_map)

local var = s({ trig="var%s+(%S+)", regTrig=true}, fmt(
	[[
		var {} {}
	]], {
		f(function (import)
			local parts = vim.split(import[1][1], ".", true)
			return parts[#parts]:gsub("^%u", string.lower)
		end, {1}),
		d(1, function (_, snip)
			return sn(1, i(1, snip.captures[1]))
		end),
}))
table.insert(snippets, var)

-- End Refactoring --

return snippets, autosnippets
