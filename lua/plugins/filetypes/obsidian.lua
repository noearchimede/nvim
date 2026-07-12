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

        local function follow_closest_link()
            local line = vim.api.nvim_get_current_line()
            unpack = table.unpack or unpack -- 5.1 compatibility
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            col = col + 1 -- make 1-based
            local closest, dist
            for _, pattern in ipairs({ "%b[]%b()", "%[%[[^%]]+%]%]", "https?://%S+" }) do
                for open, close in line:gmatch("()" .. pattern .. "()") do
                    close = close - 1
                    local d = math.min(math.abs(col - open), math.abs(col - close))

                    if not dist or d < dist then
                        closest, dist = open, d
                    end
                end
            end
            if closest then
                vim.api.nvim_win_set_cursor(0, { row, closest - 1 })
                vim.cmd("Obsidian follow_link")
            end
        end

        -- helpers for other mappings
        local obsidian = require('obsidian')
        local function opts(desc)
            return { buffer = true, desc = desc }
        end

        vim.api.nvim_create_autocmd("User", {
            pattern = "ObsidianNoteEnter",
            callback = function(ev)
                vim.keymap.set("n", "gf",
                    function() return obsidian.util.gf_passthrough() end,
                    { buffer = true, desc = "Obsidian: default gf + resolve links", noremap = false }
                )
                vim.keymap.set("n", "<cr>",
                    function() return obsidian.util.smart_action() end,
                    { buffer = true, desc = "Obsidian: smart action", expr = true }
                )
                vim.keymap.set("n", "<localleader>a",
                    function() return vim.cmd('Obsidian open') end,
                    opts("Obsidian: open in app")
                )
                vim.keymap.set("n", "<localleader>n",
                    function() return vim.cmd('Obsidian new') end,
                    opts("Obsidian: new note")
                )
                vim.keymap.set("n", "<localleader>o",
                    function() return vim.cmd('Obsidian quick_switch') end,
                    opts("Obsidian: switch to or open note")
                )
                vim.keymap.set("n", "<localleader>f",
                    follow_closest_link,
                    opts("Obsidian: follow closest link")
                )
                vim.keymap.set("n", "<localleader>b",
                    function() return vim.cmd('Obsidian backlinks') end,
                    opts("Obsidian: get list of backlinks")
                )
                vim.keymap.set("n", "<localleader>l",
                    function() return vim.cmd('Obsidian links') end,
                    opts("Obsidian: get list of (forward) links in file")
                )
                vim.keymap.set("n", "<localleader>g",
                    function() return vim.cmd('Obsidian tags') end,
                    opts("Obsidian: get list of occurrences of current tag")
                )
                vim.keymap.set("n", "<localleader>t",
                    function() return vim.cmd('Obsidian template') end,
                    opts("Obsidian: insert template")
                )
                vim.keymap.set("n", "<localleader>s",
                    function() return vim.cmd('Obsidian search') end,
                    opts("Obsidian: search")
                )
                vim.keymap.set("n", "<localleader>i",
                    function() return vim.cmd('Obsidian paste_img') end,
                    opts("Obsidian: paste image")
                )
                vim.keymap.set("n", "<localleader>c",
                    function() return vim.cmd('Obsidian toc') end,
                    opts("Obsidian: get table of contents")
                )
            end
        })

        obsidian.setup({

            legacy_commands = false,

            workspaces = my_vaults,

            completion = {
                -- Trigger completion immediately
                min_chars = 0,
            },

            open = {
                -- enable if you use the advanced-uri plugin in the Obsidian app
                use_advanced_uri = true,
            },

            -- do not prepend note id or path to wikilinks
            link = {
                style = "wiki",
                wiki = {
                    use_alias_only = true,
                },
            },

            -- do not handle frontmatter (I'm not using it at the moment)
            frontmatter = {
                enabled = false,
            },

            -- Specify how to handle attachments.
            attachments = {
                -- The default folder to place images in via `:ObsidianPasteImg`.
                -- If this is a relative path it will be interpreted as relative to the vault root.
                folder = "@new_attachments/",

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
