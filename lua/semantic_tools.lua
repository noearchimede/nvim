--                          ┌────────────────┐
--                          │ Semantic Tools │ 
--                          └────────────────┘

-- This file contains a list of all external semantic tools (LSPs, formatters,
-- linters, and treesitter parsers) that should always be installed, along with
-- some configuration for formatters and linters. LSP server configurations are
-- in the 'lsp/' directory.

local M = {}


--------------------------------------------------------------------------------
-- LSP Servers
--------------------------------------------------------------------------------
-- lsp servers are installed by mason.nvim and used natively by vim

-- if this is set to true the servers below will be automatically installed,
-- otherwise they must be installed manually (using Mason)
M.lsp_servers_auto_install = true

-- list of enabled LSP servers
-- Note that installing a server through Mason is not enough, it is only
-- available in neovim after 'vim.lsp.enable(server_name)' is called.
-- The names in this list must match the ones presented in the Mason interface.
-- For each server a configuration should be provided in a file of the same
-- name in the 'lsp/' folder.
M.lsp_servers = {
    "lua-language-server",
    "pyright",
    "clangd",
    "bash-language-server"
} -- [for mason-toool-installer]


-- enable all installed servers
vim.lsp.enable(M.lsp_servers)


--------------------------------------------------------------------------------
-- Formatters
--------------------------------------------------------------------------------
-- formatters are installed by mason.nvim and used by conform.nvim

-- if this is set to true the formatters below will be automatically installed,
-- otherwise they must be installed manually (using Mason)
M.formatters_auto_install = true

-- list of formatters, grouped by language
M.formatters_by_ft = {
    lua = {
        lsp_format = "prefer", -- use lua_ls (lsp)
    },
    python = {
        "black",
    },
    sh = {
        "shfmt",
    },
    markdown = {
        "prettier",
    },
} -- [for conform.nvim and mason-toool-installer]

-- formatter settings
M.formatter_settings = function(conform_formatters)
    -- example (from Conform README)
    --[[
    conform_formatters.yamlfix = {
        env = {
            YAMLFIX_SEQUENCE_STYLE = "block_style",
        },
    } ]]

end -- [for conform.nvim]


--------------------------------------------------------------------------------
-- Treesitter
--------------------------------------------------------------------------------
-- treesitter parsers are installed by nvim-treesitter and used natively by neovim

-- list of treesitter parsers that will be automatically installed
M.treesitter_parsers = {
    "regex",
    "c",
    "lua",
    "vim",
    "vimdoc",
    "bash",
    "query",
    "cpp",
    "python",
    "html",
    "markdown",
    "markdown_inline"
} -- [for nvim-treesitter]


return M
