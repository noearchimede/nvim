local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s, f, i, t, c = ls.s, ls.f, ls.i, ls.t, ls.c


M = {}

-- insert a box around the snippet text
table.insert(M,
    s({ trig = 'box' },
        fmt('┌─{line}─┐\n│ {text} │\n└─{line}─┘\n\n{exit}', {
            line = f(function(args)
                return string.rep("─", string.len(args[1][1]))
            end, {1}),
            text = i(1),
            exit = i(0),
        })
    )
)


-- insert an horizontal line as wide as 'tw' containing the snippet text
table.insert(M,
    s({ trig = '---' }, {
        f(function(args)
            local text = args[1][1]
            return text == '' and '–' or '– '
        end, {1}),
        i(1),
        f(function(args)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local tw = vim.opt.textwidth:get()
            local text = args[1][1]
            local reps = ( tw == 0 and 100 or tw) - col + (text ~= '' and 2 or 0)
            return (text == '' and '' or ' ') .. string.rep('–', reps)
        end, {1}),
        i(0)
    })
)


-- insert an horizontal line as wide as 'tw' above and below the snippet text
table.insert(M,
    s({ trig = '===' },
        fmt('{hline}\n{prefix}  {text}\n{prefix}{hline}\n', {
            prefix = f(function(_, parent)
                return string.gsub (parent.snippet.env.TM_CURRENT_LINE, parent.snippet.trigger .. '$', '')
            end),
            hline = f(function(args)
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local tw = vim.opt.textwidth:get()
                local text = args[1][1]
                local reps = ( tw == 0 and 100 or tw) - col + string.len(text)
                return string.rep('–', reps)
            end, {1}),
            text = i(1)
        })
    )
)


return M


