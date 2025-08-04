return {

    "nvim-tree/nvim-tree.lua",

    dependencies = {
        -- icons
        "nvim-tree/nvim-web-devicons",
        -- nicer window picker
        "s1n7ax/nvim-window-picker",
        -- add support for file operations using built-in LSP support.
        { "antosha417/nvim-lsp-file-operations", config = true, },
        -- float file preview (configured in 'on_attach' alongside all nvim-tree options)
        { 'b0o/nvim-tree-preview.lua', dependencies = { 'nvim-lua/plenary.nvim' } },

    },

    keys = {
        "<leader>tt",
        "<leader>tT",
        "<leader>tf",
        "<leader>tF",
    },

    cmd = {
        'NvimTreeOpen',
        'NvimTreeFocus',
        'NvimTreeToggle',
        'NvimTreeFindFile',
        'NvimTreeFindFileToggle',
    },


    config = function()

        local api = require('nvim-tree.api')

        -- Helper function to keep the window proportions then NvimTree is opened or closed
        local resize_wrapper = function(api_func)
            local wid_ui = vim.api.nvim_list_uis()[1].width
            local tot_wid_before = wid_ui
            if api.tree.is_visible() then
                tot_wid_before = tot_wid_before - vim.api.nvim_win_get_width(api.tree.winid())
            end
            local win_wids_before = {}
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
                if win ~= api.tree.winid() then -- api.tree.winid returns 'nil' if the tree is not visible
                    win_wids_before[win] = vim.api.nvim_win_get_width(win)
                end
            end
            api_func()
            local tot_wid_after = wid_ui
            if api.tree.is_visible() then
                tot_wid_after = tot_wid_after - vim.api.nvim_win_get_width(api.tree.winid())
            end
            if tot_wid_after ~= tot_wid_before then
                for win, win_wid_before in pairs(win_wids_before) do
                    local new_width = math.floor(win_wid_before / tot_wid_before * tot_wid_after + 0.5)
                    vim.api.nvim_win_set_width(win, new_width)
                end
            end
        end

        local on_attach_func = function(bufnr)

            -- import api for nvim-tree and dependencies
            local preview = require('nvim-tree-preview')

            -- define mapping functions used below
            local function map(key, action, desc)
                vim.keymap.set('n', key, action,
                    { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true })
            end
            local function unmap(key)
                vim.keymap.del('n', key, { buffer = bufnr })
            end

            -- helpers for custom mappings
            local function open_oil()
                -- open current node in oil.nvim
                local node = api.tree.get_node_under_cursor()
                local path = ''
                if node.type == 'directory' then
                    path = node.absolute_path
                else
                    path = node.parent.absolute_path
                end
                local ok, oil = pcall(require, 'oil')
                if ok then
                    -- if oil.nvim is installed, open with oil
                    local win_id = require('window-picker').pick_window()
                    if win_id ~= nil then
                        vim.api.nvim_set_current_win(win_id)
                        oil.open(path)
                    end
                else
                    -- otherwise open with netrw or any other default file explorer
                    vim.cmd(':e' .. path)
                end
            end
            local function open_grug()
                -- open a grug-far search
                local node = api.tree.get_node_under_cursor()
                local abspath = node.absolute_path
                local relpath = require("plenary.path"):new(abspath):make_relative(vim.fn.getcwd())
                local ok, grug = pcall(require, 'grug-far')
                if ok then
                    -- launch grug-far
                    grug.open({
                        windowCreationCommand = 'tab split',
                        openTargetWindow = { preferredLocation = 'right' },
                        prefills = { paths = relpath },
                    })
                else
                    vim.notify("grug-far not found")
                end
            end

            -- load default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- override quit to include custom 'resize_wrapper'
            map('q', function() resize_wrapper(api.tree.close) end, 'Close')
            -- help
            map('?', api.tree.toggle_help, 'Show help') -- by default S is 'search_node'
            -- open nodes
            map('o', function(node)
                api.node.open.edit(node)
                api.tree.focus()
            end, 'Open file (keep focus)')
            map('t', api.node.open.tab, 'Open: new tab') -- '<C-t>' also works (by default)
            map('v', api.node.open.vertical, 'Open: vertical split') -- '<C-v>' also works (by default)
            map('h', api.node.open.horizontal, 'Open: horizontal split') -- '<C-x>' also works (by default)
            -- delete nodes (change mapping)
            unmap('D') -- D is default, use d instead
            map('d', api.fs.trash, 'Delete')
            -- cd: include function to cd whole tab
            map('cd', function()
                api.tree.change_root_to_node()
                vim.cmd('tcd' .. vim.fn.fnameescape(vim.fn.getcwd())) -- note: sync_root_with_cwd must be true
            end, 'CD') -- '<C-]>'
            map('..', function()
                api.tree.change_root_to_parent()
                vim.cmd('tcd' .. vim.fn.fnameescape(vim.fn.getcwd())) -- note: sync_root_with_cwd must be true
            end, 'CD to root parent') -- same as default, but with addition of tcd
            -- open in Finder
            map('O', function()
                local node = api.tree.get_node_under_cursor()
                local abspath = node.absolute_path
                vim.cmd('silent !open -R ' .. vim.fn.escape(abspath, ' \\'))
            end, 'Reveal in Finder') -- by default s is 'run system'
            -- Oil
            map('-', open_oil, 'Oil: open folder')
            -- Grug-far
            map('s', open_grug, 'Grug-far: search here')
            -- Preview
            map('<Tab>', function()
                if preview.is_watching() then
                    local node = api.tree.get_node_under_cursor()
                    preview.node(node, { toggle_focus = true })
                else
                    preview.watch()
                end
            end, 'Preview: open/focus')
            map('<Esc>', preview.unwatch, 'Preview: close')
        end

        -- mappings defined using the helper above.
        -- I prefer this implementation over the default for
        -- 'preserve_window_proportions = true', which leads to the right hand
        -- side vertical split becoming too small and does not reset to the
        -- previous proportions after the tree is opened and closed, and
        -- 'preserve_window_proportions = false', which just equalizes all
        -- windows
        vim.keymap.set('n', '<leader>tt', function() resize_wrapper(api.tree.open) end)
        vim.keymap.set('n', '<leader>tT', function() resize_wrapper(api.tree.close) end)
        vim.keymap.set('n', '<leader>tf', function()
            resize_wrapper(function() api.tree.find_file({ open = true, focus = false }) end)
        end)
        vim.keymap.set('n', '<leader>tF', function()
            resize_wrapper(function() api.tree.find_file({ update_root = true, open = true, focus = false }) end)
        end)

        vim.keymap.set('n', '<leader>tj', function()
            resize_wrapper(function() api.tree.find_file({ open = true, focus = true }) end)
        end)
        vim.keymap.set('n', '<leader>tJ', function()
            resize_wrapper(function() api.tree.find_file({ update_root = true, open = true, focus = true }) end)
        end)

        require('nvim-tree').setup({

            on_attach = on_attach_func,

            hijack_cursor = true, -- keep the cursor on the first letter of the filename
            disable_netrw = true, -- see :h nvim-tree-netrw
            hijack_netrw = true, -- see :h nvim-tree-netrw
            sync_root_with_cwd = true,
            view = {
                preserve_window_proportions = true,
                -- ^^^ There are issues with this setting both enabled and disabled.
                -- Problem when enabled: open two vertical splits of same width, open tree -> the rhs one will become way too narrow
                -- Problem when disabled: open two unequally sized vertical splits, open tree, make a diagnostic error appear in one buffer -> the buffer sizes will equalize
                width = {
                    min = 15,
                    max = 30,
                    padding = 1,
                },
            },
            renderer = {
                special_files = { "README.md", "readme.md" },
                hidden_display = "simple",
                symlink_destination = false,
                icons = {
                    web_devicons = {
                        file = { enable = false, },
                        folder = { enable = false, },
                    },
                    glyphs = {
                        default = "", -- "",
                        symlink = "", -- "",
                        folder = {
                            default = "", -- "",
                            open = "", -- "",
                            empty = "", -- "",
                            empty_open = "", -- "",
                            symlink = "", -- "",
                            symlink_open = "", -- "",
                        },
                    },
                },
            },
            hijack_directories = {
                enable = false -- I'm using Oil.nvim for this
            },
            git = {
                enable = true
            },
            diagnostics = {
                enable = true,
                severity = {
                    min = vim.diagnostic.severity.WARN,
                },
            },
            modified = {
                enable = true,
            },
            actions = {
                use_system_clipboard = false,
                open_file = {
                    resize_window = true,
                    window_picker = {
                        enable = true,
                        -- pick_window returns 'nil' if no window has been picked, which causes nvim-tree
                        -- to not open the file (allowing to hit <esc> to cancel)
                        picker = function()
                            local win_id = require('window-picker').pick_window()
                            if win_id ~= nil then
                                return win_id
                            else
                                -- The picker returns nil in two cases:
                                -- 1. there are no windows that can be picked (based on the filter defined in picker config)
                                -- 2. the user cancelled
                                -- To differentiate those cases, run the picker filter manually on the windows in the
                                -- current tab (from https://github.com/s1n7ax/nvim-window-picker/issues/51)
                                local all_windows = vim.api.nvim_tabpage_list_wins(0)
                                local filter = require('window-picker.filters.default-window-filter'):new()
                                local fwindows = filter:filter_windows(all_windows)
                                if #fwindows == 0 then
                                    vim.cmd.vsplit()
                                    return vim.fn.win_getid()
                                else
                                    return nil
                                end
                            end
                        end
                    },
                },
                remove_file = {
                    close_window = true,
                },
            },
            trash = {
                cmd = "trash",
            },
        })

    end,

    init = function()
        -- disable netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end

}
