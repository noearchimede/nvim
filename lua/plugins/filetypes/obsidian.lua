return {

    "obsidian-nvim/obsidian.nvim",

    -- load obsidian.nvim on any markdown file, but the plugin will only work
    -- inside the 'workspaces' defined in the options below
    ft = "markdown",

    event = { "User EnteredObsidianVault" },

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
            callback = function(_)
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
                    -- attempt to open index file (any file with one of the following keywords in its name)
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
                    -- trigger custom event that loads Obsidian.nvim (there isn't any associated autocmd)
                    vim.api.nvim_exec_autocmds("User", { pattern = "EnteredObsidianVault" })
                end
            end
        })

    end

}
