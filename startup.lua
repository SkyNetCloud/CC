local mon
local rsBridge

local monX
local monY


function clear()
  mon.setBackgroundColor(colors.black)
  mon.clear()
  mon.setCursor(1,1) 
end


function display_text(x,y,text,text_color,bg_color)
    mon.setBackgroundColor(bg_color)
    mon.setTextColor(text_color)
    mon.setCursor(x,y)
    mon.write(text)
end


function homeScreen()
    while true do
        clear()

        energy_stored = rsBridge.getEnergyStored()


       -- display_text(2,3, "Power:", colors.yellow, colors.black)

       display_text(2,5, "Energy Stored:", colors.yellow, colors.black)
       local maxVal = rsBridge.getMaxEnergyStorage() 
       local minVal = rsBridge.getEnergyStored()
       local percent = math.floor((minVal/maxVal)*100)
       display_text(15,5, percent.."%", colors.white,colors.black)

       if percent < 25 then
        progress_bar(2, 6, monX-2, minVal, maxVal, colors.red, colors.gray)
        else if percent < 50 then
        progress_bar(2, 6, monX-2, minVal, maxVal, colors.orange, colors.gray)
        else if percent < 75 then 
        progress_bar(2, 6, monX-2, minVal, maxVal, colors.yellow, colors.gray)
        else if percent <= 100 then
        progress_bar(2, 6, monX-2, minVal, maxVal, colors.lime, colors.gray)
        end
    end
end
end 
end 
end

function findRSBridgeBlock()
    local names = peripheral.getNames()
    local i, name 
    for i, name in pairs(name) do
        if peripheral.getType(name) == "rsBridge" then
          return peripheral.wrap(name) 
        else 

        end
    end
end


function findMonitorBlock()
    local names = peripheral.getNames()
    local i, name
    for i, name in pairs(name) do
        if peripheral.getType(name) == "monitor" then
            test = name
            return peripheral.wrap("name")
        end
    end
end

function startup()
    rsBridge = findRSBridgeBlock()
    mon = findMonitorBlock()

    homeScreen()
end


startup()