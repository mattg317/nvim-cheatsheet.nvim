local default = {
    -- contents_file = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/cheat-sheet.txt",
    -- content_file_path = "",
    -- contents_file_name = vim.fn.stdpath('data') .. "/nvim-cheatsheet/cheatsheet.txt",
    -- file_name = "cheat-sheet.txt",
    -- todo_file = "todo-list.md",
    -- file_dir = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet-v2/file/",
    -- file_dir = "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet-v2/file/",
    file_path = "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet-v2/file/cheat-sheet.txt",
-- file_path = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/cheat-sheet.txt",
    file_todo = "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet-v2/file/todo-list.md",

    -- final version
    file_dir = vim.fn.stdpath('data') .. "/nvim-cheatsheet/",
    -- cheat_sheet_file = "cheat-sheet.txt",
    cheat_sheet_file = "cheatsheet.txt",
    todo_file = "todo-list.md",


    -- contents_file = true,
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
        -- win_options = {
        --     winhighlight = "Normal:MiniIconsPurple"
        -- }
    },
}

return default
