local table_control = require("cheatsheet.table_commands")
local input_control = require("cheatsheet.io_commands")

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
            table_control.display_table('none')
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
            table_control.display_table('todo')
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
