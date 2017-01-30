STA_Connecting = 1
TimerUsing = 0
US_TO_MS = 1000
file.open('config.txt', 'r')
station_cfg={}
for key, val in string.gmatch(file.read(), "(%w+)=(%w+)") do
    station_cfg[key] = val
end
print('config.ssid:',station_cfg.ssid)
print('config.pwd:',station_cfg.pwd) 
wifi.sta.config(station_cfg)

tmr.register(TimerUsing, 500, tmr.ALARM_AUTO, function()
    if wifi.sta.status() == STA_Connecting then print("waiting wifi connetion..")
    else
        ip = wifi.sta.getip()
        print("done, my ip is", ip)
        tmr.stop(TimerUsing)
    end
end)
tmr.start(TimerUsing)

