ss_log = {}
ss_log.log = false

function ss_log.write (filename,status)
  -- open the file
  local f = io.open(filename)
  -- create a empty file
  if f == nil then
      f=io.open(filename,"w")
      f:close()
  else
    f:close()
  end

  -- read the ss connection status from the file
  ss_log.status = io.open(filename):read("*a")
  -- write the ss connection status to the file
  if ss_log.status ~= status then
    f=io.open(filename,"w")
    f:write(status)
    f:close()
    ss_log.log = true
  end
end

return ss_log
