local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local table_command = require("cheatsheet.table_commands")
local Menu = require("nui.menu")
local io_command_defaults = require("cheatsheet.config.io_command_defaults")

local M = {}

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", io_command_defaults, opts or {})
    -- print(M.config.input_config_style.position)
end

-- Take Input
function M.add_command()
    -- nui function here
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
    local table_menu = function()
        local tm = table_command.read_table()
        local test_table = {}
        for index, value in ipairs(tm) do
            local data = { id = index }
            table.insert(test_table, Menu.item(value, data))
        end
        return test_table
    end
    -- load lines parameter here and then add it
    M.config.delete_config.menu_input.lines = table_menu()

    local menu = Menu( M.config.delete_config.menu, M.config.delete_config.menu_input)

    -- mount the component
    menu:mount()
    local ok = menu:map("n", "q", function(bufnr)
        menu:unmount()
    end, { noremap = true })
end

return M
