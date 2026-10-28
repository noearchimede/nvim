return {

    -- note: this is a fork of the original repo 'GCBallesteros/NotebookNavigator.nvim' and might be merged back at any time
    "vandalt/NotebookNavigator.nvim",

    dependencies = {
        "numToStr/comment.nvim", -- for "comment block" action
        "nvimtools/hydra.nvim", -- for persistent mapping leader
        "dangooddd/pyrepl.nvim", -- repl, better suited for notebooks than e.g. Iron.nvim
    },

    -- event = "VeryLazy",
    ft = "python",

    keys = {

        { "]j", function() require("notebook-navigator").move_cell("d") end, desc = "Notebook: move to next cell" },
        { "[j", function() require("notebook-navigator").move_cell("u") end, desc = "Notebook: move to previous cell" },

    },

    opts = {
        syntax_highlight = true,
    },

    config = function(_, opts)

        local nn = require("notebook-navigator")
        local Hydra = require('hydra')

        nn.setup(opts)

        local pyrepl = require("pyrepl")
        local use_pyrepl = function() return vim.g.config_nbnav_active_repl == "pyrepl" end
        local use_jupynium = function() return vim.g.config_nbnav_active_repl == "jupynium" end

        -- helpers for the "code actions" table below
        local function jupynium_build_temp_ipynb_path(bufname)
            return "%" .. vim.fn.fnamemodify(bufname, ":t:r:r") .. ".temp.ipynb"
        end

        local function jupynium_delete_temp_ipynb(bufname)
            local ok, _ = os.remove(jupynium_build_temp_ipynb_path(bufname))
            if ok then
                vim.notify("Jupinium: deleted temporary notebook " .. jupynium_build_temp_ipynb_path(bufname))
            end
        end

        -- define functions related to running code in a table that will be used for all mappings below
        local code_actions = {

            run_cell = function()
                if use_pyrepl() then
                    pyrepl.send_cell()
                elseif use_jupynium() then
                    vim.cmd(":JupyniumExecuteSelectedCells")
                end
            end,

            run_file = function()
                if use_pyrepl() then
                    pyrepl.send_buffer()
                elseif use_jupynium() then
                    local save_cursor = vim.fn.getpos(".")
                    vim.cmd('normal ggVG')
                    vim.cmd(":JupyniumExecuteSelectedCells")
                    vim.fn.setpos('.', save_cursor)
                end
            end,

            run_visual = function()
                if use_pyrepl() then
                    pyrepl.send_visual()
                elseif use_jupynium() then
                    vim.cmd(":JupyniumExecuteSelectedCells")
                end
            end,

            open_pyrepl = function()
                -- set active repl
                vim.g.config_nbnav_active_repl = "pyrepl"
                pyrepl.open_repl()
                vim.defer_fn(
                function()
                    vim.notify("If Pyrepl rutime packages are not installed yet, run ':PyreplInstall pip'.\n"
                        .. "To show matploblib images in a separate window, use %matplotlib qt (or macosx, tk, ...).")
                end, 500)
            end,

            open_jupynium = function()
                -- set active repl
                vim.g.config_nbnav_active_repl = "jupynium"
                -- attach to jupyter server (always do it, it appears safe to use when the server is already attached)
                vim.cmd("JupyniumStartAndAttachToServer")
                -- vim.notify("Hint: if Jupyter doesn't start, run :JupyniumStartAndAttachToServerInTerminal to se the error messages\n"
                -- .. "Hint: Jupynium requires both 'jupynium' and 'nbclassic' installed in the current environment")
                local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
                vim.cmd("JupyniumStartSync " .. jupynium_build_temp_ipynb_path(bufname))
                vim.cmd("JupyniumKernelSelect")
                -- define autocmd that will attempt to delete the %<name>.temp.ipynb file associated with a buffer when it is closed
                vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
                    buffer = vim.api.nvim_get_current_buf(),
                    callback = function() jupynium_delete_temp_ipynb(bufname) end,
                })
            end,

            restart_kernel = function()
                if use_pyrepl() then
                    if vim.fn.confirm("Restart REPL?", "&Yes\n&No") == 1 then
                        pyrepl.close_repl()
                        pyrepl.open_repl()
                    end
                elseif use_jupynium() then
                    if vim.fn.confirm("Restart Jupyter kernel?", "&Yes\n&No") == 1 then
                        vim.cmd(":JupyniumKernelRestart")
                    end
                end
            end,

            hide_repl = function()
                if use_pyrepl() then
                    pyrepl.hide_repl()
                end
            end,

            close_repl = function()
                if use_pyrepl() then
                    pyrepl.close_repl()
                elseif use_jupynium() then
                    vim.cmd(":JupyniumStopSync")
                    vim.notify(
                    "Sync stopped. To end the Jupyter connection close the main page in the Selenium-controlled browser")
                    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
                    jupynium_delete_temp_ipynb(bufname)
                end
            end,

            focus_repl = function()
                if use_pyrepl() then
                    pyrepl.toggle_repl_focus()
                elseif use_jupynium() then
                    vim.notify("Command not available for Jupynium")
                end
            end,

            image_history = function()
                if use_pyrepl() then
                    pyrepl.open_image_history()
                elseif use_jupynium() then
                    vim.notify("Command not available for Jupynium")
                end
            end,

            actions_menu = function()
                if use_jupynium() then
                    vim.ui.select({
                            "Download notebook",
                            "Sync from open tab",
                        }, {},
                        function(choice)
                            if choice == "Download notebook" then
                                vim.cmd("JupyniumDownloadIpynb")
                            elseif choice == "Sync from open tab" then
                                vim.ui.input({ prmpt = "Select browser tab number to sync (left to right, first is 1)" },
                                    function(input)
                                        local buf = vim.api.nvim_create_buf(true, false)
                                        vim.api.nvim_set_current_buf(buf)
                                        vim.bo[buf].filetype = 'python'
                                        vim.cmd("JupyniumLoadFromIpynbTabAndStartSync " .. tonumber(input))
                                    end)
                            end
                        end)
                end
            end,

            ipynb2py = function()
                vim.cmd("PyreplConvert")
            end

        }

        local function define_custom_hydra()
            -- define shift-enter to run current cell for consistency with usual jupyter keymappings
            vim.keymap.set({ "n" }, "<S-cr>", function() code_actions.run_cell() end, { desc = "Pyrepl: run cell" })
            -- define terminal mapping to enable focusing back to code (must match corresponding hydra mapping)
            vim.keymap.set({ "t" }, "<leader>jt", function() code_actions.focus_repl() end,
                { desc = "Pyrepl: toggle focus" })
            -- the jv mapping should also work in visual mode
            vim.keymap.set({ "v" }, "<leader>jv", function() code_actions.run_visual() end,
                { desc = "Pyrepl: send visual selection" })
            Hydra({
                mode = 'n',
                body = '<leader>j',
                heads = {
                    -- REPL commands: invoke mappings defined in pyrepl.nvim
                    -- notebook-navigator provides commands to interface with a REPL,
                    -- but pyrepl is not currently supported
                    { "j", function() code_actions.run_cell() nn.move_cell('d') end, { exit = true } },
                    { "J", function() code_actions.run_cell() nn.move_cell('d') end },
                    { "r", function() code_actions.run_cell() end, { exit = true } },
                    { "R", function() code_actions.run_cell() end, },
                    { "f", function() code_actions.run_file() end, { exit = true } },
                    { "e", function() code_actions.run_above() end, { exit = true } },
                    { "E", function() code_actions.run_above() end },
                    { "v", function() code_actions.run_visual() end, { exit = true } },
                    { "i", function() code_actions.image_history() end, { exit = true } },
                    { "o", function() code_actions.open_pyrepl() end, { exit = true } },
                    { "h", function() code_actions.hide_repl() end, { exit = true } },
                    { "q", function() code_actions.close_repl() end, { exit = true } },
                    { "t", function() code_actions.focus_repl() end, { exit = true } },
                    { "l", function() code_actions.open_jupynium() end, { exit = true } },
                    { "k", function() code_actions.restart_kernel() end, { exit = true } },
                    { "x", function() code_actions.actions_menu() end, { exit = true } },
                    -- cell navigation and editing commands: implement here
                    { "n", function() nn.move_cell("d") end, { exit = true } },
                    { "N", function() nn.move_cell("d") end },
                    { "p", function() nn.move_cell("u") end, { exit = true } },
                    { "P", function() nn.move_cell("u") end },
                    { "a", function() nn.add_cell_above() end, { exit = true } },
                    { "A", function() nn.add_cell_above() end },
                    { "b", function() nn.add_cell_below() end, { exit = true } },
                    { "B", function() nn.add_cell_below() end },
                    { "m", function() nn.merge_cell("d") end, { exit = true } },
                    { "M", function() nn.merge_cell("d") end },
                    { "s", function() nn.split_cell() end, { exit = true } },
                    { "S", function() nn.split_cell() end },
                    { "u", function() nn.swap_cell("u") end, { exit = true } },
                    { "U", function() nn.swap_cell("u") end },
                    { "d", function() nn.swap_cell("d") end, { exit = true } },
                    { "D", function() nn.swap_cell("d") end },
                    { "c", function() nn.comment_cell() end, { exit = true } },
                    { "C", function() nn.comment_cell() end },
                    { '<Esc>', nil, { exit = true } }
                },
                hint = [[ Notebook cell navigation
_j_/_J_: run and go to next   _a_/_A_: add cell above    _u_/_U_: swap with cell above
_r_/_R_/<s-cr>: run           _b_/_B_: add cell below    _d_/_D_: swap with cell below
_e_/_E_: run all cells above  _n_/_N_: go to next cell   _m_/_M_: merge with next
_v_: run visual selection   _p_/_P_: go to previous    _s_/_S_: split cell
_f_: run all cells          _c_/_C_: comment cell
REPLs:   _o_: pyrepl   _l_: live jupyter view                                _q_: close
_h_: hide   _t_: focus repl   _i_: view images   _k_: restart kernel   _x_: other actions

                               _<Esc>_: exit ]],
                config = {
                    invoke_on_body = true,
                    buffer = true,
                    desc = "Notebook navigation Hydra",
                    color = "pink",
                    hint = {
                        position = 'bottom-right',
                        float_opts = {
                            style = "minimal",
                        },
                    },
                    -- autocmd to close the hydra when the buffer is left (does not work, hydra:exit() appears to have a bug)
                    -- on_enter = function()
                    --     local bufnr = vim.api.nvim_get_current_buf()
                    --     vim.api.nvim_create_autocmd("BufLeave", {
                    --         buffer = bufnr,
                    --         once = true,
                    --         callback = function()
                    --             vim.schedule(function()
                    --                 -- exception: since the hydra might create a promt, don't exit if the new buffer is a prompt
                    --                 if vim.bo.buftype ~= "prompt" then
                    --                     require('hydra'):exit()
                    --                 end
                    --             end)
                    --         end,
                    --     })
                    -- end,
                }
            })
        end

        -- define mappings for all python files: if it's a ipynb use the custom Hydra, if not define a small subset of its mappings
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "python", "json" },
            callback = function()
                local extension = vim.fn.expand("%:e:e") -- allow two extensions for "ju.*"
                -- mappings for ju.* files and converted ipynb files
                if extension == "ipynb" or extension:match("^ju%.") then
                    define_custom_hydra()
                    -- bugfix: remove a stray mapping that Jupynium creates even with its no_keybindings option enabled
                    -- vim.cmd("nunmap <buffer> <space>jj")

                    -- mappings for unconverrted ipynb files
                elseif extension == "ipynb" then
                    vim.keymap.set("n", "<leader>jc", function() code_actions.ipynb2py() end,
                        { buffer = true, desc = "Pyrepl: convert to script" })
                    -- mappings for other python files
                else
                    vim.keymap.set("n", "<leader>jj", function()
                        vim.cmd.normal("V")
                        code_actions.run_visual()
                    end, { buffer = true, desc = "Pyrepl: send current line" })
                    vim.keymap.set("v", "<leader>jj", function() code_actions.run_visual() end,
                        { buffer = true, desc = "Pyrepl: send visual selection" })
                    vim.keymap.set("n", "<leader>jt", function() code_actions.focus_repl() end,
                        { buffer = true, desc = "Pyrepl: focus terminal" })
                    vim.keymap.set("n", "<leader>ji", function() code_actions.image_history() end,
                        { buffer = true, desc = "Pyrepl: open image viewer" })
                end
            end
        })

    end

}
