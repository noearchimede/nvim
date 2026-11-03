-- Jupyter notebooks ---------------------------------------------------------------------------------
--
-- This config allows to open and edit ipynb notebooks directly as well as handling script representations of notebooks.
--  * Actual notebooks can either be edited directly, as raw json files, or trhough an in-place conversion to
--    "percent" format script (with cells separated by `# %%`).
--  * Script representations are editable in vim just like any other script in the same language, but this config
--    provides the ability to run cells either in a cell-aware interactive terminal running a Jupyter kernel or directly
--  in Jupyter Notebook in a browser.
--
-- The current configuration uses four plugins. Most of them have some features disabled to prevent overlap. This list
-- shows only the main features that are used here.
--   * jupytext
--     --> in-place conversion if ipynb to script, without creating a permanent script file on disk (as the name
--         implies, uses the jupytext software)
--   * pyrepl
--     --> creation of scripts from ipynb; also uses the jupytext software (not the extension), but used for a one-off
--         conversion that stores the output on disk
--     --> REPL running a jupyter kernel with some support for inline images
--   * Jupynium
--     --> one-way preview of script notebooks as true notebooks in a Selenium-controlled Firefox instance
--   * Notebook-navigator
--     --> navigation within cell-structured code, both for true scripts and temporary scripts created by jupytext
--   * Hydra
--     --> mapping layer with floating hint window for all notebook-related mappings



-- Helpers --------------------------------------------------------------------------------------

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

local use_pyrepl = function() return vim.g.config_nbnav_active_repl == "pyrepl" end
local use_jupynium = function() return vim.g.config_nbnav_active_repl == "jupynium" end


-- Functions for code execution -----------------------------------------------------------------

local code_actions = {

    run_cell = function()
        if use_pyrepl() then
            require("pyrepl").send_cell()
        elseif use_jupynium() then
            vim.cmd(":JupyniumExecuteSelectedCells")
        end
    end,

    run_file = function()
        if use_pyrepl() then
            require("pyrepl").send_buffer()
        elseif use_jupynium() then
            vim.notify("Broken implementation, run cells manually")
            -- local save_cursor = vim.fn.getpos(".")
            -- vim.cmd('normal ggVG\\<Esc>')
            -- vim.cmd(":JupyniumExecuteSelectedCells")
            -- vim.fn.setpos('.', save_cursor)
        end
    end,

    run_visual = function()
        if use_pyrepl() then
            require("pyrepl").send_visual()
        elseif use_jupynium() then
            vim.cmd(":JupyniumExecuteSelectedCells")
        end
    end,

    run_above = function()
        if use_pyrepl() then
            vim.notify("Broken implementation, run cells manually")
            -- local save_cursor = vim.fn.getpos(".")
            -- vim.cmd('normal! Vgg\\<Esc>')
            -- require("pyrepl").send_visual()
            -- vim.fn.setpos('.', save_cursor)
        elseif use_jupynium() then
            vim.notify("Broken implementation, run cells manually")
            -- local save_cursor = vim.fn.getpos(".")
            -- vim.cmd('normal! Vgg\\<Esc>')
            -- vim.cmd(":JupyniumExecuteSelectedCells")
            -- vim.fn.setpos('.', save_cursor)
        end
    end,

    open_pyrepl = function()
        -- set active repl
        vim.g.config_nbnav_active_repl = "pyrepl"
        require("pyrepl").open_repl()
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
                require("pyrepl").close_repl()
                require("pyrepl").open_repl()
            end
        elseif use_jupynium() then
            if vim.fn.confirm("Restart Jupyter kernel?", "&Yes\n&No") == 1 then
                vim.cmd(":JupyniumKernelRestart")
            end
        end
    end,

    hide_repl = function()
        if use_pyrepl() then
            require("pyrepl").hide_repl()
        end
    end,

    close_repl = function()
        vim.g.config_nbnav_active_repl = nil
        if use_pyrepl() then
            require("pyrepl").close_repl()
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
            require("pyrepl").toggle_repl_focus()
        elseif use_jupynium() then
            vim.notify("Command not available for Jupynium")
        end
    end,

    image_history = function()
        if use_pyrepl() then
            require("pyrepl").open_image_history()
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

    cell_focus_mode = function()
        if use_pyrepl() then
            vim.notify("Cell focus mode only available in Jupynium")
        elseif use_jupynium() then
            vim.cmd("JupyniumShortsightedToggle")
        end
    end,

    ipynb2py = function()
        vim.cmd("PyreplConvert")
    end

}


M = {}


-- Hydra ----------------------------------------------------------------------------------------

table.insert(M, {

    "nvimtools/hydra.nvim",

    -- lazy loading: all plugins configured here are lazily loaded, and this one is arbitrarily chosen to load them when it loads
    -- --> put all other plugins in the dependencies here, and set lazy=true in all of their configs
    dependencies = {
        "vandalt/NotebookNavigator.nvim",
        "dangooddd/pyrepl.nvim",
        "kiyoon/jupynium.nvim",
        "goerz/jupytext.nvim",
    },

    ft = {
        "json",
        "python",
        -- add any other notebook languages here and at all occurrences of this mark [%&]
    },

    config = function()

        -- this function defines the hydra (plus a few auxiliyry mappings)
        -- it is called by the autocmd below in every relevant buffer
        local function define_custom_hydra()

            local nn = require('notebook-navigator')
            require('hydra')({
                mode = 'n',
                body = '<leader>j',
                heads = {
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
                    { "w", function() code_actions.cell_focus_mode() end },
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
REPLs:   _o_: pyrepl   _l_: live jupyter view          _q_: close        _x_: other actions
_h_: hide   _t_: focus repl   _i_: view images   _k_: restart kernel   _w_: cell focus mode

                               _<Esc>_: exit ]],
                config = {
                    invoke_on_body = true,
                    buffer = true,
                    desc = "Notebook navigation",
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
            -- additional mappings to complement the Hydra (also buffer-local):
            -- the jv mapping should also work in visual mode
            vim.keymap.set({ "v" }, "<leader>jv", function() code_actions.run_visual() end,
                { buffer = true, desc = "Notebook navigation: run visual" })
            -- define shift-enter to run current cell for consistency with usual jupyter keymappings
            vim.keymap.set({ "n" }, "<S-cr>", function() code_actions.run_cell() end,
                { buffer = true, desc = "Notebbok navigation: run cell" })

        end

        -- mappings for each different file type
        local mappings = {
            ipynb_raw = function()
                -- 1. json ipynb (unconverted notebooks)
                vim.keymap.set("n", "<leader>cs", function() code_actions.ipynb2py() end,
                    { buffer = true, desc = "Pyrepl: convert to script" })
                vim.keymap.set("n", "<leader>cj", "<cmd>JupytextToggle<cr>",
                    { buffer = true, desc = "Jupytext: edit as script" })
            end,
            ipynb_converted = define_custom_hydra,
            script_ju = define_custom_hydra,
            script = function()
                vim.keymap.set("n", "<leader>jj", function() vim.cmd.normal("V") code_actions.run_visual() end,
                    { buffer = true, desc = "Notebook extension: run line" })
                vim.keymap.set("v", "<leader>jj", function() code_actions.run_visual() end,
                    { buffer = true, desc = "Notebook extension: run visual" })
                vim.keymap.set("n", "<leader>jt", function() code_actions.focus_repl() end,
                    { buffer = true, desc = "Notebook extension: go to repl" })
                vim.keymap.set("n", "<leader>ji", function() code_actions.image_history() end,
                    { buffer = true, desc = "Notebook extension: show image history" })
            end
        }

        -- attach the appropriate mappings to each relevant file
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "json",
                "python",
                -- add any other notebook languages here and at all occurrences of this mark [%&]
            },
            callback = function()
                local extension = vim.fn.expand("%:e:e") -- allow two extensions for "ju.*"
                if vim.o.filetype == "json" then
                    if extension == "ipynb" then mappings.ipynb_raw()
                    end
                else -- filetype is any one of the others in the autocmd 'pattern' list
                    if extension == "ipynb" then mappings.ipynb_converted()
                    elseif extension:match("^ju%.") then mappings.script_ju()
                    else mappings.script()
                    end
                end
            end
        })

    end

})


-- NotebookNavigator -----------------------------------------------------------------------------

table.insert(M, {

    -- note: this is a fork of the original repo 'GCBallesteros/NotebookNavigator.nvim' and might be merged back at any time
    "vandalt/NotebookNavigator.nvim",

    lazy = true,

    keys = {
        { "]j", function() require("notebook-navigator").move_cell("d") end, desc = "Notebook: move to next cell" },
        { "[j", function() require("notebook-navigator").move_cell("u") end, desc = "Notebook: move to previous cell" },
    },

    opts = {
        syntax_highlight = true,
    },

})


-- Pyrepl ---------------------------------------------------------------------------------------

table.insert(M, {

    "dangooddd/pyrepl.nvim",

    dependencies = { "nvim-treesitter/nvim-treesitter" },

    lazy = true,

    cmd = {
        "PyreplConvert", -- allows to load the plugin to convert a notebook
    },

    config = function()
        local pyrepl = require("pyrepl")

        -- default config
        pyrepl.setup({
            split_horizontal = false,
            split_ratio = 0.5,
            style_treesitter = true,
            image_max_history = 50,
            image_width_ratio = 0.5,
            image_height_ratio = 0.5,
            -- built-in provider, works best for ghostty and kitty
            -- for other terminals use "image" instead of "placeholders"
            image_provider = "placeholders",
            cell_pattern = "^# %%%%.*$",
            -- Do not convert ipynb files on opening because that is handled by the goerz/jupytext plugin.
            -- I prefer that plugin over the jupytext integration here because it automatically writes
            -- changes back to the ipynb file (and manages the synchronization automatically without
            -- creating a py file in the same folder)
            jupytext_hook = false,
        })

    end,

})


-- Jupynium  ------------------------------------------------------------------------------------

table.insert(M, {

    "kiyoon/jupynium.nvim",

    dependencies = {
        "stevearc/dressing.nvim", -- optional, UI for :JupyniumKernelSelect
    },

    lazy = true,

    opts = {
        -- downloading the ipynb file is still possible with :JupyniumDownloadIpynb
        auto_download_ipynb = false,

        -- all jupyter-related mappings are unified in the config for notebook-navigator
        use_default_keybindings = false,
        textobjects = {
            use_default_keybindings = false
        },
        -- use Notebook-navigator for cell highlighting
        syntax_highlight = {
            enable = false
        },
    },

})


-- Jupytext  ------------------------------------------------------------------------------------

table.insert(M, {

    "goerz/jupytext.nvim",

    -- in addition to loading whenever the other notebook-related plugins, this
    -- needs to be available on json files, which may be raw notebooks
    ft = { "json" },

    cmd = { "JupytextToggle" },

    opts = {

        format = 'ipynb',
        update = true, -- preserve cell outputs in the .ipynb file on save
    },

    config = function(_, opts)
        require('jupytext').setup(opts)

        -- define a command to toggle conversion on demand
        -- see https://github.com/goerz/jupytext.nvim/issues/14#event-34539411164
        vim.api.nvim_create_user_command('JupytextToggle', function()
            vim.b.jupytext_format = (vim.b.jupytext_format ~= 'py:percent') and 'py:percent' or nil
            vim.cmd('edit')
        end, {})

    end

})

return M
