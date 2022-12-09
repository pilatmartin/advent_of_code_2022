local open = io.open

local function read_file(path)
    local file = open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local function get_matrix(input)
    local matrix = {}

    for line in input:gmatch "[^\n]+" do
        local line_idk = {}

        for char in line:gmatch "[0-9]" do
            table.insert(line_idk, tonumber(char))
        end

        table.insert(matrix, line_idk)
    end

    return matrix
end

local function get_tree_visibility_and_distance(matrix, i, j)
    local visible = {true, true, true, true}
    local distances = {0, 0, 0, 0}

    -- visibility/distance from the right
    for _j = j+1, #matrix, 1 do
        distances[1] = distances[1] + 1
        if matrix[i][_j] >= matrix[i][j] then visible[1] = false break end
    end

    -- visibility/distance from the left
    for _j = j-1, 1, -1 do
        distances[2] = distances[2] + 1
        if matrix[i][_j] >= matrix[i][j] then visible[2] = false break end
    end

    -- visibility/distance from the bottom
    for _i = i+1, #matrix, 1 do
        distances[3] = distances[3] + 1
        if matrix[_i][j] >= matrix[i][j] then visible[3] = false break end
    end

    -- visibility/distance from the top
    for _i = i-1, 1, -1 do
        distances[4] = distances[4] + 1
        if matrix[_i][j] >= matrix[i][j] then visible[4] = false break end
    end

    return {
        visible[1] or visible[2] or visible[3] or visible[4],
        distances[1] * distances[2] * distances[3] * distances[4]
    }
end

local function main ()
    local input = read_file "08/data"
    local matrix = get_matrix(input)
    local count, max_distance = 0, 0

    for i = 1, #matrix, 1 do
        for j = 1, #matrix, 1 do
            local treeInfo = get_tree_visibility_and_distance(matrix, i, j)
            local visible, distance = treeInfo[1], treeInfo[2]

            if visible then count = count + 1 end
            if distance > max_distance then max_distance = distance end
        end
    end

    print("First: ", count)
    print("Second: ", max_distance)
end

main()
