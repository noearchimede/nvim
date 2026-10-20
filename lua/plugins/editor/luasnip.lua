return {

    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",

    dependencies = {
        "saadparwaiz1/cmp_luasnip"
    },

    event = "InsertEnter",

    keys = {
        {
            "<C-l>",
            function()
                -- prefer jumping over expanding (to reduce risk of "recursive" snippets)
                if require('luasnip').locally_jumpable() then
                    require('luasnip').jump()
                elseif require('luasnip').expandable() then
                    require('luasnip').expand()
                end
            end,
            mode = { 'i', 's' },
            desc = "Luasnip: expand or jump",
        },
        {
            "<C-h>",
            function()
                if require('luasnip').locally_jumpable(-1) then
                    require('luasnip').jump(-1)
                end
            end,
            mode = { 'i', 's' },
            desc = "Luasnip: jump backwards",
        }
    },

    config = function()

        require('luasnip').setup{
            -- enable snippets with 'autotrigger'
            enable_autosnippets = true,
            -- events where luasnip checks if the cursor is outside the current snippet and if so leaves it
            region_check_events = "InsertEnter",

            -- show a virtual circle next to the jump points
            ext_opts = {
                [require("luasnip.util.types").choiceNode] = {
                    active = {
                        virt_text = { { "●", "ErrorMsg" } } -- use the default colors for an error
                    }
                },
                [require("luasnip.util.types").insertNode] = {
                    active = {
                        virt_text = { { "●", "warningMsg" } } -- use the default colors for a warning
                    }
                }
            }
        }

        -- create autocmd to delete jump points if Insert mode is exited and the cursor is outside the snippet
        vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
                local ls = require("luasnip")
                if ls.get_active_snip() and not ls.in_snippet() then
                    ls.unlink_current()
                end
            end,
        })

    end,

    init = function()

        -- load Luasnip-style snippets from 'snippets/luasnip' directory
        require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/luasnip" })
        -- load VScode-style snippets from 'snippets/vscode' directory
        require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets/vscode" })

    end

}
