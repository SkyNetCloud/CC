
bootstrap = "WdiT6sR5"

installer = "SkyNetCloud/CC/master/installer.lua"

meBridge_display = "SkyNetCloud/CC/master/meBridge_display.lua"

rsBridge_display = "SkyNetCloud/CC/master/rsBridge_display.lua"

local meBridge
local rsBridge 
term.clear()


function display_text_term(x,y,text,text_color,bg_color)
    term.setTextColor(text_color)
    term.setBackgroundColor(bg_color)
    term.setCursorPos(x,y)
    write(text)
end

function display_line_text(x,y,length,color)
    term.setBackgroundColor(color)
    term.setCursorPos(x,y)
    term.write(string.rep("",length))   
end



function progress_bar_term(x,y,length,minVal,maxVal,bar_color,bg_color)
    display_line_text(x,y,length,bg_color)
    local barSize = math.floor((minVal/maxVal)* length)
    display_text_term(x,y,barSize,bar_color)
end

function menu_bars()
   display_text_term(1,1,55,colors.blue)
   draw_text_term(10,1, "Storage Info Display Info Installer", colors.white,colors.blue)

   draw_line_term(1,18,55,colors.blue)
   draw_line_term(1,19,55,colors.blue)
   draw_text_term(10, 18, "by SkyNetCloud", colors.white, colors.blue)
end



function install(program,github)

    term.clear()
    menu_bars()


    display_text_term(1,3,"Installing "..program.."....", colors.yellow,colors.black)
    term.setCursorPos(1,5)
    term.setTextColor(colors.white)
    sleep(0.5)

    if fs.exists("github") then 
      display_line_text(1,4, "Github has been isntalled skipping this step")
    else 
      install_github()
    end
    
end

function install_github(program,pastebin)
    shell.run("pastebin get"..pastebin..program)
    sleep(0.5)
    shell.run("bootstrap")
end