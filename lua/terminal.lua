--                        ┌───────────────────┐
--                        │ Terminal emulator │
--                        └───────────────────┘
--
-- Settings for the integrated terminal


-- – Settings ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- always start terminals in insert mode
vim.api.nvim_create_autocmd('TermOpen',  { command = "startinsert" })
-- disable number column and signcolumn in all terminal buffers
vim.api.nvim_create_autocmd('TermOpen',  { command = "setlocal nonumber" })
vim.api.nvim_create_autocmd('TermEnter',  { command = "setlocal signcolumn=no" })
-- NOTE: the darker background in terminal windows is implemented as an
-- autocommand in my plugin spec for the 'onehalf' colorscheme


-- – Mappings ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- window navigation (similar to the mappings in normal mode for all buffers)
vim.keymap.set('t', '<c-h>', '<cmd>wincmd h<cr>')
vim.keymap.set('t', '<c-j>', '<cmd>wincmd j<cr>')
vim.keymap.set('t', '<c-k>', '<cmd>wincmd k<cr>')
vim.keymap.set('t', '<c-l>', '<cmd>wincmd l<cr>')

-- enable wincmd mappings with <c-w> from a terminal without exiting insert mode
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>')

-- exit terminal insert mode with esc
vim.keymap.set('t', '<esc>', '<c-\\><c-n>')
vim.keymap.set('t', '<c-esc>', '<esc>')

-- open a new terminal in a split
vim.keymap.set('n', '<leader>qo', '<cmd>terminal<cr>')
vim.keymap.set('n', '<leader>qv', '<cmd>vertical terminal<cr>')
vim.keymap.set('n', '<leader>qh', '<cmd>horizontal terminal<cr>')

