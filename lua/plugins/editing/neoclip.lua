return {

    "AckslD/nvim-neoclip.lua",

    dependencies = {
        "nvim-telescope/telescope.nvim"
    },

    -- neoclip needs to run before its keybinding is used, otherwise it can't track the yank history
    event = "VeryLazy",

    keys = {
        { '<leader>fy', "<cmd>Telescope neoclip<CR>", desc = "Telescope: yank registers" },
    },

    cmd = { "Telescope neoclip" },

    opts = {
        enable_persistent_history = false,
        default_register = '"',
        default_register_macros = 'q',
        enable_macro_history = false,
        content_spec_column = true,
        on_select = { -- on selecting without pasting directly
            move_to_front = false,
            close_telescope = true,
        },
        on_paste = { -- on pasting directly
            set_reg = false,
            move_to_front = false,
            close_telescope = true,
        },
        on_replay = { -- on replaying macros
            set_reg = false,
            move_to_front = false,
            close_telescope = true,
        },
        on_custom_action = {
            close_telescope = true,
        },
        keys = {
            telescope = {
                i = {
                    select = '<c-r>',       -- default: '<cr>',
                    paste = '<cr>',         -- default: '<c-p>',
                    paste_behind = '<c-k>', -- default: '<c-k>',
                    replay = '<c-q>',       -- default: '<c-q>',  -- replay a macro
                    delete = '<bs>',        -- default: '<c-d>',  -- delete an entry
                    edit = '<c-e>',         -- default: '<c-e>',  -- edit an entry
                    custom = {},
                },
                n = {
                    select = '<cr>', -- default: '<cr>',
                    paste = 'p',     -- default: 'p',
                    --- It is possible to map to more than one key.
                    -- paste = { 'p', '<c-p>' },
                    paste_behind = 'P', -- default: 'P',
                    replay = 'q',       -- default: 'q',
                    delete = '<bs>',    -- default: 'd',
                    edit = 'e',         -- default: 'e',
                    custom = {},
                },
            },
        },
    }
}
