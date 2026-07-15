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

function filterCommands(prefix)
    local result = {}
    for _, cmd in ipairs(command) do
        if cmd:sub(1, #prefix) == prefix then
            table.insert(result, cmd)
        end
    end
    return result
end

function main()
    local countTab = 0
    lua_thread.create(function()
        local lastInsertedCommand
        local oldPrefix
        local newText
        
        while true do
            wait(50)
            if sampIsChatInputActive() then
                local currentText = sampGetChatInputText()
                if currentText ~= lastInsertedCommand then 
                    oldPrefix = currentText
                    newText = filterCommands(oldPrefix)
                    countTab = 0
                end


                if isKeyJustPressed(0x09) then
                    sampSetChatInputText(string.tostring(newText[countTab]))
                    lastInsertedCommand = newText[countTab]

                    if countTab > #command then
                        countTab = 0
                    else
                        countTab = countTab + 1
                    end
                end
            end 
        end
    end)
end
