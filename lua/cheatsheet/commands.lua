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
            table_control.display_table()
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
        -- rename this
        name = "CScf",
        opts = {
            desc = "cheatsheet: change file",
            bar = true,
        },
        command = function()
            table_control.change_file()
        end
    },


}

function M.setup()
    for _, cmd in ipairs(CMDS) do
        local opts = vim.tbl_extend("force", cmd.opts, { force = true })
        vim.api.nvim_create_user_command(cmd.name, cmd.command, opts)
    end
end

return M
