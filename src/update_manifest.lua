local device = require("device")
local update = { force = true } -- require("update_init")
local dlist = { }
local body = nil
local line = ""
local repo = "konnected-io/konnected-security"
print("Heap: ", node.heap(), "Updater: Checking version")
--local fw = file.open("manifest.tmp", "w")
--local conn = net.createConnection(net.TCP, 1)
--conn:connect(443, "api.github.com")

http.get("https://api.github.com/repos/" .. repo .. "/releases/latest", nil, function(code, data)
  if (code == 200) then
    body = cjson.decode(data)
    local version = body.tag_name or device.swVersion
    version = string.match(version, "[%d%.]+")
    print("Heap: ", node.heap(), "Updater: Current version", device.swVersion)
    print("Heap: ", node.heap(), "Updater: New version", version)
    if (version > device.swVersion) or update.force then
      print("Heap: ", node.heap(), "Updater: Version outdated, retrieving manifest list...")
      http.get(
        "https://raw.githubusercontent.com/" .. repo .. "/" .. body.tag_name .. "/manifest.json", nil,
        function(code, data)
          print(code, data)
        end
      )
    end
  else
    print("Error connecting to GitHub:", code, data)
  end
end)

--conn:on("receive", function(sck, c)
--  line = string.gsub(c, "\"%," , "\"%,\r\n")
--  line = string.gsub(line, "}%," , "}%,\r\n")
--  line = string.gsub(line, "]%," , "]%,\r\n")
--  fw.write(line)
--end)
--
--conn:on("disconnection", function(sck)

--
--  local version = body.tag_name or device.swVersion
--  version = string.match(version, "[%d%.]+")
--  print("Heap: ", node.heap(), "Updater: Current version", device.swVersion)
--  print("Heap: ", node.heap(), "Updater: New version", version)
--  if (version > device.swVersion) or update.force then
--    print("Heap: ", node.heap(), "Updater: Version outdated, retrieving manifest list...")
--    local fr = file.open("manifest.tmp", "r")
--    while true do
--      line = fr.readline()
--      if (line == nil) then
--        break
--      end
--      local tag = string.find(line,"\"browser_download_url\"", 1, true)
--      if (tag) then
--        line = string.gsub(line, "\"}%," , "")
--        line = string.gsub(line, "\"}]%," , "")
--        line = string.gsub(line, "\"browser_download_url\".*\"" , "")
--        table.insert(dlist, line)
--      end
--    end
--    fr.close()
--
--    local fw = file.open("manifest", "w")
--    fw.writeline("manifest = { ")
--    for i, dl in pairs(dlist) do
--      local host, port, path, filenm = findAttr(string.match(dl, "(.*)\r\n"))
--      fw.write(table.concat({"{ host = \"",host,"\", port = \"",port,"\", path = \"", path, "\", filenm = \"",filenm,"\" }"}))
--      if i < #dlist then
--        fw.writeline(",")
--      end
--    end
--    fw.writeline("}")
--    fw.close()
--    collectgarbage()
--    print("Heap: ", node.heap(), "Updater: Manifest Retrieved")
--
--    local fw = file.open("device", "w")
--
--    fw:writeline("local device = { name = \"".. device.name .."\",\r\nhwVersion = \"" .. device.hwVersion .. "\",\r\nswVersion = \"" .. version .. "\" }")
--    fw:writeline("return device")
--    fw:close()
--    collectgarbage()
--  else
--    print("Heap: ", node.heap(), "Updater: Software version up to date, cancelling update")
--    local fupdate = file.open("var_update.lua", "w")
--    fupdate:writeline("update = { run = false, force = false, setFactory = false }")
--    fupdate:close()
--  end
--
--  if file.exists("manifest") ~= true then
--    if file.exists("update_init.lua") then
--      file.remove("update_init.lua")
--    end
--    if file.exists("update_init.lc") then
--      file.remove("update_init.lc")
--    end
--  end
--  if file.exists("manifest.tmp") then
--    file.remove("manifest.tmp")
--  end
--
--  print("Heap: ", node.heap(), "Updater: restarting in 3 seconds")
--  tmr.create():alarm(3000, tmr.ALARM_SINGLE, function(t) node.restart() end)
--end)
--conn:on("connection", function(sck)
--  sck:send("GET /repos/konnected-io/konnected-security/releases/latest HTTP/1.1\r\nHost: api.github.com\r\nConnection: keep-alive\r\n"..
--           "Accept: */*\r\nUser-Agent: ESP8266\r\n\r\n")
--end)


