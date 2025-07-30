--                                 ┌──────────┐
--                                 │ Commands │
--                                 └──────────┘



-- show current file in finder
vim.api.nvim_create_user_command("Finder", "silent exe '!open -R ' . escape(expand('%:p'), ' \\')", {})

-- open current file with default app
vim.api.nvim_create_user_command("Open", "silent exe '!open ' . expand('%:p')", {})

-- Show all highglight groups
vim.api.nvim_create_user_command("HiTest", "so $VIMRUNTIME/syntax/hitest.vim", {})

-- inspect treesitter
vim.api.nvim_create_user_command('TSInspect', function() vim.treesitter.inspect_tree() end, {})
