local map = vim.api.nvim_set_keymap
local cmp = require'cmp'
local default_opts = {noremap = true, silent = true}

-- Системный буфер обмена shift - Y
map('', 'by', '"+y', default_opts)
map('', 'bp', '"+p', default_opts)
-- Стрелочки откл. Использовать hjkl
map('', '<up>', ':echoe "Use k"<CR>', {noremap = true, silent = false})
map('', '<down>', ':echoe "Use j"<CR>', {noremap = true, silent = false})
map('', '<left>', ':echoe "Use h"<CR>', {noremap = true, silent = false})
map('', '<right>', ':echoe "Use l"<CR>', {noremap = true, silent = false})
-- Пролистнуть на страницу вниз / вверх (как в браузерах)
map('n', '<Space>', '<PageDown> zz', default_opts)
map('n', '<C-Space>', '<PageUp> zz', default_opts)

-----------------------------------------------------------
-- Moving window
-----------------------------------------------------------
-- map('n', '<S-h>', '<cmd>wincmd h<CR>', default_opts)
-- map('n', '<S-j>', '<cmd>wincmd j<CR>', default_opts)
-- map('n', '<S-p>', '<cmd>wincmd k<CR>', default_opts)
-- map('n', '<S-l>', '<cmd>wincmd l<CR>', default_opts)

-----------------------------------------------------------
-- Фн. клавиши по F1 .. F12
-----------------------------------------------------------
-- По F1 очищаем последний поиск с подсветкой
map('n', '<leader>c', ':nohl<CR>', default_opts)
map('n', '<leader>q', ':q!<CR>', default_opts)
map('n', ';q', ':bd<CR>', default_opts)
map('n', ';w', ':w<CR>', default_opts)
map('n', ';wq', ':w<CR>:bd<CR>', default_opts)
-- shift + F1 = удалить пустые строки
map('n', '<S-F1>', ':g/^$/d<CR>', default_opts)
-- <F2> для временной вставки из буфера, чтобы отключить авто идент
-- vim.o.pastetoggle='<F2>'
-- <F3> перечитать конфигурацию nvim Может не работать, если echo $TERM  xterm-256color
-- map('n', '<F6>', ':so ~/.config/nvim/init.lua<CR>:so ~/.config/nvim/lua/plugins.lua<CR>:so ~/.config/nvim/lua/setup.lua<CR>:so ~/.config/nvim/lua/binds.lua<CR>:so ~/.config/nvim/lua/opts.lua<CR>:noh<CR>', { noremap = true })
-- <S-F3> Открыть всю nvim конфигурацию для редактирования
-- map('n', '<S-F6>', ':e ~/.config/nvim/init.lua<CR>:e ~/.config/nvim/lua/plugins.lua<CR>:e ~/.config/nvim/lua/setup.lua<CR>:e ~/.config/nvim/lua/binds.lua<CR>:e ~/.config/nvim/lua/opts.lua<CR>', { noremap = true })
-- <F4> Поиск слова под курсором
-- map('n', '*', [[<cmd>lua require('telescope.builtin').grep_string()<cr>]], default_opts)
-- <S-F4> Поиск слова в модальном окошке
-- map('n', '<S-F4>', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], default_opts)
-- <F5> разные вариации нумераций строк, можно переключаться
map('n', '<F5>', ':exec &nu==&rnu? "se nu!" : "se rnu!"<CR>', default_opts)
-- <F6> дерево файлов. map('n', '<F3>', ':NvimTreeRefresh<CR>:NvimTreeToggle<CR>', default_opts) <F8>  Показ дерева классов и функций, плагин majutsushi/tagbar
-- map('n', '<F8>', ':TagbarToggle<CR>', default_opts)
-- spliter
map('', '<leader>v', ':vsplit<CR>', default_opts)
map('', '<leader>h', ':split<CR>', default_opts)
-----------------------------------------------------------
-- luasnip
-----------------------------------------------------------
map("i", "<c-n>", "<Plug>luasnip-next-choice", {})
map("s", "<c-n>", "<Plug>luasnip-next-choice", {})
map("i", "<c-p>", "<Plug>luasnip-prev-choice", {})
map("s", "<c-p>", "<Plug>luasnip-prev-choice", {})
map("i", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", default_opts)
map("s", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", default_opts)
map("i", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", default_opts)
map("s", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", default_opts)
map("", "<c-h>", "<cmd>BufferLineCyclePrev<CR>", default_opts)
map("", "<c-l>", "<cmd>BufferLineCycleNext<CR>", default_opts)
-- map('', '<C-n>', '<cmd>lua require"cmp".mapping.select_next_item()<CR>', default_opts)
-- map('', '<C-p>', '<cmd>lua require"cmp".mapping.select_prev_item()<CR>', default_opts)
-- map('', '<C-b>', '<cmd>lua require"cmp".mapping.scroll_docs()<CR>', default_opts)
-- map('', '<C-f>', '<cmd>lua require"cmp".mapping.scroll_docs()<CR>', default_opts)
-- map('', '<C-e>', '<cmd>lua require"cmp".mapping.close()<CR>', default_opts)
-- map('', '<CR>', '<cmd>lua require"cmp".mapping.confirm()<CR>', {})
