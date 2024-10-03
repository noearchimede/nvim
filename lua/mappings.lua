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
--   Abbreviations
--   Debug


-- – Leader ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

-- NOTE: the leader itself is defined directly in init.lua

-- allow using space as leader in normal, visual and op. pending modes
vim.keymap.set({ 'n', 'v', 'x' }, '<space>', '\\', { remap = true })
vim.keymap.set({ 'n', 'v', 'x' }, '\\<space>', '\\\\', { remap = true })



-- – Text navigation –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- when moving between search results, move the current match to the center
-- vim.keymap.set('n', 'n', 'nzz')
-- vim.keymap.set('n', 'N', 'Nzz')
-- vim.keymap.set('n', '*', '*zt')
-- vim.keymap.set('n', '#', '#zt')

-- make single quote work as backtick, i.e. jump to exact position
vim.keymap.set({ 'n', 'v', 'x', 'o' }, '\'', '`', { remap = true })

-- move up or down to next non-blank character in same column
vim.keymap.set({ 'n', 'v' }, '<leader>mj', ":<C-u>call search('\\%' . virtcol('.') . 'v\\S', 'W')<CR>")
vim.keymap.set({ 'n', 'v' }, '<leader>mk', ":<C-u>call search('\\%' . virtcol('.') . 'v\\S', 'bW')<CR>")



-- – Quickfix and location list ––––––––––––––––––––––––––––––––––––––––––––––––


-- toggle quickfix and location lists
vim.keymap.set('n', '<leader>qq', function()
    local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
    local action = qf_winid > 0 and 'cclose' or 'copen'
    vim.cmd('botright '..action)
end, { noremap = true, silent = true, desc = "Toggle quickfix list" })
vim.keymap.set('n', '<leader>ll', function()
    local win = vim.api.nvim_get_current_win()
    local qf_winid = vim.fn.getloclist(win, { winid = 0 }).winid
    local action = qf_winid > 0 and 'lclose' or 'lopen'
    vim.cmd(action)
end, { noremap = true, silent = true, desc = "Toggle location list" })

-- jump to next/previous elements (wihtout opening the quickfix list)
vim.keymap.set('n', ']q', "<cmd>cnext<cr>", { desc = "Quickfix: next" })
vim.keymap.set('n', '[q', "<cmd>cprevious<cr>", { desc = "Quickfix: previous" })
vim.keymap.set('n', ']l', "<cmd>lnext<cr>", { desc = "Location list: next" })
vim.keymap.set('n', '[l', "<cmd>lprevious<cr>", { desc = "Location list: previous" })
-- aliases for the mappings above for consistency with the other leader mappings
vim.keymap.set('n', '<leader>qn', "]q", { remap = true })
vim.keymap.set('n', '<leader>qp', "[q", { remap = true })
vim.keymap.set('n', '<leader>ln', "]l", { remap = true })
vim.keymap.set('n', '<leader>lp', "[l", { remap = true })
-- jump to first and last elements
vim.keymap.set('n', '<leader>qf', "<cmd>cfirst<cr>", { desc = "Quickfix: first" })
vim.keymap.set('n', '<leader>qe', "<cmd>clast<cr>", { desc = 'Quickfix: last ("end")' })
vim.keymap.set('n', '<leader>lf', "<cmd>lfirst<cr>", { desc = "Location list: first" })
vim.keymap.set('n', '<leader>le', "<cmd>llast<cr>", { desc = 'Location list: last ("end")' })
-- jumpt to next/previous file
vim.keymap.set('n', '<leader>qN', "<cmd>cnfile<cr>", { desc = "Quickfix: next file" })
vim.keymap.set('n', '<leader>qP', "<cmd>cpfile<cr>", { desc = "Quickfix: previous file" })
vim.keymap.set('n', '<leader>lN', "<cmd>lnfile<cr>", { desc = "Location list: next file" })
vim.keymap.set('n', '<leader>lP', "<cmd>lpfile<cr>", { desc = "Location list: previous file" })

-- autocmd to define a 'q' mapping to close quickfix/location windows when focused
vim.api.nvim_create_autocmd("FileType", {
    pattern = 'qf',
    callback = function()
        -- to differentiate between quickfix and location list use this:
        -- if vim.fn.getwininfo(vim.fn.win_getid()).loclist ~= 1 then ...... end
        vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true, desc = "Close" })
    end
})



-- – Editor navigation –––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- navigate between splits with a single keybinding, even from terminal windows
vim.keymap.set('n', '<c-h>', '<cmd>wincmd h<cr>')
vim.keymap.set('n', '<c-j>', '<cmd>wincmd j<cr>')
vim.keymap.set('n', '<c-k>', '<cmd>wincmd k<cr>')
vim.keymap.set('n', '<c-l>', '<cmd>wincmd l<cr>')

-- jump to the alternate buffer
vim.keymap.set('n', '<bs>', '<C-^>')


-- – Directories –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- Tab cd to the parent of the current file
vim.keymap.set('n', "<leader>td", function() vim.cmd("tcd %:p:h") end)
-- Tab cd up one directory
vim.keymap.set('n', "<leader>to", function() vim.cmd("tcd " .. vim.fn.getcwd() .. "/..") end)



-- – Searching –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- Search: higlight all matches of word under cursor
vim.keymap.set('n', '<leader>ss', ":let @/ = '\\C\\<' . expand('<cword>') . '\\>' | set hls<CR>")
-- -> visual: higlight all matches of selected text
vim.keymap.set('v', '<leader>ss',
               ":<C-u>let @/ = '\\C\\V' . escape(luaeval(\"require('utils').get_visual_selection()\"), '\\') | set hls<CR>")

-- Search Replace: replace word under cursor, then return to starting position
vim.keymap.set('n', '<leader>sr', function() require("utils").replace_in_file(vim.fn.expand('<cword>'), true) end)
-- -> visual: replace the sected text, then return to starting position
vim.keymap.set('v', '<leader>sr',
               function() require("utils").replace_in_file(require("utils").get_visual_selection(), false) end)

-- Search Clear: clear the contents of the search register
-- Note that this is not the same as ':set nohlsearch'
vim.keymap.set('n', '<leader>sc', ":nohlsearch<CR>")
-- Search Highlight: Toggle hlsearch (:hls)
vim.keymap.set('n', '<leader>sh', ":set invhlsearch<CR>:set hlsearch?<CR>")
-- Search Incremental: Toggle incsearch (:is)
vim.keymap.set('n', '<leader>si', ":set invincsearch<CR>:set incsearch?<CR>")



-- – Editing –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- yank to system clipboard
vim.keymap.set({ 'n', 'v' }, 'Y', '"*y')
vim.keymap.set('n', 'YY', '"*yy')



-- – Quick settings ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- toggle soft wrapping
vim.keymap.set('n', '<leader>xw', ':set invwrap<CR>:set wrap?<CR>')
-- toggle autoread
vim.keymap.set('n', '<leader>xa', ':set invautoread<CR>:set autoread?<CR>')
-- toggle spelling check
vim.keymap.set('n', '<leader>xs', ':set invspell<CR>:set spell?<CR>')
-- toggle list mode
vim.keymap.set('n', '<leader>xl', ':set invlist<CR>:set list?<CR>')
-- toggle signcolumn visibility when no signs are present
vim.keymap.set('n', '<leader>xg', function()
    if vim.opt.signcolumn:get() == 'auto' then ---@diagnostic disable-line: undefined-field
        vim.opt.signcolumn = 'yes'
    elseif vim.opt.signcolumn:get() == 'yes' then ---@diagnostic disable-line: undefined-field
        vim.opt.signcolumn = 'auto'
    end
end)
-- toggle mouse integration between 'all' and disabled
vim.keymap.set('n', '<leader>xm', function()
    if vim.opt.mouse:get()['a'] == nil then ---@diagnostic disable-line: undefined-field
        vim.opt.mouse = 'a'
        vim.notify("Mouse enabled", vim.log.levels.INFO)
    else
        vim.opt.mouse = ''
        vim.notify("Mouse disabled", vim.log.levels.INFO)
    end
end)



-- – Debugging –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


vim.keymap.set("n", "<leader>xys", function()
                   vim.cmd([[
		:profile start /tmp/nvim-profile.log
		:profile func *
		:profile file *
        :echo "Started profiling"
	]])
               end, { desc = "Profile Start" })

vim.keymap.set("n", "<leader>xye", function()
                   vim.cmd([[
		:profile stop
		:e /tmp/nvim-profile.log
        :echo "Ended profiling"
	]])
               end, { desc = "Profile End" })
