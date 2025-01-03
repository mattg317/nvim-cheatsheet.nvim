local event = require("nui.utils.autocmd").event
local test_utils = require("cheatsheet.test_utils")
local file_command = require("cheatsheet.file_commands")
local Menu = require("nui.menu")

local read_file =  "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/todo-list.md"
local M = {}

M.config = {
    todo_config = {
        menu = {
            position = "50%",
            size = {
                width = "40%",
                height = "40%",
            },
            border = {
                style = "single",
                text = {
                    top = "Select a note to delete",
                    top_align = "center",
                },
            },
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:Normal",
            },
        },
        menu_input = {
            -- lines = table_menu(),
            max_width = 20,
            keymap = {
                focus_next = { "j", "<Down>", "<Tab>" },
                focus_prev = { "k", "<Up>", "<S-Tab>" },
                close = { "<Esc>", "<C-c>" },
                submit = { "<CR>", "<Space>" },
            },
            on_close = function()
                print("Menu Closed!")
            end,
            on_submit = function(item)
                -- local bufnr = vim.api.nvim_get_current_buf()
                test_utils.toggle(menu.bufnr, item.text)
                print("You select " .. item.text)
                -- local confirm_delete = vim.fn.input("Are you sure you want to delete note "
                --     .. item.text .. "? - y/n ")
                -- print("Menu Submitted: ", item.text)
                -- print("Menu id: ", item._id)
                -- if confirm_delete == 'y'
                -- then
                --     vim.cmd('redraw')
                --     file_command.delete_from_table(read_file, item._id)
                -- else
                --     vim.cmd('redraw')
                --     print("Not deleting " .. item.text)
                -- end
            end,
        }
    }
}

function M.display_todo()
    local table_menu = function()
        local tm = file_command.read_table(read_file)
        local test_table = {}
        for index, value in ipairs(tm) do
            local data = { id = index }
            table.insert(test_table, Menu.item(value, data))
        end
        return test_table
    end
    -- load lines parameter here and then add it
    M.config.todo_config.menu_input.lines = table_menu()

    local menu = Menu( M.config.todo_config.menu, M.config.todo_config.menu_input)

    -- mount the component
    menu:mount()
    local ok = menu:map("n", "q", function(bufnr)
        menu:unmount()
    end, { noremap = true })
end


M.display_todo()
return M
