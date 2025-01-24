return {

    "preservim/vim-pencil",

    cmd = {
        "Pencil"
    },
    
    init = function()

        -- use soft wrapping by default (autodetects in existing files)
        vim.g["pencil#wrapModeDefault"] = "soft"

        -- disable conceal (for markdown I have a dedicated plugin, for other filetypes it is not necessary)
        vim.g["pencil#conceallevel"] = 3     -- 0=disable, 1=one char, 2=hide char, 3=hide all (def)
        vim.g["pencil#concealcursor"] = 'c'  -- " n=normal, v=visual, i=insert, c=command (def)
    end

}
