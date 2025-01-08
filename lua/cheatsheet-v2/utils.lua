local M = {}
-- rpad and get_editor_height functions taken from Oil.nvim
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

function M.create_cheatsheet_file(contents_dir, content_file)
    local create_sheet = vim.fn.input("Would you like to create one? [y/n]")
    if create_sheet == 'y'
    then
        local contents_file = contents_dir .. content_file
        if vim.fn.isdirectory(contents_dir) == 0 then
            print("\n Createing directory in " .. contents_dir .. "\n")
            vim.fn.mkdir(contents_dir)
        end
        print("\nCreateing new file in " .. contents_file .. "\n")
        local file, err = io.open(contents_file, 'w')
        if file == nil then print("Error creating file: " .. err) else file:close() end
    else
        print("\nQuitting")
    end
end
return M
