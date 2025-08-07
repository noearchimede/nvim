return {

    'mbbill/undotree',

    keys = {
        { "<leader>tu", "<cmd>UndotreeShow<cr>", desc = "Undotree: show" },
        { "<leader>tU", "<cmd>UndotreeHide<cr>", desc = "Undotree: hide" },
    },

    init = function()
        -- layout
        vim.g.undotree_WindowLayout = 4
        -- auto open the diff window
        vim.g.undotree_DiffAutoOpen = 0
        -- default height of diff window
        vim.g.undotree_DiffpanelHeight = 20
        -- focus on toggle
        vim.g.undotree_SetFocusWhenToggle = 1
        -- use short timestamps
        vim.g.undotree_ShortIndicators = 1
        -- hide 'Press ? for help' message (so that the most recent state is on the first line and can be reached with 'gg')
        vim.g.undotree_HelpLine = 0
        -- custom mappings
        vim.api.nvim_exec2([[
            function g:Undotree_CustomMap()
                " custom mappings here (this does not replace the default mappings)
                nmap <buffer> <d> <plug>UndoTreeDiffMark
            endfunc
        ]], {})

        -- set background color to same color as NivmTree
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'undotree',
            callback = function(opts)
                vim.wo.winhighlight = 'Normal:NvimTreeNormal,EndOfBuffer:NvimTreeEndOfBuffer'
            end,
        })

    end

}
