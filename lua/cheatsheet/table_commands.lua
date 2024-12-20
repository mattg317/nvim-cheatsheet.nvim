local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
-- local contents = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/cheat-sheet.txt"
-- local contents = "/users/mgiordanella/Main/10_Coding/10_Nvim/key_cheatsheet.nvim/lua/nui_cheatsheet_2/files/cheat-sheet.txt"
local contents = vim.fn.stdpath('data') .. "/nvim-cheatsheet/cheatsheet.txt"

local M = {}

function M.create_cheatsheet_file(content_file)
    print("The cheatsheet file does not exist.")
    local create_sheet = vim.fn.input("Would you like to create one? [y/n]")
    if create_sheet == 'y'
    then
        print("\nCreateing new file in " .. content_file)
        local file, err = io.open(content_file, 'w')
        if file == nil then print("Error creating file: " .. err) else file:close() end
    else
        print("\nQuitting")
    end
end

function M.read_table()
    local table_c = {}
    local file, err = io.open(contents, "r")
    if file == nil then
        print("Couldn't open file: " .. err)
        M.create_cheatsheet_file(contents)
    else
        for line in file:lines() do
            table.insert(table_c, line)
        end
        file:close()
    end
    return table_c
end


function M.table_length(table_c)
    local count = 0
    for _ in pairs(table_c)
    do
        count = count + 1
    end
    return count
end

function M.save_table(new_table)
    local file, err = io.open(contents, "w")
    if file == nil then
        print("Couldn't open file: " .. err)
    else
        for num, item in ipairs(new_table) do
            if num == #new_table then
                file:write(item)
            else
                file:write(item .. "\n")
            end
        end
        file:close()
    end
end

--- Display Table
function M.display_table()
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
    local display_table = {}
    for num, item in ipairs(M.read_table()) do
        local cheat_cmd = num .. " - " .. item
        table.insert(display_table, cheat_cmd)
    end
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, display_table)

    local ok = popup:map("n", "q", function(bufnr)
        popup:unmount()
    end, { noremap = true })
end

-- Write Table
function M.write_table(note_to_add)
    local main_table = M.read_table()
    table.insert(main_table, note_to_add)
    M.save_table(main_table)
end

function M.delete_from_table(num_to_delete)
    local main_table = M.read_table()
    local table_length = M.table_length(main_table)
    if tonumber(num_to_delete) > 0 and tonumber(num_to_delete) <= table_length then
        print("Deleting command > " .. main_table[num_to_delete])
        table.remove(main_table, num_to_delete)
        M.save_table(main_table)
    else
        print("Not a Valid Number")
    end
end

-- M.display_table()
return M
