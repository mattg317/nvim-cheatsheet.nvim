local commands = require "cheatsheet.commands"
local table_control = require("cheatsheet.table_commands")
local io_commands = require("cheatsheet.io_commands")

local M = {}

function M.setup(opts)
    opts = {
        display_table = {
            border = {
                text = {
                    top = "TODO LIST"
                }
            }
        }
    }
    table_control.setup(opts)
    io_commands.setup(opts)
    commands.setup()
end

return M
