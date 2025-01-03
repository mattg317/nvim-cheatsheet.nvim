local file_commands = require('cheatsheet.file_commands')
local utils = require("cheatsheet.utils")
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local M = {}

M.config = {
    -- contents_file = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/cheat-sheet.txt",
    -- content_file_path = "",
    -- contents_file_name = vim.fn.stdpath('data') .. "/nvim-cheatsheet/cheatsheet.txt",
    -- file_dir = vim.fn.stdpath('data') .. "/nvim-cheatsheet/",
    file_name = "cheat-sheet.txt",
    todo_file = "todo-list.md",
    -- file_dir = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/",
    file_dir = "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/",
    file_path = "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/cheat-sheet.txt",
    file_todo = "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/todo-list.md",

    -- contents_file = true,
    cheat_sheet = {
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                -- top = "CHEAT SHEET",
                -- This would check changed for note type cheat sheet, todo, notes
                top = "CHEAT SHEET",
            }
        },
        position = "50%",
        size = {
            width = "40%",
            height = "40%",
        },
        -- win_options = {
        --     winhighlight = "Normal:MiniIconsPurple"
        -- }
    },

    todo_list = {
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = "TODO List",
            }
        },
        position = "50%",
        size = {
            width = "40%",
            height = "40%",
        },
        -- win_options = {
        --     winhighlight = "Normal:MiniIconsPurple"
        -- }
    }
}


function M.display_cheat_sheet(read_file)
    local popup = Popup(M.config.display_table)

    -- mount/open the component
    popup:mount()

    -- unmount component when cursor leaves buffer
    popup:on(event.BufLeave, function()
        popup:unmount()
    end)
    local lines = {}
    local max_lhs = 1
    local highlights = {}


    for _, item in ipairs(file_commands.read_table(read_file)) do
        local start = 1
        -- Split the text for command and desc
        local one, two = item:match("([^,]+)-([^,]+)")
        -- local one, two = item:match("([^,]+) ([^,]+)")

        -- Format spacing shoutout to how OIl.nvim did this
        max_lhs = math.max(max_lhs, vim.api.nvim_strwidth(one))
        local line = string.format(" %s  %s", utils.rpad(one, max_lhs), two)
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

function M.display_todo_list(read_file)

    local popup = Popup(M.config.display_table)

    -- mount/open the component
    popup:mount()

    -- unmount component when cursor leaves buffer
    popup:on(event.BufLeave, function()
        popup:unmount()
    end)
    -- set content
    local display_table = {}
    -- TODO: add argument to read table here as well
    for _, item in ipairs(file_commands.read_table(read_file)) do
        -- local cheat_cmd = num .. " - " .. item
        table.insert(display_table, item)
    end
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, display_table)

    local ok = popup:map("n", "q", function(bufnr)
        popup:unmount()
    end, { noremap = true })
end

-- M.display_cheat_sheet(M.config.file_path)
-- M.display_todo_list(M.config.file_todo)

return M
