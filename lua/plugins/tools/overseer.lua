return {

    'stevearc/overseer.nvim',

    dependencies = {
        "stevearc/dressing.nvim", -- nicer UI
    },

    cmd = { "OverseerOpen", "OverseerToggle", "OverseerRunCmd", "OverseerRun", "OverseerInfo", "OverseerBuild" },

    keys = {
        {
            '<leader>cc',
            function()
                -- open the task selector and if a task is started open the overseer window to monitor its progress
                -- (adapted rom https://github.com/stevearc/overseer.nvim/issues/36#issuecomment-1238715487)
                require('overseer').run_template({ first = false }, function(task)
                    if task then
                        require('overseer').open({ enter = true })
                    end
                end)
            end,
            desc = "Overseer: run"
        },
        { '<leader>co', '<cmd>OverseerOpen<cr>', desc = "Overseer: toggle overview" },
        { '<leader>cO', '<cmd>OverseerClose<cr>', desc = "Overseer: focus overview" },
    },

    opts = {

        templates = { "builtin" },

        task_list = {
            max_height = { 20, 0.3 },
            bindings = {
                ["?"] = "ShowHelp",
                ["g?"] = "ShowHelp",
                ["<CR>"] = "RunAction",
                ["e"] = "Edit", -- default <C-e>
                ["o"] = "Open",
                ["v"] = "OpenVsplit", -- default <C-v>
                ["h"] = "OpenSplit", -- default <C-s>
                ["f"] = "OpenFloat", -- default <C-f>
                ["l"] = "OpenQuickFix", -- default <C-q>
                ["P"] = "TogglePreview", -- default p
                ["r"] = "IncreaseDetail", -- default <C-l>
                ["m"] = "DecreaseDetail", -- default <C-h>
                ["R"] = "IncreaseAllDetail", -- default L
                ["M"] = "DecreaseAllDetail", -- default H
                ["{"] = "DecreaseWidth", -- default [
                ["}"] = "IncreaseWidth", -- default ]
                ["["] = "PrevTask", -- default {
                ["]"] = "NextTask", -- default }
                ["p"] = "PrevTask", -- default {
                ["n"] = "NextTask", -- default }
                ["K"] = "ScrollOutputUp", -- default <C-k>
                ["J"] = "ScrollOutputDown", -- default <C-j>
                ["q"] = "Close",
                -- ["<esc>"] = "Close", // not mapped for now, as due to a bug insert mode is entered after launcing a task
            },
        },

        task_launcher = {
            bindings = {
                i = {
                    ["<C-s>"] = "Submit",
                    ["<C-c>"] = "Cancel",
                },
                n = {
                    ["<CR>"] = "Submit",
                    ["<C-s>"] = "Submit",
                    ["q"] = "Cancel",
                    ["<esc>"] = "Cancel",
                    ["g?"] = "ShowHelp",
                    ["?"] = "ShowHelp",
                },
            },
        },
        task_editor = {
            -- Set keymap to false to remove default behavior
            -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
            bindings = {
                i = {
                    ["<CR>"] = "NextOrSubmit",
                    ["<C-s>"] = "Submit",
                    ["<Tab>"] = "Next",
                    ["<S-Tab>"] = "Prev",
                    ["<C-c>"] = "Cancel",
                },
                n = {
                    ["<CR>"] = "NextOrSubmit",
                    ["<C-s>"] = "Submit",
                    ["<Tab>"] = "Next",
                    ["<S-Tab>"] = "Prev",
                    ["q"] = "Cancel",
                    ["<esc>"] = "Cancel",
                    ["g?"] = "ShowHelp",
                    ["?"] = "ShowHelp",
                },
            },
        },
        component_aliases = {
            -- Most tasks are initialized with the default components
            default = {
                { "display_duration", detail_level = 1 },
                "on_output_summarize",
                "on_exit_set_status",
                "on_complete_notify"
                },
            },

    },

    config = function(_, opts)

        local overseer = require('overseer')

        overseer.setup(opts)

        -- Run python file
        require("overseer").register_template({
            name = "python run",
            builder = function()
                local file = vim.fn.expand("%:p")
                return {
                    cmd = { "python" },
                    args = { file },
                    components = { "default" },
                }
            end,
            condition = {
                filetype = { "python" },
            },
        })

        -- Run shell script
        require("overseer").register_template({
            name = "shell run",
            builder = function()
                local file = vim.fn.expand("%")
                return {
                    cmd = { './' .. file },
                    components = { "default" },
                }
            end,
            condition = {
                filetype = { "sh" },
            },
        })

        -- Compile and run c++ program
        require("overseer").register_template({
            name = "g++ build and run",
            builder = function()
                local file = vim.fn.expand("%:p")
                local outfile = vim.fn.expand("%:p:r") .. ".out"
                return {
                    cmd = { outfile },
                    components = {
                        -- Note that since we're using the "raw task parameters" format for the dependency,
                        -- we don't have to define a separate build task.
                        { "dependencies", task_names = { { cmd = "g++", args = { file, "-o", outfile } } } },
                        "default"
                    },
                }
            end,
            condition = {
                filetype = { "cpp" },
            },
        })

        -- Export Markdown as PDF
        require("overseer").register_template({
            name = "export to PDF",
            builder = function()
                -- define the 'table unpack' command used below
                ---@diagnostic disable-next-line: deprecated
                table.unpack = table.unpack or unpack -- 5.1 compatibility
                -- file info
                local file = vim.fn.expand("%")
                local fname = vim.fn.expand("%:t:r")
                local outfile = vim.fn.expand("~/Desktop/" .. fname .. ".pdf")
                -- template selection
                -- Note: I'd like to use vim.ui.select but I would need a syncronous version. See discussion here: https://github.com/neovim/neovim/issues/24632
                local template = {}
                local template_sel = vim.fn.inputlist({ 'Select Pandoc template:', '1. Default', '2. Eisvogel' })
                if template_sel == 2 then
                    template = {
                        '--template',
                        'eisvogel', -- must be present in the ~/.pandoc/templates folder!
                        '--listings', -- use the 'listings' latex package to provide syntax higlighting in code blocks
                        '-V disable-header-and-footer' -- disable the header and footer
                        -- for other settings see https://github.com/Wandmalfarbe/pandoc-latex-template
                    }
                else
                    -- if the default template is selected there is nothing to do; if the selection is invalid fall back to default
                end
                return {
                    cmd = {
                        "pandoc",
                        "--pdf-engine=xelatex", -- this engine recognizes unicode characters
                        file,
                        "-o",
                        outfile,
                        table.unpack(template),
                    },
                    components = { "default" },
                }
            end,
            condition = {
                filetype = { "markdown" },
            }
        })

        -- create a Make command to run :make as an overseer process (similar to tpope/vim-dispatch)
        -- copied from https://github.com/stevearc/overseer.nvim/blob/master/doc/recipes.md#make-similar-to-vim-dispatch
        vim.api.nvim_create_user_command(
            "Make",
            function(params)
                -- Insert args at the '$*' in the makeprg
                local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
                if num_subs == 0 then
                    cmd = cmd .. " " .. params.args
                end
                local task = overseer.new_task({
                    cmd = vim.fn.expandcmd(cmd),
                    components = {
                        { "on_output_quickfix", open = not params.bang, open_height = 8 },
                        "default",
                    },
                })
                task:start()
            end,
            {
                desc = "Run your makeprg as an Overseer task",
                nargs = "*",
                bang = true,
            }
        )

    end
}
