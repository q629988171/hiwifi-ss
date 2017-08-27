--
-- test if ss is working
--

local log = require "luci.log"
local host, port = "www.youtube.com", 443
local socket = require("socket")
local tcp = assert(socket.tcp())
tcp:settimeout(2);
tcp:connect(host, port);
tcp:send("GET / HTTP/1.1\n");
local s, status, partial = tcp:receive()
-- ss status
local output = io.popen('/lib/gw-shadowsocks.sh status'):read('*all')
if output == 'running' then
    if status == "closed" then
        io.write('yes')
        log.print('Connection Succeeded')
    else
        io.write('no')            
        log.print('Connection Failed')
        -- reload ss
        log.print('Reload Shadowsocks')
        os.execute('/etc/init.d/gw-shadowsocks restart')        
    end
end
tcp:close()

