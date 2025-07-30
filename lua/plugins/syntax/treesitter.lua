return {

    "nvim-treesitter/nvim-treesitter",
    branch = 'main', -- the 'master' branch is frozen for backwards compatibility and quite different from 'main'

    lazy = false, -- lazy-loading is not supported (nor desirable)

    build = ":TSUpdate",

    config = function()

        -- install custom list of parsers
        local semantic_tools = require('semantic_tools')
        require('nvim-treesitter').install(semantic_tools.treesitter_parsers)

        vim.api.nvim_create_autocmd('FileType', {
            pattern = semantic_tools.treesitter_parsers,
            callback = function()
                -- syntax highlighting, provided by Neovim
                vim.treesitter.start()
                -- folds, provided by Neovim
                vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                -- indentation, provided by nvim-treesitter (experimenta!)
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        })

    end
}
