bootstrap = "WdiT6sR5"

installer = "SkyNetCloud/CC/master/installer.lua"

meBridge_display_github = "SkyNetCloud/CC/master/meBridge_display.lua"

rsBridge_display_github = "SkyNetCloud/CC/master/rsBridge_display.lua"

rsBridge_startup = "SkyNetCloud/CC/master/rsBridge_startup.lua"
meBridge_startup = "SkyNetCloud/CC/master/meBridge_startup.lua"

local meBridge
local rsBridge
term.clear()


function display_text_term(x, y, text, text_color, bg_color)
    term.setTextColor(text_color)
    term.setBackgroundColor(bg_color)
    term.setCursorPos(x, y)
    write(text)
end

function display_line_text(x, y, length, color)
    term.setBackgroundColor(color)
    term.setCursorPos(x, y)
    term.write(string.rep("", length))
end

function progress_bar_term(x, y, length, minVal, maxVal, bar_color, bg_color)
    display_line_text(x, y, length, bg_color)
    local barSize = math.floor((minVal / maxVal) * length)
    display_text_term(x, y, barSize, bar_color)
end

function menu_bars()
    display_text_term(1, 1, 55, colors.blue)
    draw_text_term(10, 1, "Storage Info Display Info Installer", colors.white, colors.blue)

    draw_line_term(1, 18, 55, colors.blue)
    draw_line_term(1, 19, 55, colors.blue)
    draw_text_term(10, 18, "by SkyNetCloud", colors.white, colors.blue)
end

function install(program, github)
    term.clear()
    menu_bars()


    display_text_term(1, 3, "Installing " .. program .. "....", colors.yellow, colors.black)
    term.setCursorPos(1, 5)
    term.setTextColor(colors.white)
    sleep(0.5)

    if fs.exists("github") then
        display_line_text(1, 4, "Github has been isntalled skipping this step")
    else
        install_github()
    end

    if fs.exists(program .. "_old") then
        fs.delete(program .. "_old")
    end

    if fs.exists("config.txt") then
        fs.delete("config.txt")
    end
    if fs.exists(program) then
        fs.copy(program, program .. "_old")
        fs.delete(program)
    end

    shell.run("github get" .. github .. " " .. program)

    sleep(0.5)

    term.setCursorPos(1, 8)

    if fs.exists("startup_old") then
        fs.delete("startup_old")
    end

    if fs.exists("startup") then
        fs.copy("startup", "startup_old")
        fs.delete("startup")
    end

    if program == "rsBridge_display" then
        shell.run("github get" .. rsBridge_startup .. " startup")
    else
        if program == "meBridge_display" then
            shell.run("github get" .. meBridge_startup .. " startup")
        end
    end
    if fs.exists(program) then
        display_text_term(1,11,"Success!", colors.lime, colors.black)
        display_text_term(1,12, "Press Enter to reboot...", colors.gray, colors.black)
        wait = read()
        shell.run("reboot")
    else
        display_text_term(1,11,"Error installing file.", colors.red, colors.black)
        sleep(0.1)
        display_text_term(1,11)
        sleep(0.1)
        fs.copy(program.."_old", program)
        fs.delete(program.."_old")

        display_text_term(1,14,"Press Enter to contiune...", colors.gray, colors.black)
        wait = read()
        start()
    end
end

function install_github(program, pastebin)
    shell.run("pastebin get" .. pastebin .. program)
    sleep(0.5)
    shell.run("bootstrap")
end

function meBridgeSearch()
    local names = peripheral.getNames()
    local i, name
    for i, name in pairs(names) do
        if peripheral.getType(name) == "meBridge" then
            return peripheral.wrap(name)
        else

        end
    end
end

function rsBridgeSearch()
    local names = peripheral.getNames()
    local i, name
    for i, name in pairs(names) do
        if peripheral.getType(name) == "rsBridge" then
            return peripheral.wrap(name)
        else

        end
    end
end

function selectProgram()
    term.clear()
    menu_bars()
    display_text_term(1, 4, "What would like to update/install? ", colors.yellow, colors.black)
    display_text_term(3, 6, "1 - RS Info Display", colors.white, colors.black)
    display_text_term(3, 7, "2 - AE Info Display", colors.white, colors.black)
    display_text_term(1, 9, "Enter 1 or 2:", colors.yellow, colors.black)

    term.setCursorPos(1, 10)
    term.setTextColor(colors.white)
    input = read()

    if input == "1" then
        install("rsBridge_display", rsBridge_display_github)
    else
        if input == "2" then
            install("meBridge_display", meBridge_display_github)
        else
            display_text_term(1, 12, "Please enter a '1' or '2'.", colors.red, colors.black)
            sleep(1)
            start()
        end
    end


    function start()
        term.clear()
        menu_bars()

        if fs.exists("config.txt") then
            if fs.exists("meBridge_display") then
                display_text_term(2, 3, "Current Program:", colors.white, colors.black)
                display_text_term(2, 4, "Storage Display", colors.lime, colors.black)
                display_text_term(1, 6, "Do you want to update this program? (y/n)", colors.white, colors.black)
                display_text_term(1, 7, "This will delete the current program and any saved settings", colors.gray,
                    colors.black)
                term.setCursorPos(1, 9)
                term.setTextColor(colors.white)
                input = read()
                if input == "y" then
                    install("rsBridge_display", rsBridge_display_github)
                elseif input == "n" then
                    selectProgram()
                end
            end
        end
    end
end
