local default = {
    -- contents_file = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/cheat-sheet.txt",
    -- content_file_path = "",
    -- contents_file_name = vim.fn.stdpath('data') .. "/nvim-cheatsheet/cheatsheet.txt",
    file_dir = vim.fn.stdpath('data') .. "/nvim-cheatsheet/",
    file_name = "cheat-sheet.txt",
    -- file_dir = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/",

    -- contents_file = true,
    display_table = {
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                -- top = "CHEAT SHEET",
                top = "CHEAT SHEET",
            }
        },
        position = "50%",
        size = {
            width = "40%",
            height = "40%",
        },
        win_options = {
            winhighlight = "Normal:MiniIconsPurple"
        }
    },
    file_picker = {
        menu = {
            position = "50%",
            size = {
                width = 25,
                height = 5,
            },
            border = {
                style = "single",
                text = {
                    top = "Change to file:",
                    top_align = "center",
                },
            },
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:Normal",
            },
        },
        menu_input = {
            -- lines = test_table,
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
