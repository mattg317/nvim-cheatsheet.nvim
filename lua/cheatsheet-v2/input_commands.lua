local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local file_command = require("cheatsheet-v2.file_commands")
local Menu = require("nui.menu")
local default_config = require("cheatsheet-v2.config.input_default_config")


local M = {}

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", default_config, opts or {})
    -- M.config.contents_file = M.config.file_dir .. M.config.cheat_sheet_file
end

---
---@param note_type string: type of note to format td for todo
---@param value any: the value passed in from the input
---@return string: formated note string
function M.format_note(note_type, value)
    local note_to_add = value .. "\n"
    M.config.contents_file = M.config.file_dir .. M.config.cheat_sheet_file
    if note_type == 'td' then
        -- Replaces command_add
        note_to_add = "- [ ] " .. note_to_add
        M.config.contents_file = M.config.file_dir .. M.config.todo_file
    end

    return note_to_add
end

---
---@param note_type string: type of note that is being add
function M.add_command(note_type)
    -- Set up submit function for input
    M.config.add_config.input_config_prompt.on_submit = function(value)
        -- format and select file here
        local note_to_add = M.format_note(note_type, value)

        -- Set checks here
        if note_to_add == '\n'
        then
            print("Not a command")
        else
            -- Finally add to table
            file_command.write_table(M.config.contents_file, note_to_add)
            print("Command added to cheat sheet: " .. value)
        end
    end

    local input = Input(
        M.config.add_config.input_config_style,
        M.config.add_config.input_config_prompt
    )
    -- make
    input:mount()
    -- unmount component when cursor leaves buffer
    input:on(event.BufLeave, function()
        input:unmount()
    end)
end

function M.delete_command()
    M.config.contents_file = M.config.file_dir .. M.config.cheat_sheet_file

    -- Pass the on_submit option into the delete config
    M.config.delete_config.menu_input.on_submit = function(item)
        local confirm_delete = vim.fn.input("Are you sure you want to delete note "
            .. item.text .. "? - y/n ")
        print("Menu Submitted: ", item.text)
        print("Menu id: ", item._id)
        if confirm_delete == 'y'
        then
            vim.cmd('redraw')
            file_command.delete_from_table(M.config.contents_file, item._id)
        else
            vim.cmd('redraw')
            print("Not deleting " .. item.text)
        end
    end

    local table_menu = function()
        local tm = file_command.read_table(M.config.contents_file)
        local test_table = {}
        for index, value in ipairs(tm) do
            local data = { id = index }
            table.insert(test_table, Menu.item(value, data))
        end
        return test_table
    end
    -- load lines parameter here and then add it
    M.config.delete_config.menu_input.lines = table_menu()

    local menu = Menu(M.config.delete_config.menu, M.config.delete_config.menu_input)

    -- mount the component
    menu:mount()
    local ok = menu:map("n", "q", function(bufnr)
        menu:unmount()
    end, { noremap = true })
end


return M
