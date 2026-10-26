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

        local function repl_action(action)
            local run_with_pyrepl = vim.g.config_nbnav_active_repl == "pyrepl"
            local run_with_neopyter = vim.g.config_nbnav_active_repl == "neopyter"

            -- actions for both pyrepl and neopyter
            local pyrepl = require("pyrepl")
            if action == 'run cell' then
                if run_with_pyrepl then pyrepl.send_cell()
                elseif run_with_neopyter then require("neopyter.jupyter").notebook:run_selected_cell()
                end
            elseif action == 'run file' then
                if run_with_pyrepl then pyrepl.send_buffer()
                elseif run_with_neopyter then require("neopyter.jupyter").notebook:run_all()
                end
            elseif action == 'run above' then
                if run_with_pyrepl then vim.notify("Running cells above in Pyrepl is not implemented, do it manually")
                elseif run_with_neopyter then require("neopyter.jupyter").notebook:run_all_above()
                end
            elseif action == 'run visual' then
                if run_with_pyrepl then pyrepl.send_visual()
                elseif run_with_neopyter then vim.notify("Can't run arbitrary code selections in Jupyter")
                end

            -- pyrepl only
            elseif action == 'open repl' then
                vim.g.config_nbnav_active_repl = "pyrepl"
                pyrepl.open_repl()
                local open_msg = "If Pyrepl rutime packages are not installed yet, run ':PyreplInstall pip'.\n"
                .. "To show matploblib images in a separate window, use %matplotlib qt (or macosx, tk, ...).\n"
                vim.defer_fn(function() vim.notify(open_msg) end, 500)
            elseif action == 'hide repl' then
                pyrepl.hide_repl()
            elseif action == 'close repl' then
                pyrepl.close_repl()
            elseif action == 'focus repl' then
                pyrepl.toggle_repl_focus()
            elseif action == 'image history' then
                pyrepl.open_image_history()

            -- jupyterlab only
            elseif action == 'open jl' then
                vim.g.config_nbnav_active_repl = "neopyter"
                local jsonlist = vim.system({ "jupyter", "server", "list", "--jsonlist" }, { text = true }):wait().stdout
                local servers = vim.json.decode(jsonlist or '{}')
                if #servers > 0 then
                    vim.notify("Jupyter Lab is already running", vim.log.levels.INFO)
                else
                    -- launch jupyter lab in a terminal split (the user may hide it with :q)
                    vim.cmd("botright 15 new")
                    local py_env = require("venv-selector").venv() or vim.env.VIRTUAL_ENV
                    vim.g.config_nbnav_jl_job = vim.fn.jobstart({ vim.fs.joinpath(py_env, "bin", "python"), "-m", "jupyterlab" }, {
                        term = true,
                        cwd = vim.fn.expand("~"),
                        on_exit = function() vim.g.config_nbnav_jl_job = nil end,
                    })
                end
                vim.cmd("Neopyter connect")
                require("neopyter.async").run(function()
                    -- async context
                    local lab = require("neopyter.jupyter")
                    local notebook = lab:get_notebook(0) -- Get notebook for current buffer 
                    notebook:attach()
                end)
            elseif action == 'close jl' then
                vim.cmd("Neopyter disconnect")
                if vim.g.config_nbnav_jl_job then
                    vim.fn.jobstop(vim.g.config_nbnav_jl_job)
                end
            elseif action == 'restart kernel' then

            else
                vim.notify("Unknown REPL action: " .. action)
            end
        end

        local function define_custom_hydra()
            -- define shift-enter to run current cell for consistency with usual jupyter keymappings
            vim.keymap.set( { "n" }, "<S-cr>", function() repl_action('run cell') end, { desc = "Pyrepl: run cell" } )
            -- define terminal mapping to enable focusing back to code (must match corresponding hydra mapping)
            vim.keymap.set( { "t" }, "<leader>jt", function() repl_action('focus repl') end, { desc = "Pyrepl: toggle focus" } )
            -- the jv mapping should also work in visual mode
            vim.keymap.set( { "v" }, "<leader>jv", function() repl_action('run visual') end, { desc = "Pyrepl: send visual selection" } )
            Hydra({
                mode = 'n',
                body = '<leader>j',
                heads = {
                    -- REPL commands: invoke mappings defined in pyrepl.nvim
                    -- notebook-navigator provides commands to interface with a REPL,
                    -- but pyrepl is not currently supported
                    { "j", function() repl_action('run cell') nn.move_cell('d') end, { exit = true  } },
                    { "J", function() repl_action('run cell') nn.move_cell('d') end  },
                    { "r", function() repl_action('run cell') end, { exit = true } },
                    { "R", function() repl_action('run cell') end, },
                    { "f", function() repl_action('run file') end, { exit = true } },
                    { "e", function() repl_action('run above') end, { exit = true } },
                    { "E", function() repl_action('run above') end },
                    { "v", function() repl_action('run visual') end, { exit = true } },
                    { "i", function() repl_action('image history') end, { exit = true } },
                    { "o", function() repl_action('open repl') end, { exit = true } },
                    { "h", function() repl_action('hide repl') end, { exit = true } },
                    { "q", function() repl_action('close repl') end, { exit = true } },
                    { "t", function() repl_action('focus repl') end, { exit = true } },
                    { "l", function() repl_action('open jl') end, { exit = true } },
                    { "x", function() repl_action('close jl') end, { exit = true } },
                    { "k", function() repl_action('restart kernel') end, { exit = true } },
                    -- cell navigation and editing commands: implement here
                    { "n", function() nn.move_cell("d") end, { exit = true } },
                    { "N", function() nn.move_cell("d") end },
                    { "p", function() nn.move_cell("u") end, { exit = true } },
                    { "P", function() nn.move_cell("u") end },
                    { "a", function() nn.add_cell_above() end, { exit = true } },
                    { "A", function() nn.add_cell_above() end },
                    { "b", function() nn.add_cell_below() end, { exit = true } },
                    { "B", function() nn.add_cell_below() end },
                    { "m", function() nn.merge_cell("d") end , { exit = true  } },
                    { "M", function() nn.merge_cell("d") end },
                    { "s", function() nn.split_cell() end , { exit = true  } },
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
Pyrepl        _o_|_h_|_q_: open|hide|quit   REPL _t_: go to terminal   _i_: view images  
JupyterLab    _l_|_x_: link|unlink jupyterlab   _k_: restart kernel
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
            pattern = "python",
            callback = function()
                local extension = vim.fn.expand("%:e:e") -- allow two extensions for "ju.*"
                if extension == "ipynb" or extension:match("^ju%.") then
                    -- mappings for jupyter notebooks
                    define_custom_hydra()
                else
                    -- mappings for other python files
                    vim.keymap.set("n", "<leader>jj", function() vim.cmd.normal("V") repl_action("run visual") end, { buffer = true, desc = "Pyrepl: send current line" })
                    vim.keymap.set("v", "<leader>jj", function() repl_action("run visual") end, { buffer = true, desc = "Pyrepl: send visual selection" })
                    vim.keymap.set("n", "<leader>jf", function() repl_action("run buffer") end, { buffer = true, desc = "Pyrepl: send file" })
                    vim.keymap.set("n", "<leader>jt", function() repl_action("focus repl") end, { buffer = true, desc = "Pyrepl: focus terminal" })
                    vim.keymap.set("n", "<leader>ji", function() repl_action("image history") end, { buffer = true, desc = "Pyrepl: open image viewer" })
                end
            end
        })

    end

}
