local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local table_command = require("cheatsheet.table_commands")

local M = {}

-- Take Input
function M.read_command_input(command_type)
    local msg = ''
    if command_type == 'add' then
        msg = "Enter Command >"
    elseif command_type == 'delete' then
        msg = "Delete Command Number >"
    else
        print('Not a valid command')
    end

    -- nui function here
    local input = Input({
        position = "50%",
        size = {
            width = 30,
        },
        border = {
            style = "single",
            text = {
                top = msg,
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
    }, {
        prompt = "> ",
        -- default_value = greeting,
        on_close = function()
            print("Input Closed!")
        end,
        on_submit = function(value)
            -- Replaces command_add
            local note_to_add = value .. "\n"

            -- Set checks here
            if note_to_add == '\n'
            then
                print("Not a command")
            elseif command_type == 'add' then
                -- Finally add to table
                table_command.write_table(note_to_add)
                print("Command added to cheat sheet: " .. value)
            elseif command_type == 'delete' then
                table_command.delete_from_table(value)
            end
        end,
    })
    -- make
    input:mount()
    -- unmount component when cursor leaves buffer
    input:on(event.BufLeave, function()
        input:unmount()
    end)
end


return M
