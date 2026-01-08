-- @description IFLS: Launcher (compat wrapper)
-- @version 1.0
-- @author IFLS
local r = reaper
local rp = r.GetResourcePath():gsub("\\","/")
local target = rp .. "/Scripts/IFLS_Toolbar_Suite/entry/IFLS_TB_Launcher.lua"
local f = io.open(target, "rb")
if f then f:close() else
  r.MB("Launcher not found:\n"..target, "IFLS", 0); return
end
dofile(target)
