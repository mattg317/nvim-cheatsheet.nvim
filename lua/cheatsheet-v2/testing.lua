local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local default_config = require("cheatsheet.config.display_table")
-- local file_dir = "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/cheat-sheet.txt"
local file_dir = "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/test-sheet.txt"

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

function M.read_table(read_file)
    -- TODO: i dont thin we need to change the content file, just use what we want concatenated
    local table_c = {}
    -- local file, err = io.open(M.config.contents_file, "r")
    local file, err = io.open(read_file, "r")
    if file == nil then
        print("Couldn't open file: " .. err)
    else
        for line in file:lines() do
            table.insert(table_c, line)
        end
        file:close()
    end
    return table_c
end

function M.display_table(read_file)
    local popup = Popup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = "CHEAT SHEET",
            }
        },
        position = "50%",
        size = {
            width = "40%",
            height = "40%",
        },
        win_options = {
            winhighlight = "Normal:MiniIconsPurple"
        }
    })
    -- mount/open the component
    popup:mount()

    -- unmount component when cursor leaves buffer
    popup:on(event.BufLeave, function()
        popup:unmount()
    end)
    -- set content
    local lines = {}
    local max_lhs = 1
    local highlights = {}
    for _, item in ipairs(M.read_table(read_file)) do
        local start = 1
        -- Split the text for command and desc
        -- local one, two = item:match("([^,]+)-([^,]+)")
        local one, two = item:match("([^,]+) ([^,]+)")

        -- Format spacing shoutout to how OIl.nvim did this
        max_lhs = math.max(max_lhs, vim.api.nvim_strwidth(one))
        local line = string.format(" %s  %s", M.rpad(one, max_lhs), two)
        table.insert(lines, line)

        -- Highlighting
        local keywidth = vim.api.nvim_strwidth(one)
        table.insert(highlights, { "Special", #lines, start, start + keywidth })
    end
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, lines)
    local ns = vim.api.nvim_create_namespace("CheatSheet")
    for _, hl in ipairs(highlights) do
        local hl_group, lnum, start_col, end_col = unpack(hl)
        vim.api.nvim_buf_set_extmark(popup.bufnr, ns, lnum - 1, start_col, {
            end_col = end_col,
            hl_group = hl_group,
        })
    end

    local ok = popup:map("n", "q", function(bufnr)
        popup:unmount()
    end, { noremap = true })
end

function M.test_display(read_file)
    local display_table = {}
    local lines = {}
    local max_lhs = 1
    local highlights = {}
    local max_line = 1
    for _, item in ipairs(M.read_table(read_file)) do
        local start = 1
        -- Split the text for command and desc
        local one, two = item:match("([^,]+)-([^,]+)")

        -- Format spacing shoutout to how OIl.nvim did this
        max_lhs = math.max(max_lhs, vim.api.nvim_strwidth(one))
        local line = string.format(" %s  %s", M.rpad(one, max_lhs), two)
        max_line = math.max(max_line, vim.api.nvim_strwidth(line))
        table.insert(lines, line)

        -- Highlighting
        local keywidth = vim.api.nvim_strwidth(one)
        table.insert(highlights, { "Special", #lines, start, start + keywidth })
        -- table.insert(display_table, line)
        -- local cheat_cmd =  item
        -- table.insert(display_table, cheat_cmd)
    end
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, lines)

    local ns = vim.api.nvim_create_namespace("CheatSheet")
    for _, hl in ipairs(highlights) do
        local hl_group, lnum, start_col, end_col = unpack(hl)
        vim.api.nvim_buf_set_extmark(bufnr, ns, lnum - 1, start_col, {
            end_col = end_col,
            hl_group = hl_group,
        })
    end

    -- buf specific keymaps
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = bufnr })
    vim.keymap.set("n", "<c-c>", "<cmd>close<CR>", { buffer = bufnr })
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].bufhidden = "wipe"
    local editor_width = vim.o.columns

    local editor_height = M.get_editor_height()
    local winid = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        row = math.max(0, (editor_height - #lines) / 2),
        col = math.max(0, (editor_width - max_line - 1) / 2),
        width = math.min(editor_width, max_line + 1),
        height = math.min(editor_height, #lines),
        zindex = 150,
        style = "minimal",
        border = "rounded",
    })
    local function close()
        if vim.api.nvim_win_is_valid(winid) then
            vim.api.nvim_win_close(winid, true)
        end
    end
    vim.api.nvim_create_autocmd("BufLeave", {
        callback = close,
        once = true,
        nested = true,
        buffer = bufnr,
    })
    vim.api.nvim_create_autocmd("WinLeave", {
        callback = close,
        once = true,
        nested = true,
    })
end

-- M.test_display(file_dir)
M.display_table(file_dir)


return M
