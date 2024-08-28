return {

    "natecraddock/workspaces.nvim",

    requires = {
        'nvim-telescope/telescope.nvim', -- optional
    },

    keys = {
        { '<leader>wp', '<cmd>Telescope workspaces<cr>', desc = 'Workspaces: open telescope picker' },
        { '<leader>wa', function()
            -- use feedkeys to start the autocompletion menu with <tab>
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":Workspaces<Tab>", true, true, true), 'tn', false)
        end, desc = 'Workspaces: prepopulate command line' },
    },

    opts = {

        -- controls how the directory is changed. valid options are "global", "local", and "tab"
        cd_type = "tab",

        -- sort the list of workspaces by name after loading from the workspaces path.
        sort = true,
        -- sort by recent use rather than by name. requires sort to be true
        mru_sort = true,

        -- lists of hooks to run after specific actions
        -- hooks can be a lua function or a vim command (string)
        -- lua hooks take a name, a path, and an optional state table
        -- if only one hook is needed, the list may be omitted
        hooks = {
            add = {},
            remove = {},
            rename = {},
            open_pre = function()
                if require("utils").tab_is_empty(0) then
                    -- if the current tab is empty use it
                    vim.g.workspaces_opened_new_tab = false
                else
                    -- otherwise create a new tab before switching workspace
                    vim.cmd("tabe")
                    vim.g.workspaces_opened_new_tab = true
                end
            end,
            open = function()
                -- open tree
                vim.cmd("NvimTreeOpen")
                -- focus main window, not tree, which would lead to problems if
                -- a file is opened from outside the tree (e.g. with Telescope)
                vim.cmd("wincmd l")
                -- notify
                local tab_mess = (vim.g.workspaces_opened_new_tab and " in new tab" or "")
                vim.notify("Workspace " .. (require('workspaces').name() or "???") .. " loaded" .. tab_mess)
            end
        },
    },

    init = function()
        -- attach telescope extension
        require('telescope').load_extension('workspaces')
    end

}
