return {

    "neovim/nvim-lspconfig",

    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
        -- mason
        "williamboman/mason.nvim",
        -- interface with cmp-nvim
        "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
        -- create autocommand for LSP attach to define mappings etc.
        vim.api.nvim_create_autocmd("LspAttach", {
            desc = 'LSP actions',
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(event)

                local function map(mode, key, func, desc)
                    vim.keymap.set(mode, key, func, { desc = desc, buffer = event.buf, silent = true })
                end

                -- Insert mode mappings
                map({"i", "n"}, "<C-s>", vim.lsp.buf.signature_help, "LSP: show signature help")

                -- Normal and Visual mode mappings
                map("n", "<leader><leader>n", vim.diagnostic.goto_next, "Diagnostics: previous")
                map("n", "<leader><leader>p", vim.diagnostic.goto_prev, "Diagnostics: next")
                map("n", "<leader><leader>v", vim.diagnostic.open_float, "Diagnostics: show line diagnostics")
                map("n", "<leader><leader>k", vim.lsp.buf.hover, "LSP: show documentation hover") -- this is equivalent to K in most (all?) contexts
                map("n", "<leader><leader>j", vim.lsp.buf.signature_help, "LSP: show signature help")
                map("n", "<leader><leader>d", vim.lsp.buf.definition, "LSP: go to definition")
                map("n", "<leader><leader>l", vim.lsp.buf.declaration, "LSP: go to declaration")
                map("n", "<leader><leader>i", vim.lsp.buf.implementation, "LSP: go to implementation")
                map("n", "<leader><leader>t", vim.lsp.buf.type_definition, "LSP: go to type definition")
                map("n", "<leader><leader>r", vim.lsp.buf.references, "LSP: go to references")

                map("n", "<leader><leader>c", vim.lsp.buf.rename, "LSP: rename")
                map({ "n", "v" }, "<leader><leader>a", vim.lsp.buf.code_action, "LSP: code actions")
                map({"n", "v"}, "<leader><leader>f", vim.lsp.buf.format, "LSP: format")

                map("n", "<leader><leader>q", ":LspRestart<CR>", "LSP: restart")

            end,

        })

        -- customise the way diagnostics are shown
        vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = false
        })

        -- customise diagnostics symbols in the gutter
        -- (from https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#customizing-how-diagnostics-are-displayed)
        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end


    end,
}
