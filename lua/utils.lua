local M = {}


--- Replace a piece of text in the current file
--
-- This function can only operate on a single-line piece of text
function M.replace_in_file(text, whole_word)

    -- verify that 'text' is a valid single-line piece of text
    if type(text) == nil then
        vim.fn.confirm("No text selected")
        return
    end
    if string.find(text, '\n') ~= nil then
        vim.fn.confirm("This function can't operate on multi-line strings")
        return
    end

    -- if the whole_word option is true add the word delimiter sequences
    local word_pre = whole_word and '\\<' or ''
    local word_post = whole_word and '\\>' or ''

    -- select a separator (arbitrary; if the separator appears in the string it is escaped)
    local sep = '@'
    -- save cursor position to restore it at the end
    local view = vim.fn.winsaveview()

    -- build the search command
    local search_string = '\\V' .. word_pre .. vim.fn.escape(text, sep .. '\\') .. word_post
    print(":%s" .. sep .. search_string .. sep .. "___" .. sep .. "gc")
    -- ask the user for the replacement text
    local repl_text = vim.fn.input("Replace all occurrences of \"" .. text .. "\" in this file with: ", text)
        -- execute the replacement
    if repl_text ~= "" then
        local replace_string = vim.fn.escape(repl_text, sep .. '\\')
        local replace_command = ":%s" .. sep .. search_string .. sep .. replace_string .. sep .. "gc"
        vim.cmd(replace_command)
    end
    vim.fn.winrestview(view)

end



--- Get the text contained in the current (or latest) visual selection
--
-- Adapted from https://github.com/neovim/neovim/pull/21115#issuecomment-1320900205
function M.get_visual_selection()

    -- exit visual mode
    -- It doesn't actually seem to leave visual mode, but if this line is
    -- removed the function returns the previous visual selection ('< and '>
    -- seem to be only updated after visual is left, though I haven't found
    -- information about this in the documentation)
    vim.cmd.normal(vim.api.nvim_replace_termcodes('<esc>', true, true, true))
    -- get start and end of visual selection
    local _, ls, cs, _ = unpack(vim.fn.getpos("'<"))
    local _, le, ce, _ = unpack(vim.fn.getpos("'>"))
    -- get text
    local text_array = vim.api.nvim_buf_get_text(0, ls-1, cs-1, le-1, ce, {})
    -- concatenate lines
    return table.concat(text_array, '\n')

end


return M
