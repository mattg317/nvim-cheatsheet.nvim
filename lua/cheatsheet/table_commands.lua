local Popup = require("nui.popup")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event
local default_config = require("cheatsheet.config.display_table")

local M = {}
-- local config = {}

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", default_config, opts or {})

    M.config.contents_file = M.config.file_dir .. M.config.file_name
    local file, err = io.open(M.config.contents_file, "r")
    if file == nil then
        print("Couldn't open file: " .. err)
        M.create_cheatsheet_file(M.config.file_dir, M.config.file_name)
    end
end

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

function M.read_table()
    local table_c = {}
    local file, err = io.open(M.config.contents_file, "r")
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

function M.table_length(table_c)
    local count = 0
    for _ in pairs(table_c)
    do
        count = count + 1
    end
    return count
end

function M.save_table(new_table)
    local file, err = io.open(M.config.contents_file, "w")
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
--- TODO: opts can get passed in here
function M.display_table()
    local popup = Popup(M.config.display_table)

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

function M.change_file()
    local file_dir = vim.fn.stdpath('data') .. "/nvim-cheatsheet/"
    local dirs = vim.fs.dir(file_dir)
    local test_table = {}
    for value, _ in dirs do
        table.insert(test_table, Menu.item(value))
    end

    M.config.file_picker.menu_input.lines = test_table
    M.config.file_picker.menu_input.on_submit = function(item)
        -- Here is where I need to swtich the view
        local new_file = file_dir .. item.text
        M.config.contents_file = new_file
        print("Menu Submitted: ", item.text)
        print("You select the file in - " .. new_file)
    end
    local menu = Menu(M.config.file_picker.menu, M.config.file_picker.menu_input)
    -- local menu = Menu({

    -- mount the component
    menu:mount()
end

return M
