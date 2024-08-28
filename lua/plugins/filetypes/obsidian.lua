local my_vaults = {
    {
        -- keys required for the obsidian.nvim "workspaces" setting
        name = "personal",
        path = "~/Personale/Appunti",
        -- keys used in my custom functions
        index = "@Index.md"
    }
}

return {

    "epwalsh/obsidian.nvim",

    version = "*", -- recommended, use latest release instead of latest commit

    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",
    },

    -- load obsidian.nvim on any markdown file, but the plugin will only work
    -- inside the 'workspaces' defined in the options below
    ft = "markdown",

    event = "User EnteredObsidianVault",

    cmd = { "ObsidianQuickSwitch", "ObsidianNew" },

    opts = {

        workspaces = my_vaults,

        templates = {
            folder = "_templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
            -- A map for custom variables, the key should be the variable and the value a function
            substitutions = {},
        },

        completion = {
            -- Trigger completion immediately
            min_chars = 0,
        },

        mappings = {
            -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
            ["gf"] = {
                action = function() return require("obsidian").util.gf_passthrough() end,
                opts = { noremap = false, expr = true, buffer = true },
            },
            -- Toggle check-boxes: deleted default mapping; only define the more general <cr> below
            -- Smart action depending on context, either follow link or toggle checkbox.
            ["<cr>"] = {
                action = function() return require("obsidian").util.smart_action() end,
                opts = { buffer = true, expr = true },
            },
            ['<localleader>a'] = {
                action = function() return vim.cmd('ObsidianOpen') end,
                opts = { buffer = true, desc = "Obsidian: open in app" },
            },
            ['<localleader>n'] = {
                action = function() return vim.cmd('ObsidianNew') end,
                opts = { buffer = true, desc = "Obsidian: new note" },
            },
            ['<localleader>o'] = {
                action = function() return vim.cmd('ObsidianQuickSwitch') end,
                opts = { buffer = true, desc = "Obsidian: switch to or open note" },
            },
            ['<localleader>b'] = {
                action = function() return vim.cmd('ObsidianBacklinks') end,
                opts = { buffer = true, desc = "Obsidian: get list of backlinks" },
            },
            ['<localleader>l'] = {
                action = function() return vim.cmd('ObsidianLinks') end,
                opts = { buffer = true, desc = "Obsidian: get list of (forward) links in file" },
            },
            ['<localleader>g'] = {
                action = function() return vim.cmd('ObsidianTags') end,
                opts = { buffer = true, desc = "Obsidian: get list of occurrences of current tag" },
            },
            ['<localleader>t'] = {
                action = function() return vim.cmd('ObsidianTemplate') end,
                opts = { buffer = true, desc = "Obsidian: insert template" },
            },
            ['<localleader>s'] = {
                action = function() return vim.cmd('ObsidianSearch') end,
                opts = { buffer = true, desc = "Obsidian: search" },
            },
            ['<localleader>i'] = {
                action = function() return vim.cmd('ObsidianPasteImg') end,
                opts = { buffer = true, desc = "Obsidian: paste image" },
            },
            ['<localleader>c'] = {
                action = function() return vim.cmd('ObsidianTOC') end,
                opts = { buffer = true, desc = "Obsidian: get table of contents" },
            },
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

    },

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
                    if vim.v.event.cwd == vim.fn.fnamemodify(v.path, ':p:h') then
                        vault = v
                        break
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
