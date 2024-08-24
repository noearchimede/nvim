return {

    'stevearc/overseer.nvim',

    dependencies = {
        "stevearc/dressing.nvim", -- nicer UI
    },

    cmd = { "OverseerOpen", "OverseerToggle", "OverseerRunCmd", "OverseerRun", "OverseerInfo", "OverseerBuild" },

    keys = {
        {
            '<leader>ct',
            function()
                -- open the task selector and if a task is started open the overseer window to monitor its progress
                -- (adapted rom https://github.com/stevearc/overseer.nvim/issues/36#issuecomment-1238715487)
                require('overseer').run_template({ first = false }, function(task)
                    if task then
                        require('overseer').open({ enter = false })
                    end
                end)
            end,
            desc = "Overseer: run"
        },
        {
            '<leader>co',
            '<cmd>OverseerToggle<cr>',
            desc = "Overseer: toggle overview",
        },
    },

    opts = {

        templates = { "builtin" },

        task_list = {
            max_height = { 20, 0.3 },
        },

    },

    init = function()

        local overseer = require('overseer')

        require("overseer").register_template({
            name = "python run",
            builder = function()
                -- Full path to current file (see :help expand())
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

        require("overseer").register_template({
            name = "shell run",
            builder = function()
                -- Full path to current file (see :help expand())
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
