--                              ┌──────────┐
--                              │ Mappings │
--                              └──────────┘
--
-- Sections:
--
--   Leader
--   Text Navigation
--   Editor Navigation
--   Searching
--   Editing
--   Quick settings



-- – Leader ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

-- NOTE: the leader itself is defined directly in init.lua

-- allow using space as leader in normal, visual and op. pending modes
vim.keymap.set({'n', 'v', 'x'}, '<space>', '\\', { remap = true })
vim.keymap.set({'n', 'v', 'x'}, '\\<space>', '\\\\', { remap = true })


-- – Text navigation –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- when moving between search results, move the current match to the center
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '*', '*zt')
vim.keymap.set('n', '#', '#zt')

-- make single quote work as backtick, i.e. jump to exact position
vim.keymap.set({'n', 'v', 'x'}, '\'', '`', { remap = true })

-- move up or down to next non-blank character in same column
vim.keymap.set('n', '<leader>mj', ":<C-u>call search('\\%' . virtcol('.') . 'v\\S', 'W')<CR>")
vim.keymap.set('n', '<leader>mk', ":<C-u>call search('\\%' . virtcol('.') . 'v\\S', 'bW')<CR>")



-- – Editor navigation –––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- navigate between splits with a single keybinding, even from terminal windows
vim.keymap.set({'n', 't'}, '<c-h>', '<c-w>h')
vim.keymap.set({'n', 't'}, '<c-j>', '<c-w>j')
vim.keymap.set({'n', 't'}, '<c-k>', '<c-w>k')
vim.keymap.set({'n', 't'}, '<c-l>', '<c-w>l')

-- exit terminal with esc-esc
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')



-- – Searching –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- Search: higlight all matches of word under cursor
vim.keymap.set('n', '<leader>ss', ":let @/ = '\\C\\<' . expand('<cword>') . '\\>' | set hls<CR>")
-- -> visual: higlight all matches of selected text
vim.keymap.set('v', '<leader>ss', ":<C-u>let @/ = '\\C\\V' . escape(luaeval(\"require('utils').get_visual_selection()\"), '\\') | set hls<CR>")

-- Search Replace: replace word under cursor, then return to starting position
vim.keymap.set('n', '<leader>sr', function() require("utils").replace_in_file(vim.fn.expand('<cword>'), true) end)
-- -> visual: replace the sected text, then return to starting position
vim.keymap.set('v', '<leader>sr', function() require("utils").replace_in_file(require("utils").get_visual_selection(), false) end)

-- Search Clear: clear the contents of the search register
-- Note that this is not the same as ':set nohlsearch'
vim.keymap.set('n', '<leader>sc', ":nohlsearch<CR>")
-- Search Highlight: Toggle hlsearch (:hls)
vim.keymap.set('n', '<leader>sh', ":set invhlsearch<CR>:set hlsearch?<CR>")
-- Search Incremental: Toggle incsearch (:is)
vim.keymap.set('n', '<leader>si', ":set invincsearch<CR>:set incsearch?<CR>")



-- – Editing –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- yank to system clipboard
vim.keymap.set({'n', 'v'}, '<s-y>', '"*y')



-- – Quick settings ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- toggle soft wrapping
vim.keymap.set('n', '<leader>xw', ':set invwrap<CR>:set wrap?<CR>')
-- toggle autoread
vim.keymap.set('n', '<leader>xa', ':set invautoread<CR>:set autoread?<CR>')
-- toggle spelling check
vim.keymap.set('n', '<leader>xs', ':set invspell<CR>:set spell?<CR>')
-- toggle list mode
vim.keymap.set('n', '<leader>xl', ':set invlist<CR>:set list?<CR>')



