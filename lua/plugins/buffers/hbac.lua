return {

    'axkirillov/hbac.nvim',

    dependencies = {
        'nvim-telescope/telescope.nvim'
    },

    lazy = false,

    keys = {
        { "<leader>bc", function()
            vim.print("HBAC: close all unpinned buffers? [y/N]")
            if vim.fn.nr2char(vim.fn.getchar()) == 'y' then
                require("hbac").close_unpinned()
                vim.print("HBAC: closed unpinned buffers")
            else
                vim.print("HBAC: operation interrupted")
            end
        end,
        desc = "HBAC: close all unpinned buffers" }
    },

    opts = {
        autoclose = false,
        threshold = 10,
        close_command = function(bufnr)
            vim.api.nvim_buf_delete(bufnr, {})
        end,
        close_buffers_with_windows = false,
        telescope = {
            sort_mru = true, -- sort by most recently used
            sort_lastused = true,
            selection_strategy = "row",
            use_default_mappings = true,
            mappings = {
                i = {
                    ["<C-c>"] = function(prompt_bufnr) require("hbac.telescope.actions").close_unpinned(prompt_bufnr) end,
                    ["<C-x>"] = function(prompt_bufnr) require("hbac.telescope.actions").delete_buffer(prompt_bufnr) end,
                    ["<C-a>"] = function(prompt_bufnr) require("hbac.telescope.actions").pin_all(prompt_bufnr) end,
                    ["<C-u>"] = function(prompt_bufnr) require("hbac.telescope.actions").unpin_all(prompt_bufnr) end,
                    ["<C-p>"] = function(prompt_bufnr) require("hbac.telescope.actions").toggle_pin(prompt_bufnr) end,
                },
            },
            -- Pinned/unpinned icons and their hl groups. Defaults to nerdfont icons
            pin_icons = {
                pinned = { "󰐃 ", hl = "DiagnosticOk" },
                unpinned = { "󰤱 ", hl = "DiagnosticError" },
            },
        },
    },

    init = function()
        -- load telescope extension
        require('telescope').load_extension('hbac')

    end
}
