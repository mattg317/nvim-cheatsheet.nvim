local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
local file_command = require("cheatsheet-v2.file_commands")
local Menu = require("nui.menu")

local read_file =  "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/cheat-sheet.txt"

local M = {}
M.config  = {
    add_config = {
        input_config_style = {
            position = "50%",
            size = {
                width = 30,
            },
            border = {
                style = "single",
                text = {
                    top = "Enter Command >",
                    top_align = "center",
                },
            },
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:Normal",
            },
        },
        input_config_prompt = {
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
                else
                    -- Finally add to table
                    file_command.write_table(read_file, note_to_add)
                    print("Command added to cheat sheet: " .. value)
                end
            end,
        }
    },
    delete_config = {
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
                local confirm_delete = vim.fn.input("Are you sure you want to delete note "
                    .. item.text .. "? - y/n ")
                print("Menu Submitted: ", item.text)
                print("Menu id: ", item._id)
                if confirm_delete == 'y'
                then
                    vim.cmd('redraw')
                    file_command.delete_from_table(read_file, item._id)
                else
                    vim.cmd('redraw')
                    print("Not deleting " .. item.text)
                end
            end,
        }
    }
}

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
        local tm = file_command.read_table(read_file)
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

M.delete_command()
return M
