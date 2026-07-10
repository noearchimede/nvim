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

    config = function()

        require('notebook-navigator').setup({
            syntax_highlight = true,
        })

        local nn = require("notebook-navigator")
        local pyrepl = require("pyrepl")
        local Hydra = require('hydra')
        -- define shift-enter to run current cell for consistency with usual jupyter keymappings
        vim.keymap.set( { "n" }, "<S-cr>", function() pyrepl.send_cell() end, { desc = "Pyrepl: run cell" } )
        -- define terminal mapping to enable focusing back to code (must match corresponding hydra mapping)
        vim.keymap.set( { "t" }, "<leader>jt", function() pyrepl.toggle_repl_focus() end, { desc = "Pyrepl: toggle focus" } )
        -- the jv mapping should also work in visual mode
        vim.keymap.set( { "v" }, "<leader>jv", function() pyrepl.send_visual() end, { desc = "Pyrepl: send visual selection" } )
        Hydra({
            mode = 'n',
            body = '<leader>j',
            on_enter = function() require('which-key').show({ key = '<leader>j' }) end,
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

}
