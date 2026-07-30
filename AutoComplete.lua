local sampev = require 'samp.events'
require 'moonloader'

local command = {
    "/me", 
    "/eject",
    "/cleave",
    "/leave",
    "/mn",
    "/help",
    "/report",
    "/tasks",
    "/ab",
    "/adhelp",
    "/admod",
    "/afford",
    "/myfract",
    "/mycrew",
}



function levenstain(str1, str2)
    
    local matrix = {}
    
    local len1 = string.len(str1)
    local len2 = string.len(str2)

    for i = 0, len1 do
        matrix[i] = {[0] = i}
    end

    for j = 1, len2 do
        matrix[0][j] = j
    end
    local cost
    for i = 1, len1 do
        for j = 1, len2 do
            if string.sub(str1, i,i) == string.sub(str2, j,j) then
                cost =  0
            else
                cost =  1
            end

            matrix[i][j] = math.min(matrix[i][j - 1] + 1, matrix[i - 1][j] + 1,matrix[i - 1][j - 1] + cost )
        end
    end
    return matrix[len1][len2]
end


function filterCommands(strUsers)
    local tableStr = {}
    local finalyTable = {}

    for i in ipairs(command) do
        local dist = levenstain(strUsers, command[i])

        if dist <= 5 then
            local entry = {}
            entry.cmd = command[i]
            entry.dist = dist
            table.insert(tableStr, entry)
        end
    end

    for i = 1, #tableStr - 1, 1 do
        for j = 1,#tableStr - i, 1 do
            if tableStr[j].dist > tableStr[j + 1].dist then
                local temp = tableStr[j]
                tableStr[j] = tableStr[j + 1]
                tableStr[j + 1] = temp
            end
        end
    end

    for i in ipairs(tableStr) do
        print("Origin ", strUsers)
        print("str - " ..  tableStr[i].cmd .. " key - " .. tableStr[i].dist)
    end

    for i = 1,  math.min(5, #tableStr) do
        table.insert(finalyTable, tableStr[i].cmd)
    end

    return finalyTable
end

function main()
    lua_thread.create(function()
        local lastInsertedCommand
        local oldPrefix
        local newText
        local countTab = 1
        while true do
            wait(50)
            if sampIsChatInputActive() then
                local currentText = sampGetChatInputText()
                if currentText ~= lastInsertedCommand then 
                    oldPrefix = currentText
                    newText = filterCommands(oldPrefix)
                    countTab = 1
                end


                if isKeyJustPressed(0x09) then
                    sampSetChatInputText(tostring(newText[countTab]))
                    lastInsertedCommand = tostring(newText[countTab])

                    if countTab > #newText then
                        countTab = 1
                    else
                        countTab = countTab + 1
                    end
                end
            end 
        end
    end)
end
