local file_commands = require('cheatsheet-v2.file_commands')
local utils = require("cheatsheet.utils")
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local default_config = require("cheatsheet-v2.config.default_config")

local M = {}

function M.create_cheatsheet_file(contents_dir, content_file)
    print("The cheatsheet file does not exist.")
    local create_sheet = vim.fn.input("Would you like to create one? [y/n]")
    if create_sheet == 'y'
    then
        local contents_file = contents_dir .. content_file
        if vim.fn.isdirectory(contents_dir) == 0 then
            print("\n Createing directory in " .. contents_dir)
            vim.fn.mkdir(contents_dir)
        end
        print("\nCreateing new file in " .. contents_file)
        local file, err = io.open(contents_file, 'w')
        if file == nil then print("Error creating file: " .. err) else file:close() end
    else
        print("\nQuitting")
    end
end
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", default_config, opts or {})
    M.config.contents_file = M.config.file_dir .. M.config.cheat_sheet_file
    local file, err = io.open(M.config.contents_file, "r")
    if file == nil then
        print("Couldn't open file: " .. err)
        M.create_cheatsheet_file(M.config.file_dir, M.config.file_name)
    end
end



function M.display_cheat_sheet()
    local popup = Popup(M.config.cheat_sheet)

    -- mount/open the component
    popup:mount()

    -- unmount component when cursor leaves buffer
    popup:on(event.BufLeave, function()
        popup:unmount()
    end)
    local lines = {}
    local max_lhs = 1
    local highlights = {}


    -- for _, item in ipairs(file_commands.read_table(M.config.file_path)) do
    for _, item in ipairs(file_commands.read_table(M.config.contents_file)) do
        local start = 1
        -- Split the text for command and desc
        -- local one, two = item:match("([^,]+)-([^,]+)")
        local one, two = item:match("(%S+)%s(.+)")
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

-- M.setup()
-- M.display_cheat_sheet()

return M
