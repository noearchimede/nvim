return {

    "chentoast/marks.nvim",

    keys = { 'm' },

    opts = {

        -- whether movements cycle back to the beginning/end of buffer. default true
        cyclic = false,

        -- how often (in ms) to redraw signs/recompute mark positions. default 150.
        refresh_interval = 250,

        -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
        -- sign/virttext. Bookmarks can be used to group together positions and quickly move
        -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
        -- default virt_text is "".
        bookmark_0 = { sign = "" },
        bookmark_1 = { sign = "󰬺" }, -- 󰎤  󰲠
        bookmark_2 = { sign = "󰬻" }, -- 󰎧  󰲣
        bookmark_3 = { sign = "󰬼" }, -- 󰎪  󰔶
        bookmark_4 = { sign = "󰬽" }, -- 󰎭  󰝤
        bookmark_5 = { sign = "󰬾" }, -- 󰎱  󱅎
        bookmark_6 = { sign = "󰬿" }, -- 󰎳  󰋘
        bookmark_7 = { sign = "󰭀" }, -- 󰎶  󰎸
        bookmark_8 = { sign = "󰭁" }, -- 󰎹  󰭁
        bookmark_9 = { sign = "󰭂" }, -- 󰎼  󱂐

        -- define mappings explicitly (slightly different than default)
        default_mappings = true,
        mappings = {

            -- named marks (a-z, A-Z)

            set = 'm', -- Sets a letter mark (will wait for input).
            set_next = 'm,', -- Set next available lowercase mark at cursor.
            toggle = false, -- Toggle next available mark at cursor.

            delete = 'dm', -- Delete a letter mark (will wait for input).
            delete_line = 'dm-', -- Deletes all marks on current line.
            delete_buf = 'dm_', -- Deletes all marks in current buffer.

            next = 'm}', -- Goes to next mark in buffer.
            prev = 'm{', -- Goes to previous mark in buffer.

            preview = 'm:', -- Previews mark (will wait for user input). press <cr> to just preview the next mark.


            -- bookmarks

            set_bookmark0 = 'm0', -- Sets a bookmark from group[0-9].
            set_bookmark1 = 'm1',
            set_bookmark2 = 'm2',
            set_bookmark3 = 'm3',
            set_bookmark4 = 'm4',
            set_bookmark5 = 'm5',
            set_bookmark6 = 'm6',
            set_bookmark7 = 'm7',
            set_bookmark8 = 'm8',
            set_bookmark9 = 'm9',

            delete_bookmark = 'dm=', -- Deletes the bookmark under the cursor.

            delete_bookmark0 = 'dm0', -- Deletes all bookmarks from group[0-9].
            delete_bookmark1 = 'dm1',
            delete_bookmark2 = 'dm2',
            delete_bookmark3 = 'dm3',
            delete_bookmark4 = 'dm4',
            delete_bookmark5 = 'dm5',
            delete_bookmark6 = 'dm6',
            delete_bookmark7 = 'dm7',
            delete_bookmark8 = 'dm8',
            delete_bookmark9 = 'dm9',

            next_bookmark = 'm]]', -- Moves to the next bookmark having the same type as the bookmark under the cursor.
            prev_bookmark = 'm[[', -- Moves to the previous bookmark having the same type as the bookmark under the cursor.

            next_bookmark0 = 'm]0', -- Moves to the next bookmark of the same group type (by line number then buffer number)
            next_bookmark1 = 'm]1',
            next_bookmark2 = 'm]2',
            next_bookmark3 = 'm]3',
            next_bookmark4 = 'm]4',
            next_bookmark5 = 'm]5',
            next_bookmark6 = 'm]6',
            next_bookmark7 = 'm]7',
            next_bookmark8 = 'm]8',
            next_bookmark9 = 'm]9',

            prev_bookmark0 = 'm[0', -- Moves to the previous bookmark of the same group type (by line number then buffer number)
            prev_bookmark1 = 'm[1',
            prev_bookmark2 = 'm[2',
            prev_bookmark3 = 'm[3',
            prev_bookmark4 = 'm[4',
            prev_bookmark5 = 'm[5',
            prev_bookmark6 = 'm[6',
            prev_bookmark7 = 'm[7',
            prev_bookmark8 = 'm[8',
            prev_bookmark9 = 'm[9',

            annotate = 'm\\', -- Prompts the user for a virtual line annotation that is then placed above the bookmark.
        },

    },

    config = function(_, opts)
        
        require('marks').setup(opts)

        -- create aliases to the 'next bookmark' actions
        -- This is a hacky way to do it, but it appears that the mappings table in 'opts' can only accept one mapping per key
        vim.keymap.set({ 'n', 'v' }, "'0", "<plug>(Marks-next-bookmark0)")
        vim.keymap.set({ 'n', 'v' }, "'1", "<plug>(Marks-next-bookmark1)")
        vim.keymap.set({ 'n', 'v' }, "'2", "<plug>(Marks-next-bookmark2)")
        vim.keymap.set({ 'n', 'v' }, "'3", "<plug>(Marks-next-bookmark3)")
        vim.keymap.set({ 'n', 'v' }, "'4", "<plug>(Marks-next-bookmark4)")
        vim.keymap.set({ 'n', 'v' }, "'5", "<plug>(Marks-next-bookmark5)")
        vim.keymap.set({ 'n', 'v' }, "'6", "<plug>(Marks-next-bookmark6)")
        vim.keymap.set({ 'n', 'v' }, "'7", "<plug>(Marks-next-bookmark7)")
        vim.keymap.set({ 'n', 'v' }, "'8", "<plug>(Marks-next-bookmark8)")
        vim.keymap.set({ 'n', 'v' }, "'9", "<plug>(Marks-next-bookmark9)")
    end

}
