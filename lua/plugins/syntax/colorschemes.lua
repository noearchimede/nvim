-- Note: all colorscheme plugins are grouped in this single file
return {

    -- onedark
    {
        "navarasu/onedark.nvim",

        lazy = false,
        priority = 1000,

        config = {

            -- Main options --
            style = 'dark', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
            transparent = false, -- Show/hide background
            term_colors = true, -- Change terminal color as per the selected theme style
            ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
            cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

            -- toggle theme style ---
            toggle_style_key = "<leader>xt", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
            toggle_style_list = {
                'dark',
                'darker',
                --'cool',
                --'deep',
                --'warm',
                --'warmer',
                'light',
            }, -- List of styles to toggle between

            -- Change code style ---
            -- Options are italic, bold, underline, none
            -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
            code_style = {
                comments = 'italic',
                keywords = 'none',
                functions = 'none',
                strings = 'none',
                variables = 'none'
            },

            -- Lualine options --
            lualine = {
                transparent = false, -- lualine center bar transparency
            },

            -- Custom Highlights --
            colors = {}, -- Override default colors
            highlights = { -- Override highlight groups

                -- NOTE: colors for this colorscheme are defined in
                -- /Users/noe/.local/share/nvim/lazy/onedark.nvim/lua/onedark/palette.lua

                -- highlight for markdown
                ["@markup.strong"] = { fg = '$red' },
                ["@markup.italic"] = { fg = '$yellow' },

                -- higlight for neogit
                ["NeogitSectionHeader"] = { fg = '$black', bg = '$green' },
                ["NeogitUntrackedfiles"] = { fg = '$black', bg = '$purple' },
                ["NeogitUnstagedchanges"] = { fg = '$black', bg = '$blue' },
                ["NeogitStagedchanges"] = { fg = '$black', bg = '$yellow' },

            },

            -- Plugins Config --
            diagnostics = {
                darker = true, -- darker colors for diagnostic
                undercurl = true, -- use undercurl instead of underline for diagnostics
                background = true, -- use background color for virtual text
            },

        },

        init = function()

            -- make terminal buffers darker
            vim.api.nvim_create_autocmd('TermOpen', { command = "setlocal winhighlight=Normal:TerminalBaground" })
            -- hi BlackBg guibg=black
            -- au TermOpen * :set winhighlight=Normal:BlackBg

        end

    },

    -- nord
    {
        "gbprod/nord.nvim",

        lazy = true, -- change to false if this becomes the main theme
        --priority = 1000,
    },


    -- tokyonight
    {
        "folke/tokyonight.nvim",

        lazy = true, -- change to false if this becomes the main theme
        -- priority = 1000,
    },

}
