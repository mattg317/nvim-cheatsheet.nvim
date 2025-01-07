local commands = require("cheatsheet-v2.commands")
local display_cheatsheet = require("cheatsheet-v2.display_cheatsheet")
local display_todo = require("cheatsheet-v2.todo_display")

local M = {}

function M.setup(opts)
    -- Probably want to check for file here maybe? or check tjs video about waiting for lazy to call it
    display_cheatsheet.setup(opts)
    display_todo.setup(opts)
    commands.setup()
end

return M
