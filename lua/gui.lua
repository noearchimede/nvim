-- Configuration for the Neovide GUI

if vim.g.neovide then

    vim.cmd.cd(vim.fn.expand("~"))

    -- NEOVIDE SETTINGS
    -- documentented on the official page: https://neovide.dev/configuration.html


    -- – mappings ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


    -- mappings to change font size
    vim.g.neovide_scale_factor = 1.0
    vim.keymap.set("n", "<D-+>", function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.05
    end)
    vim.keymap.set("n", "<D-=>", function()
        vim.g.neovide_scale_factor = 1.0
    end)
    vim.keymap.set("n", "<D-->", function()
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * (1 / 1.05)
    end)

    -- mappings to copy-paste from system clipboard
    if vim.fn.has("mac") == 1 then
        -- macos: cmd-v (in all modes) and cmd-c (in visual mode)
        vim.keymap.set('v', '<D-c>', '"+y')
        vim.keymap.set({ 'n', 'v' }, '<D-v>', '"+P')
        vim.keymap.set({ 't' }, '<D-v>', '<c-\\><c-n>"+Pi')
        vim.keymap.set('c', '<D-v>', '<C-r>+')
        vim.keymap.set('i', '<D-v>', '<esc>"+pa')
    else
        -- windows and linux: paste with ctrl-v in insert mode, ctrl-shift-v in normal mode
        -- (since in normal mode ctrl-v is visual block). Copy with ctrl-c (in visual only)
        vim.keymap.set('v', '<C-c>', '"+y')
        vim.keymap.set('v', '<C-v>', '"+P')
        vim.keymap.set('n', '<C-S-v>', '"+P')
        vim.keymap.set({ 't' }, '<C-S-v>', '<c-\\><c-n>"+Pi')
        vim.keymap.set('c', '<C-v>', '<C-r>+')
        vim.keymap.set('i', '<C-v>', '<esc>"+pa')
    end


    if vim.fn.has("mac") == 1 then
        -- mapping to open a new Neovide instance.
        vim.keymap.set("n", "<D-n>", function()
            vim.system(
                { "open", "--new", "-b", "com.neovide.neovide" },
                { cwd = vim.fn.expand('~'), detach = true }
            )
        end, { silent = true })
    end

    -- – neovide settings ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


    -- mouse settings
    vim.g.neovide_hide_mouse_when_typing = true

    -- float window shadow settings
    vim.g.neovide_floating_shadow = false

    -- blur settings
    vim.g.neovide_window_blurred = false
    vim.g.neovide_floating_blur_amount_x = 0
    vim.g.neovide_floating_blur_amount_y = 0

    -- window animation settings
    vim.g.neovide_position_animation_length = 0.2
    vim.g.neovide_scroll_animation_length = 0.1
    vim.g.neovide_scroll_animation_far_lines = 0

    -- disable cursor animations (cool but distracting)
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    -- disable cursor antialias to fix a small visual issue
    vim.g.neovide_cursor_antialiasing = true

    -- set font for Neovide (set in config.toml in the neovide config path)
    -- vim.opt.guifont = "JetBrainsMono Nerd Font:h12:#e-antialias:#h-full"

    -- enable this to show a frametime graph in the upper left corner
    -- vim.g.neovide_profiler = true


    -- – modified nvim settings  –––––––––––––––––––––––––––––––––––––––––––––––––––––––––


    -- show the deleted lines in diffs as vertical lines, as the horizontal
    -- ones I use normally don't line up in neovide
    vim.opt.fillchars:append { diff = "│" }

end
