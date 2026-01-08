-- @description IFLS: Diagnostics (compat wrapper)
-- @version 1.0
-- @author IFLS
local r = reaper
local ok_ctx, _, script_file = pcall(r.get_action_context)
local rp = r.GetResourcePath():gsub("\\","/")
local target = rp .. "/Scripts/IFLS_Toolbar_Suite/tools/diagnostics.lua"
local f = io.open(target, "rb")
if f then f:close() else
  r.MB("Diagnostics not found:\n"..target, "IFLS", 0); return
end
dofile(target)
