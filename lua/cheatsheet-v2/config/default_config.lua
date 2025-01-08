local default = {
    file_dir = vim.fn.stdpath('data') .. "/nvim-cheatsheet/",
    cheat_sheet_file = "cheatsheet.txt",
    todo_file = "todo-list.md",
    cheat_sheet = {
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = "CHEAT SHEET",
            }
        },
        position = "50%",
        size = {
            width = "40%",
            height = "40%",
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
    },
}

return default
