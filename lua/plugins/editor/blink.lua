return {

    "saghen/blink.cmp",

    -- V2 is under active developement, readme suggests using v1 for now
    version = '1.*',

    opts = function()

        -- helper to determine if suggestion idx_shift positions from current one is a snippet
        local function sel_is_snippet(cmp, idx_shift)
            local items = cmp.get_items()
            local idx = cmp.get_selected_item_idx() or 0
            local item = items[(idx + idx_shift - 1) % #items + 1]
            return item and item.kind == require('blink.cmp.types').CompletionItemKind.Snippet
        end

        return {

            completion = {
                list = {
                    selection = {
                        -- do not preselect first suggestion (user must use Tab to insert it)
                        preselect = false,
                        -- when a suggestion is selected, insert it automatically
                        -- this is overwritten in the tab mappings to prevent auto-inserting snippets
                        auto_insert = true,
                    },
                },
            },

            sources = {
                default = {
                    'lsp',
                    'path',
                    'snippets',
                    'buffer',
                    'jupynium' -- jupynium.nvim plugin
                },
                providers = {
                    snippets = {
                        opts = {
                            -- show labels for snippets
                            use_label_description = true,
                        }
                    },
                    jupynium = { -- jupynium.nvim plugin
                        name = "Jupynium",
                        module = "jupynium.blink_cmp",
                        score_offset = 100,
                    }
                }
            },

            keymap = {
                preset = 'none',
                ["<Tab>"] = { -- select next (auto-insert unless it's a snippet)
                    function(cmp) return cmp.select_next({ auto_insert = not sel_is_snippet(cmp, 1) }) end,
                    "fallback"
                },
                ["<S-Tab>"] = { -- select previous (auto-insert unless it's a snippet)
                    function(cmp) return cmp.select_prev({ auto_insert = not sel_is_snippet(cmp, -1) }) end,
                    "fallback"
                },
                ["<Down>"] = { -- like Tab
                    function(cmp) return cmp.select_next({ auto_insert = not sel_is_snippet(cmp, 1) }) end,
                    "fallback"
                },
                ["<Up>"] = { -- like S-Tab
                    function(cmp) return cmp.select_prev({ auto_insert = not sel_is_snippet(cmp, -1) }) end,
                    "fallback"
                },
                ["<CR>"] = { -- if a snippet is selected, insert it
                    function(cmp)
                        if sel_is_snippet(cmp, 0) then return cmp.accept() end
                        return false
                    end,
                    "fallback",
                },
            }

        }
    end,

}
