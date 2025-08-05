return {

    "stevearc/quicker.nvim",

    -- Note: I use two plugins that provide quickfix features, nvim-bqf and quicker.
    -- In the current config, quicker provides:
    --  * nicer formatting of list
    --  * ability to edit quickfix and have edits reflect in buffers
    -- Some features of quicker are intentionally not enabled (in particular
    -- the ability to show context lines around each item)

    ft = "qf",

    opts = {
        -- Local options to set for quickfix
        opts = {
            number = true,
        },
        edit = {
            -- enable editing the quickfix like a normal buffer
            enabled = true,
            -- do not autosave changes made to the buffers via the quickfix
            autosave = false,
        },
        -- Keep the cursor to the right of the filename and lnum columns
        constrain_cursor = true,
    }

}
