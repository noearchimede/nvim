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

    init = function()

        -- load Luasnip-style snippets from 'snippets/luasnip' directory
        require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/luasnip" })
        -- load VScode-style snippets from 'snippets/vscode' directory
        require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets/vscode" })

    end,

    config = function()

        require('luasnip').setup({
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
            },
        })

    end,

}
