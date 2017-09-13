--
-- test if ss is working
--

local log = require "luci.log"
local ss_log = require "luci.ss_log"
local host, port = "www.youtube.com", 443
local socket = require("socket")
local tcp = assert(socket.tcp())
local filename = "/tmp/ss_status"
tcp:settimeout(2);
tcp:connect(host, port);
tcp:send("GET / HTTP/1.1\n");
local s, status, partial = tcp:receive()
-- ss status
local output = io.popen('/lib/gw-shadowsocks.sh status'):read('*a')
if output == 'running' then
  if status == "closed" then
    io.write('yes')
    ss_log.write(filename,"0")
    if ss_log.log then log.print('SS Connection Succeeded') end
  else
    io.write('no')
    ss_log.write(filename,"1")
    if ss_log.log then log.print('SS Connection Failed') end
    -- reload ss
    log.print('Reload Shadowsocks')
    os.execute('/etc/init.d/gw-shadowsocks restart')
  end
else
  if status == "closed" then
    ss_log.write(filename,"2")
    if ss_log.log then log.print('SS is not running but show connection is normal') end
    -- kill usbreset.sh
    os.execute("ps | grep /lib/usbreset.sh | grep -v grep | awk '{print $1}' | xargs kill -9")
    -- execute usbreset.sh
    os.execute('/lib/usbreset.sh >/dev/null 2>&1 &')
  else
    ss_log.write(filename,"3")
    if ss_log.log then log.print('SS is Stopped') end
  end
end
tcp:close()
