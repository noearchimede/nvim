return {

    "nvim-tree/nvim-tree.lua",

    dependencies = {

        -- icons
        "nvim-tree/nvim-web-devicons",

        -- nicer UI for input fields (optional, not even mentioned in readme!)
        "stevearc/dressing.nvim",

        -- nicer window picker
        "s1n7ax/nvim-window-picker",

        -- add support for file operations using built-in LSP support.
        {
            "antosha417/nvim-lsp-file-operations",
            config = true,
        },

        -- float file preview (configured in 'on_attach' alongside all nvim-tree options)
        {
            'b0o/nvim-tree-preview.lua',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },

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


    config = function(_, opts)

        require('nvim-tree').setup(opts)

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

    end,

    opts = {

        on_attach = function(bufnr)
            -- import api
            local api = require "nvim-tree.api"

            -- define mapping function with common options preset
            local function map(key, action, desc)
                vim.keymap.set('n', key, action,
                    { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true })
            end


            -- helper function for integration with Oil
            local function open_oil()
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
                    oil.open(path)
                else
                    -- otherwise open with netrw or any other default file explorer
                    vim.cmd(':e' .. path)
                end
            end

            -- helper function for integration with grug-far
            local function open_grug()
                local node = api.tree.get_node_under_cursor()
                local abspath = node.absolute_path
                local relpath = require("plenary.path"):new(abspath):make_relative(vim.fn.getcwd())
                local ok, grug = pcall(require, 'grug-far')
                if ok then
                    -- note: copied from my config for grug-far (in grug-far.lua)
                    vim.cmd('tabnew')
                    vim.opt_local.buflisted = false
                    vim.opt_local.buftype = "nofile"
                    vim.opt_local.bufhidden = "wipe"
                    vim.opt_local.swapfile = true
                    local winCmd = 'aboveleft vsplit'
                    winCmd = winCmd ..
                        ' | lua vim.api.nvim_win_set_width(0, math.floor(vim.api.nvim_win_get_width(0) * 4 / 3))'
                    -- launch grug-far
                    grug.grug_far({
                        prefills = { paths = relpath },
                        windowCreationCommand = winCmd
                    })
                end
                -- if grug-far is not found do nothing
            end

            -- helper function for "reveal in Finder"
            local function reveal_in_finder()
                local node = api.tree.get_node_under_cursor()
                local abspath = node.absolute_path
                vim.cmd('silent !open -R ' .. vim.fn.escape(abspath, ' \\'))
            end

            -- Currently unused letters:
            -- lowercase: <none> (j and k are used as main motions, s is used for Leap.nvim)
            -- uppercase: G O Q T U V X Y Z

            -- open nodes
            map('o', function(node)
                api.node.open.edit(node)
                api.tree.focus()
            end, 'Open file (keep focus)') -- 'O'
            map('<cr>', api.node.open.edit, 'Open') -- '<CR>' and 'o'
            map('t', api.node.open.tab, 'Open: new tab') -- '<C-t>'
            map('v', api.node.open.vertical, 'Open: vertical split') -- '<C-v>'
            map('h', api.node.open.horizontal, 'Open: horizontal split') -- '<C-x>' -- not using 's' as that is used by leap
            -- map('<C-e>', api.node.open.replace_tree_buffer, 'Open: in place') -- '<C-e>'
            map('<2-LeftMouse>', api.node.open.edit, 'Open') -- '<2-LeftMouse>'
            map('<2-RightMouse>', api.tree.change_root_to_node, 'CD') -- '<2-RightMouse>'

            -- integration with other plugins
            map('l', open_oil, 'Oil: open folder')
            map('z', open_grug, 'Grug-far: search here')

            -- create, delete and move nodes
            map('n', api.fs.create, 'Create file or directory') -- 'a'
            map('y', api.fs.copy.node, 'Copy') -- 'c'
            map('p', api.fs.paste, 'Paste') -- 'p'
            map('x', api.fs.cut, 'Cut') -- 'x'
            --map('d', api.fs.remove, 'Delete') -- 'd' -- do not use
            map('D', api.fs.trash, 'Trash') -- 'D'
            map('r', api.fs.rename, 'Rename') -- 'r'
            map('w', api.fs.rename_basename, 'Rename: only basename') -- 'e'
            map('d', api.fs.rename_sub, 'Rename: only directory') -- '<C-r>'
            map('e', api.fs.rename_full, 'Rename: full path') -- 'u'

            -- copy node info
            map('cy', api.fs.copy.filename, 'Copy name') -- 'y'
            map('cE', api.fs.copy.relative_path, 'Copy relative path') -- 'Y'
            map('ce', api.fs.copy.absolute_path, 'Copy absolute path') -- 'gy'
            map('cw', api.fs.copy.basename, 'Copy basename') -- 'ge'

            -- change directory: also update working directory for the current tab
            map('cd',
                function()
                    api.tree.change_root_to_node(); vim.cmd('tcd' .. vim.fn.fnameescape(vim.fn.getcwd()))
                end, 'CD') -- '<C-]>'
            map('cu',
                function()
                    api.tree.change_root_to_parent(); vim.cmd('tcd' .. vim.fn.fnameescape(vim.fn.getcwd()))
                end, 'Up') -- '-'
            map('..',
                function()
                    api.tree.change_root_to_parent(); vim.cmd('tcd' .. vim.fn.fnameescape(vim.fn.getcwd()))
                end, 'Up') -- '-'

            map('i', api.node.show_info_popup, 'Info') -- '<C-k>'
            map('E', api.tree.expand_all, 'Expand all') -- 'E'
            map('W', api.tree.collapse_all, 'Collapse') -- 'W'
            map('<BS>', api.node.navigate.parent_close, 'Close directory') -- '<BS>'
            map('u', api.node.navigate.parent, 'Parent directory') -- 'P'
            map('J', api.node.navigate.sibling.last, 'Last sibling') -- 'J'
            map('K', api.node.navigate.sibling.first, 'First sibling') -- 'K'
            map(':', api.node.run.cmd, 'Run command') -- '.'
            map('S', api.tree.search_node, 'Search') -- 'S'

            map('m', api.marks.toggle, 'Toggle bookmark') -- 'm'
            map('bd', api.marks.bulk.delete, 'Delete bookmarked') -- 'bd'
            map('bt', api.marks.bulk.trash, 'Trash bookmarked') -- 'bt'
            map('bm', api.marks.bulk.move, 'Move bookmarked') -- 'bmv'

            map('B', api.tree.toggle_no_buffer_filter, 'Toggle filter: no buffer') -- 'B'
            map('C', api.tree.toggle_git_clean_filter, 'Toggle filter: git clean') -- 'C'
            map('F', api.live_filter.clear, 'Live filter: clear') -- 'F'
            map('f', api.live_filter.start, 'Live filter: start') -- 'f'
            map('H', api.tree.toggle_hidden_filter, 'Toggle filter: dotfiles') -- 'H'
            map('I', api.tree.toggle_gitignore_filter, 'Toggle filter: git ignore') -- 'I'
            map('M', api.tree.toggle_no_bookmark_filter, 'Toggle filter: no bookmark') -- 'M'
            -- map('UUU', api.tree.toggle_custom_filter, 'Toggle filter: custom')      -- 'U'
            map('L', api.node.open.toggle_group_empty, 'Toggle group empty') -- 'L'

            map('[g', api.node.navigate.git.prev, 'Prev git') -- '[c'
            map(']g', api.node.navigate.git.next, 'Next git') -- ']c'
            map('[e', api.node.navigate.diagnostics.prev, 'Prev diagnostic') -- '[e'
            map(']e', api.node.navigate.diagnostics.next, 'Next diagnostic') -- ']e'

            map('q', api.tree.close, 'Close') -- 'q'
            map('R', api.tree.reload, 'Refresh') -- 'R'
            map('<C-R>', api.tree.reload, 'Refresh') -- 'R'
            map('A', api.node.run.system, 'Run system') -- 's'
            map('a', reveal_in_finder, 'Reveal in Finder') -- custom action, no default
            map('?', api.tree.toggle_help, 'Help') -- 'g?'
            map('g?', api.tree.toggle_help, 'Help') -- 'g?'


            -- Configuration of the float file preview extension
            local preview = require('nvim-tree-preview')
            -- helper function for "preview: toggle"
            map('P', function()
                if preview.is_watching() then
                    preview.unwatch()
                else
                    preview.watch()
                end
            end, 'Preview: toggle')
            -- tab: if no preview open node, if preview toggle focus between tree and preview
            map('<Tab>', function()
                if preview.is_watching() then
                    local node = api.tree.get_node_under_cursor()
                    preview.node(node, { toggle_focus = true })
                else
                    api.node.open.edit()
                end
            end, 'Open | Preview: focus')
            map('<Esc>', preview.unwatch, 'Preview: close')
        end,

        hijack_cursor = true, -- keep the cursor on the first letter of the filename
        disable_netrw = true, -- see :h nvim-tree-netrw
        hijack_netrw = true, -- see :h nvim-tree-netrw
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        sort = {
            sorter = "name",
            folders_first = true,
        },
        view = {
            cursorline = true,
            preserve_window_proportions = true,
            -- ^^^ There are issues with this setting both enabled and disabled.
            -- Problem when enabled: open two vertical splits of same width, open tree -> the rhs one will become way too narrow
            -- Problem when disabled: open two unequally sized vertical splits, open tree, make a diagnostic error appear in one buffer -> the buffer sizes will equalize
            width = {
                min = 15,
                max = 35,
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
                git_placement = "before",
                modified_placement = "after",
                diagnostics_placement = "signcolumn",
                bookmarks_placement = "signcolumn",
                padding = " ",
                symlink_arrow = " ➛ ",
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                    modified = true,
                    diagnostics = true,
                    bookmarks = true,
                },
                glyphs = {
                    default = "", -- "",
                    symlink = "", -- "",
                    bookmark = "󰆤", -- "󰆤",
                    modified = "●", -- "●",
                    folder = {
                        arrow_closed = "", -- "",
                        arrow_open = "", -- "",
                        default = "", -- "",
                        open = "", -- "",
                        empty = "", -- "",
                        empty_open = "", -- "",
                        symlink = "", -- "",
                        symlink_open = "", -- "",
                    },
                    git = {
                        unstaged = "✗",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                        ignored = "◌",
                    },
                },
            },
        },
        update_focused_file = {
            enable = false,
            update_root = {
                enable = false,
            },
        },
        git = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = false,
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = false,
            severity = {
                min = vim.diagnostic.severity.WARN,
                max = vim.diagnostic.severity.ERROR,
            },
        },
        modified = {
            enable = true,
            show_on_dirs = true,
            show_on_open_dirs = false,
        },
        filters = {
            enable = true,
            git_ignored = true,
            dotfiles = true,
        },
        live_filter = {
            prefix = "Filter: ",
            always_show_folders = false,
        },
        actions = {
            use_system_clipboard = false,
            change_dir = {
                enable = true,
                global = false,
                restrict_above_cwd = false,
            },
            open_file = {
                resize_window = true,
                window_picker = {
                    enable = true,
                    picker = function() return require('window-picker').pick_window() end,
                },
            },
        },
        trash = {
            cmd = "trash",
        },
    },

    init = function()
        -- disable netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end

}
