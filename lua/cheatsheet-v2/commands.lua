local input_control = require("cheatsheet-v2.input_commands")
local cheat_sheet_table = require("cheatsheet-v2.display_commands")
local todo_table = require("cheatsheet-v2.todo_display")

local M = {}


local CMDS = {
    {
        name = "CheatSheetToggle",
        opts = {
            desc = "cheatsheet: open",
            bar = true,
        },
        command = function()
            -- add the check for if the file exists here possibly
            -- table_control.display_table('none')
            cheat_sheet_table.display_cheat_sheet()
        end,
    },
    {
        name = "CheatSheetAdd",
        opts = {
            desc = "cheatsheet: add",
            bar = true,
        },
        command = function()
            input_control.add_command()
        end,
    },
    {
        name = "CheatSheetDelete",
        opts = {
            desc = "cheatsheet: delete",
            bar = true,
        },
        command = function()
            input_control.delete_command()
        end
    },
    {
        name = "ReadTodo",
        opts = {
            desc = "Display todo list",
            bar = true,
        },
        command = function()
            -- add the check for if the file exists here possibly
            print("REading todo")
            -- table_control.display_table('todo')
            todo_table.toggle_todo_display()
        end,
    },

}

function M.setup()
    for _, cmd in ipairs(CMDS) do
        local opts = vim.tbl_extend("force", cmd.opts, { force = true })
        vim.api.nvim_create_user_command(cmd.name, cmd.command, opts)
    end
end

return M
