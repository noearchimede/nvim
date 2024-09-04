return {

    's1n7ax/nvim-window-picker',

    name = 'window-picker',

    event = 'VeryLazy',

    version = '2.*',

    config = {
        -- 'statusline-winbar' | 'floating-big-letter'
        hint = 'floating-big-letter',
        selection_chars = 'FJDKSLAGHTZRUEIWOQPVBCNXMY',
        show_prompt = true,
        filter_rules = {
            -- when there is only one window available to pick from, use it without prompting
            autoselect_one = true,
            include_current_win = true,
            -- filter using buffer options
            bo = {
                filetype = {
                    'NvimTree',
                    'trouble',
                    'aerial',
                    'fidget',
                    'undotree',
                    'qf',
                },
                buftype = {
                    'terminal',
                },
            },
            -- filter using window options
            wo = {},
        },
    },
}
