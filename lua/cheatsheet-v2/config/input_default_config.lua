local default = {
    file_dir = vim.fn.stdpath('data') .. "/nvim-cheatsheet/",
    cheat_sheet_file = "cheatsheet.txt",
    todo_file = "todo-list.md",
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
        }
    }
}

return default
