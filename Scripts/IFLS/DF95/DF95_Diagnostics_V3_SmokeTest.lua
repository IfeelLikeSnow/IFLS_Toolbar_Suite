-- DF95_Diagnostics_V3_SmokeTest.lua
-- Quick system check: core files + capabilities. Prints console report and shows a short summary.

local r = reaper
local base = r.GetResourcePath():gsub("\\","/")

local function join(...)
  local t = {...}
  return table.concat(t, "/")
end

local function file_exists(path)
  local f = io.open(path, "r")
  if f then f:close() return true end
  return false
end

local Caps = dofile(join(base, "Scripts", "DF95Framework", "Lib", "DF95_Capabilities.lua"))

local checks = {
  { name="DF95_Hubs.lua", path=join(base,"Scripts","DF95Framework","Menus","DF95_Hubs.lua") },
  { name="DF95_MenuBuilder.lua", path=join(base,"Scripts","DF95Framework","Lib","DF95_MenuBuilder.lua") },
  { name="DF95_Config.json", path=join(base,"Support","DF95_Config.json") },
}

local caps = { "sws", "reapack", "reaimgui", "js_reascriptapi" }

r.ClearConsole()
r.ShowConsoleMsg("DF95 V3 Smoke Test\n==================\n\n")

local ok_all = true

r.ShowConsoleMsg("Files:\n")
for _, c in ipairs(checks) do
  local ok = file_exists(c.path)
  ok_all = ok_all and ok
  r.ShowConsoleMsg(string.format(" - %-22s : %s\n", c.name, ok and "OK" or ("MISSING ("..c.path..")")))
end

r.ShowConsoleMsg("\nCapabilities:\n")
local missing_caps={}
for _, cap in ipairs(caps) do
  local ok = Caps.has(cap)
  if not ok then missing_caps[#missing_caps+1]=cap end
  r.ShowConsoleMsg(string.format(" - %-14s : %s\n", cap, ok and "OK" or "MISSING"))
end

local summary
if ok_all and #missing_caps==0 then
  summary = "DF95 Smoke Test: OK\n\nAlles gefunden, alle Capabilities verfügbar."
else
  summary = "DF95 Smoke Test: Issues found\n\n"
  if not ok_all then summary = summary .. "- Mindestens eine Datei fehlt.\n" end
  if #missing_caps>0 then summary = summary .. "- Missing: " .. table.concat(missing_caps,", ") .. "\n" end
  summary = summary .. "\nDetails: REAPER Console."
end

r.ShowMessageBox(summary, "DF95 Smoke Test", 0)
