-- @description IFLS_Toolbar_Suite Alias: IFLS_DF95_DF95_V166_Export_Fieldrec_MicFusion_Slices_PostChanFX
-- @version 1.0
-- @about Wrapper that runs legacy DF95 script at IFLS/DF95/DF95_V166_Export_Fieldrec_MicFusion_Slices_PostChanFX.lua
local r=reaper
local rp=r.GetResourcePath():gsub("\\","/")
local target=rp.."/Scripts/IFLS/DF95/DF95_V166_Export_Fieldrec_MicFusion_Slices_PostChanFX.lua"
local f=io.open(target,"rb")
if not f then
  r.MB("Missing legacy script:\n"..target, "IFLS_Toolbar_Suite", 0)
  return
end
f:close()
dofile(target)
