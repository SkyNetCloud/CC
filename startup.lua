local version = 0.1

local mon
local rsBridge

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

--create progress bar
--draws two overlapping lines
--background line of bg_color
--main line of bar_color as a percentage of minVal/maxVal
function progress_bar(x, y, length, minVal, maxVal, bar_color, bg_color)
    draw_line(x, y, length, bg_color)   --backgoround bar
    local barSize = math.floor((minVal / maxVal) * length)
    draw_line(x, y, barSize, bar_color) --progress so far
end

--same as above but on the computer terminal
function progress_bar_term(x, y, length, minVal, maxVal, bar_color, bg_color)
    draw_line_term(x, y, length, bg_color)   --backgoround bar
    local barSize = math.floor((minVal / maxVal) * length)
    draw_line_term(x, y, barSize, bar_color) --progress so far
end

function save_config()
    sw = fs.open("config.txt", "w")
    sw.writeLine(version)
    sw.close()
end

--read settings from file
function load_config()
    sr = fs.open("config.txt", "r")
    version = tonumber(sr.readLine())
    sr.close()
end

function homeScreen()
    while true do
        clear()

        --energy_stored = rsBridge.getEnergyStorage()


        -- display_text(2,3, "Power:", colors.yellow, colors.black)

        draw_text(2, 5, "Energy Stored:", colors.yellow, colors.black)
        local maxVal = rsBridge.getMaxEnergyStorage()
        local minVal = rsBridge.getEnergyStorage()
        local percent = math.floor((minVal / maxVal) * 100)
        draw_text(15, 5, percent .. "%", colors.white, colors.black)

        -- if percent < 25 then
        --     progress_bar(2, 6, monX - 2, minVal, maxVal, colors.red, colors.gray)
        -- else
        --     if percent < 50 then
        --         progress_bar(2, 6, monX - 2, minVal, maxVal, colors.orange, colors.gray)
        --     else
        --         if percent < 75 then
        --             progress_bar(2, 6, monX - 2, minVal, maxVal, colors.yellow, colors.gray)
        --         else
        --             if percent <= 100 then
        --                 progress_bar(2, 6, monX - 2, minVal, maxVal, colors.lime, colors.gray)
        --             end
        --         end
        --     end
        -- end
    end
end

function call_homepage()
    clear()
    parallel.waitForAny(homeScreen)
    
end



function test_stuff()
    term.clear()

    draw_text_term(1, 3, "Searching for a peripherals...", colors.white, colors.black)
    sleep(1)

    rsBridge = findRSBridgeBlock()
    mon = findMonitorBlock()

    if mon == null then
        draw_text_term(1, 7, "Error:", colors.red, colors.black)
        draw_text_term(1, 8, "Could not connect to a monitor. Place a 3x3 advanced monitor", colors.red, colors.black)
        draw_text_term(1, 11, "Press Enter to continue...", colors.gray, colors.black)
        wait = read()
        setup_wizard()
    else
        monX, monY = mon.getSize()
        draw_text_term(27, 6, "success", colors.lime, colors.black)
        sleep(0.5)
    end
    draw_text_term(2, 7, "saving configuration...", colors.white, colors.black)  

    save_config()

    sleep(0.1)
    draw_text_term(1, 9, "Setup Complete!", colors.lime, colors.black) 
    sleep(1)

    auto = auto_string == "true"
    call_homepage() 

end

function findRSBridgeBlock()
    local names = peripheral.getNames()
    local i, name
    for i, name in pairs(names) do
        if peripheral.getType(name) == "rsBridge" then
            return peripheral.wrap(name)
        else
            return term.write("No rsBridge Found")
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
            return term.write("no Monitor found")
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