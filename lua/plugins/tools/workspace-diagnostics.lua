return {

    "artemave/workspace-diagnostics.nvim",

    -- NOTE: when vim.lsp.buf.workspace_diagnostics() is released this plugin will become redundant
    -- see https://github.com/artemave/workspace-diagnostics.nvim/issues/20

    keys = function()
        local function run_diagnostics()
            local out_text = {}
            for _, client in ipairs(vim.lsp.get_clients({ buffer = vim.api.nvim_get_current_buf() })) do
                require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
                table.insert(out_text, client['name'])
            end
            if out_text == {} then
                vim.notify("Unable to extract workspace diagnostics: no language server for current buffer", vim.log.levels.WARN)
            else
                vim.notify("Extracted workspace diagnostics for: " .. table.concat(out_text, ", "), vim.log.levels.INFO)
            end
        end
        return {
            { '<leader><leader>w', run_diagnostics, desc = "Workspace diagnostics: run for language of current buffer" }
        }
    end,

    opts = {
        workspace_files = function()
            -- this is the default workspace_files function
            local gitPath = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
            local workspace_files = vim.fn.split(vim.fn.system("git ls-files " .. "'" .. gitPath .. "'"), "\n")
            return workspace_files
        end,
    }

}
