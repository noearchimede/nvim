-- Note: "jiaoshijie/undotree" is a good alternative written for nvim with e.g. float preview,
-- but the tree gets wider every time the history branches and can be very annoying with larger 
-- files
return {

    'mbbill/undotree',

    keys = {
        { "<leader>tu", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
    },

    init = function()
        -- layout: tree on the right hand side, diff (wide) on the bottom
        vim.g.undotree_WindowLayout = 4
        -- focus on toggle
        vim.g.undotree_SetFocusWhenToggle = 1
        -- use short timestamps
        vim.g.undotree_ShortIndicators = 1
    end

}
