--                              ┌──────────┐
--                              │ Settings │
--                              └──────────┘
--
-- Sections:
--   Editor Settings
--   Text Display
--   Text Navigation
--   Text Editing



-- – Editor settings –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- disable mouse integration by default
vim.opt.mouse = ''

-- after this delay the CursorHold action is triggered and the swap file is
-- written to disk
vim.opt.updatetime = 300

-- splits: open to the right (vertical) or below (horizontal) the current one
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show command autocompletion options when typing `:___<TAB>`
-- at each <TAB>: first complete the longest common string, then show a list of
-- possibilities, finally iterate through all options
-- When completing buffers sort the suggestions in order of last use.
vim.opt.wildmode = "longest,full:lastused"
-- Enable wildmenu
vim.opt.wildmenu = true
-- Ignore case of commands and filenames while autocompleting
vim.opt.wildignorecase = true

-- do not resize splits automatically
vim.opt.equalalways = false

-- Terminal.app does not support 24-bit colors; for other terminals enable them
if os.getenv("TERM_PROGRAM") ~= "Apple_Terminal" then
	vim.opt.termguicolors = true
end

-- set colorscheme; if not available, fail silently and keep the default one
local colo_ok, _ = pcall(vim.cmd, 'colorscheme onedark')
if not colo_ok then
	vim.cmd 'colorscheme default'
end

-- keep undo history across nvim sessions
vim.opt.undofile = true

-- clear jumplist on nvim startup (changing the corresponding option in ':set shada' would also remove other things)
vim.api.nvim_create_autocmd("VimEnter", { command = "clearjumps" })

-- always show signcolumn by default
vim.opt.signcolumn = 'yes'



-- – Text-Display –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- Line numbers
vim.opt.number = true

-- highlight cursor line
vim.opt.cursorline = true

-- scroll before reaching end of window
vim.opt.scrolloff = 5

-- draw line indicating the (hard) wrap point, if any
vim.opt.colorcolumn = "+1"

-- soft wrap at words (not characters)
vim.opt.linebreak = true
-- print a (non-text) character to indicate soft wrapping
vim.opt.showbreak = "↳ "
-- keep indent when soft wrapping
vim.opt.breakindent = true
-- align indented lines to lists (with 'flp'), but leave at least 40 chars
vim.opt.breakindentopt = { "min:40", "sbr", "list:-1" }

-- folding: enable, but keep all folds open when a file is opened
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 999

-- spelling: disabled by default, use `:set spell` when it is required
vim.opt.spelllang = { "en_uk", "it", "de", "fr" }
-- spell check highligthing: only highlight errors, by underlining them
-- rare, local, and capitalization mistakes are not highlighted
vim.cmd([[hi clear SpellBad]])
vim.cmd([[hi SpellBad cterm=underline gui=undercurl guisp=#CC4400]])
vim.cmd([[hi clear SpellRare]])
vim.cmd([[hi clear SpellCap]])
vim.cmd([[hi clear SpellLocal]])

-- listchars: characters used to show invisible characters if 'list' is set
vim.opt.listchars = { eol = "¶", tab = "–>" ,space = "•", trail = "~", extends = ">", precedes = "<", nbsp = "°" }

-- filler characters: in diff mode show diagonal lines insted of horizontal dashes
vim.opt.fillchars:append { diff = "╱" }



-- – Text Navigation ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- do not cycle back to the start of a file after reaching the end
vim.opt.wrapscan = false

-- when searching, ignore case by default unless the query contains uppercase characters
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- use the same settings for searching tags (:h tags)
vim.opt.tagcase = "followscs"



-- – Text Editing –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


-- tabs (using the second option suggested in `:h tabstop`)
vim.opt.tabstop = 4  -- number of spaces used to render a `tab` character
vim.opt.shiftwidth = 4  -- numebr of spaces for (auto)indent
vim.opt.expandtab = true  -- tabs are made of spaces

-- text wrapping:
-- -  b: only wrap text inserted in the current mode and only if the line was
--       already longer than textwidth when insert mode was entered
-- -  c: auto-wrap comments
-- -  n: format lists as defined in formatlistpat (requires autoindent)
-- -  q: automatically wrap with `gq`
-- -  j: when it makes sense, remove the comment leader when joining lines
vim.opt.formatoptions = "bcnqj"
-- Many ftplugins add the 'o' options. This autocmd removes it for all filetypes.
vim.api.nvim_create_autocmd("FileType", {
	callback = function() vim.opt_local.formatoptions:remove("o") end,
})

-- behaviour of ctrl-A and ctrl-X: treat numbers starting with 0 as decimal, not octal
vim.opt.nrformats:remove { "octal" }

-- formatlistpat: set to a very inclusive value and make it available as a
--                variable e.g. for ftplugins
local flp_value = [[\m]] -- set magic mode
-- bullet list:
-- optional spaces | one of *-–+>•# | optional extra -–> | at least one space
flp_value = flp_value .. [[^\s*[\-–>\*•#+]\[\-–>]+\s\+]]
-- numbered list 1 (potentially long numbers or letters):
-- optional spaces | optional ([{< | at least one of [0-9a-zA-Z] | mandatory )]}>.: | at least two spaces
flp_value = flp_value .. [[\|]] .. [[^\s*[(\[{<]\?[0-9a-zA-Z]\+[:.)\]}>]\+\s\{2,\}]]
-- numbered list 2 (only one number but does not require two spaces):
-- optional spaces | exactly one number | mandatory )]}>.: | at least one space
flp_value = flp_value .. [[\|]] .. [[^\s*[0-9][:.)\]}>]\s\+]]
-- labelled list 1: label (max two words) | one of the follwing:
--   - at least one space | one or more of -=:– | at least one space
--   - optionally, one or more of :.)}]> | at least two spaces
flp_value = flp_value .. [[\|]] .. [[^\S\+\%(\s\+[\-=:–]\+\s\+\|[:.)}\]>]\?\s\{2,\}\)]]


-- set flp val
vim.opt.formatlistpat = flp_value


