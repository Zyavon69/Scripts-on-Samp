require 'moonloader'

function main() 
    lua_thread.create(function ()
        local command = {}
        while true do
            if sampIsChatInputActive() then
                --local str = sampGetChatInputText()
                if isKeyDown(0x11) and  isKeyJustPressed(0x08) then
                    print("Клавиши нажаты ")
                end
            end
        end
    end)  
end