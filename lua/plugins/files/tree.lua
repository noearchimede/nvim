return {

    "nvim-tree/nvim-tree.lua",

    dependencies = {

        -- icons
        "nvim-tree/nvim-web-devicons",

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

        -- NOTE: this is a hack to avoid the problem of the rhs vertical split
        -- being made narrower than necessary when the tree is opened. If
        -- 'preserve_window_proportions' worked as expected the second command
        -- would not be necesssary.
        { "<leader>tt", "<cmd>NvimTreeOpen<cr><cmd>horizontal wincmd =<cr>" },

        { "<leader>tc", "<cmd>NvimTreeClose<cr>" },
        { "<leader>tf", "<cmd>NvimTreeFindFile<cr>" },
        { "<leader>tF", "<cmd>NvimTreeFindFile!<cr>" },

    },

    cmd = {
        'NvimTreeOpen',
        'NvimTreeFocus',
        'NvimTreeFindFile',
        'NvimTreeToggle',
        'NvimTreeFindFileToggle',
    },

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
                -- if oil is not found do nothing
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

            -- Currently unused letters:
            -- lowercase: a (j and k are used as main motions, s is used for Leap.nvim)
            -- uppercase: A G P Q T U V X Y Z

            -- open nodes
            map('<CR>', function(node)
                api.node.open.edit(node); api.tree.focus()
            end, 'Open file (keep focus)') -- 'O'
            map('o', api.node.open.edit, 'Open') -- '<CR>' and 'o'
            map('<Tab>', api.node.open.preview, 'Open: preview') -- '<Tab>'
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
            map('O', api.node.run.system, 'Run system') -- 's'
            map('g?', api.tree.toggle_help, 'Help') -- 'g?'


            -- Configuration of the float file preview extension
            local preview = require('nvim-tree-preview')

            map('<Tab>', function()
                local ok, node = pcall(api.tree.get_node_under_cursor)
                if ok and preview.is_watching() then
                    preview.node(node, { toggle_focus = true })
                else
                    preview.watch()
                end
            end, 'Preview: watch')
            map('<Esc>', preview.unwatch, 'Preview: close')
        end,

        hijack_cursor = true, -- keep the cursor on the first letter of the filename
        disable_netrw = false, -- see :h nvim-tree-netrw
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
            -- There are issues with this setting both enabled and disabled.
            -- Problem when enabled: open two vertical splits of same width, open tree -> the rhs one will become way too narrow
            -- Problem when disabled: open two unequally sized vertical splits, open tree, make a diagnostic error appear in one buffer -> the buffer sizes will equalize
            width = {
                min = 20,
                max = 40,
                padding = 1,
            },
        },
        renderer = {
            group_empty = false,
            full_name = false,
            indent_width = 2,
            special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
            symlink_destination = false,
            highlight_git = "none",
            highlight_diagnostics = "none",
            highlight_opened_files = "none",
            highlight_modified = "none",
            highlight_bookmarks = "none",
            highlight_clipboard = "name",
            icons = {
                web_devicons = {
                    file = { enable = false, },
                    folder = { enable = false, },
                },
                git_placement = "after",
                modified_placement = "before",
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
        system_open = {
            cmd = "",
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
            use_system_clipboard = true,
            change_dir = {
                enable = true,
                global = false,
                restrict_above_cwd = false,
            },
            open_file = {
                resize_window = true,
                window_picker = {
                    enable = true,
                    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                },
            },
        },
        trash = {
            cmd = "trash",
        },
    }

}
