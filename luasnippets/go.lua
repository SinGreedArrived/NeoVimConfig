local ls = require("luasnip") -- {{{
local s = ls.s
local i = ls.i
local t = ls.t
local l = require("luasnip.extras").lambda

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

local firstChar = function(args)
	local firstChar = string.lower(args[1][1]:sub(1, 1))
	return sn(nil, {
		t(firstChar),
	})
end

local camelToSnake = function (args)
	local word = args
	local result = ""
	local nbr = true

	word:gsub(".", function(char)
		if nbr then
			result = result..char:lower()
			nbr = false

			return
		end

		if char >= 'A' and char <= 'Z' then
			result = result..'_'..char:lower()

			return
		end

		result = result..char
	end)

	return result
end

local upperCase = function(args)
	local res = string.upper(camelToSnake(args[1][1]))
	return sn(nil, {
		t(res),
	})
end


local lowerStart = function(args)
	local lowerCase = args[1][1]:gsub("%a", string.lower, 1)
	return sn(nil, {
		t(lowerCase),
	})
end

local upperStart = function(args)
	local uc = args[1][1]:gsub("%a", string.upper, 1)
	return sn(nil, {
		t(uc),
	})
end

local trimNumber = function(args)
	local res = args[1][1]:gsub("%d+", "")
	return sn(nil, {
		t(res),
	})
end


local trim_parenthese = function(args)
	return args:gsub("%(", ""):gsub("%)", ""):gsub("%s", "")
end

local func_name_for_err = function()
	local curLine = vim.api.nvim_win_get_cursor(0)[1]

	for j = curLine, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(0, j - 1, j, false)[1]
		local func_name = line:match("err :?= ([^(]+)%(")
		if func_name then
			local _, dot_count = func_name:gsub("%.", "")
			if dot_count > 1 then
				return func_name:gsub("%w+%.", "", dot_count - 1)
			end
			return func_name:gsub("%w", string.lower, 1)
		end
	end
end

local split = function(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local result = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(result, str)
	end
	return result
end

local get_nil_value = function(type)
	local nilValue = {}
	nilValue["^string$"] = [[""]]
	nilValue["^bool$"] = "false"
	nilValue["^%*"] = "nil"
	nilValue["^error$"] = [[fmt.Errorf("]] .. func_name_for_err() .. [[: %w", err)]]
	nilValue["u?int%d?%d?"] = "0"
	nilValue["float%d?%d?"] = "0.0"
	nilValue["^%w+%..*$"] = type .. "{}"

	for key, value in pairs(nilValue) do
		if type:match(key) then
			return value
		end
	end

	return "nil"
end

local get_return = function()
	return f(function()
		local result = "return "
		local curLine = vim.api.nvim_win_get_cursor(0)[1]
		local method_result = ""

		for j = curLine, 1, -1 do
			local line = vim.api.nvim_buf_get_lines(0, j - 1, j, false)[1]

			if line:match("^%)%s(.*)%s{$") then
				method_result = line:match("^%)%s(.*)%s{$")
			end

			if line:match("^func") then
				method_result = line:match("^func.*%)%s(.*)%s{$")
			end

			if method_result ~= "" and method_result ~= nil  then
				local returns = split(trim_parenthese(method_result), ",")
				for _, value in ipairs(returns) do
					local val = get_nil_value(value)
					result = result .. val .. ", "
				end
				return result:gsub(",%s$", "")
			end
		end

		return result
	end, {})
end

-- Start Refactoring --
local testmode = s("testmode", t("This is test mode"))
table.insert(snippets, testmode)

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

local iferr = s(
	{ trig = "iferr" },
	fmt(
		[[
	if err != nil {{
		{}
	}}
]],
		{ get_return() }
	)
)
table.insert(snippets, iferr)

local append = s(
	{ trig = "ap", regTrig = true, hidden = true },
	fmt(
		[[
		{ArrRep} = append({Arr}, {})
	]],
		{
			Arr = i(1),
			ArrRep = rep(1),
			i(0),
		}
	)
)
table.insert(snippets, append)

local func = s(
	{ trig = "fn%s+(.+)", regTrig = true, hidden = true },
	fmt(
		[[
			// {} ...
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
				sn(nil, { t("("), i(1), t(" "), i(2), t(")") }),
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


-- TODO replace
-- -- baseService
-- local baseService = s(
-- 	{ trig = "baseService" },
-- 	fmt(
-- 		[[
-- 	// Service.
-- 	type {Name} struct {{
-- 		{fields}
-- 	}}
--
-- 	// New service.
-- 	func New(
-- 		{fieldsRepWithComm}
-- 	) *{NameRep} {{
-- 		s := &{NameRep}{{{}}}
--
-- 		return s
-- 	}}
-- ]],
-- 		{
-- 			Name = i(1, "Service"),
-- 			fields = i(2, ""),
-- 			NameRep = rep(1),
-- 			fieldsRepWithComm = l(l._1:gsub("\n", ",\n"), 2),
-- 			i(0),
-- 		}
-- 	)
-- )
-- table.insert(snippets, baseService)
--
local baseRepo = s(
	{ trig = "baseRepo" },
	fmt(
		[[
	// {RepoName} repository.
	type {RepoNameRep} struct {{
		db *sqlx.DB
	}}

	// New{RepoNameRep} return {RepoNameRep} repository.
	func New{RepoNameRep}(
		db *sqlx.DB,
	) {RepoNameRep} {{
		return {RepoNameRep}{{
			db:db,
		}}
	}}
]],
		{
			RepoName = i(1, "RepoName"),
			RepoNameRep = rep(1),
		}
	)
)
table.insert(snippets, baseRepo)

-- VALUE SNIPPETS --
--
local valueStr = s(
	{ trig = "valueStr" },
	fmt(
		[[
	package value

	type {Name} string

	func New{NameRep}({value} string) {NameRep} {{
		return {NameRep}({valueRep})
	}}

	func ({char} {NameRep}) String() string {{
		return string({charRep})
	}}

	func ({charRep} *{NameRep}) StringPtr() *string {{
		if {charRep} == nil {{
			return nil
		}}

		res := {charRep}.String()

		return &res
	}}
	{}
]],
		{
			Name = i(1, "Name"),
			NameRep = rep(1),
			value = d(2, lowerStart, 1),
			valueRep = rep(2),
			char = d(3, firstChar, 1),
			charRep = rep(3),
			i(0),
		}
	)
)
table.insert(snippets, valueStr)

local valueUint = s(
	{ trig = "valueUint" },
	fmt(
		[[
	package value

	type {Name} {valueType}

	func New{NameRep}({value} {valueTypeRep}) {NameRep} {{
		return {NameRep}({valueRep})
	}}

	func ({char} {NameRep}) {ValueType}() {valueTypeRep} {{
		return {valueTypeRep}({charRep})
	}}

	func ({charRep} *{NameRep}) {ValueTypeRep}Ptr() *{valueTypeRep} {{
		if {charRep} == nil {{
			return nil
		}}

		res := {charRep}.{ValueTypeRep}()

		return &res
	}}

	func ({charRep} {NameRep}) String() string {{
		return strconv.Format{ValueTypeWithoutNumber}({valueTypeWithoutNumber}64({charRep}), 10)
	}}

	func ({charRep} *{NameRep}) StringPtr() *string {{
		if {charRep} == nil {{
			return nil
		}}

		res := {charRep}.String()

		return &res
	}}
	{}
]],
		{
			Name = i(1, "Name"),
			NameRep = rep(1),
			valueType = c(2, {
				t("uint"),
				t("uint8"),
				t("uint16"),
				t("uint32"),
				t("uint64"),
				t("int"),
				t("int8"),
				t("int16"),
				t("int32"),
				t("int64"),
			}),
			valueTypeRep = rep(2),
			ValueType = d(3, upperStart, 2),
			ValueTypeRep = rep(3),
			value = i(4, "v"),
			valueRep = rep(4),
			char = d(5, firstChar, 1),
			charRep = rep(5),
			valueTypeWithoutNumber = d(6, trimNumber, 2),
			ValueTypeWithoutNumber = d(7, upperStart, 6),
			i(0),
		}
	)
)
table.insert(snippets, valueUint)

-- END VALUE SNIPPERS --

-- TEST SNIPPETS --
--
local testRepo = s( { trig = "testRepo" }, fmt( [[
			type test{Name}RepoSuite struct {{
				suite.Suite

				db         *sqlx.DB
				{name}Repo {service}.{RepoInterface}
			}}

			func Test{NameRep}Repo(t *testing.T) {{
				if testing.Short() {{
					t.Skip("skipping integration test")
				}}

				suite.Run(t, &test{NameRep}RepoSuite{{}})
			}}

			// SetupSuite will run before the tests in the suite are run.
			func (s *test{NameRep}RepoSuite) SetupSuite() {{
				cfg, err := config.NewConfig()
				s.Require().NoError(err)

				db, err := sqlx.Connect("pgx", cfg.PG.URL)
				s.Require().NoError(err)

				s.db = db
				s.{nameRep}Repo = persistence.New{NameRep}(db)
			}}

			// TearDownSuite will run after all the tests in the suite have been run.
			func (s *test{NameRep}RepoSuite) TearDownSuite() {{
				s.db.Close()
			}}

			func (s *test{NameRep}RepoSuite) Test{FuncName}() {{
				ctx := context.Background()
				rq := s.Require()

				err := dbtest.MigrateFromFile(s.db, "testdata/{funcName}.sql")
				rq.NoError(err)

				testCases := []struct{{
					name string
					errorText string
				}}{{
					{{}},
				}}

				for _, tc := range testCases {{
					s.Run(tc.name, func() {{
						result, err := s.{nameRep}Repo.{FuncNameRep}(
							ctx,
							{}
						)
						if tc.errorText != "" {{
							rq.Error(err)
							rq.ErrorContains(err, tc.errorText)
						}}else{{
							rq.NoError(err)
							rq.EqualValues(tc.expected, result)
						}}
					}})
				}}
			}}
]],
		{
			Name = i(1, "Name"),
			NameRep = rep(1),
			service = i(2, "service"),
			RepoInterface = i(3, "RepoInterface"),
			name = d(4, lowerStart, 1),
			nameRep = rep(4),
			FuncName = i(5, "FuncName"),
			funcName = d(6, lowerStart, 1),
			FuncNameRep = rep(5),
			i(0),
		}
	)
)
table.insert(snippets, testRepo)

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

-- END TEST SNIPPETS --

local returns = s(
	{ trig = "ret" },
	fmt(
		[[
		{}
	]],
		{
			get_return(),
		}
	)
)
table.insert(snippets, returns)

local context = s({ trig = "ctx" }, fmt("{}", { t("ctx context.Context") }))
table.insert(snippets, context)

local httpClient = s(
	{trig = "httpClient" },
	fmt(
		[[
const (
	method{methodName}Tmpl = "%s/{methodUri}"
)

type HttpClient interface {{
	Do(ctx context.Context, req *http.Request, reqBodyDump bool, respBodyDump bool) (*http.Response, error)
}}

type client struct {{
	cfg        config.{clientName}
	httpClient HttpClient
}}

type Option func(c *client)

func New(cfg config.{clientNameRep}, opts ...clients.Option) *client {{
	return &client{{
		cfg:        cfg,
		httpClient: clients.New(cfg.RequestTimeout, opts...),
	}}
}}

func (c *client) {methodNameRep}(
	ctx context.Context,
	body io.Reader,
) ({response}, error) {{
	var (
		uri    = fmt.Sprintf(method{methodNameRep}Tmpl, c.cfg.Host)
		method = http.{httpMethod}
	)

	req, err := http.NewRequestWithContext(ctx, method, uri, body)
	if err != nil {{
		return 0, fmt.Errorf("http.NewRequestWithContext: %w", err)
	}}
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", c.cfg.Token)

	resp, err := c.httpClient.Do(ctx, req, {reqTrueFalse}, {respTrueFalse})
	if err != nil {{
		return 0, fmt.Errorf("httpClient.Do: %w", err)
	}}
	defer resp.Body.Close()

	if resp.StatusCode == http.StatusOK {{
		var response {methodNameRep}Response
		if err := json.NewDecoder(resp.Body).Decode(&response); err != nil {{
			return 0, fmt.Errorf("json.NewDecoder: %w", err)
		}}

		return response.{fieldName}, nil
	}}

	return 0, failure.NewCustomError(resp.StatusCode, "Ошибка ответа от %s код: %d", c.cfg.Host, resp.StatusCode)
}}{}
		]],
		{
			methodName = i(1, "methodName"),
			methodNameRep  = rep(1),
			methodUri = i(2, "something_uri"),
			clientName = i(3, "clientName"),
			clientNameRep = rep(3),
			reqTrueFalse = c(4, {
				t("true"),
				t("false"),
			}),
			respTrueFalse = c(5, {
				t("true"),
				t("false"),
			}),
			fieldName = i(6, "fieldName"),
			response = i(7, "response"),
			httpMethod = c(8, {
				t("MethodGet"),
				t("MethodPost"),
			}),
			i(0),
		}
	)
)
table.insert(snippets, httpClient)

local configHttpClient = s(
	{trig = "config_http_client" },
	fmt(
		[[
{clientName} struct {{
	Host           string        `envconfig:"{clientNameUpper}_HOST" default:"http://{host}"`
	Token          value.Token   `envconfig:"{clientNameUpperRep}_TOKEN"`
	RequestTimeout time.Duration `envconfig:"{clientNameUpperRep}_REQUEST_TIMEOUT" default:"5s"`
}}{}
		]],
		{
			clientName = i(1, "clientName"),
			clientNameUpper = d(2, upperCase, 1),
			clientNameUpperRep = rep(2),
			host = i(3),
			i(0),
		}
	)
)
table.insert(snippets, configHttpClient)

return snippets, autosnippets
