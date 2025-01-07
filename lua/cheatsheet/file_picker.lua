local Menu = require("nui.menu")
local table_control = require("cheatsheet.table_commands")
local opts = require("cheatsheet.config.display_table")
-- local event = require("nui.utils.autocmd").event

table_control.setup(opts)

-- Read files in a directory

local table_menu = function(dirs)
    local test_table = {}
    for value, _ in dirs do
        table.insert(test_table, Menu.item(value))
    end
    return test_table
end
local file_dir = vim.fn.stdpath('data') .. "/nvim-cheatsheet/"

local dirs = vim.fs.dir(file_dir)

local menu = Menu({
  position = "50%",
  size = {
    width = 25,
    height = 5,
  },
  border = {
    style = "single",
    text = {
      top = "[Choose-an-Element]",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal,FloatBorder:Normal",
  },
}, {
  lines = table_menu(dirs),
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
      -- Here is where I need to swtich the view
      local new_file = file_dir .. item.text
      opts.file_name = item.text
    print("Menu Submitted: ", item.text)
    print("You select the file in - " .. new_file)
  end,
})

-- mount the component
menu:mount()
-- table_control.display_table()
