--                              ┌──────────┐
--                              │ Mappings │
--                              └──────────┘
--
-- Sections:
--
--   Leader
--   Text Navigation
--   LSP
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


-- – LSP --------–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

-- create autocommand for LSP attach to define (buffer-local) mappings etc.
vim.api.nvim_create_autocmd("LspAttach", {
    desc = 'LSP actions',
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(event)

        local function map(mode, key, func, desc)
            vim.keymap.set(mode, key, func, { desc = desc, buffer = event.buf, silent = true })
        end

        -- Insert mode mappings
        map({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, "LSP: show signature help")

        -- Normal and Visual mode mappings
        map("n", "<leader><leader>n", vim.diagnostic.goto_next, "Diagnostics: next")
        map("n", "<leader><leader>p", vim.diagnostic.goto_prev, "Diagnostics: previous")
        map("n", "]d", vim.diagnostic.goto_next, "Diagnostics: next") -- overwrite :h ]d-default to also show the diagnostic text
        map("n", "[d", vim.diagnostic.goto_prev, "Diagnostics: previous") -- see above
        map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end,
            "Diagnostics: next error")
        map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end,
            "Diagnostics: previous error")
        map("n", "]w", function() vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } }) end,
            "Diagnostics: next error or warning")
        map("n", "[w", function() vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN } }) end,
            "Diagnostics: previous error or warning")

        map("n", "<leader><leader>v", vim.diagnostic.open_float, "Diagnostics: show line diagnostics")
        map("n", "<leader><leader>k", vim.lsp.buf.hover, "LSP: show documentation hover") -- equivalent to K, see :h K-lsp-default
        map("n", "<leader><leader>j", vim.lsp.buf.signature_help, "LSP: show signature help")
        map("n", "<leader><leader>d", vim.lsp.buf.definition, "LSP: go to definition")
        map("n", "<leader><leader>l", vim.lsp.buf.declaration, "LSP: go to declaration")
        map("n", "<leader><leader>i", vim.lsp.buf.implementation, "LSP: go to implementation")
        map("n", "<leader><leader>t", vim.lsp.buf.type_definition, "LSP: go to type definition")
        map("n", "<leader><leader>r", vim.lsp.buf.references, "LSP: go to references")

        map("n", "<leader><leader>D", function() require('utils').lsp_goto_with_picker(vim.lsp.buf.definition) end,
            "LSP: go to definition")
        map("n", "<leader><leader>L", function() require('utils').lsp_goto_with_picker(vim.lsp.buf.declaration) end,
            "LSP: go to declaration")
        map("n", "<leader><leader>I", function() require('utils').lsp_goto_with_picker(vim.lsp.buf.implementation) end,
            "LSP: go to implementation")
        map("n", "<leader><leader>T", function() require('utils').lsp_goto_with_picker(vim.lsp.buf.type_definition) end,
            "LSP: go to type definition")

        map("n", "<leader><leader>c", vim.lsp.buf.rename, "LSP: rename")
        map({ "n", "v" }, "<leader><leader>a", vim.lsp.buf.code_action, "LSP: code actions")
        -- map({ "n", "v" }, "<leader><leader>f", vim.lsp.buf.format, "LSP: format") <<< handled by conform.nvim

        -- stop/start/restart LPS
        map("n", "<leader><leader>qq", ":LspStop<CR>", "LSP: stop")
        map("n", "<leader><leader>qr", ":LspRestart<CR>", "LSP: restart")
        map("n", "<leader><leader>qs", ":LspStart<CR>", "LSP: restart")

    end
})


-- – Quickfix and location list ––––––––––––––––––––––––––––––––––––––––––––––––


-- toggle quickfix and location lists
vim.keymap.set('n', '<leader>qq', "<cmd>botright copen<cr>", { desc = "Quickfix: open" })
vim.keymap.set('n', '<leader>qQ', "<cmd>cclose<cr>", { desc = "Quickfix: close" })
vim.keymap.set('n', '<leader>ll', "<cmd>lopen<cr>", { desc = "Location list: open" })
vim.keymap.set('n', '<leader>lL', "<cmd>lclose<cr>", { desc = "Location list: close" })

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

-- autocmd to define mappings local to quickfix/location windows
vim.api.nvim_create_autocmd("FileType", {
    pattern = 'qf',
    callback = function()

        -- if needed, use this to differentiate between quickfix and location list:
        -- if vim.fn.getwininfo(vim.fn.win_getid()).loclist ~= 1 then ...... end
        vim.keymap.set('n', 'q', "<cmd>close<cr>", { buffer = true, desc = "Close" })
        vim.keymap.set('n', 'o', "<cr><c-w>p", { buffer = true, desc = "Jump but keep focus" })
        vim.keymap.set('n', '<cr>', "<cr>", { buffer = true, desc = "Jump" })

        -- motions
        local function motion(key)
            if vim.g.quickfix_auto_jump == true then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key .. '<cr><c-w>p', true, true, true), 'n', true)
            else -- this includes 'nil' when the control variable is not yet set
                vim.g.quickfix_auto_jump = false -- set variable on first use
                vim.api.nvim_feedkeys(key, 'n', true)
            end
        end

        -- note: 'not nil' is 'true', so this works even if the control variable is not yet set
        vim.keymap.set('n', 'P', function() vim.g.quickfix_auto_jump = not vim.g.quickfix_auto_jump end,
            { buffer = true, desc = "Toggle autojump" })
        vim.keymap.set('n', 'j', function() motion('j') end, { buffer = true, desc = "Next" })
        vim.keymap.set('n', 'k', function() motion('k') end, { buffer = true, desc = "Previous" })
        vim.keymap.set('n', 'gg', function() motion('gg') end, { buffer = true, desc = "First" })
        vim.keymap.set('n', 'G', function() motion('G') end, { buffer = true, desc = "Last" })

        -- quickfix history
        vim.keymap.set('n', '<C-n>', '<cmd>cnewer<cr>', { buffer = true, desc = "Next list" })
        vim.keymap.set('n', '<C-p>', '<cmd>colder<cr>', { buffer = true, desc = "Previous list" })
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

-- add new line without entering insert mode
vim.keymap.set('n', '<cr>', 'o<esc>')
vim.keymap.set('n', '<s-cr>', 'O<esc>')



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
