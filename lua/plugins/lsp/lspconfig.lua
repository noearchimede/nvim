return {

    "neovim/nvim-lspconfig",

    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
        -- mason
        "williamboman/mason.nvim",
        -- interface with cmp-nvim
        "hrsh7th/cmp-nvim-lsp",
        -- window picker for custom "open in window" function
        "s1n7ax/nvim-window-picker",
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
                map("n", "<leader><leader>n", vim.diagnostic.goto_next, "Diagnostics: next")
                map("n", "<leader><leader>p", vim.diagnostic.goto_prev, "Diagnostics: previous")
                map("n", "]d", vim.diagnostic.goto_next, "Diagnostics: next") -- overwrite :h ]d-default to also show the diagnostic text
                map("n", "[d", vim.diagnostic.goto_prev, "Diagnostics: previous") -- see above
                map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, "Diagnostics: next error")
                map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, "Diagnostics: previous error")
                map("n", "]w", function() vim.diagnostic.goto_next({ severity = { min =vim.diagnostic.severity.WARN } }) end, "Diagnostics: next error or warning")
                map("n", "[w", function() vim.diagnostic.goto_prev({ severity = { min =vim.diagnostic.severity.WARN } }) end, "Diagnostics: previous error or warning")

                map("n", "<leader><leader>v", vim.diagnostic.open_float, "Diagnostics: show line diagnostics")
                map("n", "<leader><leader>k", vim.lsp.buf.hover, "LSP: show documentation hover") -- equivalent to K, see :h K-lsp-default
                map("n", "<leader><leader>j", vim.lsp.buf.signature_help, "LSP: show signature help")
                map("n", "<leader><leader>d", vim.lsp.buf.definition, "LSP: go to definition")
                map("n", "<leader><leader>l", vim.lsp.buf.declaration, "LSP: go to declaration")
                map("n", "<leader><leader>i", vim.lsp.buf.implementation, "LSP: go to implementation")
                map("n", "<leader><leader>t", vim.lsp.buf.type_definition, "LSP: go to type definition")
                map("n", "<leader><leader>r", vim.lsp.buf.references, "LSP: go to references")

                -- definitions etc. with window picker (adapted from https://www.reddit.com/r/neovim/comments/140b1p9/does_anyone_have_a_tip_or_keybind_to_open_and/)
                local function lsp_goto_with_picker(lsp_func)
                    lsp_func({
                        on_list = function(options)
                            -- if there are multiple items, warn the user
                            if #options.items > 1 then vim.notify("Multiple items found, opening first one", vim.log.levels.WARN) end
                            -- get id of current window
                            local win_origin = vim.api.nvim_get_current_win()
                            -- create temporary horizontal and vertical splits as additional choices for the user
                            local buf = vim.api.nvim_create_buf(true, true)
                            vim.cmd('vsplit')
                            vim.cmd('vert resize 5')
                            local win_tmp_ver = vim.api.nvim_get_current_win()
                            vim.api.nvim_win_set_buf(win_tmp_ver, buf)
                            vim.api.nvim_set_current_win(win_origin)
                            vim.cmd('split')
                            vim.cmd('resize 5')
                            local win_tmp_hor = vim.api.nvim_get_current_win()
                            vim.api.nvim_win_set_buf(win_tmp_hor, buf)
                            vim.api.nvim_set_current_win(win_origin)
                            -- pick window
                            local picker = require("window-picker")
                            local win_selected = picker.pick_window()
                            -- close the temporary windows if not selected, otherwise resize
                            if win_selected ~= win_tmp_hor then
                                vim.api.nvim_win_close(win_tmp_hor, false)
                            else
                                local height = vim.api.nvim_win_get_height(win_origin)
                                vim.api.nvim_win_set_height(win_tmp_hor, math.floor(height/2))
                            end
                            if win_selected ~= win_tmp_ver then
                                vim.api.nvim_win_close(win_tmp_ver, false)
                            else
                                local width = vim.api.nvim_win_get_width(win_origin)
                                vim.api.nvim_win_set_width(win_tmp_ver, math.floor(width/2))
                            end
                            -- focus the selected window and open the documentation there
                            vim.api.nvim_set_current_win(win_selected)
                            local item = options.items[1]
                            vim.cmd("e +" .. item.lnum .. " " .. item.filename .. "|" .. "normal " .. item.col .. "|")
                        end
                    })
                end
                map("n", "<leader><leader>D", function() lsp_goto_with_picker(vim.lsp.buf.definition) end, "LSP: go to definition")
                map("n", "<leader><leader>L", function() lsp_goto_with_picker(vim.lsp.buf.declaration) end, "LSP: go to declaration")
                map("n", "<leader><leader>I", function() lsp_goto_with_picker(vim.lsp.buf.implementation) end, "LSP: go to implementation")
                map("n", "<leader><leader>T", function() lsp_goto_with_picker(vim.lsp.buf.type_definition) end, "LSP: go to type definition")

                map("n", "<leader><leader>c", vim.lsp.buf.rename, "LSP: rename")
                map({ "n", "v" }, "<leader><leader>a", vim.lsp.buf.code_action, "LSP: code actions")
                map({"n", "v"}, "<leader><leader>f", vim.lsp.buf.format, "LSP: format")

                map("n", "<leader><leader>qq", ":LspStop<CR>", "LSP: stop")
                map("n", "<leader><leader>qr", ":LspRestart<CR>", "LSP: restart")
                map("n", "<leader><leader>qs", ":LspStart<CR>", "LSP: restart")

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
