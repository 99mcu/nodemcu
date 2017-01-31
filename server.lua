if srv then srv:close() end
srv=net.createServer(net.TCP)
HEADER200 = "HTTP/1.1 200 OK\r\n"..
            "Server: NodeMCU on ESP8266\r\n"..
            "Content-Type: text/%s; charset=UTF-8\r\n\r\n"
HEADER404 = "HTTP/1.0 404 Not Found\r\n\r\nPage not found"

sendPayload = function(fil, cli)
  local tem = fil:read()
  if tem then
    print('len = ',string.len(tem))
    cli:send(tem, function () sendPayload(fil, cli) end)
  else
    print('close.')
    cli:close()
  end
  collectgarbage()
end

srv:listen(80,function(conn)
    conn:on("receive", function(client,payload)
        local tarFile = string.sub(payload,string.find(payload,"GET /") +5,string.find(payload,"HTTP/") -2 )
        if tarFile == "" then tarFile = "index.html" end
        local fff = file.open(tarFile, "r")
        local name, ext = tarFile:match( "(%w+).(%w+)")
        local header = HEADER200:format(ext)
        if fff then
            client:send(header, function () sendPayload(fff, client) end)
        else
            client:send(HEADER404, function () client:close() end)
        end
        collectgarbage()
        f = nil
        tarFile = nil
    end)
end)
