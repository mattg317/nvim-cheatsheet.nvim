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
M.setup()
-- Take Input
-- function M.read_command_input(command_type)
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


    local menu = Menu( M.config.delete_config.menu, M.config.delete_config.menu_input)
    --     position = "50%",
    --     size = {
    --         width = "40%",
    --         height = "40%",
    --     },
    --     border = {
    --         style = "single",
    --         text = {
    --             top = "Select a note to delete",
    --             top_align = "center",
    --         },
    --     },
    --     win_options = {
    --         winhighlight = "Normal:Normal,FloatBorder:Normal",
    --     },
    -- },
    -- {
    --     lines = table_menu(),
    --     max_width = 20,
    --     keymap = {
    --         focus_next = { "j", "<Down>", "<Tab>" },
    --         focus_prev = { "k", "<Up>", "<S-Tab>" },
    --         close = { "<Esc>", "<C-c>" },
    --         submit = { "<CR>", "<Space>" },
    --     },
    --     on_close = function()
    --         print("Menu Closed!")
    --     end,
    --     on_submit = function(item)
    --         local confirm_delete = vim.fn.input("Are you sure you want to delete note "
    --             .. item.text .. "? - y/n ")
    --         print("Menu Submitted: ", item.text)
    --         print("Menu id: ", item._id)
    --         if confirm_delete == 'y'
    --         then
    --             vim.cmd('redraw')
    --             table_command.delete_from_table(item._id)
    --         else
    --             vim.cmd('redraw')
    --             print("Not deleting " .. item.text)
    --         end
    --     end,
    -- })

    -- mount the component
    menu:mount()
    local ok = menu:map("n", "q", function(bufnr)
        menu:unmount()
    end, { noremap = true })
end

return M
