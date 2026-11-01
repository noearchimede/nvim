return {

    "obsidian-nvim/obsidian.nvim",

    -- load obsidian.nvim on any markdown file, but the plugin will only work
    -- inside the 'workspaces' defined in the options below
    ft = "markdown",

    cmd = { "Obsidian", "ConfigObsidianSetupVault" },

    opts = {

        legacy_commands = false,

        workspaces = {
            {
                name = "auto",
                path = function()
                    local root = vim.fs.root(0, '.obsidian')
                    return root
                end
            }
        },

        completion = {
            -- Trigger completion immediately
            min_chars = 0,
        },

        open = {
            -- enable if you use the advanced-uri plugin in the Obsidian app
            use_advanced_uri = true,
        },

        -- do not handle frontmatter (I'm not using it at the moment)
        frontmatter = {
            enabled = false,
        },

        -- Specify how to handle attachments.
        attachments = {
            -- The default folder to place images in via `:ObsidianPasteImg`, relative to the vault root
            folder = "@new_attachments/",
            img_name_func = function()
                -- Prefix image names with timestamp.
                return string.format("%s-", os.time())
            end,
        },

    },

    config = function(_, opts)

        require('obsidian').setup(opts)

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

        local function open_index()
            local root = vim.fs.root(vim.fn.getcwd(), '.obsidian')
            if not root then return end
            local index_file_keywords = { "index", "indice" }
            for name, type in vim.fs.dir(root) do
                if type == "file" then
                    for _, pattern in ipairs(index_file_keywords) do
                        if name:lower():find(pattern, 1, true) then
                            vim.cmd.edit(vim.fs.joinpath(root, name))
                            vim.bo.filetype = 'markdown'
                        end
                    end
                end
            end
        end

        vim.api.nvim_create_user_command("ConfigObsidianSetupVault", function()
            -- set workspace explicitly to load Obsidian if not already loaded and ensure the state is set correctly
            vim.cmd('Obsidian workspace auto')
            -- attempt to open index file
            open_index()
            -- this appears to be necessary to ensure the obsidian lsp is attached
            vim.schedule(function() vim.cmd('edit') end)
        end, {})

        vim.api.nvim_create_autocmd("User", {
            pattern = "ObsidianNoteEnter",
            callback = function(_)
                print("done")
                local function map(key, callback, desc)
                    vim.keymap.set("n", key, callback, { buffer = true, desc = desc })
                end
                local obsidian = require('obsidian')
                map("gf", function() obsidian.util.gf_passthrough() end, "Obsidian: default gf + resolve links")
                map("<cr>", function() obsidian.util.smart_action() end, "Obsidian: smart action")
                map("<localleader>a", function() vim.cmd('Obsidian open') end, "Obsidian: open in app")
                map("<localleader>n", function() vim.cmd('Obsidian new') end, "Obsidian: new note")
                map("<localleader>o", function() vim.cmd('Obsidian quick_switch') end, "Obsidian: switch to or open note")
                map("<localleader>f", function() follow_closest_link() end, "Obsidian: follow closest link")
                map("<localleader>b", function() vim.cmd('Obsidian backlinks') end, "Obsidian: get list of backlinks")
                map("<localleader>l", function() vim.cmd('Obsidian links') end, "Obsidian: get list of (forward) links in file")
                map("<localleader>g", function() vim.cmd('Obsidian tags') end, "Obsidian: get list of occurrences of current tag")
                map("<localleader>t", function() vim.cmd('Obsidian template') end, "Obsidian: insert template")
                map("<localleader>s", function() vim.cmd('Obsidian search') end, "Obsidian: search")
                map("<localleader>i", function() vim.cmd('Obsidian paste_img') end, "Obsidian: paste image")
                map("<localleader>c", function() vim.cmd('Obsidian toc') end, "Obsidian: get table of contents")
                map("<localleader>h", function() open_index() end, "Obsidian: get table of contents")
            end
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
                local root = vim.fs.root(vim.fn.getcwd(), '.obsidian')
                if root then
                    vim.notify("Entered Obsidian Vault")
                    vim.cmd("ConfigObsidianSetupVault")
                end
            end
        })

    end

}
