return {

    "artemave/workspace-diagnostics.nvim",

    keys = function()
        local function run_diagnostics()
            local out_text = {}
            for _, client in ipairs(vim.lsp.get_clients({ buffer = vim.api.nvim_get_current_buf() })) do
                require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
                table.insert(out_text, client['name'])
            end
            if out_text == {} then
                vim.print("Unable to extract workspace diagnostics: no language server for current buffer")
            else
                vim.fn.confirm("Extracted workspace diagnostics for: " .. table.concat(out_text, ", "))
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
