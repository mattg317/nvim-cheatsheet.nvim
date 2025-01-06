local M = {}

function M.read_table(read_file)
    local table_c = {}
    local file, err = io.open(read_file, "r")

    if file == nil then
        print("Couldn't open file: " .. err)
    else
        for line in file:lines() do
            table.insert(table_c, line)
        end
        file:close()
    end
    return table_c
end

function M.table_length(table_c)
    local count = 0
    for _ in pairs(table_c)
    do
        count = count + 1
    end
    return count
end

function M.save_table(read_file, new_table)
    -- TODO: this needed to be udpated as well
    local file, err = io.open(read_file, "w")
    if file == nil then
        print("Couldn't open file: " .. err)
    else
        for num, item in ipairs(new_table) do
            if num == #new_table then
                file:write(item)
            else
                file:write(item .. "\n")
            end
        end
        file:close()
    end
end

function M.write_table(read_file, note_to_add)
    local main_table = M.read_table()
    table.insert(main_table, note_to_add)
    M.save_table(read_file, main_table)
end

function M.delete_from_table(read_file, num_to_delete)
    local main_table = M.read_table(read_file)
    local table_length = M.table_length(main_table)
    if tonumber(num_to_delete) > 0 and tonumber(num_to_delete) <= table_length then
        print("Deleting command > " .. main_table[num_to_delete])
        table.remove(main_table, num_to_delete)
        M.save_table(read_file, main_table)
    else
        print("Not a Valid Number")
    end
end

return M
