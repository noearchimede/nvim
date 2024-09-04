-- Note: "jiaoshijie/undotree" is a good alternative written for nvim with e.g. float preview,
-- but the tree gets wider every time the history branches and can be very annoying with larger
-- files
return {

    'mbbill/undotree',

    keys = {
        { "<leader>tu", "<cmd>UndotreeShow<cr>", desc = "Undotree: show" },
        { "<leader>th", "<cmd>UndotreeHide<cr>", desc = "Undotree: hide" },
    },

    init = function()

        -- layout
        vim.g.undotree_WindowLayout = 3

        -- set the undotree window width.
        vim.g.undotree_SplitWidth = 40
        -- set the diff window height.
        vim.g.undotree_DiffpanelHeight = 20
        -- auto open the diff window
        vim.g.undotree_DiffAutoOpen = 0
        -- focus on toggle
        vim.g.undotree_SetFocusWhenToggle = 1
        -- use short timestamps
        vim.g.undotree_ShortIndicators = 1
        -- hide 'Press ? for help' message (so that the most recent state is on the first line and can be reached with 'gg')
        vim.g.undotree_HelpLine = 0

        -- custom mappings
        vim.api.nvim_exec2([[
            function g:Undotree_CustomMap()
                nmap <buffer> <esc> <plug>UndotreeClose
                nmap <buffer> g? <plug>UndotreeHelp
                " define other custom mappings here (this does not replace the default mappings)
            endfunc
        ]], {})

    end

}
