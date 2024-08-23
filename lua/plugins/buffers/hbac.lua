return {

    'axkirillov/hbac.nvim',

    lazy = false,

    keys = {
        {
            "<leader>bu",
            function()
                vim.print("HBAC: close all unpinned buffers? [y/N] ")
                if vim.fn.nr2char(vim.fn.getchar()) == 'y' then
                    require("hbac").close_unpinned()
                    vim.print("HBAC: closed unpinned buffers", vim.log.levels.info)
                else
                    vim.print("HBAC: operation interrupted", vim.log.levels.info)
                end
            end,
            desc = "HBAC: close all unpinned buffers"
        }
    },

    opts = {
        autoclose = false, -- only close with keybinding
        threshold = 10, -- for autoclose
        close_command = function(bufnr)
            vim.api.nvim_buf_delete(bufnr, {})
        end,
        close_buffers_with_windows = false, -- do not close buffers with winodws
        telescope = {} -- do not use telescope integration
    },

}
