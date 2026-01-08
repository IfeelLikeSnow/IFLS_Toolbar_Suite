-- @description IFLS_Toolbar_Suite Alias: IFLS_DF95_DF95_V95_1_Fieldrec_Split_And_Distribute_MicBundle_AutoGain
-- @version 1.0
-- @about Wrapper that runs legacy DF95 script at IFLS/DF95/ReampSuite/DF95_V95_1_Fieldrec_Split_And_Distribute_MicBundle_AutoGain.lua
local r=reaper
local rp=r.GetResourcePath():gsub("\\","/")
local target=rp.."/Scripts/IFLS/DF95/ReampSuite/DF95_V95_1_Fieldrec_Split_And_Distribute_MicBundle_AutoGain.lua"
local f=io.open(target,"rb")
if not f then
  r.MB("Missing legacy script:\n"..target, "IFLS_Toolbar_Suite", 0)
  return
end
f:close()
dofile(target)
