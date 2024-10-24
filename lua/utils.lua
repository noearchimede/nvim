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
    ---@diagnostic disable-next-line: deprecated
    table.unpack = table.unpack or unpack -- 5.1 compatibility
    local _, ls, cs, _ = table.unpack(vim.fn.getpos("'<"))
    local _, le, ce, _ = table.unpack(vim.fn.getpos("'>"))
    -- get text
    local text_array = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
    -- concatenate lines
    return table.concat(text_array, '\n')

end



--- Check if the current tab is empty
---
--- An empty tab may contain special windows such as a NvimTree instance
--- @param tabpage integer tabpage handle, use 0 for current tab
function M.tab_is_empty(tabpage)

    -- iterate over all windows in tab
    local wins_in_tab = vim.api.nvim_tabpage_list_wins(tabpage)
    for _, winid in ipairs(wins_in_tab) do
        -- get filetype of each open buffer
        local ft = vim.api.nvim_get_option_value(
            'filetype',
            { buf = vim.api.nvim_win_get_buf(winid) }
        )
        -- compare filetype against a list of allowed types
        if not (ft == '' or ft == 'NvimTree' or ft == 'alpha') then
            -- if a "non-trivial" filetype is detected the tab is not empty
            return false
        end
    end
    -- if no window triggered the 'return false' condition the tab is empty
    return true

end


--- Run a 'vim.lsp.<...>' function and select the output window with a window picker
---
--- This function is intended to be used to create mappings
--- @param lsp_func function from the 'vim.lsp' module
function M.lsp_goto_with_picker(lsp_func)
    local ok, picker = pcall(require, "window-picker")
    if not ok then
        vim.notify("Unable to load the 'window-picker' module ('s1n7ax/nvim-window-picker' plugin not installed?)")
    end
    lsp_func({
        on_list = function(options)
            -- if there are multiple items, warn the user
            if #options.items > 1 then vim.notify("Multiple items found, opening first one", vim.log.levels.WARN) end
            -- get id of current window
            local win_origin = vim.api.nvim_get_current_win()
            -- create temporary horizontal and vertical splits as additional choices for the user
            local buf = vim.api.nvim_create_buf(true, true)
            vim.cmd('vsplit')
            vim.cmd('vert resize 5')
            local win_tmp_ver = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(win_tmp_ver, buf)
            vim.api.nvim_set_current_win(win_origin)
            vim.cmd('split')
            vim.cmd('resize 5')
            local win_tmp_hor = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(win_tmp_hor, buf)
            vim.api.nvim_set_current_win(win_origin)
            -- pick window
            local win_selected = picker.pick_window()
            -- close the temporary windows if not selected, otherwise resize
            if win_selected ~= win_tmp_hor then
                vim.api.nvim_win_close(win_tmp_hor, false)
            else
                local height = vim.api.nvim_win_get_height(win_origin)
                vim.api.nvim_win_set_height(win_tmp_hor, math.floor(height / 2))
            end
            if win_selected ~= win_tmp_ver then
                vim.api.nvim_win_close(win_tmp_ver, false)
            else
                local width = vim.api.nvim_win_get_width(win_origin)
                vim.api.nvim_win_set_width(win_tmp_ver, math.floor(width / 2))
            end
            -- focus the selected window and open the documentation there
            vim.api.nvim_set_current_win(win_selected)
            local item = options.items[1]
            vim.cmd("e +" .. item.lnum .. " " .. item.filename .. "|" .. "normal " .. item.col .. "|")
        end
    })
end


return M
