return {

    'stevearc/oil.nvim',

    cmd = { 'Oil' },

    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
        default_file_explorer = true,
        -- Id is automatically added at the beginning, and name at the end
        -- See :help oil-columns
        columns = {
            "icon",
            -- "permissions",
            -- "size",
            -- "mtime",
        },
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = true,

        -- Oil will automatically delete hidden buffers after this delay
        -- You can set the delay to false to disable cleanup entirely
        -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
        cleanup_delay_ms = false, -- default: 2000

        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = true,

        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
        -- Additionally, if it is a string that matches "actions.<name>",
        -- it will use the mapping at require("oil.actions").<name>
        -- Set to `false` to remove a keymap
        -- See :help oil-actions for a list of all available actions
        keymaps = {

            ["g?"] = "actions.show_help",

            ["<CR>"] = "actions.select",

            ["<C-S>v"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
            ["<C-S>s"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
            ["<C-S>t"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
            ["<C-S>x"] = "actions.open_external",

            ["<C-P>"] = "actions.preview",
            ["<C-C>"] = "actions.close",
            ["<C-N>"] = "actions.refresh",

            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",

            -- ["`"] = "actions.cd",
            -- ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
            --
            ["gs"] = "actions.change_sort",
            ["g."] = "actions.toggle_hidden",
            ["g\\"] = "actions.toggle_trash",

        },
        use_default_keymaps = false, -- if this is removed default mappings appear alongside custom ones

        view_options = {
            -- Show files and directories that start with "."
            show_hidden = true,
            -- This function defines what will never be shown, even when `show_hidden` is set
            is_always_hidden = function(name, bufnr)
                return string.match(name, '.DS_Store')
            end,
            -- Sort file names in a more intuitive order for humans. Is less performant,
            -- so you may want to set to false if you work with large directories.
            natural_order = true,
        },
    }

}
