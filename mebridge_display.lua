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

--dropdown menu for settings
function settings_menu()
    draw_line(12, 2, 18, colors.gray)
    draw_line(12, 3, 18, colors.gray)
    draw_text(13, 2, "Check for Updates", colors.white, colors.gray)
    draw_text(13, 3, "Reset peripherals", colors.white, colors.gray)
end

--basic popup screen with title bar and exit button
function popup_screen(y, title, height)
    clear()
    menu_bar()

    draw_line(4, y, 22, colors.blue)
    draw_line(25, y, 1, colors.red)

    for counter = y + 1, height + y do
        draw_line(4, counter, 22, colors.white)
    end

    draw_text(25, y, "X", colors.white, colors.red)
    draw_text(5, y, title, colors.white, colors.blue)
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
    draw_text(2, 1, "Settings", colors.white, colors.blue)
    draw_line(1, 25, monX, colors.blue)
    draw_text(2, 25, "     MEBridge Display", colors.white, colors.blue)
end

function homepage()
    while true do
        clear()
        menu_bar()
        terminal_screen()


        -----------Item Storage---------------
        draw_text(2, 8, "Used Storage:", colors.yellow, colors.black)
        local maxVal = meBridge.getTotalItemStorage()
        local minVal = math.floor(meBridge.getUsedItemStorage())

        if minVal > 500 then
            progress_bar(2, 9, monX - 2, minVal, maxVal, colors.lime, colors.gray)
        else
            if minVal > 1000 then
                progress_bar(2, 9, monX - 2, minVal, maxVal, colors.yellow, colors.gray)
            else
                if minVal > 1500 then
                    progress_bar(2, 9, monX - 2, minVal, maxVal, colors.orange, colors.gray)
                else
                    if minVal > 6000 then
                        progress_bar(2, 9, monX - 2, minVal, maxVal, colors.red, colors.gray)
                    else
                        if minVal >= 2500 then
                            progress_bar(2, 9, monX - 2, 2000, maxVal, colors.red, colors.gray)
                        end
                    end
                end
            end
        end

        draw_text(15, 8, math.floor(minVal) .. "/" .. maxVal, colors.white, colors.black)



        draw_text(2, 11, "Power Usage:", colors.yellow, colors.black)
        local maxVal = meBridge.getMaxEnergyStorage()
        local minVal = math.floor(meBridge.getEnergyUsage())

        if minVal < 500 then
            progress_bar(2, 12, monX - 2, minVal, maxVal, colors.lime, colors.gray)
        else
            if minVal < 1000 then
                progress_bar(2, 12, monX - 2, minVal, maxVal, colors.yellow, colors.gray)
            else
                if minVal < 1500 then
                    progress_bar(2, 12, monX - 2, minVal, maxVal, colors.orange, colors.gray)
                else
                    if minVal < 2000 then
                        progress_bar(2, 12, monX - 2, minVal, maxVal, colors.red, colors.gray)
                    else
                        if minVal >= 2500 then
                            progress_bar(2, 12, monX - 2, 2000, maxVal, colors.red, colors.gray)
                        end
                    end
                end
            end
        end

        draw_text(15, 11, math.floor(minVal) .. "/" .. maxVal, colors.white, colors.black)



        sleep(0.5)
    end
end

function rf_mode()
    wait = read()
end

function steam_mode()
    wait = read()
end

function install_update(program, pastebin)
    clear()
    draw_line(4, 5, 22, colors.blue)

    for counter = 6, 10 do
        draw_line(4, counter, 22, colors.white)
    end

    draw_text(5, 5, "Updating...", colors.white, colors.blue)
    draw_text(5, 7, "Open computer", colors.black, colors.white)
    draw_text(5, 8, "terminal.", colors.black, colors.white)

    if fs.exists("install") then fs.delete("install") end
    shell.run("pastebin get 2JU1k5vg install")
    shell.run("install")
end

function update()
    popup_screen(5, "Updates", 4)
    draw_text(5, 7, "Connecting to", colors.black, colors.white)
    draw_text(5, 8, "github...", colors.black, colors.white)

    sleep(0.5)

    shell.run("github get  SkyNetCloud/CC/master/current_version.txt")
    sr = fs.open("current_version.txt", "r")
    current_version = tonumber(sr.readLine())
    sr.close()
    fs.delete("current_version.txt")
    terminal_screen()

    if current_version > version then
        popup_screen(5, "Updates", 7)
        draw_text(5, 7, "Update Available!", colors.black, colors.white)
        draw_text(11, 9, " Install ", colors.white, colors.black)
        draw_text(11, 11, " Ignore ", colors.white, colors.black)

        local event, side, xPos, yPos = os.pullEvent("monitor_touch")

        --Instatll button
        if yPos == 9 and xPos >= 11 and xPos <= 17 then
            install_update()
        end

        --Exit button
        if yPos == 5 and xPos == 25 then
            call_homepage()
        end
        call_homepage()
    else
        popup_screen(5, "Updates", 5)
        draw_text(5, 7, "You are up to date!", colors.black, colors.white)
        draw_text(11, 9, " Okay ", colors.white, colors.black)

        local event, side, xPos, yPos = os.pullEvent("monitor_touch")

        --Okay button
        if yPos == 9 and xPos >= 11 and xPos <= 17 then
            call_homepage()
        end

        --Exit button
        if yPos == 5 and xPos == 25 then
            call_homepage()
        end
        call_homepage()
    end
end

function reset_peripherals()
    clear()
    draw_line(4, 5, 22, colors.blue)

    for counter = 6, 10 do
        draw_line(4, counter, 22, colors.white)
    end

    draw_text(5, 5, "Reset Peripherals", colors.white, colors.blue)
    draw_text(5, 7, "Open computer", colors.black, colors.white)
    draw_text(5, 8, "terminal.", colors.black, colors.white)
    setup_wizard()
end

function mon_touch()
    --when the monitor is touch on the homepage
    if y == 1 then
            if x < 3 then
                if x < monX then
                    settings_menu()
                    local event, side, xPos, yPos = os.pullEvent("monitor_touch")
                    if xPos > 13 then
                        if yPos == 2 then
                            update()
                        else
                            if yPos == 3 then
                                reset_peripherals()
                            else
                                call_homepage()
                            end
                        end
                    else
                        call_homepage()
                    end
                end
            end
    end
end

function call_homepage()
    clear()
    parallel.waitForAny(homepage)

    if stop_function == "terminal_screen" then
        stop_function = "nothing"
        setup_wizard()
    else
        if stop_function == "monitor_touch" then
            stop_function = "nothing"
            mon_touch()
        end
    end
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

function terminal_screen()
    term.clear()

    draw_line_term(1, 1, 55, colors.blue)
    draw_text_term(13, 1, "Storage Info Display", colors.white, colors.blue)
    draw_line_term(1, 19, 55, colors.blue)
    draw_line_term(1, 18, 55, colors.blue)
    draw_text_term(13, 18, "By SkyNetCloud", colors.green, colors.blue)

    draw_text_term(1, 3, "Current program:", colors.white, colors.blue)
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
