local file_command = require("cheatsheet-v2.file_commands")
local utils = require("cheatsheet-v2.utils")

-- local read_file = "/Users/mgiordanella/Main/10_Coding/10_Nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/todo-list.md"
local read_file = "/home/matthewgiordanella/Main/30-39_Coding/nvim/nvim-cheatsheet.nvim/lua/cheatsheet/file/todo-list.md"

local M = {}
local checked_character = "x"

local checked_checkbox = "%[" .. checked_character .. "%]"
local unchecked_checkbox = "%[ %]"

local line_contains_unchecked = function(line)
    return line:find(unchecked_checkbox)
end

local line_contains_checked = function(line)
    return line:find(checked_checkbox)
end

local line_with_checkbox = function(line)
    -- return not line_contains_a_checked_checkbox(line) and not line_contains_an_unchecked_checkbox(line)
    return line:find("^%s*- " .. checked_checkbox)
        or line:find("^%s*- " .. unchecked_checkbox)
        or line:find("^%s*%d%. " .. checked_checkbox)
        or line:find("^%s*%d%. " .. unchecked_checkbox)
end

local checkbox = {
    check = function(line)
        return line:gsub(unchecked_checkbox, checked_checkbox, 1)
    end,

    uncheck = function(line)
        return line:gsub(checked_checkbox, unchecked_checkbox, 1)
    end,

    make_checkbox = function(line)
        if not line:match("^%s*-%s.*$") and not line:match("^%s*%d%s.*$") then
            -- "xxx" -> "- [ ] xxx"
            return line:gsub("(%S+)", "- [ ] %1", 1)
        else
            -- "- xxx" -> "- [ ] xxx", "3. xxx" -> "3. [ ] xxx"
            return line:gsub("(%s*- )(.*)", "%1[ ] %2", 1):gsub("(%s*%d%. )(.*)", "%1[ ] %2", 1)
        end
    end,
}


function M.display_win()
    -- WE want to view this file as is, it doesn't need to be drawn onto the buffer
    local max_line = 1

    local tm = file_command.read_table(read_file)
    local lines = {}
    for _, value in ipairs(tm) do
        max_line = math.max(max_line, vim.api.nvim_strwidth(value))
        table.insert(lines, value)
    end

    -- along this reasoning, need to create the buf from a file and delete when it leaves each time
    -- might also was to start with a check that that buffer isn't curren't open as well w
    -- local bufnr = vim.api.nvim_create_buf(false, false)
    -- vim.api.nvim_buf_call(bufnr, vim.cmd.edit)
    -- vim.api.nvim_set_option_value('bufhidden', 'wipe')
    -- vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
    -- vim.api.nvim_buf_set_name(bufnr, 'test-todo')
    -- this has been replaced with vim.api.nvim_set_option_value
    -- vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")

    -- Create the buffer and use the file as the buffer name
    local bufnr = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(bufnr, read_file)

    local editor_width = vim.o.columns
    local editor_height = utils.get_editor_height()
    local winid = vim.api.nvim_open_win(bufnr, true, {
        relative = 'editor',
        row = math.max(0, (editor_height - #lines) / 2),
        col = math.max(0, (editor_width - max_line - 1) / 2),
        width = math.min(editor_width, max_line + 15),
        height = math.min(editor_height, #lines),
        zindex = 150,
        border = "rounded",
    })
    -- Wipe buffer when it gets hidden
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = bufnr })
    -- Edit the file thats in the buffer
    vim.api.nvim_buf_call(bufnr, vim.cmd.edit)

    local function close()
        if vim.api.nvim_win_is_valid(winid) then
            -- try running save table here
            vim.api.nvim_win_close(winid, true)
            -- vim.api.nvim_buf_delete(bufnr, { force = true})
        end
    end
    vim.api.nvim_create_autocmd("BufLeave", {
        callback = close,
        once = true,
        nested = true,
        buffer = bufnr,
    })
    vim.api.nvim_create_autocmd("WinLeave", {
        callback = close,
        once = true,
        nested = true,
    })
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = bufnr })
    local function toggle()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local start_line = cursor[1] - 1
        local current_line = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 1, false)[1] or ""

        local new_line = ""
        if not line_with_checkbox(current_line) then
            print("not line with check")
            new_line = checkbox.make_checkbox(current_line)
        elseif line_contains_unchecked(current_line) then
            print("line with uncheck")
            new_line = checkbox.check(current_line)
        elseif line_contains_checked(current_line) then
            print("line with check")
            new_line = checkbox.uncheck(current_line)
        end

        vim.api.nvim_buf_set_lines(bufnr, start_line, start_line + 1, false, { new_line })
    end
    -- will need to set something here for toggleing it
    vim.keymap.set("n", "x", toggle, { buffer = bufnr })
end

M.display_win()
return M
