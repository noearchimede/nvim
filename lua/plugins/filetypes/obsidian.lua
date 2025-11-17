local my_vaults = {
    {
        name = "no-vault",
        path = function() return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0))) end
    },
    {
        -- keys required for the obsidian.nvim "workspaces" setting
        name = "personal",
        path = "~/Personale/Appunti",
        overrides = {
            templates = {
                folder = "_templates",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M",
            },

        },
        -- keys used in my custom functions
        index = "@Indice.md"
    }
}

return {

    "obsidian-nvim/obsidian.nvim",

    -- load obsidian.nvim on any markdown file, but the plugin will only work
    -- inside the 'workspaces' defined in the options below
    ft = "markdown",

    event = "User EnteredObsidianVault",

    cmd = { "ObsidianQuickSwitch", "ObsidianNew" },

    config = function()

        -- Structure of this config function:
        --  - helpers used to define mappings
        --  - obsidian.setup()
        --     - mappings
        --     - other settings

        -- follow the closest link to the cursor
        -- adapted from https://github.com/epwalsh/obsidian.nvim/issues/471#issue-2171588399
        local follow_closest_link = function()
            local iter = require("obsidian.itertools").iter
            local search = require("obsidian.search")
            local client = require("obsidian").get_client()
            ---@diagnostic disable-next-line: deprecated
            unpack = table.unpack or unpack -- 5.1 compatibility

            local current_line = vim.api.nvim_get_current_line()
            local _, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
            cur_col = cur_col + 1 -- nvim_win_get_cursor returns 0-indexed column
            local best_match = nil
            for match in iter(search.find_refs(current_line, { include_naked_urls = true, include_file_urls = true })) do
                local open, close, _ = unpack(match)
                if
                    best_match == nil
                    or math.abs(cur_col - open) < math.abs(cur_col - best_match[2])
                    or math.abs(cur_col - close) < math.abs(cur_col - best_match[1])
                then
                    best_match = match
                end
            end
            if best_match == nil then
                return nil
            end
            local link = current_line:sub(best_match[1], best_match[2])
            client:follow_link_async(link, nil)
        end

        -- helpers for other mappings
        local obsidian = require('obsidian')
        local function opts(desc)
            return { buffer = true, desc = desc }
        end

        obsidian.setup({

            -- mappings ----------------------------------------------------------------------

            mappings = {
                -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
                ["gf"] = {
                    action = function() return obsidian.util.gf_passthrough() end,
                    opts = { buffer = true, desc = "Obsidian: default gf + resolve links", noremap = false },
                },
                -- Toggle check-boxes: deleted default mapping; only define the more general <cr> below
                -- Smart action depending on context, either follow link or toggle checkbox.
                ["<cr>"] = {
                    action = function() return obsidian.util.smart_action() end,
                    opts = { buffer = true, desc = "Obsidian: smart action", expr = true },
                },
                ['<localleader>a'] = {
                    action = function() return vim.cmd('ObsidianOpen') end,
                    opts = opts("Obsidian: open in app"),
                },
                ['<localleader>n'] = {
                    action = function() return vim.cmd('ObsidianNew') end,
                    opts = opts("Obsidian: new note"),
                },
                ['<localleader>o'] = {
                    action = function() return vim.cmd('ObsidianQuickSwitch') end,
                    opts = opts("Obsidian: switch to or open note"),
                },
                ['<localleader>f'] = {
                    action = follow_closest_link,
                    opts = opts("Obsidian: follow closest link"),
                },
                ['<localleader>b'] = {
                    action = function() return vim.cmd('ObsidianBacklinks') end,
                    opts = opts("Obsidian: get list of backlinks"),
                },
                ['<localleader>l'] = {
                    action = function() return vim.cmd('ObsidianLinks') end,
                    opts = opts("Obsidian: get list of (forward) links in file"),
                },
                ['<localleader>g'] = {
                    action = function() return vim.cmd('ObsidianTags') end,
                    opts = opts("Obsidian: get list of occurrences of current tag"),
                },
                ['<localleader>t'] = {
                    action = function() return vim.cmd('ObsidianTemplate') end,
                    opts = opts("Obsidian: insert template"),
                },
                ['<localleader>s'] = {
                    action = function() return vim.cmd('ObsidianSearch') end,
                    opts = opts("Obsidian: search"),
                },
                ['<localleader>i'] = {
                    action = function() return vim.cmd('ObsidianPasteImg') end,
                    opts = opts("Obsidian: paste image"),
                },
                ['<localleader>c'] = {
                    action = function() return vim.cmd('ObsidianTOC') end,
                    opts = opts("Obsidian: get table of contents"),
                },
            },

            -- settings -------------------------------------------------------

            workspaces = my_vaults,

            completion = {
                -- Trigger completion immediately
                min_chars = 0,
            },

            -- enable if you use the advanced-uri plugin in the Obsidian app
            use_advanced_uri = true,

            -- do not prepend note id or path to wikilinks
            wiki_link_func = "use_alias_only",

            -- do not handle frontmatter (I'm not using it at the moment)
            disable_frontmatter = true,

            -- Specify how to handle attachments.
            attachments = {
                -- The default folder to place images in via `:ObsidianPasteImg`.
                -- If this is a relative path it will be interpreted as relative to the vault root.
                img_folder = "@new_attachments/",

                -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
                ---@return string
                img_name_func = function()
                    -- Prefix image names with timestamp.
                    return string.format("%s-", os.time())
                end,
            },

        })
    end,

    init = function()

        -- set conceallevel to 2. This will also be set by the render-markdown
        -- plugin, but that happens too late and an UI warning is triggered by
        -- obsidian.nvim
        vim.api.nvim_create_autocmd('BufEnter', {
            callback = function(opts)
                if vim.bo[opts.buf].filetype == 'markdown' then
                    vim.opt.conceallevel = 2
                end
            end,
        })

        -- load Obsidian if CWD is changed to a vault directory
        vim.api.nvim_create_autocmd('DirChanged', {
            callback = function()
                local vault = nil
                for _, v in ipairs(my_vaults) do
                    if type(v.path) == string then
                        ---@diagnostic disable-next-line: param-type-mismatch
                        if vim.v.event.cwd == vim.fn.fnamemodify(v.path, ':p:h') then
                            vault = v
                            break
                        end
                    end
                end
                if vault then
                    vim.g.obsidian_current_vault_spec = vault
                    vim.notify("Entered Obsidian Vault")
                    vim.api.nvim_exec_autocmds("User", { pattern = "EnteredObsidianVault" })
                    vim.api.nvim_exec_autocmds("User", { pattern = "EnteredObsidianVaultAfterLoad" })
                end
            end
        })

        -- autocmd executed after the DirChanged autocmd above is triggered
        -- EnteredObsidianVault, which loads Obsidian.nvim
        vim.api.nvim_create_autocmd('User', {
            pattern = "EnteredObsidianVaultAfterLoad",
            callback = function()
                if require("utils").tab_is_empty(0) then
                    if vim.g.obsidian_current_vault_spec.index then
                        -- if the vault setting table contains an "index" file open it
                        vim.cmd.edit(vim.g.obsidian_current_vault_spec.index)
                        -- set filetype markdown, as it is not set automatically
                        vim.bo.filetype = 'markdown'
                    end
                end
            end
        })

    end

}
