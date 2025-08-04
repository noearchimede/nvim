return {

    "lewis6991/gitsigns.nvim",

    event = { 'BufReadPre', 'BufNewFile' },

    opts = {

        on_attach = function(bufnr)

            local gitsigns = require('gitsigns')

            -- Helpers for mappings
            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = bufnr, desc = "Gitsigns: " .. desc })
            end

            local function prev_hunk()
                if vim.wo.diff then
                    vim.cmd.normal({ ']c', bang = true })
                else
                    gitsigns.nav_hunk('next')
                end
            end
            local function next_hunk()
                if vim.wo.diff then
                    vim.cmd.normal({ '[c', bang = true })
                else
                    gitsigns.nav_hunk('prev')
                end
            end

            map('n', ']c', prev_hunk, "next hunk")
            map('n', '<leader>gn', prev_hunk, "next hunk")
            map('n', '[c', next_hunk, "previous hunk")
            map('n', '<leader>gp', next_hunk, "previous hunk")

            map('n', '<leader>gs', gitsigns.stage_hunk, "stage hunk")
            map('v', '<leader>gs', function()
                gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, "stage selection")
            
            map('n', '<leader>gr', gitsigns.reset_hunk, "reset hunk")
            map('v', '<leader>gr', function()
                gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, "reset selection")

            map('n', '<leader>gu', gitsigns.undo_stage_hunk, "undo stage hunk")

            map('n', '<leader>gv', gitsigns.preview_hunk, "preview hunk")

            map('n', '<leader>gS', gitsigns.stage_buffer, "stage buffer")
            map('n', '<leader>gR', gitsigns.reset_buffer, "reset buffer")

            map('n', '<leader>gb', gitsigns.blame, "file blame")

            map('n', '<leader>gx', gitsigns.toggle_deleted, "toggle inline view of deleted lines")
            map('n', '<leader>gw', gitsigns.toggle_word_diff, "toggle inline word diff view")
            map('n', '<leader>gy', gitsigns.toggle_linehl, "toggle inline line change view")
            map('n', '<leader>gi', function()
                local new_val = gitsigns.toggle_linehl()
                gitsigns.toggle_word_diff(new_val)
                gitsigns.toggle_deleted(new_val) -- deprecated but still works for now 
            end, "toggle full inline diff view")

        end,
    },

    init = function()

        -- create autocmd to create 'q' map in blame buffers
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "gitsigns-blame",
            callback = function()
                vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = true, desc = "Close" })
            end
        })

    end

}
