-- compat wrapper for legacy nested install path
local r=reaper
local rp=r.GetResourcePath():gsub("\\","/")
dofile(rp.."/Scripts/IFLS_Toolbar_Suite/tools/diagnostics.lua")
