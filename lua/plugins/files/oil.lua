return {

    'stevearc/oil.nvim',

    cmd = { 'Oil' },

    dependencies = { "nvim-tree/nvim-web-devicons" },

    keys = {
        { "<leader>to", "<cmd>Oil<cr>", { desc = "Open Oil" } },
        { "-", "<cmd>Oil<cr>", { desc = "Open Oil" } }
    },

    opts = {
        -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
        default_file_explorer = true,
        -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
        delete_to_trash = true,
        -- Oil will automatically delete hidden buffers after this delay
        cleanup_delay_ms = 5000, -- default: 2000
        -- Set to true to watch the filesystem for changes and reload oil
        watch_for_changes = true,
        -- Keymaps (only different than defaults are listed)
        keymaps = {
            -- for consistency with other plugins
            ["<C-h>"] = false, -- I use this to switch windows
            ["<C-l>"] = false, -- I use this to switch windows
            ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
            ["<C-x>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a vertical split" },
            ["<C-r>"] = "actions.refresh",
            ["<C-s>"] = function()
                local ok, grug = pcall(require, 'grug-far')
                if ok then
                    local entry = require('oil').get_cursor_entry()
                    local dir = require('oil').get_current_dir()
                    grug.open({
                        windowCreationCommand = 'tab split',
                        openTargetWindow = { preferredLocation = 'right' },
                        prefills = { paths = dir .. entry.name },
                    })
                end
            end
        },
    }

}
