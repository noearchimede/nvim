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
        local pyrepl = require("pyrepl")
        local Hydra = require('hydra')

        nn.setup(opts)

        local function define_custom_hydra()
            -- define shift-enter to run current cell for consistency with usual jupyter keymappings
            vim.keymap.set( { "n" }, "<S-cr>", function() pyrepl.send_cell() end, { desc = "Pyrepl: run cell" } )
            -- define terminal mapping to enable focusing back to code (must match corresponding hydra mapping)
            vim.keymap.set( { "t" }, "<leader>jt", function() pyrepl.toggle_repl_focus() end, { desc = "Pyrepl: toggle focus" } )
            -- the jv mapping should also work in visual mode
            vim.keymap.set( { "v" }, "<leader>jv", function() pyrepl.send_visual() end, { desc = "Pyrepl: send visual selection" } )
            Hydra({
                mode = 'n',
                body = '<leader>j',
                heads = {
                    -- REPL commands: invoke mappings defined in pyrepl.nvim
                    -- notebook-navigator provides commands to interface with a REPL,
                    -- but pyrepl is not currently supported
                    { "J", function() pyrepl.send_cell() pyrepl.step_cell_forward() end, { exit = true  } },
                    { "j", function() pyrepl.send_cell() pyrepl.step_cell_forward() end  },
                    { "R", function() pyrepl.send_cell() end, { exit = true } },
                    { "r", function() pyrepl.send_cell() end, },
                    { "f", function() pyrepl.send_buffer() end, { exit = true } },
                    { "v", function() pyrepl.send_visual() end, { exit = true } },
                    { "i", function() pyrepl.open_image_history() end, { exit = true } },
                    { "o", function()
                        vim.notify("To install Pyrepl rutime packages run ':PyreplInstall pip'.")
                        pyrepl.open_repl()
                    end, { exit = true } },
                    { "h", function() pyrepl.hide_repl() end, { exit = true } },
                    { "q", function() pyrepl.close_repl() end, { exit = true } },
                    { "t", function() pyrepl.toggle_repl_focus() end, { exit = true } },
                    -- cell navigation and editing commands: implement here
                    { "N", function() nn.move_cell("d") end, { exit = true } },
                    { "n", function() nn.move_cell("d") end },
                    { "P", function() nn.move_cell("u") end, { exit = true } },
                    { "p", function() nn.move_cell("u") end },
                    { "A", function() nn.add_cell_above() end, { exit = true } },
                    { "a", function() nn.add_cell_above() end },
                    { "B", function() nn.add_cell_below() end, { exit = true } },
                    { "b", function() nn.add_cell_below() end },
                    { "M", function() nn.merge_cell("d") end , { exit = true  } },
                    { "m", function() nn.merge_cell("d") end },
                    { "S", function() nn.split_cell() end , { exit = true  } },
                    { "s", function() nn.split_cell() end },
                    { "U", function() nn.swap_cell("u") end, { exit = true } },
                    { "u", function() nn.swap_cell("u") end },
                    { "D", function() nn.swap_cell("d") end, { exit = true } },
                    { "d", function() nn.swap_cell("d") end },
                    { "C", function() nn.comment_cell() end, { exit = true } },
                    { "c", function() nn.comment_cell() end },
                    { '<Esc>', nil, { exit = true } }
                },
                hint = [[ Notebook cell navigation
_j_/_J_: run and go to next _a_/_A_: add cell above    _u_/_U_: swap with cell above
_r_/_R_/<s-cr>: run         _b_/_B_: add cell below    _d_/_D_: swap with cell below
_c_/_C_: comment cell       _n_/_N_: go to next cell   _m_/_M_: merge with next
_f_: run all cells          _p_/_P_: go to previous    _s_/_S_: split cell        
_v_: run visual _i_: image history _t_: focus terminal _o_|_h_|_q_: open|hide|quit REPL
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
                }
            })
        end

        -- define mappings for all python files: if it's a ipynb use the custom Hydra, if not define a small subset of its mappings
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "python",
            callback = function()
                local extension = vim.fn.expand("%:e")
                if extension == "ipynb" then
                    -- mappings for jupyter notebooks
                    define_custom_hydra()
                else
                    -- mappings for other python files
                    vim.keymap.set("n", "<leader>jj", function() vim.cmd.normal("V") pyrepl.send_visual() end, { buffer = true, desc = "Pyrepl: send current line" })
                    vim.keymap.set("v", "<leader>jj", function() pyrepl.send_visual() end, { buffer = true, desc = "Pyrepl: send visual selection" })
                    vim.keymap.set("n", "<leader>jf", function() pyrepl.send_buffer() end, { buffer = true, desc = "Pyrepl: send file" })
                    vim.keymap.set("n", "<leader>jt", function() pyrepl.toggle_repl_focus() end, { buffer = true, desc = "Pyrepl: focus terminal" })
                    vim.keymap.set("n", "<leader>ji", function() pyrepl.open_image_history() end, { buffer = true, desc = "Pyrepl: open image viewer" })
                end
            end
        })

    end

}
