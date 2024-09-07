return {

    'numToStr/Comment.nvim',

    keys = {
        { "gcc", mode = "n", desc = "Comment: linewise on line" },
        { "gbc", mode = "n", desc = "Comment: blockwise on line" },

        { "gc", mode = "v", desc = "Comment: linewise" },
        { "gb", mode = "v", desc = "Comment: blockwise" },

        { "gcO", mode = "n", desc = "Comment: add comment above line" },
        { "gco", mode = "n", desc = "Comment: add comment below line" },
        { "gcA", mode = "n", desc = "Comment: add comment at end of line" },
    },

    opts = {
        padding = true, ---Add a space b/w comment and the line
        sticky = true, ---Whether the cursor should stay at its position
        ignore = nil, ---Lines to be ignored while (un)comment
        toggler = { ---LHS of toggle mappings in NORMAL mode
            line = 'gcc', ---Line-comment toggle keymap
            block = 'gbb', ---Block-comment toggle keymap
        },
        opleader = { ---LHS of operator-pending mappings in NORMAL and VISUAL mode
            line = 'gc', ---Line-comment keymap
            block = 'gb', ---Block-comment keymap
        },
        extra = { ---LHS of extra mappings
            above = 'gcO', ---Add comment on the line above
            below = 'gco', ---Add comment on the line below
            eol = 'gcA', ---Add comment at the end of line
        },
        pre_hook = nil, ---Function to call before (un)comment
        post_hook = nil, ---Function to call after (un)comment
    }
}
