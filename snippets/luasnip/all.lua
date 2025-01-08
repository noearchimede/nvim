local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s, f, i, t, c = ls.s, ls.f, ls.i, ls.t, ls.c

M = {}



---––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
---  Boxes
---––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


local function box_snip(h, v, tl, tr, bl, br)
    return fmt(tl .. h .. '{line}' .. h .. tr .. '\n' .. '{prefix}' .. v .. ' {text} ' .. v .. '\n' .. '{prefix}' .. bl .. h .. '{line}' .. h .. br .. '\n' .. '{exit}', {
            prefix = f(function(_, parent)
                return string.gsub(parent.snippet.env.TM_CURRENT_LINE, parent.snippet.trigger .. '$', '')
            end),
            line = f(function(args)
                return string.rep(h, string.len(args[1][1]))
            end, {1}),
            text = i(1),
            exit = i(0),
        })
end
table.insert(M, s({ trig = 'box'}, box_snip('─', '│', '┌', '┐', '└', '┘')))
table.insert(M, s({ trig = 'boxs'}, box_snip('-', '|', '+', '+', '+', '+')))
table.insert(M, s({ trig = 'box#'}, box_snip('#', '#', '#', '#', '#', '#')))



--–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
--  Horizontal lines
--–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


--– single line –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

-- insert an horizontal line as wide as 'tw' containing the snippet text
local function line_snip(line_char)
    return {
        f(function(args)
            local text = args[1][1]
            return text == '' and line_char or line_char .. ' '
        end, { 1 }),
        i(1),
        f(function(args)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local tw = vim.opt.textwidth:get()
            local text = args[1][1]
            local reps = (tw == 0 and 100 or tw) - col + (text ~= '' and 2 or 0)
            return (text == '' and '' or ' ') .. string.rep(line_char, reps)
        end, { 1 }),
        i(0)
    }
end
table.insert(M, s({ trig = '---' }, line_snip('-')))
table.insert(M, s({ trig = '--n' }, line_snip('–')))
table.insert(M, s({ trig = '--m' }, line_snip('—')))
table.insert(M, s({ trig = '###' }, line_snip('#')))


--– double line –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

-- insert an horizontal line as wide as 'tw' above and below the snippet text
local function line_above_below_snip(line_char)
    return fmt('{hline}\n{prefix}  {text}\n{prefix}{hline}\n', {
        prefix = f(function(_, parent)
            return string.gsub(parent.snippet.env.TM_CURRENT_LINE, parent.snippet.trigger .. '$', '')
        end),
        hline = f(function(args)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local tw = vim.opt.textwidth:get()
            local text = args[1][1]
            local reps = (tw == 0 and 100 or tw) - col + string.len(text)
            return string.rep(line_char, reps)
        end, { 1 }),
        text = i(1)
    })
end
table.insert(M, s({ trig = '---2' }, line_above_below_snip('-')))
table.insert(M, s({ trig = '--n2' }, line_above_below_snip('–')))
table.insert(M, s({ trig = '--m2' }, line_above_below_snip('—')))
table.insert(M, s({ trig = '###2' }, line_above_below_snip('#')))


return M


