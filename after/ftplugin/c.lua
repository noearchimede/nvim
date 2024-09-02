-- after filetype plugin for c/c++


vim.opt_local.textwidth = 80


vim.opt_local.cinoptions = ''
-- do not indent case labels
vim.opt_local.cinoptions:append(':0')
-- do not add additional indent for case statements with curly braces
vim.opt_local.cinoptions:append('l1')
-- do not intent `private:`, `protected:` and `public:`
vim.opt_local.cinoptions:append('g0')
-- do not indent the content of namespace definitions
vim.opt_local.cinoptions:append('N-s')
-- do not indent after `extern "C"` or `extern "C++"`
vim.opt_local.cinoptions:append('E-s')
-- c-style comments: do not indent middle lines
vim.opt_local.cinoptions:append('c0,C1')
