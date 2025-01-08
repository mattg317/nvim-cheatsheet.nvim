local file_command = require("cheatsheet-v2.file_commands")
local utils = require("cheatsheet-v2.utils")
local toggle = require("cheatsheet-v2.toggle")
local default_config = require("cheatsheet-v2.config.default_config")

local M = {}


function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", default_config, opts or {})
    M.config.contents_file = M.config.file_dir .. M.config.todo_file
    local file, err = io.open(M.config.contents_file, "r")
    if file == nil then
        print("\nCouldn't open " .. M.config.todo_file .. " " .. err)
        utils.create_cheatsheet_file(M.config.file_dir, M.config.todo_file)
    end
end

function M.toggle_todo_display()
    local max_line = 1

    local tm = file_command.read_table(M.config.contents_file)
    local lines = {}
    for _, value in ipairs(tm) do
        max_line = math.max(max_line, vim.api.nvim_strwidth(value))
        table.insert(lines, value)
    end

    -- Create the buffer and use the file as the buffer name
    local bufnr = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_buf_set_name(bufnr, M.config.contents_file)

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
        title = "TODO List",
        title_pos = "center",
    })
    -- Wipe buffer when it gets hidden
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = bufnr })
    vim.api.nvim_set_option_value('winhighlight', 'Normal:Normal', {})
    -- Edit the file thats in the buffer
    vim.api.nvim_buf_call(bufnr, vim.cmd.edit)

    local function close()
        if vim.api.nvim_win_is_valid(winid) then
            vim.api.nvim_win_close(winid, true)
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
    -- This is still in progress because of needing to save it
    vim.keymap.set("n", "x", toggle.toggle, { buffer = bufnr })
end

return M
