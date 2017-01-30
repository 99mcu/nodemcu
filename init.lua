STA_Connecting = 1
TimerUsing = 0
US_TO_MS = 1000
require "wificon"
wifi.sta.config(wificon)
tmr.register(TimerUsing, 500, tmr.ALARM_AUTO, function()
    if wifi.sta.status() == STA_Connecting then print("waiting wifi connetion..")
    else
        ip = wifi.sta.getip()
        print("done, my ip is", ip)
        tmr.stop(TimerUsing)
    end
end)
tmr.start(TimerUsing)

