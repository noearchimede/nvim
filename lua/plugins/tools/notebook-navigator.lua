return {

    "GCBallesteros/NotebookNavigator.nvim",

    dependencies = {
        "hkupty/iron.nvim", -- REPL
        "numToStr/comment.nvim", -- for "comment block" action
        "nvimtools/hydra.nvim", -- for persistent mapping leader
    },

    -- event = "VeryLazy",
    ft = "python",

    keys = {

        { "]j", function() require("notebook-navigator").move_cell("d") end, desc = "Notebook: move to next cell" },
        { "[j", function() require("notebook-navigator").move_cell("u") end, desc = "Notebook: move to previous cell" },

    },

    config = function()

        require('notebook-navigator').setup({})

        local Hydra = require('hydra')
        Hydra({
            mode = 'n',
            body = '<leader>j',
            on_enter = function() require('which-key').show({ key = '<leader>j' }) end,
            heads = {
                -- REPL commands: invoke mappings defined in iron.lua
                -- notebook-navigator provides commands to interface with the REPL,
                -- but my Iron mappings behave better with the rest of my Iron config
                { "j", "<cmd>ConfigNbnavIronSendBlockAdvance<cr>", { exit = true  } },
                { "J", "<cmd>ConfigNbnavIronSendBlockAdvance<cr>"  },
                { "r",  "<cmd>ConfigNbnavIronSendBlock<cr>", { exit = true } },
                { "R",  "<cmd>ConfigNbnavIronSendBlock<cr>", },
                { "f", "<cmd>ConfigNbnavIronSendAll<cr>", { exit = true  } },
                -- cell navigation and editing commands: implement here
                { "n", function() require("notebook-navigator").move_cell("d") end, { exit = true } },
                { "N", function() require("notebook-navigator").move_cell("d") end },
                { "p", function() require("notebook-navigator").move_cell("u") end, { exit = true } },
                { "P", function() require("notebook-navigator").move_cell("u") end },
                { "a", function() require('notebook-navigator').add_cell_above() end, { exit = true } },
                { "A", function() require('notebook-navigator').add_cell_above() end },
                { "b", function() require('notebook-navigator').add_cell_below() end, { exit = true } },
                { "B", function() require('notebook-navigator').add_cell_below() end },
                { "m", function() require('notebook-navigator').merge_cell("d") end , { exit = true  } },
                { "M", function() require('notebook-navigator').merge_cell("d") end },
                { "s", function() require('notebook-navigator').split_cell() end , { exit = true  } },
                { "S", function() require('notebook-navigator').split_cell() end },
                { "u", function() require('notebook-navigator').swap_cell("u") end, { exit = true } },
                { "U", function() require('notebook-navigator').swap_cell("u") end },
                { "d", function() require('notebook-navigator').swap_cell("d") end, { exit = true } },
                { "D", function() require('notebook-navigator').swap_cell("d") end },
                { "c", function() require('notebook-navigator').comment_cell() end },
                { "C", function() require('notebook-navigator').comment_cell() end, { exit = true } },
			    { '<Esc>', nil, { exit = true } }
            },
            hint = [[ Notebook cell navigation
_j_/_J_: run (go to next)  _a_/_A_: add cell above    _u_/_U_: swap with cell above
_r_/_R_: run (don't move)  _b_/_B_: add cell below    _d_/_D_: swap with cell below
_n_/_N_: go to next cell   _m_/_M_: merge with next   _c_/_C_: comment cell
_p_/_P_: go to previous    _s_/_S_: split cell        _f_:     run all cells
                           _<Esc>_: exit
            ]],
            config = {
                invoke_on_body = true,
                buffer = true, -- define hydra only for current buffer
                desc = "Notebook navigation Hydra",
                hint = {
                    position = 'bottom',
                    float_opts = {
                        style = "minimal",
                    },
                },
            }
        })

    end

}
