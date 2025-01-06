local M = {}

M.rpad = function(text, length)
    if not length then
        return text
    end
    local textlen = vim.api.nvim_strwidth(text)
    local delta = length - textlen
    if delta > 0 then
        return text .. string.rep(" ", delta)
    else
        return text
    end
end

M.get_editor_height = function()
    local editor_height = vim.o.lines - vim.o.cmdheight
    -- Subtract 1 if tabline is visible
    if vim.o.showtabline == 2 or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1) then
        editor_height = editor_height - 1
    end
    -- Subtract 1 if statusline is visible
    if
        vim.o.laststatus >= 2 or (vim.o.laststatus == 1 and #vim.api.nvim_tabpage_list_wins(0) > 1)
    then
        editor_height = editor_height - 1
    end
    return editor_height
end

return M
