-- @description IFLS_Toolbar_Suite Alias: IFLS_DF95_IFLS_AudioImportHub_ImGui
-- @version 1.0
-- @about Wrapper that runs legacy DF95 script at IFLS/IFLS/Hubs/IFLS_AudioImportHub_ImGui.lua
local r=reaper
local rp=r.GetResourcePath():gsub("\\","/")
local target=rp.."/Scripts/IFLS/IFLS/Hubs/IFLS_AudioImportHub_ImGui.lua"
local f=io.open(target,"rb")
if not f then
  r.MB("Missing legacy script:\n"..target, "IFLS_Toolbar_Suite", 0)
  return
end
f:close()
dofile(target)
