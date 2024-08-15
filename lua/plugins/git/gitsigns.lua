return {

    "lewis6991/gitsigns.nvim",

    event = { 'BufReadPre', 'BufNewFile' },

    config = function()
        local gitsigns = require('gitsigns')
        gitsigns.setup({

            signs = {
                add = { text = '┃' },
                change = { text = '┃' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
                untracked = { text = '┆' },
            },
            signs_staged = {
                add = { text = '┃' },
                change = { text = '┃' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
                untracked = { text = '┆' },
            },
            signs_staged_enable = true,
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true
            },
            auto_attach = true,
            attach_to_untracked = false,
            current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 200,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000, -- Disable if file is longer than this (in lines)
            preview_config = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },

            on_attach = function(bufnr)
                local function map(mode, l, r, desc)
                    local opts = { buffer = bufnr, desc = "Gitsigns: " .. desc }
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                local function prev_hunk()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        gitsigns.nav_hunk('next')
                    end
                end
                map('n', ']c', prev_hunk, "next hunk")
                map('n', '<leader>gn', prev_hunk, "next hunk")

                local function next_hunk()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end
                map('n', '[c', next_hunk, "previous hunk")
                map('n', '<leader>gp', next_hunk, "previous hunk")

                -- Actions
                map('n', '<leader>gs', gitsigns.stage_hunk, "stage hunk")
                map('v', '<leader>gs', function()
                        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, "stage selection")

                map('n', '<leader>gr', gitsigns.reset_hunk, "reset hunk")
                map('v', '<leader>gr', function()
                        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, "reset selection")

                map('n', '<leader>gz', gitsigns.undo_stage_hunk, "undo stage hunk")

                map('n', '<leader>gv', gitsigns.preview_hunk, "preview hunk")

                map('n', '<leader>gS', gitsigns.stage_buffer, "stage buffer")
                map('n', '<leader>gR', gitsigns.reset_buffer, "reset buffer")

                map('n', '<leader>gb', gitsigns.blame, "file blame")

                -- Implemented by diffview
                -- map('n', '<leader>gdi', gitsigns.diffthis, "diff file against the index")
                -- map('n', '<leader>gdc', function() gitsigns.diffthis('~') end, "diff file against the last commit")

                map('n', '<leader>gx', gitsigns.toggle_deleted, "toggle view of deleted lines")
            end,
        })
    end

}
