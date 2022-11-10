local ls = require("luasnip") -- {{{
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

local snippets, autosnippets = {}, {} -- }}}

local group = vim.api.nvim_create_augroup("Golang Snippets", { clear = true })
local file_pattern = "*.go"

local function cs(trigger, nodes, opts) -- {{{
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
end -- }}}

-- Start Refactoring --
local testmode = s("testmode", t("This is test mode"))
table.insert(snippets, testmode)

local forrange = s(
	{ trig = "forr%s+(%S+)", regTrig = true, hidden = true },
	fmt(
		[[
		for {} := range {} {{
			{}
		}}
	]],
		{
			c(1, {
				sn(1, { i(1, "i") }),
				sn(1, { t("_, "), i(1, "v") }),
				sn(1, { i(1, "i"), t(", "), i(2, "v") }),
			}),
			f(function(_, snip)
				return snip.captures[1]
			end),
			i(0),
		}
	)
)
table.insert(snippets, forrange)

-- local type = s({trig = "type%s+(%S+)", regTrig = true, hidden = true}, fmt([[
-- 		type {} {} {{
-- 			{}
-- 		}}
-- 	]], {
--     d(1, function(_, snip) return sn(1, i(1, snip.captures[1])) end),
--     c(2, {t("struct"), t("interface")}), i(0)
-- }))
-- table.insert(snippets, type)

local if_err_check = s(
	"ife-",
	fmt(
		[[
		if {} := {}{}({}); err != nil {{
			return {}
		}}
	]],
		{
			c(1, { t("_, err"), t("err") }),
			i(2, "obj"),
			i(3, "Meth"),
			i(4, "args"),
			d(5, function(import)
				return sn(nil, {
					i(1),
					t([[, fmt.Errorf("]]),
					t(import[1][1]),
					t([[: %w", err)]]),
				})
			end, { 3 }),
		}
	)
)
table.insert(snippets, if_err_check)

local append = s(
	{ trig = "ap%s+(%S+)", regTrig = true, hidden = true },
	fmt(
		[[
		{} = append({}, {})
	]],
		{
			d(1, function(_, snip)
				return sn(1, i(1, snip.captures[1]))
			end),
			rep(1),
			i(0),
		}
	)
)
table.insert(snippets, append)

local func = s(
	{ trig = "fn%s+(.+)", regTrig = true, hidden = true },
	fmt(
		[[
			// {}
			func {} {}({}) {} {{
				{}
			}}
		]],
		{
			f(function(index)
				return index[1]
			end, { 2 }),
			c(1, {
				t(""),
				sn(nil, { t("("), i(1), t(" "), c(2, { t(""), t("*") }), i(3), t(")") }),
			}),
			d(2, function(_, snip)
				return sn(1, i(1, snip.captures[1]))
			end),
			i(3),
			c(4, {
				sn(nil, { r(1, "result", i(1)) }),
				sn(nil, { t("("), r(1, "result"), t(",error)") }),
			}),
			i(0),
		}
	)
)
table.insert(snippets, func)

local make_slice_or_map = s(
	{
		trig = "make%s+(%S+)",
		regTrig = true,
		hidden = true,
	},
	fmt(
		[[
		{} := make({}{})
	]],
		{
			f(function(import)
				local parts = vim.split(import[1][1], ".", true)
				return parts[#parts]:gsub("^%u", string.lower)
			end, { 1 }),
			d(1, function(_, snip)
				return sn(1, i(1, snip.captures[1]))
			end),
			c(2, {
				sn(nil, { i(1) }),
				sn(nil, { t(","), r(1, "lenArr", i(1, "0")) }),
				sn(nil, { t(","), r(1, "lenArr"), t(","), r(2, "alloc", i(1, "0")) }),
			}),
		}
	)
)
table.insert(snippets, make_slice_or_map)

local var = s(
	{ trig = "var%s+(%S+)", regTrig = true, hidden = true },
	fmt(
		[[
		var {} {}
	]],
		{
			f(function(import)
				local parts = vim.split(import[1][1], ".", true)
				return parts[#parts]:gsub("^%u", string.lower)
			end, { 1 }),
			d(1, function(_, snip)
				return sn(1, i(1, snip.captures[1]))
			end),
		}
	)
)
table.insert(snippets, var)

local rerr = s(
	{ trig = "rerr", regTrig = true },
	fmt(
		[[
		{}.Require().{}
	]],
		{
			i(1),
			c(2, {
				t("NoError(err)"),
				t("Error(err)"),
				sn(nil, { t("ErrorIs("), i(1), t(", "), i(2), t(")") }),
			}),
		}
	)
)
table.insert(autosnippets, rerr)

local if_err = s(
	{ trig = "ife" },
	fmt(
		[[
		if err != nil {{
			return {}
		}}
	]],
		{
			c(1, {
				sn(nil, { i(1) }),
				sn(nil, {
					t([[fmt.Errorf("]]),
					r(1, "errFunc", i(1, "errFunc")),
					t([[: %w", err)]]),
				}),
				sn(nil, { i(1), t([[, fmt.Errorf("]]), r(2, "errFunc"), t([[: %w", err)]]) }),
			}),
		}
	)
)
table.insert(snippets, if_err)

local baseRepo = s(
	{ trig = "baseRepo" },
	fmt(
		[[
	// {} repository.
	type {} struct {{
		db *sqlx.DB
	}}

	// New{} return {} repository.
	func New{}(
		db *sqlx.DB,
	) {} {{
		return {}{{
			db:db,
		}}
	}}
]],
		{
			i(1, "RepoName"),
			rep(1),
			rep(1),
			rep(1),
			rep(1),
			rep(1),
			rep(1),
		}
	)
)
table.insert(snippets, baseRepo)

local dbIntToValue = s(
	{ trig = "dbIntToValue" },
	fmt(
		[[
	type {} int64

	// Value.
	func ({} {}) Value() value.{} {{
		return value.New{}(strconv.FormatInt(int64({}), 10))
	}}

	func ({} *{}) ValuePtr() *value.{} {{
		if {} == nil {{
			return nil
		}}

		return &{}.Value()
	}}
	{}
]],
		{
			i(1, "TypeName"),
			i(2, "i"),
			rep(1),
			rep(1),
			rep(1),
			rep(2),
			rep(2),
			rep(1),
			rep(1),
			rep(2),
			rep(2),
			i(0),
		}
	)
)
table.insert(snippets, dbIntToValue)

local baseService = s(
	{ trig = "baseService" },
	fmt(
		[[
	// Service.
	type {} struct {{
		{}
	}}

	// New service.
	func New(
		{}
	) *{} {{
		s := &{}{{
			{}
		}}

		return s
	}}
	{}
]],
		{
			i(1, "Service"),
			i(2, ""),
			rep(2),
			rep(1),
			rep(1),
			rep(2),
			i(0),
		}
	)
)
table.insert(snippets, baseService)

-- PSS admin methods
local pss_service = s(
	{ trig = "pss_service" },
	fmt(
		[[
		type {}Repo interface {{
			{}ByID(ctx context.Context, id string) (entity.{u}, error)
			{u}s(ctx context.Context) ([]entity.{u}, error)
			Create{u}(ctx context.Context, {} entity.{u},) (entity.{u}, error)
			Update{u}(ctx context.Context, {arg} entity.{u},) (entity.{u}, error)
			Delete{u}(ctx context.Context, id string,) error
		}}

		// {u}ByID returns {l} by id.
		func (s Service) {u}ByID(
			ctx context.Context,
			id string,
		) (entity.{u}, error) {{
			return s.{l}Repo.{u}ByID(ctx, id)
		}}


		// {u}s returns all {l}.
		func (s Service) {u}s(ctx context.Context) ([]entity.{u}, error) {{
			return s.{l}Repo.{u}s(ctx)
		}}

		// Create{u} creates {l}.
		func (s Service) Create{u}(
			ctx context.Context,
			{arg} entity.{u},
		) (entity.{u}, error) {{
			return s.{l}Repo.Create{u}(ctx, {arg})
		}}

		// Update{u} updates {l}.
		func (s Service) Update{u}(
			ctx context.Context, 
			{arg} entity.{u},
		) (entity.{u}, error) {{
			return s.{l}Repo.Update{u}(ctx, mg)
		}}

		// Delete{u} deletes {l}.
		func (s Service) Delete{u}(
			ctx context.Context, 
			id string,
		) error {{
			return s.{l}Repo.Delete{u}(ctx, id)
		}}
]],
		{
			i(1, "Entity"),
			i(2, "entity"),
			i(3, "arg"),
			u = rep(1),
			l = rep(2),
			arg = rep(3),
		}
	)
)
table.insert(snippets, pss_service )

local pss_repo = s({trig= "pss-repo"}, fmt([[
	// {}ByID returns {} by id.
	func ({} {u}) {u}ByID(ctx context.Context, id string) (entity.{u}, error) {{
		var res entity.{u}

		if err := c.db.GetContext(
			ctx, 
			&res, 
			`
			`, 
			id,
		); err != nil {{
			if errors.Is(err, sql.ErrNoRows) {{
				return res, failure.NewNotFoundError(fmt.Sprintf("{l} id %v", id))
			}}

			return res, fmt.Errorf("db.GetContext: %w", err)
		}}
	
		return res, err
	}}
	
	// {u}s returns all {l}.
	func ({s} {u}) {u}s(ctx context.Context) ([]entity.{u}, error) {{
		var res []entity.{u}

		if err := c.db.SelectContext(
			ctx, 
			&res, 
			`
			`,
		); err != nil {{
			return nil, fmt.Error("db.SelectContext: %w", err)
		}}
	
		return res, nil
	}}
	
	// Create{u} creates {l}.
	func ({s} {u}) Create{u}(ctx context.Context, {} entity.{u}) (entity.{u}, error) {{
		{arg}.ID = entity.GenerateUID()

		if _, err := c.db.NamedExecContext(
			ctx, 
			``, 
			{arg},
		); err != nil {{
			return entity.{u}, fmt.Errorf("db.NamedExecContext: %w", err)
		}}
	
		return cf, nil
	}}
	
	// Update{u} updates {l}.
	func ({s} {u}) Update{u}(ctx context.Context, {arg} entity.{u}) error {{
		if _, err := c.db.NamedExecContext(
			ctx, 
			``,
			{arg},
		); err != nil {{
			return fmt.Errorf("db.NamedExecContext: %w", err)
		}}
	
		return nil
	}}
	
	// Delete{u} deletes {l}.
	func ({s} {u}) Delete{u}(ctx context.Context, id string) error {{
		if _, err := c.db.ExecContext(
			ctx, 
			`
			`,
			id,
		); err != nil {{
			return fmt.Errorf("db.ExecContext: %w", err)
		}}

		return nil
	}}
]], {
	i(1, "ENITITY"),
	i(2, "enitity"),
	i(3, "r"),
	i(4, "arg"),
	u = rep(1),
	l = rep(2),
	s = rep(3),
	arg = rep(4),
}))
table.insert(snippets, pss_repo)
-- End Refactoring --

return snippets, autosnippets
