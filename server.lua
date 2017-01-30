srv=net.createServer(net.TCP)
HEADER200 = "HTTP/1.1 200 OK\r\n"..
            "Server: NodeMCU on ESP8266\r\n" ..
            "Content-Type: text/html; charset=UTF-8\r\n\r\n"
HEADER404 = "HTTP/1.0 404 Not Found\r\n\r\nPage not found"
srv:listen(80,function(conn)
    conn:on("receive", function(client,payload)
        local tarFile = string.sub(payload,string.find(payload,"GET /") +5,string.find(payload,"HTTP/") -2 )
        if tarFile == "" then tarFile = "index.html" end
        local f = file.open(tarFile, "r")
        if f ~= nil then
            local tem = file.read()
            print(tem)
            client:send(HEADER200, client:send(tem))
        else
            client:send(HEADER404)
        end
        client:on("sent", function ()
            client:close()
        end)
        collectgarbage()
        f = nil
        tarFile = nil
    end)
end)