require 'moonloader'

function addCommandsList(command)
    for line in io.lines("moonloader\\command.txt") do
    line = line:gsub("\r", ""):gsub("^%s*(.-)%s*$", "%1") 
        if line ~= "" then
            table.insert(command, line)
        end
    end
end 


function levenstain(str1, str2)                        

    local len1 = string.len(str1)
    local len2 = string.len(str2)

    local matrix = {}

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

local commands = {
}

function filterCommands(strUsers, command) 
    if type(strUsers) ~= "string" then
        strUsers = tostring(strUsers)
    end

    strUsers = string.lower(strUsers)
    local tableStr = {}
    local finalyStr = {}
    
    for i = 1, #command do
        local dist = levenstain(strUsers, command[i])
        print("org" .. strUsers)
        print("command - " .. command[i] .. " dist - " .. dist)
        if dist < 5 then
            table.insert(tableStr, {command[i], dist})
        end
    end

    for i = 1, #tableStr do
        for j = 1, #tableStr - i do
            if tableStr[j][2] > tableStr[j  + 1][2] then
                local tmp = tableStr[j]
                tableStr[j] = tableStr[j + 1]
                tableStr[j + 1] = tmp
            end
        end
    end

    print("After sort")

    for i = 1, #tableStr do
        print("org " .. strUsers)
        print("command " ..  tableStr[i][1] .. " dist - " .. tableStr[i][2])
    end

    for i = 1, math.min(5, #tableStr) do
        finalyStr[i] = tableStr[i][1]
    end

    return finalyStr

end

function main()
    addCommandsList(commands)
   
        local oldPrefix
        local newText
        local countTab = 1
        local userInput
        local lastInsertedCommand
        while true do
        
            wait(50)
            if sampIsChatInputActive() then
                
                local currentText = sampGetChatInputText()
                local userInput = sampGetChatInputText()

                if userInput ~= lastInsertedCommand then
                    oldPrefix = currentText
                    newText = filterCommands(oldPrefix, commands)
                    countTab = 1
                end

                if isKeyJustPressed(0x09) then
                    if #newText >= countTab then
                        sampSetChatInputText(newText[countTab])
                        lastInsertedCommand = newText[countTab]
                        countTab = countTab + 1
                    else
                        countTab = 1
                    end
                end

            end
        end
end
