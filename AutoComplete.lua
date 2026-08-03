--local sampev = require 'samp.events'
require 'moonloader'

--[[function addCommandsList(command)
    for line in io.lines("moonloader\\command.txt") do
    line = line:gsub("\r", ""):gsub("^%s*(.-)%s*$", "%1") 
        if line ~= "" then
            table.insert(command, line)
        end
    end
end]]-- 


function levenstain(str1, str2)                        
    if str1 == nil then
        str1 = ""
    end
    if str2 == nil then
        str2 = ""
    end
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

local command = {
    "/me",
    "/eject",
    "mycrew",
    "myfract"
}

function filterCommands(prefix)

    local result = {}
    for _, cmd in ipairs(command) do
        if cmd:sub(1, #prefix) == prefix then
            table.insert(result, cmd)
        end
    end
    return result
end

--[[function filterCommands(strUsers)
    
    if type(strUsers) ~= "string" then
        return {}
    end 

    strUsers = string.lower(strUsers)

    local tableStr = {}
    local finalyTable = {}
    
    for i = 1, #command do
        local dist = levenstain(tostring(strUsers), tostring(command[i]))

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

    for i = 1,  math.min(5, #tableStr) do
        table.insert(finalyTable, tableStr[i].cmd)
    end

    return finalyTable
end]]-- 

function main()
    --addCommandsList(command)
    
    --local ok,err = pcall(function ()
        lua_thread.create(function ()
            local lastInsertedCommand
            local userInput
            local oldPrefix
            local newText
            local countTab = 1
            while true do
                wait(50)
                if sampIsChatInputActive() then
                    local currentText = sampGetChatInputText()
                    userInput = sampGetChatInputText()
                
                    if type(currentText) ~= "string" then
                        print("Это не строка")
                        currentText = tostring(currentText)
                    end
                        if userInput ~= lastInsertedCommand then 
                            oldPrefix = currentText
                            --local ok, result = pcall(filterCommands, oldPrefix)
                            --if ok then
                                newText = filterCommands(oldPrefix)
                            --else
                                --print("ошибка в filterCommands", result)
                                --newText = {}
                            end
                            countTab = 1
                        end

                    if isKeyJustPressed(0x09) then
                        if newText ~= nil then
                            if type(newText) == "table" then
                                if  #newText >= countTab then
                                    
                                    local text = tostring(newText[countTab])
                                    --text = text:gsub("%c", "")
                                    if text and text ~= "" then
                                        sampSetChatInputText(text)
                                        --local ok, err = pcall(sampSetChatInputText, text)
                                    --if not ok then
                                        --print("Ошибка в sampGetChatInputText",err)
                                        --return
                                        lastInsertedCommand = text
                                        countTab = countTab + 1
                                    end
                                elseif #newText == 0 then
                                    return
                                else
                                    countTab = 1
                                end     
                                
                            end
                        else 
                            newText = {}
                        end 
                    end
                end 
            end)    
        --end
        --while true do
            --wait(50)
        --end
    --end)    
    --[[if not ok then
        print("[AutoComplete] Ошибка в потоке",err)
        wait(1000)
    end
    wait(50)--]]
end
