local default = {
    -- contents_file = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/cheat-sheet.txt",
    -- content_file_path = "",
    -- contents_file_name = vim.fn.stdpath('data') .. "/nvim-cheatsheet/cheatsheet.txt",
    -- file_dir = vim.fn.stdpath('data') .. "/nvim-cheatsheet/",
    file_name = "cheat-sheet.txt",
    todo_file = "todo-list.md",
    file_dir = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/",
    -- file_dir = "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/",

    -- contents_file = true,
    display_table = {
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                -- top = "CHEAT SHEET",
                -- This would check changed for note type cheat sheet, todo, notes
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
    }
}

return default
