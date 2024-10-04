-- Configuration for the Neovide GUI

if vim.g.neovide then

    vim.cmd('cd ~')

    -- NEOVIDE SETTINGS
    -- documentented on the official page: https://neovide.dev/configuration.html


    -- – mappings ––––––––––––––-–––––––––––––––––––––––––––––––––––––––––––––––––––––––––


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

    -- mappings to copy-paste from system clipboard with cmd-v and cmd-c
    vim.keymap.set('v', '<D-c>', '"+y') -- Copy
    vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
    vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
    vim.keymap.set('c', '<D-v>', '<C-r>+') -- Paste command mode
    vim.keymap.set('i', '<D-v>', '<C-r>+') -- Paste insert mode

    -- mapping to open a new Neovide instance. This is a workaround from
    -- [https://github.com/neovide/neovide/issues/2020#issuecomment-1714042856];
    -- use until the feature is implemented directly.
    vim.keymap.set("n", "<D-n>", ":silent exec '!neovide &'<cr>")


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

    -- set font (set in config.tomlile)
    -- vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h12:#e-antialias:#h-full"

    -- enable this to show a frametime graph in the upper left corner
    -- vim.g.neovide_profiler = true


    -- – modified nvim settings  –––––––––––––––––––––––––––––––––––––––––––––––––––––––––


    -- show the deleted lines in diffs as vertical lines, as the horizontal
    -- ones I use normally don't line up in neovide
    vim.opt.fillchars:append { diff = "│" }

end
