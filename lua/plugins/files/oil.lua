return {

    'stevearc/oil.nvim',

    cmd = { 'Oil' },

    dependencies = { "nvim-tree/nvim-web-devicons" },

    keys = {
        { "<leader>to", "<cmd>Oil<cr>", { desc = "Open Oil in current buffer" } }
    },

    opts = {

        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
        default_file_explorer = true,

        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = true,

        -- Oil will automatically delete hidden buffers after this delay
        cleanup_delay_ms = 5000, -- default: 2000

        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = true,

        -- Keymaps (only different than defaults are listed)
        keymaps = {
            -- default is 's' for actions.select vertical
            ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
            -- default is <c-l>
            ["<C-r>"] = "actions.refresh",
        },

        view_options = {
            -- Show files and directories that start with "."
            show_hidden = false, -- can toggle with g. by default
            -- This function defines what will never be shown, even when `show_hidden` is set
            is_always_hidden = function(name, bufnr)
                return string.match(name, '.DS_Store')
            end,
        },
    }

}
