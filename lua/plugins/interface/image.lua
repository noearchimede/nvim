return {
    -- see the image.nvim readme for more information about configuring this plugin
    "3rd/image.nvim",

    opts = {
        backend = "kitty", -- Kitty's image protocol, available in Kitty, Ghostty, ...
        max_width = 100,
        max_height = 12,
        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
}
