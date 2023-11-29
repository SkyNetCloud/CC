local m = peripheral.wrap("right")
local rsBridge = peripheral.find("rsBridge")


function screen()
    local size = m.getSize()
    if size < 5 then 
     print("Size is less then 5 blocks")
    end
end

screen()

while true do
   print("Log:")
   sleep(1)
end