if srv then srv:close() end
srv=net.createServer(net.TCP)
HEADER200 = "HTTP/1.1 200 OK\r\n"..
            "Server: NodeMCU on ESP8266\r\n"..
            "Content-Type: text/%s; charset=UTF-8\r\n\r\n"
HEADER404 = "HTTP/1.0 404 Not Found\r\n\r\nPage not found"
HEADERJSON = "HTTP/1.1 200 OK\r\n"..
             "Server: NodeMCU on ESP8266\r\n"..
             "Content-Type: application/json; charset=UTF-8\r\n\r\n"

sendPayload = function(fil, cli)
  local tem = fil:read()
  if tem then
    print('len = ',string.len(tem))
    cli:send(tem, function () sendPayload(fil, cli) end)
  else
    print('close.')
    cli:close()
    fil:close()
    tem = nil
    fil = nil
    cli = nil
  end
end

function handleGET (client, tarFile)
    if tarFile == "" then tarFile = "index.html" end
    local fff = file.open(tarFile, "r")
    local name, ext = tarFile:match( "(%w+).(%w+)")
    print(fff, name, ext)
    local header = HEADER200:format(ext)
    if fff then
        client:send(header, function () sendPayload(fff, client) end)
    else
        client:send(HEADER404, function () client:close() end)
    end
    name = nil
    tarFile = nil
end

JSON = 1
ENURL = 2
function handlePOST (client, payload)
    local cut, tail = payload:find('\r\n\r\n')
    if cut then
        local cType = ENURL
        local header = payload:sub(1,cut)
        local body = payload:sub(tail)
        for key, val in header:gmatch("(%S+):([^\n]+)") do
            if key == 'Content-Type' then
                cType = val:find('json') and JSON or ENURL
            end
        end
        print('type = ',cType)
        local params = {}
        for k, v in pairs(params) do
            print(k,v)
        end
        if cType == JSON then
            local t = cjson.decode(body)
            for k, v in pairs(t) do params[k] = v end
        else
            for k, v in body:gmatch("(%w+)=(%w+)") do params[k] = v end
        end
        for k, v in pairs(params) do
            gpio.write(k, (v == 1 or v == '1') and gpio.LOW or gpio.HIGH)
        end 
        client:send(HEADERJSON, function()
            local json = {}
            json.a = "vf"
            json.b = 123
            client:send(cjson.encode(json), function () client:close() end)
            client:close()
        end)
    else
        client:send("no params!!!", function() client:close() end)
    end
end
srv:listen(80,function(conn)
    conn:on("receive", function(client, payload)
        if payload:find("GET") == 1 then
            local url = payload:match("GET +(%S+)")
            handleGET(client, url:sub(2)) -- sub to remove '/'
        elseif payload:find("POST") == 1 then
            handlePOST(client, payload)
        end
    end)
end)
