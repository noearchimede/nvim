return {

    "hrsh7th/nvim-cmp",

    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "petertriho/cmp-git",
        "nvim-lua/plenary.nvim" -- required by petertriho/cmp-git
    },

    -- If nvim-cmp is lazy-loaded, it is not able to recognize some of its
    -- sources (e.g. cmp-buffer). So (for now) lazy loading is disabled.
    lazy = false,

    config = function()

        -- define a mapping to toggle autocomplete
        -- based on https://github.com/gitaarik/nvim-cmp-toggle
        local function toggle_autocomplete()
            local cmp = require('cmp')
            local current_setting = cmp.get_config().completion.autocomplete
            if current_setting and #current_setting > 0 then
                cmp.setup({ completion = { autocomplete = false } })
                vim.notify('Autocomplete disabled')
            else
                cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
                vim.notify('Autocomplete enabled')
            end
        end
        vim.keymap.set('n', '<Leader>xc', toggle_autocomplete)


        -- set up nvim-cmp
        local cmp = require('cmp')
        local luasnip  = require('luasnip')

        cmp.setup({

            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end
            },

            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },

            -- The following mappings are adapted from the wiki of nvim-cmp. Summary:
            --
            -- i_(S-)Tab   cmp menu visible ? insert next/prev entry  :  jump to next/prev snippet tag
            -- i_CR        cmp menu visible ? select completion or expand snippet  :  <CR>
            -- i_CTRL_n/p  cmp menu visible ? select next/prev completion item  :  <C-n>/<C-p>
            --
            -- c_(S-)Tab   cmp menu visible ? insert next/prev entry  :  starts completion
            -- c_CR        completion selected ? insert completion  :  accept line (i.e. <CR>)
            -- c_CTRL_n/p  cmp menu visible ? select next/prev completion item  :  filter history (<Up>, <Down>)
            mapping = {

                ['<CR>'] = cmp.mapping({
                    i = function(fallback)
                        if luasnip.expandable() then
                            luasnip.expand()
                        else
                            fallback()
                        end
                    end
                }),
                ["<Tab>"] = cmp.mapping({
                    c = function()
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            cmp.complete()
                        end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end,
                    s = function(fallback)
                        if luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end
                }),
                ["<S-Tab>"] = cmp.mapping({
                    c = function()
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            cmp.complete()
                        end
                    end,
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end,
                    s = function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end
                }),
                ['<C-l>'] = cmp.mapping({
                    -- jump to next snippet position; confirm autocompletion only
                    -- if selected (e.g. with <C-n>); if nothing is selected CR
                    -- works as usual
                    i = function()
                        if luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        end
                        -- extra functionality: detect if a snipped was deleted and if so remove it
                        luasnip.unlink_current_if_deleted()
                    end,
                }),
                ['<Down>'] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end,
                    { 'i' }

                ),
                ['<Up>'] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end,
                    { 'i' }

                ),
                ['<C-n>'] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end,
                    { 'i', 'c' }
                ),
                ['<C-p>'] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end,
                    { 'i', 'c' }

                ),
                -- navigate quick documentation window
                ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
                ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
                -- close completion menu
                ['<C-e>'] = cmp.mapping(cmp.mapping.close(), {'i', 'c'})
            },

            sources = cmp.config.sources(
                {
                    -- NOTE: remember to update the filetype-specific settings below if this is modified!!!
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    -- completion from all buffers (see :h cmp-buffer-all-buffers)
                    { name = 'buffer',
                        option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }
                    }
                }
            )


        }) -- end of cmp.setup(...)

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        -- NOTE: disabled because while completion worked fine, the ability to
        -- move through search history with arrows was broken and I couldn't
        -- find a way to restore it (it works fine in the ':' command line, but
        -- not in in '/' and '?'...). Anyways autocompletion it is not so
        -- important here.
        --[[ cmp.setup.cmdline({ '/', '?' }, {
            sources = cmp.config.sources(
                {
                    { name = 'buffer',
                        option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }
                    }
                }
            )
            -- mappings are imported from cmp.setup(...)
        }) ]]

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            sources = cmp.config.sources(
                {
                    { name = 'path',
                        option = { trailing_slash = false }
                    },
                }, {
                    { name = 'cmdline' }
                }
            ),
            matching = { disallow_symbol_nonprefix_matching = false }
            -- mappings are imported from cmp.setup(...)
        })


        -- filetype-specific configs

        -- gitcommit buffers
        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources(
                {
                    { name = 'git' },
                }, {
                    { name = 'buffer',
                        option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end },
                    }
                }
            )
        })
        require("cmp_git").setup()

        -- lua files
        cmp.setup.filetype('lua', {
            sources = cmp.config.sources(
                {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'nvim_lua' },
                    -- completion from all buffers (see :h cmp-buffer-all-buffers)
                    { name = 'buffer',
                        option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end },
                    }
                }
            )
        })


    end

}
