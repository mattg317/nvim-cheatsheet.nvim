local io_command_defaults = require("cheatsheet.config.io_command_defaults")
local table_command = require("cheatsheet.table_commands")
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local M = {}

-- function M.setup(opts)
--     M.config = vim.tbl_deep_extend("force", io_command_defaults, opts or {})
--     -- print(M.config.input_config_style.position)
-- end
--
-- -- Take Input
-- function M.add_command()
--     -- nui function here
--
--     local input = Input(
--         {
--
--             position = "50%",
--             size = {
--                 width = 30,
--             },
--             border = {
--                 style = "single",
--                 text = {
--                     top = "<Command> - <Description>",
--                     top_align = "center",
--                 },
--             },
--             win_options = {
--                 winhighlight = "Normal:Normal,FloatBorder:Normal",
--             },
--         },
--         {
--             prompt = "> ",
--             -- default_value = greeting,
--             on_close = function()
--                 print("Input Closed!")
--             end,
--             on_submit = function(value)
--                 -- Replaces command_add
--                 -- local note_to_add = value .. "\n"
--                 local note_to_add = value
--                 -- local one, two = note_to_add:match("(.+)-([^,]+)")
--                 -- local one = note_to_add:match("(\\S+)-(.+)")
--                 -- print(note_to_add:match("(.+)-([^,]+)")
--                 -- local one, two = string.match(note_to_add, "(.+)-(.+)" )
--                 -- local com_desc = vim.fn.split("hello - there", "-")
--                 --
--                 local com_desc = vim.fn.split(note_to_add, "-")
--                 if vim.fn.len(com_desc) ~= 2 then
--                     print("Not in valid format")
--                 else
--                     local comm = com_desc[1]
--                     local desc = com_desc[2]
--                     note_to_add = comm .. " " .. desc
--                     table_command.write_table(note_to_add)
--                     print("Command added to cheat sheet: " .. value)
--                 end
--                 -- local comm = string.gsub(com_desc[1], " ", "")
--                 -- local desc = string.gsub(com_desc[2], " ", "")
--                 -- -- NOTE: add new line here
--                 -- print("found:" .. comm .. ":and:" .. desc)
--                 --
--                 -- print(string.match("hello - there", "(.+)-(.+)"))
--                 -- print(vim.fn.split("hello - there", "-")[2])
--
--                 -- Set checks here
--                 -- if note_to_add == '\n'
--                 -- then
--                 --     print("Not a command")
--                 -- else
--                 --     -- Finally add to table
--                 --     print("Command added to cheat sheet: " .. value)
--                 -- end
--             end,
--         }
--     )
--     -- make
--     input:mount()
--     -- unmount component when cursor leaves buffer
--     input:on(event.BufLeave, function()
--         input:unmount()
--     end)
-- end

-- M.add_command()
-- print(vim.fn.split("comm stuff here", "^(?:[^ ]*)(\\s)" )[1])
-- print(vim.fn.split("comm stuff here", "^(\\S*)\\s")[1])
-- local one, two = string.find("comm stuff here", "(\\S+)(.*)")
local x = "comm stuff here"
local one, two = x:match("(%S+)%s(.+)")
print(two)

return M
