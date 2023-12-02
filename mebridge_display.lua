local version = 0.2

local mon
local meBridge

local monX
local monY


function clear()
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setCursorPos(1, 1)
end

--display text on computer's terminal screen
function draw_text_term(x, y, text, text_color, bg_color)
    term.setTextColor(text_color)
    term.setBackgroundColor(bg_color)
    term.setCursorPos(x, y)
    write(text)
end

--display text text on monitor, "mon" peripheral
function draw_text(x, y, text, text_color, bg_color)
    mon.setBackgroundColor(bg_color)
    mon.setTextColor(text_color)
    mon.setCursorPos(x, y)
    mon.write(text)
end

--draw line on computer terminal
function draw_line(x, y, length, color)
    mon.setBackgroundColor(color)
    mon.setCursorPos(x, y)
    mon.write(string.rep(" ", length))
end

--draw line on computer terminal
function draw_line_term(x, y, length, color)
    term.setBackgroundColor(color)
    term.setCursorPos(x, y)
    term.write(string.rep(" ", length))
end

function progress_bar(x, y, length, minVal, maxVal, bar_color, bg_color)
    draw_line(x, y, length, bg_color)   --backgoround bar
    local barSize = math.floor((minVal / maxVal) * length)
    draw_line(x, y, barSize, bar_color) --progress so far
end

function progress_bar_term(x, y, length, minVal, maxVal, bar_color, bg_color)
    draw_line_term(x, y, length, bg_color)   --backgoround bar
    local barSize = math.floor((minVal / maxVal) * length)
    draw_line_term(x, y, barSize, bar_color) --progress so far
end

function save_config()
    sw = fs.open("config.txt", "w")
    sw.writeLine(version)
    sw.writeLine(auto_string)
    sw.close()
end

function load_config()
    sr = fs.open("config.txt", "r")
    version = tonumber(sr.readLine())
    auto_string = sr.readLine()
    sr.close()
end

function menu_bar()
    draw_line(1, 1, monX, colors.blue)
    draw_text(2, 1, "     MEBridge Display", colors.white, colors.blue)
    draw_line(1, 19, monX, colors.blue)
    draw_text(2, 25, "     MEBridge Display", colors.white, colors.blue)
end

function homepage()
while true do
    clear()
    menu_bar()
   -- terminal_screen()
 
 
    -----------Item Storage---------------
    draw_text(2, 8, "Used Storage:", colors.yellow, colors.black)
    local maxVal = meBridge.getTotalItemStorage()
    local minVal = math.floor(meBridge.getUsedItemStorage())
 
    if minVal < 500 then
    progress_bar(2, 9, monX-2, minVal, maxVal, colors.lime, colors.gray)
    else if minVal < 1000 then
    progress_bar(2, 9, monX-2, minVal, maxVal, colors.yellow, colors.gray)
    else if minVal < 1500 then  
    progress_bar(2, 9, monX-2, minVal, maxVal, colors.orange, colors.gray)
    else if minVal < 2000 then
    progress_bar(2, 9, monX-2, minVal, maxVal, colors.red, colors.gray)
    else if minVal >= 2000 then
      progress_bar(2, 9, monX-2, 2000, maxVal, colors.red, colors.gray)
    end
    end
    end
    end
    end
 
    draw_text(15, 8, math.floor(minVal).."/"..maxVal, colors.white, colors.black)



    draw_text(2, 11, "Power Usage:", colors.yellow, colors.black)
    local maxVal = meBridge.getMaxEnergyStorage()
    local minVal = math.floor(meBridge.getEnergyUsage())
 
    if minVal < 500 then
    progress_bar(2, 9, monX-2, minVal, maxVal, colors.lime, colors.gray)
    else if minVal < 1000 then
    progress_bar(2, 9, monX-2, minVal, maxVal, colors.yellow, colors.gray)
    else if minVal < 1500 then  
    progress_bar(2, 9, monX-2, minVal, maxVal, colors.orange, colors.gray)
    else if minVal < 2000 then
    progress_bar(2, 9, monX-2, minVal, maxVal, colors.red, colors.gray)
    else if minVal >= 2000 then
      progress_bar(2, 9, monX-2, 2000, maxVal, colors.red, colors.gray)
    end
    end
    end
    end
    end
 
    draw_text(15, 11, math.floor(minVal).."/"..maxVal, colors.white, colors.black)
 

 
    sleep(0.5)
  end
end

function call_homepage()
    clear()
    parallel.waitForAny(homepage)
end

function test_stuff()
    term.clear()

    draw_text_term(1, 3, "Searching for a peripherals...", colors.white, colors.black)
    sleep(1)

    meBridge = findMEBridgeBlock()
    mon = findMonitorBlock()



    draw_text_term(2, 5, "Connecting to MEBridge...", colors.white, colors.black)
    sleep(0.5)
    if meBridge == null then
        draw_text_term(1, 8, "Error:", colors.red, colors.black)
        draw_text_term(1, 9, "Could not connect to MEBridge", colors.red, colors.black)
        draw_text_term(1, 10, "MEBridge must be connected with networking cable", colors.white, colors.black)
        draw_text_term(1, 11, "and modems or the computer is directly beside", colors.white, colors.black)
        draw_text_term(1, 14, "Press Enter to continue...", colors.gray, colors.black)
        wait = read()
        setup_wizard()
    else
        draw_text_term(27, 5, "success", colors.lime, colors.black)
        sleep(0.5)
    end

    draw_text_term(2, 6, "Connecting to monitor...", colors.white, colors.black)
    sleep(0.5)
    if mon == null then
        draw_text_term(1, 7, "Error:", colors.red, colors.black)
        draw_text_term(1, 8, "Could not connect to a monitor. Place a 3x3 advanced monitor", colors.red, colors.black)
        draw_text_term(1, 11, "Press Enter to continue...", colors.gray, colors.black)
    else
        monX, monY = mon.getSize()
        draw_text_term(27, 6, "success", colors.lime, colors.black)
        sleep(0.5)
    end

    call_homepage()
end

function findMEBridgeBlock()
    local names = peripheral.getNames()
    local i, name
    for i, name in pairs(names) do
        if peripheral.getType(name) == "meBridge" then
            return peripheral.wrap(name)
        else
            -- return term.write("No meBridge Found")
        end
    end
end

function findMonitorBlock()
    local names = peripheral.getNames()
    local i, name
    for i, name in pairs(names) do
        if peripheral.getType(name) == "monitor" then
            test = name
            return peripheral.wrap(name)
        else
            --return term.write("no Monitor found")
        end
    end
end

function setup_wizard()
    term.clear()
    wait = read()
    test_stuff()
end

function startup()
    if fs.exists("config.txt") then
        load_config()
        test_stuff()
    else
        setup_wizard()
    end
end

startup()
