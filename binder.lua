require 'moonloader'

function main()
    while true do 
    wait(50)

        if isKeyJustPressed(0x49) then
            sampSendChatMessage("/inv")
        end
    end
end