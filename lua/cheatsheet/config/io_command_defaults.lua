local table_command = require("cheatsheet.table_commands")

local io_commands_defaults = {
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
                    table_command.write_table(note_to_add)
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
                    table_command.delete_from_table(item._id)
                else
                    vim.cmd('redraw')
                    print("Not deleting " .. item.text)
                end
            end,
        }
    }
}

return io_commands_defaults
-- local input = Input(io_command_defaults.input_config_style, io_command_defaults.input_config_prompt)
