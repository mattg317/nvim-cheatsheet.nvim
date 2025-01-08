local display_cheatsheet = require("cheatsheet-v2.cheatsheet_display")
local display_todo = require("cheatsheet-v2.todo_display")
local input_commands = require("cheatsheet-v2.input_commands")

local M = {}

function M.setup(opts)
    display_cheatsheet.setup(opts)
    display_todo.setup(opts)
    input_commands.setup(opts)

end

return M
