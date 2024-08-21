return {

    "nvim-treesitter/nvim-treesitter",

    dependencies = {

        -- auto-insert 'end' after 'if', 'function', etc when appropriate
        -- (used in addition to autopair for brackets and quotes)
        'RRethy/nvim-treesitter-endwise',

    },

    build = ":TSUpdate",

    config = function ()

        -- define commands to start/stop treesitter
        vim.api.nvim_create_user_command('TSStop', function() vim.treesitter.stop() end, {})
        vim.api.nvim_create_user_command('TSStart', function() vim.treesitter.start() end, {})
        -- define command to inspect syntax tree
        vim.api.nvim_create_user_command('TSInspect', function() vim.treesitter.inspect_tree() end, {})

        -- configura treesitter
        require("nvim-treesitter.configs").setup({

            ensure_installed = ( function()
                -- the list of default parsers is in this file, alongside the configuration of language servers
                local my_config = require('semantic_tools')
                return my_config.treesitter_parsers
            end )(),

            sync_install = false,

            highlight = {

                -- enable for all files
                enable = true,

                -- conditions where tresitter will be disabled by default
                disable = function(lang, buf)
                    -- disable treesitter highlighting for files larger than 100 KB
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.notify("TreeSitter is disabled for this file. Enable with :TSStart.", vim.log.levels.INFO)
                        return true
                    end
                    -- disable treesitter in latex files. See ':h vimtex-faq-treesitter'
                    if lang == "latex" then return true end
                end,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- It may be useful to add "latex" here, see ':h vimtex-faq-treesitter'
                additional_vim_regex_highlighting = false, -- can also be a list of languages

            },

            indent = {
                enable = true,
            },

            -- extension: add 'end' in languages that use it to close functions etc.
            endwise = {
                enable = true,
            },


        })

    end

}
