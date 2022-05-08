require('neotags').setup({
    enable = true, -- enable neotags.lua
    ctags = {
        run = true, -- run ctags
        directory = '~/.vim_tags', -- default directory where to store tags
        verbose = false ,-- verbose ctags output
        binary = 'ctags', -- ctags binary
        args = { -- ctags arguments
            '--fields=+l',
            '--c-kinds=+p',
            '--c++-kinds=+p',
            '--sort=no',
            '-a'
        },
    },
    ft_conv = { -- ctags filetypes to vim filetype
        ['c++'] = 'cpp',
        ['moonscript'] = 'moon',
        ['c#'] = 'cs',
        ['go'] = 'go'
    },
    ft_map = { -- combine tags from multiple languages (for example header files in c/cpp)
        cpp = { 'cpp', 'c' },
        c = { 'c', 'cpp' }
    },
    hl = {
        patternlength = 2048, -- max syntax length when splitting it into chunks
        prefix = [[\C\<]], -- default syntax prefix
        suffix = [[\>]] -- default syntax suffix
    },
    tools = {
        find = nil, -- tool to find files (defaults to running ctags with -R)
        -- find = { -- example using fd
        --     binary = 'fd',
        --     args = { '-t', 'f', '-H', '--full-path' },
        -- },
    },
    ignore = { -- filetypes to ignore
        'cfg',
        'conf',
        'help',
        'mail',
        'markdown',
        'nerdtree',
        'nofile',
        'readdir',
        'qf',
        'text',
        'plaintext'
    },
    notin = { -- where not to include highlights
        '.*String.*',
        '.*Comment.*',
        'cIncluded',
        'cCppOut2',
        'cCppInElse2',
        'cCppOutIf2',
        'pythonDocTest',
        'pythonDocTest2'
    }
})

vim.cmd [[
  augroup NeotagsLua
    autocmd!
    autocmd FileType * :silent! lua require('neotags').highlight()
    autocmd BufWritePost * :silent! lua require('neotags').update()
  augroup end
]]
