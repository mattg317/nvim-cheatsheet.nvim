local CMDS = {
    {
        name = "CheatSheetToggle",
        opts = {
            desc = "cheatsheet: open",
            bar = true,
        },
        command = function()
            require("cheatsheet-v2.cheatsheet_display").display_cheat_sheet()
        end,
    },
    {
        name = "ToggleQuickSheet",
        opts = {
            nargs = 1,
            desc = "Toggle which quick sheet to display",
            bar = true,
        },
        command = function(opts)
            local usage = "Usage:  :Toggleit <sheet_type: cs|td>, ie. :Toggleit cs"
            if opts.args == 'cs' then
                require("cheatsheet-v2.cheatsheet_display").display_cheat_sheet()
            elseif opts.args == 'td' then
                require("cheatsheet-v2.todo_display").toggle_todo_display()
            else
                print("Invaled argument > " .. usage)
                return
            end
        end,
    },
    {
        name = "CheatSheetAdd",
        opts = {
            desc = "cheatsheet: add",
            bar = true,
        },
        command = function()
            require("cheatsheet-v2.input_commands").add_command('cs')
        end,
    },
    {
        name = "CheatSheetDelete",
        opts = {
            desc = "cheatsheet: delete",
            bar = true,
        },
        command = function()
            require("cheatsheet-v2.input_commands").delete_command()
        end
    },

}

for _, cmd in ipairs(CMDS) do
    local opts = vim.tbl_extend("force", cmd.opts, { force = true })
    vim.api.nvim_create_user_command(cmd.name, cmd.command, opts)
end
