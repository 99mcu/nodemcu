if srv then srv:close() end
srv=net.createServer(net.TCP)
HEADER200 = "HTTP/1.1 200 OK\r\n"..
            "Server: NodeMCU on ESP8266\r\n" ..
            "Content-Type: text/html; charset=UTF-8\r\n\r\n"
HEADER404 = "HTTP/1.0 404 Not Found\r\n\r\nPage not found"

sendPayload = function(fopened, cli)
  print(fopened)
  local tem = file.read()
  if tem then
    print('len = ',string.len(tem))
    cli:send(tem, function () sendPayload(fopened, cli) end)
  else
    print('close.')
    cli:close()
  end
end
srv:listen(80,function(conn)
    conn:on("receive", function(client,payload)
        local tarFile = string.sub(payload,string.find(payload,"GET /") +5,string.find(payload,"HTTP/") -2 )
        if tarFile == "" then tarFile = "index.html" end
        local f = file.open(tarFile, "r")
        if f ~= nil then
            client:send(HEADER200, function () sendPayload(f, client) end)
        else
            client:send(HEADER404, function () client:close() end)
        end
        collectgarbage()
        f = nil
        tarFile = nil
    end)
end)
